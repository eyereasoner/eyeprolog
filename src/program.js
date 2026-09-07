// Program representation and clause indexing.
// Indexes are deliberately conservative: they speed up common scalar arguments but never replace unification as the final check.
import { ATOM, COMPOUND, NUMBER, STRING, VAR, Env, atom, compound, deref, flattenConjunction, isScalar, numberTerm, properListItems, termToString, variable } from './term.js';
import { formatTermForWrite } from './write.js';
import {
  ISO_OPERATOR_DEFINITIONS,
  PART2_OPERATOR_DEFINITIONS,
  PART3_OPERATOR_DEFINITIONS,
  QUAD_OPERATOR_DEFINITIONS,
  createParserOperatorState,
  parseClauses,
  parseClausesInto,
  parseGoalText,
  tryParseClausesFastInto,
} from './parser.js';
import { PrologError, convertClauseBodyTerm, getDefaultRegistry, getStrictIsoRegistry } from './iso.js';
import { currentWorkingDirectory, fs, path } from './platform.js';
import {
  standardLibrarySources,
  eyePrologAmbiguousLibraryAutoload,
  eyePrologLibraryAutoload,
  eyePrologInteropLibraryIndicators,
  eyePrologInteropLibraryModules,
} from './standard-library.js';
import { expandDcgRuleClause } from './dcg.js';
import { expandClauseGoals, expandSourceClause } from './source-expansion.js';
import {
  CompactBinaryClause, clauseBodyLength, clauseHasCut, compactHeadArgName, compactHeadArgType, modulePredicateKey,
  indexCompactOne, indexOne, isCompactBinaryClause, makeArgumentIndex, rebuildGroupIndexes, termContainsCut, termHasNoVariables,
} from './program-indexing.js';
export { selectClauseCandidates, selectClauseCandidatesForValues, selectGroundClauseCandidates } from './program-indexing.js';
import {

  componentHasNegativeEdge, componentHasCut, reachableIndexes, datalogDependencyClauseCount, isFiniteDatalogGroup, isRangeRestrictedFiniteDatalogGroup, isFiniteWfsDatalogGroup, inferStructuralInputPositions, hasStrictListTailRecursion, hasLinearNumericRecursion, isPiAccumulator, isPortableBetweenGenerator, directGoalDependencyKey, collectGoalDependencies, stronglyConnectedComponents, computeNegationStrata,
} from './program-analysis.js';

const RE_DECIMAL_INT = /^\d+$/;

const DEFER_PROGRAM_BUILD = Symbol('deferProgramBuild');
const FAST_PARSE_ABORT = Symbol('fastParseAbort');
const PROGRAM_BUILD_BATCH_SIZE = 16384;
const preparedBundledLibraryCache = new Map();
const NORMAL_OPERATOR_DEFINITIONS = [
  ...ISO_OPERATOR_DEFINITIONS,
  ...PART2_OPERATOR_DEFINITIONS,
  ...PART3_OPERATOR_DEFINITIONS,
  ...QUAD_OPERATOR_DEFINITIONS,
];

function collectMultiplicitySensitiveDependencies(goal, out = []) {
  if (goal?.type !== COMPOUND) return out;
  if (goal.name === ',' && goal.arity === 2) {
    collectMultiplicitySensitiveDependencies(goal.args[0], out);
    collectMultiplicitySensitiveDependencies(goal.args[1], out);
    return out;
  }
  if ((goal.name === 'findall' || goal.name === 'bagof') && goal.arity === 3) {
    out.push(...collectGoalDependencies(goal.args[1], false, true));
    return out;
  }
  if ((goal.name === ';' || goal.name === '->') && goal.arity === 2) {
    collectMultiplicitySensitiveDependencies(goal.args[0], out);
    collectMultiplicitySensitiveDependencies(goal.args[1], out);
    return out;
  }
  if ((goal.name === '\\+' || goal.name === 'not' || goal.name === 'tnot' || goal.name === 'once') && goal.arity === 1) {
    collectMultiplicitySensitiveDependencies(goal.args[0], out);
    return out;
  }
  if (goal.name === 'wfs_truth' && goal.arity === 2) {
    collectMultiplicitySensitiveDependencies(goal.args[0], out);
    return out;
  }
  if (goal.name === 'forall' && goal.arity === 2) {
    collectMultiplicitySensitiveDependencies(goal.args[0], out);
    collectMultiplicitySensitiveDependencies(goal.args[1], out);
  }
  return out;
}


// Cut-guided tail recursion is usually a deterministic search loop rather than
// a cyclic relation. Tabling such loops can retain every intermediate numeric
// state (for example prime scanning in Goldbach) and turn a bounded depth-first
// search into an enormous table. Keep this deliberately narrow: each recursive
// clause must contain exactly one direct self-call and that call must be the last
// body goal. Branching recursion such as Takeuchi therefore remains eligible
// for recursion planning and explicit tabling.
function hasDirectCutTailRecursion(group) {
  if (group.hasCut !== true || group.clauses.length === 0) return false;
  let sawRecursive = false;
  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) return false;
    const body = clause.body ?? [];
    let recursiveIndex = -1;
    let recursiveCount = 0;
    for (let i = 0; i < body.length; i++) {
      const goal = body[i];
      if (goal?.type !== COMPOUND || goal.name !== group.name || goal.arity !== group.arity) continue;
      if ((goal.module ?? group.module) !== group.module) continue;
      recursiveIndex = i;
      recursiveCount++;
    }
    if (recursiveCount === 0) continue;
    if (recursiveCount !== 1 || recursiveIndex !== body.length - 1) return false;
    sawRecursive = true;
  }
  return sawRecursive;
}

function preparedBundledLibraryCacheKey(program, options) {
  const filename = String(options.filename ?? '');
  if (filename !== standardLibrarySources.get('clpz')?.filename) return null;
  // A user hook deliberately defined before use_module/1 is allowed to
  // transform bundled source. Such a program needs its own ordinary expansion.
  if (program.groups.has(modulePredicateKey('user', 'term_expansion', 2)) ||
      program.groups.has(modulePredicateKey('user', 'goal_expansion', 2))) return null;
  return `${filename}\u0000${options.sourceMetadata === false ? 'compact' : 'metadata'}`;
}

function cachedClauseCopy(clause) {
  const copy = { ...clause };
  if (Array.isArray(clause.body)) copy.body = [...clause.body];
  if (clause.source != null) copy.source = { ...clause.source };
  delete copy.index;
  delete copy.groundHead;
  delete copy.scalarHead;
  delete copy._localFreshPlan;
  return copy;
}

function termContainsStringExtension(term, seen = new Set()) {
  if (term == null || typeof term !== 'object' || seen.has(term)) return false;
  seen.add(term);
  if (term.type === STRING) return true;
  if (term.type === COMPOUND) return term.args.some((arg) => termContainsStringExtension(arg, seen));
  return false;
}

function clauseContainsStringExtension(clause) {
  if (clause == null) return false;
  if (clause.head0Type === STRING || clause.head1Type === STRING) return true;
  if (termContainsStringExtension(clause.head) || termContainsStringExtension(clause.query)) return true;
  return Array.isArray(clause.body) && clause.body.some((goal) => termContainsStringExtension(goal));
}
export class Program {
  constructor(clauses = [], options = {}) {
    this.clauses = [];
    this.groups = new Map();
    this.modules = new Map([['user', { name: 'user', exports: new Map(), filename: '<input>' }]]);
    this.moduleImports = new Map();
    this.moduleMetaPredicates = new Map();
    this.autoloadedPredicates = [];
    this.libraryImports = [];
    this.interopPortabilityWarnings = [];
    this.libraryShadowingWarnings = [];
    this.dynamicPredicates = new Set();
    // ISO 7.5.3 notes that a public/1 directive declaring user-defined
    // procedures to be public would be an extension. Such a procedure stays
    // static -- it cannot be modified -- but clause/2 may inspect it.
    this.publicPredicates = new Set();
    this.multifilePredicates = new Set();
    this.discontiguousPredicates = new Set();
    this.strictIso = options.isoStrict === true;
    // Tabling is opt-in through explicit `:- table ...` directives. Ordinary
    // recursive predicates retain standard depth-first Prolog control.
    this.tabledPredicates = new Set();
    this.operators = new Map();
    const predefinedOperators = this.strictIso ? ISO_OPERATOR_DEFINITIONS : NORMAL_OPERATOR_DEFINITIONS;
    // The predefined lists contain no competing declarations in the same
    // prefix, infix, or postfix class. Populate them directly; defineOperator
    // still performs replacement semantics for source-level op/3 directives.
    for (const [priority, specifier, name] of predefinedOperators) {
      this.operators.set(`${specifier}\u0000${name}`, { priority, specifier, name });
    }
    this.initializations = [];
    // Track how many initialization/1 directives have run so a REPL can
    // autoload a library after startup and execute only that library's newly
    // appended initializations without repeating earlier side effects.
    this._initializationsExecutedCount = 0;
    this.quads = [];
    this.prologFlagDirectives = [];
    this.charConversionDirectives = [];
    this.doubleQuotes = options.doubleQuotes ?? 'chars';
    this._revisionState = { value: 0 };
    this.mutable = false;
    this._negationAnalysis = null;
    if (options[DEFER_PROGRAM_BUILD] === true) return;
    const builder = new ProgramBuilder(options, this);
    builder.addClauses(clauses);
    builder.finish();
  }
  defineOperator(priority, specifier, name) {
    const operatorClass = ['fx', 'fy'].includes(specifier) ? ['fx', 'fy']
      : ['xf', 'yf'].includes(specifier) ? ['xf', 'yf']
        : ['xfx', 'xfy', 'yfx'];
    for (const existing of operatorClass) this.operators.delete(`${existing}\u0000${name}`);
    const key = `${specifier}\u0000${name}`;
    if (priority !== 0) this.operators.set(key, { priority, specifier, name });
  }
  static parse(source, options = {}) {
    return buildProgramFromSources([source], options);
  }
  static parseSources(sources = [], options = {}) {
    return buildProgramFromSources(sources, options);
  }
  makeGroup(name, arity, module = 'user') {
    // A group corresponds to one predicate indicator, for example edge/3.
    // Compact single-argument indexes are built eagerly. Wider combinations
    // are constructed on first use, avoiding eager O(arity^2) pair tables while
    // still allowing call-driven combinations of any width.
    const group = {
      name,
      arity,
      module,
      metaArgumentModes: this.moduleMetaPredicates.get(module)?.get(`${name}/${arity}`) ?? [],
      clauses: [],
      argIndexes: Array.from({ length: arity }, makeArgumentIndex),
      demandIndexes: new Map(),
      rejectedDemandIndexes: new Set(),
      tabled: false,
      recursive: false,
      tableInputPositions: [],
      tableAllVariants: false,
      datalogLeastModel: false,
      wfsDatalog: false,
      scalarFactsOnly: true,
      dynamic: this.dynamicPredicates.has(modulePredicateKey(module, name, arity)),
      public: this.publicPredicates.has(modulePredicateKey(module, name, arity)),
      negationStratum: null,
      hasCut: false,
      cutReachable: null,
      bundledLibrary: false,
    };
    return group;
  }
  indexClause(clause) {
    this._indexClause(clause, false);
  }
  _indexClause(clause, initialBuild) {
    const head = clause.head;
    if (!initialBuild) assertHeadIsDefinable(head, this.strictIso);
    if (head.type !== ATOM && head.type !== COMPOUND) return;
    const module = clause.module ?? 'user';
    const key = modulePredicateKey(module, head.name, head.arity);
    let group = this.groups.get(key);
    if (!group) {
      group = this.makeGroup(head.name, head.arity, module);
      this.groups.set(key, group);
    }
    clause.groundHead = termHasNoVariables(head);
    clause.scalarHead = head.type === COMPOUND && head.args.every(isScalar);
    if (clause.body.length !== 0 || !clause.scalarHead) group.scalarFactsOnly = false;
    // Keep already-used groups correct when embedders append clauses through
    // the public indexClause method.
    if (!initialBuild) {
      group.demandIndexes.clear();
      group.rejectedDemandIndexes.clear();
    }
    group.clauses.push(clause);
    if (clauseHasCut(clause)) group.hasCut = true;
    const clausePosition = group.clauses.length - 1;
    for (let i = 0; i < head.arity; i++) {
      indexOne(group.argIndexes[i], head.args[i], clause, group.clauses, clausePosition, group.dynamic === true);
    }
  }
  findGroup(name, arity, module = 'user') {
    const indicator = `${name}/${arity}`;
    const direct = this.groups.get(module === 'user' ? indicator : `${module}:${indicator}`);
    if (direct) return direct;
    let current = this.moduleImports.get(module)?.get(indicator);
    if (current == null) return null;
    const visited = new Set([module]);
    while (!visited.has(current)) {
      visited.add(current);
      const imported = this.groups.get(current === 'user' ? indicator : `${current}:${indicator}`);
      if (imported) return imported;
      const importedModule = this.moduleImports.get(current)?.get(indicator);
      if (importedModule == null) return null;
      current = importedModule;
    }
    return null;
  }
  defineModule(name, exports, filename = '<input>') {
    const indicators = new Map(exports.map((indicator) => [`${indicator.name}/${indicator.arity}`, indicator]));
    this.modules.set(name, { name, exports: indicators, filename });
  }
  importModule(target, source, requested = null) {
    const definition = this.modules.get(source);
    if (!definition) throw new PrologError('existence_error(module)', atom(source));
    const imports = this.moduleImports.get(target) ?? new Map();
    const selected = requested ?? [...definition.exports.values()];
    for (const indicator of selected) {
      const key = `${indicator.name}/${indicator.arity}`;
      if (!definition.exports.has(key)) {
        throw new PrologError('existence_error(procedure)', compound('/', [atom(indicator.name), numberTerm(indicator.arity)]));
      }
      const previous = imports.get(key);
      const resolved = this.findGroup(indicator.name, indicator.arity, source);
      const canonicalSource = resolved?.module ?? source;
      const previousResolved = previous == null
        ? null
        : this.findGroup(indicator.name, indicator.arity, previous);
      const canonicalPrevious = previousResolved?.module ?? previous;
      if (previous != null && canonicalPrevious !== canonicalSource) {
        throw new PrologError('permission_error(import, procedure)', compound('/', [atom(indicator.name), numberTerm(indicator.arity)]));
      }
      imports.set(key, canonicalSource);
    }
    this.moduleImports.set(target, imports);
  }
  defineMetaPredicate(module, template) {
    if (template.type !== COMPOUND) return;
    const modes = [];
    for (let index = 0; index < template.args.length; index++) {
      const spec = template.args[index];
      if (spec.type === ATOM && spec.name === ':') {
        modes.push({ index, kind: 'context' });
      } else if (spec.type === NUMBER && RE_DECIMAL_INT.test(spec.name)) {
        // Numeric closure modes are a widely implemented compatibility
        // extension. Keep their existing hidden lexical qualification while
        // reserving explicit Module:Goal wrapping for ISO Part 2 ':' modes.
        modes.push({ index, kind: 'closure' });
      }
    }
    const definitions = this.moduleMetaPredicates.get(module) ?? new Map();
    definitions.set(`${template.name}/${template.arity}`, modes);
    this.moduleMetaPredicates.set(module, definitions);
    const group = this.groups.get(modulePredicateKey(module, template.name, template.arity));
    if (group) group.metaArgumentModes = modes;
  }
  ensureDynamicGroup(name, arity, module = 'user') {
    assertPredicateIsDefinable(name, arity, this.strictIso);
    const key = modulePredicateKey(module, name, arity);
    let group = this.groups.get(key);
    if (!group) {
      this.dynamicPredicates.add(key);
      this.mutable = true;
      group = this.makeGroup(name, arity, module);
      group.dynamic = true;
      this.groups.set(key, group);
    }
    return group;
  }
  insertDynamicClause(clause, atStart = false) {
    clause.module ??= clause.head.module ?? 'user';
    const group = this.ensureDynamicGroup(clause.head.name, clause.head.arity, clause.module);
    clause.index = this.clauses.length;
    clause.groundHead = termHasNoVariables(clause.head);
    clause.scalarHead = clause.head.type === COMPOUND && clause.head.args.every(isScalar);
    this.clauses.push(clause);
    if (atStart) {
      group.clauses.unshift(clause);
      rebuildGroupIndexes(group);
    } else {
      const clausePosition = group.clauses.length;
      group.clauses.push(clause);
      // assertz/1 is by far the common dynamic-update path. Appending a clause
      // does not invalidate the existing argument buckets, so extend them in
      // place instead of rebuilding the whole predicate after every insert.
      // This changes repeated ground bookkeeping from quadratic to linear.
      group.demandIndexes.clear();
      group.rejectedDemandIndexes.clear();
      if (clause.body.length !== 0 || !clause.scalarHead) group.scalarFactsOnly = false;
      if (clauseHasCut(clause)) group.hasCut = true;
      for (let i = 0; i < clause.head.arity; i++) {
        indexOne(group.argIndexes[i], clause.head.args[i], clause, group.clauses, clausePosition, true);
      }
    }
    this.noteMutation(clause.body.length > 0);
  }
  removeDynamicClause(group, clause) {
    const index = group.clauses.indexOf(clause);
    if (index < 0) return false;
    group.clauses.splice(index, 1);
    const allIndex = this.clauses.indexOf(clause);
    if (allIndex >= 0) this.clauses.splice(allIndex, 1);
    rebuildGroupIndexes(group);
    this.noteMutation(clause.body.length > 0);
    return true;
  }
  abolishDynamicGroup(name, arity, module = 'user') {
    const key = modulePredicateKey(module, name, arity);
    const group = this.groups.get(key);
    if (!group) return;
    const removed = new Set(group.clauses);
    const reanalyze = group.clauses.some((clause) => clause.body.length > 0);
    this.clauses = this.clauses.filter((clause) => !removed.has(clause));
    this.groups.delete(key);
    this.dynamicPredicates.delete(key);
    this.noteMutation(reanalyze);
  }
  get revision() {
    return this._revisionState.value;
  }
  noteMutation(reanalyze = false) {
    this._revisionState.value++;
    this._negationAnalysis = null;
    if (reanalyze && !this.strictIso) this.markRecursivePredicates();
  }
  markRecursivePredicates() {
    // Recursion analysis still drives execution optimizations and explicit tabling metadata.
    const groups = [...this.groups.values()];
    const indexByGroup = new Map(groups.map((group, i) => [group, i]));
    const deps = groups.map(() => new Set());
    const cutDeps = groups.map(() => new Set());
    const multiplicitySensitiveRoots = new Set();
    const negativeEdges = [];
    const wfsNegativeEdges = [];
    for (const group of groups) {
      const groupIndex = indexByGroup.get(group);
      let compactDependencies = null;
      for (const clause of group.clauses) {
        if (isCompactBinaryClause(clause)) {
          if (clause.bodyName != null) (compactDependencies ??= new Set()).add(clause.bodyName);
          continue;
        }
        for (const goal of clause.body) {
          for (const dependency of collectMultiplicitySensitiveDependencies(goal)) {
            const dep = this.findGroup(dependency.name, dependency.arity, dependency.module ?? group.module);
            if (dep) multiplicitySensitiveRoots.add(indexByGroup.get(dep));
          }
          for (const dependency of collectGoalDependencies(goal, false, true)) {
            const dep = this.findGroup(dependency.name, dependency.arity, dependency.module ?? group.module);
            if (dep) cutDeps[groupIndex].add(indexByGroup.get(dep));
          }
          const directKey = directGoalDependencyKey(goal);
          if (directKey) {
            const dep = this.findGroup(goal.name, goal.arity, goal.module ?? group.module);
            if (dep) deps[groupIndex].add(indexByGroup.get(dep));
            continue;
          }
          for (const dependency of collectGoalDependencies(goal, false)) {
            const dep = this.findGroup(dependency.name, dependency.arity, dependency.module ?? group.module);
            if (dep) {
              const dependencyIndex = indexByGroup.get(dep);
              deps[groupIndex].add(dependencyIndex);
              if (dependency.negative) {
                negativeEdges.push([groupIndex, dependencyIndex]);
                if (dependency.wfs === true) wfsNegativeEdges.push([groupIndex, dependencyIndex]);
              }
            }
          }
        }
      }
      for (const name of compactDependencies ?? []) {
        const dep = this.findGroup(name, 2, group.module);
        if (!dep) continue;
        const dependencyIndex = indexByGroup.get(dep);
        deps[groupIndex].add(dependencyIndex);
        cutDeps[groupIndex].add(dependencyIndex);
      }
    }
    const finiteDatalogCache = new Map();
    const rangeRestrictedDatalogCache = new Map();
    for (const group of groups) {
      const start = indexByGroup.get(group);
      const standardLibraryModule = group.module !== 'user' &&
        this.modules.get(group.module)?.filename?.startsWith('src/lib/');
      group.bundledLibrary = standardLibraryModule === true;
      group.cutReachable = [...reachableIndexes(start, cutDeps)].some((index) => groups[index].hasCut);
      const seen = new Set();
      const stack = [start];
      let recursive = false;
      while (stack.length && !recursive) {
        const current = stack.pop();
        if (seen.has(current)) continue;
        seen.add(current);
        for (const next of deps[current]) {
          if (next === start) { recursive = true; break; }
          if (!seen.has(next)) stack.push(next);
        }
      }
      // Bundled libraries use their written ISO control directly. User modules
      // are analyzed for recursion, but tabling itself is strictly opt-in.
      const plannedRecursive = recursive && !standardLibraryModule;
      const explicitlyTabled = this.tabledPredicates.has(modulePredicateKey(group.module, group.name, group.arity));
      group.recursive = plannedRecursive;
      group.tabled = explicitlyTabled;
      group.tableInputPositions = explicitlyTabled && plannedRecursive
        ? inferStructuralInputPositions(group)
        : [];
      group.cutRecursive = plannedRecursive && componentHasCut(start, deps, groups);
      const linearNumeric = plannedRecursive && !explicitlyTabled && hasLinearNumericRecursion(group) &&
        (isPiAccumulator(group) || isPortableBetweenGenerator(group));
      group.linearNumeric = linearNumeric;
      group.fastPi = linearNumeric && isPiAccumulator(group);
      const directRecursiveComponent = plannedRecursive && [...deps[start]].every((dependency) =>
        dependency === start || !reachableIndexes(dependency, deps).has(start)
      );
      group.listTailRecursive = directRecursiveComponent && !group.cutRecursive &&
        hasStrictListTailRecursion(group);
      const cutTailRecursion = plannedRecursive && hasDirectCutTailRecursion(group);
      const multiplicitySensitive = [...multiplicitySensitiveRoots].some((root) => reachableIndexes(root, deps).has(start));
      group.cutTailRecursion = cutTailRecursion;
      group.multiplicitySensitive = multiplicitySensitive;
      group.depthFirstRecursive = plannedRecursive && !explicitlyTabled;
      // Function-free positive recursive rules have a finite Herbrand base.
      // They can safely use a shared most-general table, which avoids computing
      // a separate recursive closure for every bound input (TC/SG/Wine style).
      group.tableAllVariants = group.tabled && isFiniteDatalogGroup(this, group, finiteDatalogCache) &&
        datalogDependencyClauseCount(this, group) >= 128;
      // Large finite, range-restricted positive Datalog can be evaluated as a
      // single indexed least model.  Keep tableAllVariants as the semantic
      // fallback for finite programs whose answers may contain variables.
      group.datalogLeastModel = group.tableAllVariants &&
        isRangeRestrictedFiniteDatalogGroup(this, group, rangeRestrictedDatalogCache);
    }

    // Explicit tnot/1 opts finite, function-free Datalog into well-founded
    // evaluation.  Keep ISO \+/1 and not/1 on their existing negation-as-failure
    // path: WFS is an extension with different three-valued semantics and must
    // not silently change ordinary Prolog programs.  A group is WFS-backed when
    // its dependency cone reaches an SCC containing an edge introduced by
    // tnot/1 and the whole cone is range-restricted finite Datalog.
    const wfsCycleNodes = new Set();
    for (const [from, to] of wfsNegativeEdges) {
      if (!reachableIndexes(to, deps).has(from)) continue;
      wfsCycleNodes.add(from);
      wfsCycleNodes.add(to);
    }
    const finiteWfsCache = new Map();
    for (const group of groups) {
      const start = indexByGroup.get(group);
      const reachable = reachableIndexes(start, deps);
      const reachesWfsCycle = [...wfsCycleNodes].some((index) => reachable.has(index));
      group.wfsDatalog = reachesWfsCycle && isFiniteWfsDatalogGroup(this, group, finiteWfsCache);
    }
  }

  analyzeNegationStratification() {
    // Stratified negation is a portability diagnostic. A program is stratified
    // when no predicate depends negatively on itself, directly or indirectly.
    const groups = [...this.groups.values()];
    const groupKeys = new Map(groups.map((group) => [group, modulePredicateKey(group.module, group.name, group.arity)]));
    const groupByKey = new Map(groups.map((group) => [modulePredicateKey(group.module, group.name, group.arity), group]));
    const indexByKey = new Map(groups.map((group, i) => [modulePredicateKey(group.module, group.name, group.arity), i]));
    const edges = [];

    for (const group of groups) {
      const from = groupKeys.get(group);
      for (const clause of group.clauses) {
        for (const goal of clause.body) {
          for (const dep of collectGoalDependencies(goal, false)) {
            const target = this.findGroup(dep.name, dep.arity, dep.module ?? group.module);
            if (!target) continue;
            edges.push({ from, to: groupKeys.get(target), negative: dep.negative });
          }
        }
      }
    }

    const adjacency = groups.map(() => []);
    for (const edge of edges) {
      const from = indexByKey.get(edge.from);
      const to = indexByKey.get(edge.to);
      if (from == null || to == null) continue;
      adjacency[from].push(to);
    }

    const sccs = stronglyConnectedComponents(adjacency);
    const componentByIndex = new Map();
    for (let component = 0; component < sccs.length; component++) {
      for (const index of sccs[component]) componentByIndex.set(index, component);
    }

    const violations = [];
    const seen = new Set();
    for (const edge of edges) {
      if (!edge.negative) continue;
      const from = indexByKey.get(edge.from);
      const to = indexByKey.get(edge.to);
      if (from == null || to == null) continue;
      if (componentByIndex.get(from) !== componentByIndex.get(to)) continue;
      const key = `${edge.from}->${edge.to}`;
      if (seen.has(key)) continue;
      seen.add(key);
      violations.push({ from: edge.from, to: edge.to });
    }

    const strata = computeNegationStrata(groups, edges, indexByKey);
    for (const group of groups) group.negationStratum = strata.get(groupKeys.get(group)) ?? null;

    this._negationAnalysis = {
      dependencies: edges,
      errors: violations,
      stratified: violations.length === 0,
    };
    return violations;
  }
  ensureNegationStratification() {
    if (!this._negationAnalysis) this.analyzeNegationStratification();
    return this._negationAnalysis;
  }
  get negationDependencies() {
    return this.ensureNegationStratification().dependencies;
  }
  get negationStratificationErrors() {
    return this.ensureNegationStratification().errors;
  }
  get stratifiedNegation() {
    return this.ensureNegationStratification().stratified;
  }
  assertStratifiedNegation() {
    const violations = this.ensureNegationStratification().errors;
    if (violations.length === 0) return true;
    const details = violations.map((edge) => `${edge.from} depends negatively on ${edge.to}`).join('; ');
    throw new Error(`unstratified negation: ${details}`);
  }
  isStratifiedNegation() {
    return this.ensureNegationStratification().stratified;
  }

  groupHasRule(group) {
    return group.clauses.some((clause) => clauseBodyLength(clause) > 0);
  }
  sourceFactLines(predicateKeys = null, options = {}) {
    const lines = new Set();
    const env = new Env();
    const writeOptions = {
      ...options,
      operators: options.operators ?? [...this.operators.values()],
      quoted: true,
    };
    for (const clause of this.clauses) {
      if (isCompactBinaryClause(clause)) {
        if (clause.bodyName != null) continue;
        if (predicateKeys && !predicateKeys.has(`${clause.headName}/2`)) continue;
        lines.add(`${formatTermForWrite(clause.head, env, writeOptions)}.\n`);
        continue;
      }
      if (clause.body.length !== 0 || (clause.head.type !== ATOM && clause.head.type !== COMPOUND)) continue;
      if (predicateKeys && !predicateKeys.has(`${clause.head.name}/${clause.head.arity}`)) continue;
      lines.add(`${formatTermForWrite(clause.head, env, writeOptions)}.\n`);
    }
    return lines;
  }
}

class ProgramBuilder {
  constructor(options = {}, program = null) {
    this.options = options;
    this.program = program ?? new Program([], { ...options, [DEFER_PROGRAM_BUILD]: true });
    this.declaredDynamicIndicators = new Map();
    this.declaredPublicIndicators = new Map();
    this.declaredMultifileIndicators = new Map();
    this.declaredDiscontiguousIndicators = new Map();
    this.declaredTableIndicators = new Map();
    this.directiveDeclarationsByText = new Map();
    this.clauseTextUnitsByKey = new Map();
    this.lastPredicateByText = new Map();
    this.lastGroupKey = null;
    this.lastGroup = null;
    this.finished = false;
  }

  declarationSet(textUnit, kind) {
    const unit = textUnit ?? '<input>';
    let declarations = this.directiveDeclarationsByText.get(unit);
    if (!declarations) {
      declarations = { dynamic: new Set(), public: new Set(), multifile: new Set(), discontiguous: new Set(), table: new Set() };
      this.directiveDeclarationsByText.set(unit, declarations);
    }
    return declarations[kind];
  }

  noteProcedureClause(key, textUnit) {
    if (!this.program.strictIso) return;
    const unit = textUnit ?? '<input>';
    const declarations = this.directiveDeclarationsByText.get(unit);
    const units = this.clauseTextUnitsByKey.get(key) ?? new Set();

    if (this.program.dynamicPredicates.has(key) && !declarations?.dynamic.has(key)) {
      throw new Error(`ISO preparation error: dynamic(${key}) must precede clauses for ${key} in every Prolog text`);
    }

    if (units.size > 0 && !units.has(unit)) {
      if (!declarations?.multifile.has(key)) {
        throw new Error(`ISO preparation error: multifile(${key}) is required before clauses for ${key} in this Prolog text`);
      }
      for (const prior of units) {
        if (!this.directiveDeclarationsByText.get(prior)?.multifile.has(key)) {
          throw new Error(`ISO preparation error: multifile(${key}) is required in every Prolog text containing clauses for ${key}`);
        }
      }
    }

    const last = this.lastPredicateByText.get(unit);
    if (last != null && last !== key && units.has(unit) && !declarations?.discontiguous.has(key)) {
      throw new Error(`ISO preparation error: discontiguous(${key}) must precede non-consecutive clauses for ${key}`);
    }
    units.add(unit);
    this.clauseTextUnitsByKey.set(key, units);
    this.lastPredicateByText.set(unit, key);
  }

  addProcedureDirective(clause, kind, targetSet, declaredMap) {
    const program = this.program;
    const indicators = procedureDirectiveIndicators(clause, kind, program.strictIso);
    if (indicators == null) return false;
    const textUnit = clause.textUnit ?? '<input>';
    const local = this.declarationSet(textUnit, kind);
    for (const indicator of indicators) {
      assertDynamicIndicatorIsDefinable(indicator, program.strictIso);
      const module = clause.module ?? 'user';
      const key = modulePredicateKey(module, indicator.name, indicator.arity);
      if (program.strictIso && this.clauseTextUnitsByKey.get(key)?.has(textUnit)) {
        throw new Error(`ISO preparation error: ${kind}(${indicator.key}) must precede all clauses for ${indicator.key}`);
      }
      if (program.strictIso && kind === 'dynamic') {
        for (const prior of this.clauseTextUnitsByKey.get(key) ?? []) {
          if (prior !== textUnit && !this.directiveDeclarationsByText.get(prior)?.dynamic.has(key)) {
            throw new Error(`ISO preparation error: dynamic(${indicator.key}) is required in every Prolog text containing clauses for ${indicator.key}`);
          }
        }
      }
      if (program.strictIso && kind === 'multifile') {
        for (const prior of this.clauseTextUnitsByKey.get(key) ?? []) {
          if (prior !== textUnit && !this.directiveDeclarationsByText.get(prior)?.multifile.has(key)) {
            throw new Error(`ISO preparation error: multifile(${indicator.key}) is required in every Prolog text containing clauses for ${indicator.key}`);
          }
        }
      }
      local.add(key);
      targetSet.add(key);
      declaredMap.set(`${textUnit}\u0000${key}`, { ...indicator, key, module, textUnit });
      if (kind === 'public') {
        // Unlike dynamic/1, a public declaration says nothing about existence:
        // it only grants clause/2 access. Groups created later pick the flag up
        // from program.publicPredicates in makeGroup.
        const existing = program.groups.get(key);
        if (existing) existing.public = true;
      }
      if (kind === 'dynamic') {
        // A dynamic declaration creates the procedure immediately, not only
        // when ProgramBuilder.finish() runs. Compile-time source-expansion
        // hooks can therefore call an explicitly declared empty dynamic
        // predicate while the remainder of the same file is still loading.
        let existing = program.groups.get(key);
        if (!existing) {
          existing = program.makeGroup(indicator.name, indicator.arity, module);
          program.groups.set(key, existing);
        }
        existing.dynamic = true;
      }
    }
    return true;
  }

  addClauses(clauses) {
    if (this.finished) throw new Error('program builder is already finalized');
    const program = this.program;
    let lastGroupKey = this.lastGroupKey;
    let lastGroup = this.lastGroup;

    for (const clause of clauses) {
      if (program.strictIso && clauseContainsStringExtension(clause)) {
        // Programmatic clauses are part of the public embedding surface.  The
        // normal profile permits its host string term extension, but the Part 1
        // strict profile must reject that implementation-specific sixth type.
        throw new PrologError('representation_error(term)');
      }
      if (clause?.kind === 'quad') {
        const module = clause.module ?? 'user';
        annotateGoalModule(clause.query, module);
        program.quads.push({ ...clause, module });
        continue;
      }
      clause.index = program.clauses.length;
      program.clauses.push(clause);

      if (isCompactBinaryClause(clause)) {
        assertPredicateIsDefinable(clause.headName, 2, program.strictIso);
        const module = clause.module ?? 'user';
        const key = modulePredicateKey(module, clause.headName, 2);
        this.noteProcedureClause(key, clause.textUnit);
        let group = key === lastGroupKey ? lastGroup : program.groups.get(key);
        if (!group) {
          group = program.makeGroup(clause.headName, 2, module);
          program.groups.set(key, group);
        }
        lastGroupKey = key;
        lastGroup = group;
        const clausePosition = group.clauses.length;
        group.clauses.push(clause);
        clause.groundHead = clause.head0Type !== VAR && clause.head1Type !== VAR;
        clause.scalarHead = clause.groundHead;
        if (clause.bodyName != null || !clause.scalarHead) group.scalarFactsOnly = false;
        indexCompactOne(group.argIndexes[0], clause.head0Type, clause.head0Name, clause, group.clauses, clausePosition);
        indexCompactOne(group.argIndexes[1], clause.head1Type, clause.head1Name, clause, group.clauses, clausePosition);
        continue;
      }

      if (!isDirectiveClause(clause)) {
        if (Array.isArray(clause.body) && clause.body.length > 0) {
          // ISO 7.6.2 applies when source text is prepared as well as when a
          // clause term is asserted dynamically. Keep the original variable
          // objects while wrapping variable goals in call/1 so sharing with
          // the head (and recursively through ;/2 and ->/2) is preserved for
          // later clause/2 and retract/1 conversion back to terms.
          //
          // 7.5.1 prepares the read-terms of a Prolog text into database
          // clauses by this same conversion, so it is not conditional on the
          // strict profile. Skipping it left a bare variable goal where the
          // standard requires call/1, which both reports the wrong body term
          // through clause/2 (8.8.1.4, legs/2) and makes a cut in that goal
          // transparent instead of local to the call (7.8.3).
          clause.body = clause.body.map((goal) => convertClauseBodyTerm(goal));
        }
        assertHeadIsDefinable(clause.head, program.strictIso);
        const head = clause.head;
        if (head.type !== ATOM && head.type !== COMPOUND) continue;
        const module = clause.module ?? 'user';
        const key = modulePredicateKey(module, head.name, head.arity);
        this.noteProcedureClause(key, clause.textUnit);
        let group = key === lastGroupKey ? lastGroup : program.groups.get(key);
        if (!group) {
          group = program.makeGroup(head.name, head.arity, module);
          program.groups.set(key, group);
        }
        lastGroupKey = key;
        lastGroup = group;
        const clausePosition = group.clauses.length;
        group.clauses.push(clause);
        clause.groundHead = termHasNoVariables(head);
        clause.scalarHead = head.type === COMPOUND && head.args.every(isScalar);
        if (clauseHasCut(clause)) group.hasCut = true;
        if (clause.body.length !== 0 || !clause.scalarHead) group.scalarFactsOnly = false;
        for (let i = 0; i < head.arity; i++) {
          indexOne(group.argIndexes[i], head.args[i], clause, group.clauses, clausePosition, group.dynamic === true);
        }
        continue;
      }

      this.addDirectiveClause(clause);
    }

    this.lastGroupKey = lastGroupKey;
    this.lastGroup = lastGroup;
  }

  addDirectiveClause(clause) {
    const program = this.program;
    const module = clause.module ?? 'user';
    const textUnit = clause.textUnit ?? '<input>';
    this.addProcedureDirective(clause, 'dynamic', program.dynamicPredicates, this.declaredDynamicIndicators);
    // public/1 is an extension, so the strict Part 1 profile does not offer it.
    if (!program.strictIso) {
      this.addProcedureDirective(clause, 'public', program.publicPredicates, this.declaredPublicIndicators);
    }
    this.addProcedureDirective(clause, 'multifile', program.multifilePredicates, this.declaredMultifileIndicators);
    this.addProcedureDirective(clause, 'discontiguous', program.discontiguousPredicates, this.declaredDiscontiguousIndicators);
    this.addProcedureDirective(clause, 'table', program.tabledPredicates, this.declaredTableIndicators);

    const operator = operatorDirective(clause);
    if (operator) {
      for (const name of operator.names) program.defineOperator(operator.priority, operator.specifier, name);
    }

    const directive = clause.head.args[0];
    if (directive?.type === COMPOUND && directive.name === 'module' && directive.arity === 2) {
      const name = directive.args[0];
      const exports = moduleExportIndicators(directive.args[1]);
      if (name.type !== ATOM) throw new PrologError('type_error(atom)', name);
      if (exports == null) throw new PrologError('type_error(list)', directive.args[1]);
      program.defineModule(name.name, exports, clause.source?.filename ?? clause.moduleFilename ?? '<input>');
    } else if (directive?.type === COMPOUND && directive.name === 'meta_predicate' && directive.arity === 1) {
      for (const template of flattenDirectiveSequence(directive.args[0])) {
        program.defineMetaPredicate(module, template);
      }
    } else if (directive?.type === COMPOUND && directive.name === 'initialization' && directive.arity === 1) {
      annotateGoalModule(directive.args[0], module);
      program.initializations.push(directive.args[0]);
    } else if (directive?.type === COMPOUND && directive.name === 'set_prolog_flag' && directive.arity === 2) {
      program.prologFlagDirectives.push(directive.args);
    } else if (directive?.type === COMPOUND && directive.name === 'char_conversion' && directive.arity === 2) {
      program.charConversionDirectives.push(directive.args);
    }
    if (program.strictIso) this.lastPredicateByText.set(textUnit, '@directive');
  }

  finish() {
    if (this.finished) return this.program;
    this.finished = true;
    const program = this.program;

    // A dynamic declaration creates a procedure even when it has no clauses.
    // Calls to that procedure fail normally instead of being treated as calls
    // to an unknown predicate.
    for (const declarations of [
      this.declaredDynamicIndicators, this.declaredMultifileIndicators, this.declaredDiscontiguousIndicators,
    ]) {
      for (const indicator of declarations.values()) {
        if (!program.groups.has(indicator.key)) {
          program.groups.set(indicator.key, program.makeGroup(indicator.name, indicator.arity, indicator.module));
        }
      }
    }
    program.mutable = program.dynamicPredicates.size > 0;

    // Static indexes are built while clauses stream into the builder. Dynamic
    // updates still rebuild only the affected predicate group.
    // Strict ISO core mode follows ordinary ISO clause selection rather than
    // EyeProlog's recursion-planning metadata, numeric recursion shortcuts, or
    // explicitly tabled fixed points.  Leaving the recursion-planning fields at their
    // neutral defaults preserves the standard depth-first execution model.
    if (!program.strictIso) program.markRecursivePredicates();
    if (this.options.analyzeNegation === true || this.options.strictNegation === true) {
      program.analyzeNegationStratification();
    }
    if (this.options.strictNegation === true) program.assertStratifiedNegation();
    return program;
  }
}

function buildProgramFromSources(sources, options) {
  // The source-metadata-free path is common for CLI and conformance runs. For
  // a homogeneous source set, first try the compact parser directly into a
  // fresh builder. Source sets that contain module-loading directives use a
  // hybrid path instead: directive-heavy sources take the general parser while
  // independent fast-compatible sources can still keep their compact clauses.
  // This matters for launchers that load a small support program followed by a
  // very large ordinary fact/rule file.
  const hasModuleDirectives = sources.some((source) => {
    const text = typeof source === 'string' ? source : source?.text ?? source?.source ?? '';
    return /:-\s*(?:module|use_module)\s*\(/.test(text);
  });
  if (options.sourceMetadata === false && !hasModuleDirectives) {
    const builder = new ProgramBuilder(options);
    if (loadSourcesIntoBuilder(builder, sources, options, true)) return builder.finish();
  }
  if (options.sourceMetadata === false && hasModuleDirectives) {
    const builder = new ProgramBuilder(options);
    if (loadSourcesIntoBuilder(builder, sources, options, 'hybrid')) return builder.finish();
  }

  const builder = new ProgramBuilder(options);
  loadSourcesIntoBuilder(builder, sources, options, false);
  return builder.finish();
}

function cloneOperatorState(state) {
  return {
    infixOperators: new Map(state.infixOperators),
    prefixOperators: new Map(state.prefixOperators),
    postfixOperators: new Map(state.postfixOperators),
  };
}

function cloneParserFlagState(state) {
  return {
    doubleQuotes: state.doubleQuotes,
    charConversion: state.charConversion,
    charConversions: new Map(state.charConversions),
  };
}

function hybridFastSource(source, options) {
  // Module/include directives recurse into additional source texts and can
  // change lexical context. Keep those sources on the general loader. Ordinary
  // user files may still contain op/3, dynamic/1, discontiguous/1, etc.; the
  // compact parser handles those term-by-term and updates the shared state.
  if (/:-(?:\s|\/\*[\s\S]*?\*\/)*(?:module|use_module|include|ensure_loaded)\s*\(/.test(source)) return false;
  const probeOptions = {
    ...options,
    operatorState: cloneOperatorState(options.operatorState),
    parserFlagState: cloneParserFlagState(options.parserFlagState),
    onWarning: null,
  };
  return tryParseClausesFastInto(source, () => {}, () => {}, probeOptions);
}

// Program.parse() can see host-supplied goals through autoloadGoals while it
// builds the program. A Program passed directly to run() has already completed
// that phase, so extend the existing instance with the same canonical interop
// imports before solving those goals. Keeping this here lets both paths share
// the dependency analysis and module-loading rules.
// Load one bundled library module into an already-built Program without
// importing its public predicates into user. This is useful for host bootstraps
// that call a module-private Prolog entry point while keeping the user-facing
// module export list unchanged.
export function loadBundledProgramLibrary(program, name, options = {}) {
  if (program.modules.has(name)) return program;
  const operatorState = createParserOperatorState(
    [...program.operators.values()],
    false,
    { isoStrict: program.strictIso },
  );
  const parserFlagState = {
    doubleQuotes: program.doubleQuotes ?? options.doubleQuotes ?? 'chars',
    charConversion: 'on',
    charConversions: new Map(),
  };
  const builder = new ProgramBuilder({ ...options, isoStrict: program.strictIso }, program);
  const loadedModules = new Set([...program.modules.keys()].filter((module) => module !== 'user'));
  const ensured = new Set();
  const designation = compound('library', [atom(name)]);
  const loaded = readModuleSource(designation, {
    ...options,
    isoStrict: program.strictIso,
    operatorState,
    parserFlagState,
  });
  const childContext = { module: loaded.name };
  if (!loadSourceIntoBuilder(
    builder, loaded.text, loaded.options, ensured, loadedModules, false, childContext,
  )) {
    throw new Error(`could not load library(${name})`);
  }
  program.noteMutation(false);
  builder.finish();
  return program;
}

export function autoloadProgramGoals(program, inputs, options = {}) {
  if (inputs == null || (Array.isArray(inputs) && inputs.length === 0)) return program;
  const operatorState = createParserOperatorState(
    [...program.operators.values()],
    false,
    { isoStrict: program.strictIso },
  );
  const parserFlagState = { doubleQuotes: program.doubleQuotes ?? options.doubleQuotes ?? 'chars', charConversion: 'on', charConversions: new Map() };
  const goals = parseInteropGoalInputs(inputs, {
    ...options,
    isoStrict: program.strictIso,
    operatorState,
    parserFlagState,
  }, program);

  if (!program.strictIso && options.autoload !== false) {
    const builder = new ProgramBuilder({ ...options, isoStrict: false }, program);
    const loadedModules = new Set([...program.modules.keys()].filter((name) => name !== 'user'));
    const autoloadCount = program.autoloadedPredicates.length;
    autoloadLibraryDependencies(builder, {
      ...options,
      isoStrict: false,
      operatorState,
      parserFlagState,
    }, new Set(), loadedModules, goals);
    if (program.autoloadedPredicates.length !== autoloadCount) {
      // Existing Solver instances key their tables by Program revision, and a
      // previously requested negation analysis is no longer complete once new
      // library groups become reachable.
      program.noteMutation(false);
      builder.finish();
    }
  }
  analyzeInteropPortability(program, goals);
  return program;
}

function loadSourcesIntoBuilder(builder, sources, options, fast) {
  const ensured = new Set();
  const loadedModules = new Set();
  const operatorState = createParserOperatorState([], true, { isoStrict: options.isoStrict === true });
  const parserFlagState = { doubleQuotes: options.doubleQuotes ?? 'chars', charConversion: 'on', charConversions: new Map() };
  const prepared = sources.map((source) => ({
    source,
    options: { ...sourceOptionsFor(source, options), operatorState, parserFlagState },
  }));
  for (const item of prepared) {
    const filename = sourcePath(item.options);
    if (filename) ensured.add(filename);
  }
  try {
    for (const [sourceIndex, item] of prepared.entries()) {
      const text = typeof item.source === 'string'
        ? item.source
        : item.source?.text ?? item.source?.source ?? '';
      const context = {
        module: 'user',
        textUnit: sourcePath(item.options) ?? `<input:${sourceIndex}>`,
      };
      const sourceFast = fast === 'hybrid' ? hybridFastSource(text, item.options) : fast;
      if (!loadSourceIntoBuilder(builder, text, item.options, ensured, loadedModules, sourceFast, context)) return false;
    }
    const autoloadGoals = parseInteropGoalInputs(options.autoloadGoals, {
      ...options,
      operatorState,
      parserFlagState,
    }, builder.program);
    if (options.isoStrict !== true && options.autoload !== false) {
      autoloadLibraryDependencies(builder, {
        ...options,
        operatorState,
        parserFlagState,
      }, ensured, loadedModules, autoloadGoals);
    }
    analyzeInteropPortability(builder.program, autoloadGoals);
    builder.program.doubleQuotes = parserFlagState.doubleQuotes;
    return true;
  } catch (error) {
    if (error === FAST_PARSE_ABORT) return false;
    throw error;
  }
}


const interopIndicatorSet = new Set(eyePrologInteropLibraryIndicators);
const interopLibraryModuleSet = new Set(eyePrologInteropLibraryModules);

function libraryDesignationName(designation) {
  return designation?.type === COMPOUND && designation.name === 'library' && designation.arity === 1 &&
    designation.args[0]?.type === ATOM
    ? designation.args[0].name
    : null;
}

function bundledLibraryModule(program, module) {
  return module !== 'user' && program.modules.get(module)?.filename?.startsWith('src/lib/');
}

function groupDependencies(group) {
  const dependencies = [];
  for (const clause of group.clauses) {
    // Forward rules store executable premises inside their heads instead of in
    // ordinary clause bodies. Include those premises in static dependency
    // analysis so portability checks see the same calls that runtime will see.
    if (group.name === ':+') {
      collectForwardRulePremiseDependencies(
        clause.head,
        (goal, out) => out.push(...collectGoalDependencies(goal, false, true)),
        dependencies,
      );
    }
    if (isCompactBinaryClause(clause)) {
      if (clause.bodyName != null) {
        dependencies.push({
          key: `${clause.bodyName}/2`,
          name: clause.bodyName,
          arity: 2,
          module: clause.module ?? group.module,
        });
      }
      continue;
    }
    for (const goal of clause.body) {
      dependencies.push(...collectGoalDependencies(goal, false, true));
    }
  }
  return dependencies;
}

function collectForwardRulePremiseDependencies(term, collect, out) {
  if (term?.type !== COMPOUND) return out;
  if (term.name === ':+' && term.arity === 2) {
    collect(term.args[1], out);
    collectForwardRulePremiseDependencies(term.args[0], collect, out);
    return out;
  }
  if (term.name === ',' && term.arity === 2) {
    collectForwardRulePremiseDependencies(term.args[0], collect, out);
    collectForwardRulePremiseDependencies(term.args[1], collect, out);
  }
  return out;
}

// Autoloading needs a slightly richer dependency walk than recursion analysis.
// Meta-predicates such as forall/2 and setof/3 are themselves callable
// procedures while also containing executable goals.  The recursion graph
// intentionally looks through those wrappers; the autoloader must see both the
// wrapper and any statically visible nested calls so a bundled library can be
// loaded before execution reaches it.
// ISO 13211-1, 7.1.6.3: the iterated goal of `V1^V2^...^Goal` is Goal.  The
// qualifiers only mark witness variables as existentially quantified, so every
// static analysis of a bagof/3 or setof/3 goal argument has to look through
// them before it reaches the callable term.
function iteratedGoalTerm(goal) {
  let current = goal;
  while (current?.type === COMPOUND && current.name === '^' && current.arity === 2) {
    current = current.args[1];
  }
  return current;
}

function collectAutoloadGoalDependencies(goal, out = []) {
  if (goal?.type === ATOM) {
    out.push({ key: `${goal.name}/0`, name: goal.name, arity: 0, module: goal.module });
    return out;
  }
  if (goal?.type !== COMPOUND) return out;
  if (goal.name === ',' && goal.arity === 2) {
    collectAutoloadGoalDependencies(goal.args[0], out);
    collectAutoloadGoalDependencies(goal.args[1], out);
    return out;
  }
  if ((goal.name === ';' || goal.name === '->') && goal.arity === 2) {
    collectAutoloadGoalDependencies(goal.args[0], out);
    collectAutoloadGoalDependencies(goal.args[1], out);
    return out;
  }
  if ((goal.name === '\\+' || goal.name === 'not' || goal.name === 'tnot' || goal.name === 'once') && goal.arity === 1) {
    collectAutoloadGoalDependencies(goal.args[0], out);
    return out;
  }
  if (goal.name === 'wfs_truth' && goal.arity === 2) {
    collectAutoloadGoalDependencies(goal.args[0], out);
    return out;
  }

  out.push({ key: `${goal.name}/${goal.arity}`, name: goal.name, arity: goal.arity, module: goal.module });

  if (goal.name === 'forall' && goal.arity === 2) {
    collectAutoloadGoalDependencies(goal.args[0], out);
    collectAutoloadGoalDependencies(goal.args[1], out);
  } else if ((goal.name === 'findall' || goal.name === 'bagof' || goal.name === 'setof' || goal.name === 'sumall') && goal.arity === 3) {
    // bagof/3 and setof/3 take an iterated-goal term (ISO 13211-1, 7.1.6.3):
    // any number of `Witness^Goal` qualifiers wrap the goal that is actually
    // executed.  Autoloading has to see through them, otherwise
    // setof(X, Y^member(X,L), S) raises existence_error(member/2) while the
    // unqualified setof(X, member(X,L), S) resolves normally.
    collectAutoloadGoalDependencies(iteratedGoalTerm(goal.args[1]), out);
  } else if (goal.name === 'countall' && goal.arity === 2) {
    collectAutoloadGoalDependencies(goal.args[0], out);
  } else if ((goal.name === 'aggregate_min' || goal.name === 'aggregate_max') && goal.arity === 5) {
    collectAutoloadGoalDependencies(goal.args[2], out);
  } else if (goal.name === 'catch' && goal.arity === 3) {
    collectAutoloadGoalDependencies(goal.args[0], out);
    collectAutoloadGoalDependencies(goal.args[2], out);
  } else if ((goal.name === 'call_cleanup' || goal.name === 'setup_call_cleanup') && (goal.arity === 2 || goal.arity === 3)) {
    for (const arg of goal.args) collectAutoloadGoalDependencies(arg, out);
  } else if (goal.name === 'call' && goal.arity === 1) {
    collectAutoloadGoalDependencies(goal.args[0], out);
  }
  return out;
}

function groupAutoloadDependencies(group) {
  const dependencies = [];
  for (const clause of group.clauses) {
    if (group.name === ':+') {
      collectForwardRulePremiseDependencies(clause.head, collectAutoloadGoalDependencies, dependencies);
    }
    if (isCompactBinaryClause(clause)) {
      if (clause.bodyName != null) {
        dependencies.push({
          key: `${clause.bodyName}/2`,
          name: clause.bodyName,
          arity: 2,
          module: clause.module ?? group.module,
        });
      }
      continue;
    }
    for (const goal of clause.body) collectAutoloadGoalDependencies(goal, dependencies);
  }
  return dependencies;
}

function parseInteropGoalInputs(inputs, options, program) {
  if (inputs == null) return [];
  const values = Array.isArray(inputs) ? inputs : [inputs];
  return values.filter((value) => value != null).map((value) => {
    if (typeof value !== 'string') return value;
    return parseGoalText(value, {
      doubleQuotes: options.parserFlagState?.doubleQuotes ?? options.doubleQuotes ?? program.doubleQuotes ?? 'chars',
      operatorDefinitions: [...program.operators.values()],
      isoStrict: options.isoStrict === true,
    });
  });
}

function extraGoalDependencies(goals) {
  const dependencies = [];
  for (const goal of goals) collectAutoloadGoalDependencies(goal, dependencies);
  return dependencies;
}

function procedureResolvedBeforeAutoload(program, dependency, targetModule) {
  if (program.findGroup(dependency.name, dependency.arity, targetModule)) return true;
  return program.moduleImports.get(targetModule)?.has(dependency.key) === true;
}

function autoloadLibraryFor(dependency) {
  // ISO built-ins always take precedence over optional library autoloading.
  if (getDefaultRegistry().get(dependency.name, dependency.arity) != null) return null;
  const ambiguous = eyePrologAmbiguousLibraryAutoload[dependency.key];
  if (ambiguous != null) {
    throw new PrologError(
      'permission_error(import, procedure)',
      compound('/', [atom(dependency.name), numberTerm(dependency.arity)]),
    );
  }
  return eyePrologLibraryAutoload[dependency.key] ?? null;
}

function libraryAutoloadRequests(program, extraGoals = []) {
  const requests = new Map();
  for (const group of program.groups.values()) {
    if (bundledLibraryModule(program, group.module)) continue;
    for (const dependency of groupAutoloadDependencies(group)) {
      const targetModule = dependency.module ?? group.module;
      if (procedureResolvedBeforeAutoload(program, dependency, targetModule)) continue;
      const library = autoloadLibraryFor(dependency);
      if (library == null) continue;
      const requestKey = `${targetModule}\u0000${dependency.key}`;
      requests.set(requestKey, {
        targetModule,
        library,
        name: dependency.name,
        arity: dependency.arity,
        key: dependency.key,
      });
    }
  }
  for (const goal of program.initializations) {
    for (const dependency of collectAutoloadGoalDependencies(goal)) {
      const targetModule = dependency.module ?? 'user';
      if (procedureResolvedBeforeAutoload(program, dependency, targetModule)) continue;
      const library = autoloadLibraryFor(dependency);
      if (library == null) continue;
      const requestKey = `${targetModule}\u0000${dependency.key}`;
      requests.set(requestKey, {
        targetModule,
        library,
        name: dependency.name,
        arity: dependency.arity,
        key: dependency.key,
      });
    }
  }
  for (const dependency of extraGoalDependencies(extraGoals)) {
    const targetModule = dependency.module ?? 'user';
    if (procedureResolvedBeforeAutoload(program, dependency, targetModule)) continue;
    const library = autoloadLibraryFor(dependency);
    if (library == null) continue;
    const requestKey = `${targetModule}\u0000${dependency.key}`;
    requests.set(requestKey, {
      targetModule,
      library,
      name: dependency.name,
      arity: dependency.arity,
      key: dependency.key,
    });
  }
  return [...requests.values()];
}

function autoloadLibraryDependencies(builder, options, ensured, loadedModules, extraGoals = []) {
  const program = builder.program;
  while (true) {
    const requests = libraryAutoloadRequests(program, extraGoals);
    if (requests.length === 0) return;
    let changed = false;
    for (const request of requests) {
      if (procedureResolvedBeforeAutoload(program, request, request.targetModule)) continue;
      if (!loadedModules.has(request.library)) {
        const designation = compound('library', [atom(request.library)]);
        const loaded = readModuleSource(designation, options);
        const childContext = { module: loaded.name };
        // Bundled library sources are small and directive-heavy.  Parse them
        // with the general parser even when the user source took the compact
        // fast path; this avoids rebuilding otherwise-fast user programs.
        if (!loadSourceIntoBuilder(
          builder, loaded.text, loaded.options, ensured, loadedModules, false, childContext,
        )) {
          throw new Error(`could not autoload library(${request.library})`);
        }
      }
      program.importModule(request.targetModule, request.library, [request]);
      program.autoloadedPredicates.push({
        targetModule: request.targetModule,
        library: request.library,
        indicator: request.key,
      });
      changed = true;
    }
    if (!changed) return;
  }
}

function analyzeInteropPortability(program, extraGoals = []) {
  const warnings = new Map();
  const nonInteropImports = new Map();
  for (const entry of program.libraryImports) {
    if (bundledLibraryModule(program, entry.targetModule)) continue;
    if (!interopLibraryModuleSet.has(entry.library)) {
      warnings.set(`library:${entry.targetModule}:${entry.library}`, {
        kind: 'library',
        library: entry.library,
        targetModule: entry.targetModule,
      });
      const libraries = nonInteropImports.get(entry.targetModule) ?? new Set();
      libraries.add(entry.library);
      nonInteropImports.set(entry.targetModule, libraries);
      continue;
    }
    if (entry.imports != null) {
      for (const indicator of entry.imports) {
        if (interopIndicatorSet.has(indicator.key)) continue;
        warnings.set(`predicate:${entry.targetModule}:${entry.library}:${indicator.key}`, {
          kind: 'predicate',
          library: entry.library,
          indicator: indicator.key,
          targetModule: entry.targetModule,
        });
      }
    }
  }

  for (const group of program.groups.values()) {
    if (bundledLibraryModule(program, group.module)) continue;
    for (const dependency of groupDependencies(group)) {
      const targetModule = dependency.module ?? group.module;
      const resolved = program.findGroup(dependency.name, dependency.arity, targetModule);
      if (!resolved || !bundledLibraryModule(program, resolved.module)) continue;
      if (interopIndicatorSet.has(dependency.key)) continue;
      if (nonInteropImports.get(targetModule)?.has(resolved.module)) continue;
      warnings.set(`predicate:${targetModule}:${resolved.module}:${dependency.key}`, {
        kind: 'predicate',
        library: resolved.module,
        indicator: dependency.key,
        targetModule,
      });
    }
  }

  for (const dependency of extraGoalDependencies(extraGoals)) {
    const targetModule = dependency.module ?? 'user';
    const resolved = program.findGroup(dependency.name, dependency.arity, targetModule);
    if (!resolved || !bundledLibraryModule(program, resolved.module)) continue;
    if (interopIndicatorSet.has(dependency.key)) continue;
    if (nonInteropImports.get(targetModule)?.has(resolved.module)) continue;
    warnings.set(`predicate:${targetModule}:${resolved.module}:${dependency.key}`, {
      kind: 'predicate',
      library: resolved.module,
      indicator: dependency.key,
      targetModule,
    });
  }
  program.interopPortabilityWarnings = [...warnings.values()];
  analyzeLibraryShadowing(program);
}

// A user-defined procedure replaces the bundled-library procedure of the same
// name and arity: the library clauses are never autoloaded, so other parts of
// the same program that expected the library behaviour just see the user's
// clauses. Bundled library modules keep resolving their own internal calls, so
// this only affects user code, but within user code it acts at a distance
// across included files.
//
// How strictly this is treated depends on how explicit the program was, which
// follows the graded scheme SWI-Prolog uses for the same situation:
//
//   implicit autoload                          -> warning
//   use_module(library(L))                     -> warning
//   use_module(library(L), [Name/Arity])       -> permission_error
//
// Only the last case is an outright contradiction: the program asked for that
// exact predicate to be imported and then supplied clauses for it. The first
// two stay warnings so that flat, module-free programs -- which load unchanged
// on Scryer and Trealla, where the library is simply never imported -- keep
// working. Note that ISO reserves permission_error(modify, static_procedure)
// for built-in predicates (7.5.3); library predicates are not built-ins, so
// this error is raised only where the program's own import list demands it.
function analyzeLibraryShadowing(program) {
  const explicitlyImported = new Map();
  for (const entry of program.libraryImports) {
    if (entry.imports == null) continue;
    for (const indicator of entry.imports) {
      explicitlyImported.set(`${entry.targetModule}:${indicator.key}`, entry.library);
    }
  }

  const shadowed = new Map();
  for (const group of program.groups.values()) {
    if (group.module !== 'user') continue;
    const key = `${group.name}/${group.arity}`;
    const explicitLibrary = explicitlyImported.get(`${group.module}:${key}`);
    if (explicitLibrary != null) throw staticProcedureModificationError(group.name, group.arity);
    const library = eyePrologLibraryAutoload[key];
    if (library == null || shadowed.has(key)) continue;
    shadowed.set(key, { kind: 'shadowed-library-predicate', indicator: key, library });
  }
  program.libraryShadowingWarnings = [...shadowed.values()];
}

function sourceOptionsFor(source, options) {
  if (typeof source === 'string') return options;
  return {
    ...options,
    filename: source?.filename ?? '<input>',
    baseDir: source?.baseDir ?? options.baseDir,
  };
}

function sourcePath(options) {
  if (!path) return null;
  const filename = String(options.filename ?? '');
  if (!filename || filename.startsWith('<') || /^https?:\/\//.test(filename)) return null;
  const base = options.baseDir ?? currentWorkingDirectory();
  return path.resolve(base, filename);
}

function loadSourceIntoBuilder(builder, source, options, ensured, loadedModules, fast, context) {
  const batch = [];
  const deferredGoalExpansions = [];
  // ISO/IEC 13211-2 amendment (2013), 6.2.5: a module body is one
  // Prolog text whose first term is module/2 and whose body continues to the
  // end of that text. Track prepared source terms per load so a later module/2
  // cannot silently switch the owning module mid-text. A recursive load gets
  // its own counter, so a distinct Prolog text may begin a distinct module.
  let sourceTermCount = 0;
  const preparedCacheKey = preparedBundledLibraryCacheKey(builder.program, options);
  const preparedForCache = preparedCacheKey == null ? null : [];
  const flush = () => {
    if (batch.length === 0) return;
    builder.addClauses(batch);
    batch.length = 0;
  };

  const processClause = (inputClause) => {
    let clause = inputClause;
    if (clause?.kind === 'quad') {
      flush();
      clause.module = context.module;
      builder.addClauses([clause]);
      return;
    }

    // User source expansion is a normal-profile compile-time facility. Hooks
    // execute against the clauses that have already been prepared, matching
    // Prolog's left-to-right source loading model. Strict ISO Part 1 keeps its
    // processor-defined preparation semantics unchanged.
    if (!builder.program.strictIso) {
      const expansion = expandSourceClause(builder.program, clause, context.module, {
        module: context.module,
        filename: options.filename ?? '<input>',
      });
      if (expansion.expanded) {
        for (const generated of expansion.clauses) processPreparedClause(generated);
        return;
      }
    }
    processPreparedClause(clause);
  };

  const acceptPreparedClause = (clause, lexicalModule, record = true) => {
    const sourceTermIndex = sourceTermCount++;
    const remember = () => {
      if (record && preparedForCache != null) {
        preparedForCache.push({ clause: cachedClauseCopy(clause), lexicalModule });
      }
    };

    const moduleDeclaration = moduleDirective(clause);
    if (moduleDeclaration) {
      if (sourceTermIndex !== 0) {
        throw new PrologError('permission_error(redefine, module)', atom(moduleDeclaration.name));
      }
      flush();
      clause.module = moduleDeclaration.name;
      clause.textUnit = context.textUnit;
      clause.moduleFilename = options.filename ?? '<input>';
      remember();
      builder.addClauses([clause]);
      context.module = moduleDeclaration.name;
      loadedModules.add(moduleDeclaration.name);
      return;
    }
    const use = useModuleDirective(clause);
    if (use) {
      flush();
      clause.module = context.module;
      clause.textUnit = context.textUnit;
      remember();
      builder.addClauses([clause]);
      const libraryName = libraryDesignationName(use.designation);
      if (libraryName != null) {
        builder.program.libraryImports.push({
          targetModule: context.module,
          library: libraryName,
          imports: use.imports == null ? null : use.imports.map((indicator) => ({ ...indicator })),
        });
      }
      const loaded = readModuleSource(use.designation, options);
      if (!loadedModules.has(loaded.name)) {
        const childContext = { module: loaded.name };
        if (!loadSourceIntoBuilder(builder, loaded.text, loaded.options, ensured, loadedModules, fast, childContext)) {
          throw FAST_PARSE_ABORT;
        }
      }
      builder.program.importModule(context.module, loaded.name, use.imports);
      return;
    }
    const include = includeDirective(clause);
    if (!include) {
      clause.module ??= context.module;
      clause.textUnit ??= context.textUnit;
      if (!isDirectiveClause(clause)) {
        const bodyModule = clause.lexicalModule ?? lexicalModule;
        for (const goal of clause.body) annotateGoalModule(goal, bodyModule);
      }
      remember();
      const isExpansionHook = !isDirectiveClause(clause) &&
        clause.head?.arity === 2 && ['term_expansion', 'goal_expansion'].includes(clause.head?.name);
      if (isExpansionHook) {
        // A hook becomes visible to the very next source term, so it cannot
        // wait in the large streaming build batch.
        flush();
        builder.addClauses([clause]);
      } else {
        batch.push(clause);
        if (batch.length >= PROGRAM_BUILD_BATCH_SIZE) flush();
      }
      return;
    }
    flush();
    remember();
    if (builder.program.strictIso && include.name === 'ensure_loaded') {
      builder.lastPredicateByText.set(context.textUnit ?? '<input>', '@directive');
    }
    const child = readIncludedSource(include, options, ensured);
    if (include.name === 'ensure_loaded') {
      const declaration = sourceModuleDeclaration(child.text, child.options);
      if (declaration) {
        // ISO/IEC 13211-2 amendment (2013), 6.2.5.6 notes that the public
        // predicates of a module loaded with ensure_loaded/1 are imported in
        // the same sense as use_module/1. Loading remains idempotent, but each
        // importing module still receives its own import mapping.
        if (!loadedModules.has(declaration.name)) {
          const childContext = {
            module: declaration.name,
            textUnit: sourcePath(child.options) ?? context.textUnit,
          };
          if (!loadSourceIntoBuilder(builder, child.text, child.options, ensured, loadedModules, fast, childContext)) {
            throw FAST_PARSE_ABORT;
          }
        }
        builder.program.importModule(context.module, declaration.name, null);
        return;
      }
      if (child.alreadyLoaded) return;
    }
    const childContext = include.name === 'include'
      ? context
      : { module: context.module, textUnit: sourcePath(child.options) ?? context.textUnit };
    if (!loadSourceIntoBuilder(builder, child.text, child.options, ensured, loadedModules, fast, childContext)) {
      throw FAST_PARSE_ABORT;
    }
  };

  const processPreparedClause = (inputClause) => {
    let clause = inputClause;
    const lexicalModule = context.module;

    // Grammar-rule expansion belongs to ISO/IEC TS 13211-3 rather than the
    // Part 1 strict-core language.  In strict core mode -->/2 remains the
    // ordinary predefined operator term from Table 7 and is not rewritten.
    const grammarClause = builder.program.strictIso ? null : expandDcgRuleClause(clause, lexicalModule);
    if (grammarClause) clause = grammarClause;

    // A source module qualifier on a clause head selects the procedure owner,
    // while unqualified calls in the body retain the lexical module of the
    // source text. This distinction is essential for conventional hooks such
    // as user:term_expansion/2 defined from library modules.
    if (!builder.program.strictIso) clause = normalizeQualifiedClauseHead(clause, lexicalModule);

    if (!builder.program.strictIso && !isDirectiveClause(clause)) {
      try {
        expandClauseGoals(builder.program, clause, lexicalModule, {
          module: lexicalModule,
          filename: options.filename ?? '<input>',
        });
      } catch (error) {
        // Scryer-compatible goal-expansion hooks may refer to helper predicates
        // that occur later in the same source file. Keep loading so those
        // helpers become visible, then retry this clause at end-of-source.
        // A still-missing helper (or any other expansion error) is reported on
        // the final retry rather than being silently ignored.
        if (!(error instanceof PrologError) || error.formal !== 'existence_error(procedure)') throw error;
        clause.module ??= lexicalModule;
        clause.textUnit ??= context.textUnit;
        deferredGoalExpansions.push({ clause, lexicalModule });
        return;
      }
    }

    acceptPreparedClause(clause, lexicalModule);
  };

  const cachedEntry = preparedCacheKey == null ? null : preparedBundledLibraryCache.get(preparedCacheKey);
  if (cachedEntry?.source === source) {
    for (const item of cachedEntry.clauses) {
      acceptPreparedClause(cachedClauseCopy(item.clause), item.lexicalModule, false);
    }
    flush();
    return true;
  }

  if (fast) {
    const acceptBinary = (headName, head0Type, head0Name, head1Type, head1Name,
        bodyName, body0Type, body0Name, body1Type, body1Name) => {
      batch.push(new CompactBinaryClause(
        headName, head0Type, head0Name, head1Type, head1Name,
        bodyName, body0Type, body0Name, body1Type, body1Name,
      ));
      batch[batch.length - 1].module = context.module;
      batch[batch.length - 1].textUnit = context.textUnit;
      if (batch.length >= PROGRAM_BUILD_BATCH_SIZE) flush();
    };
    const parsed = tryParseClausesFastInto(source, processClause, acceptBinary, options);
    if (parsed) flush();
    return parsed;
  }
  parseClausesInto(source, options, processClause);
  flush();
  if (!builder.program.strictIso && deferredGoalExpansions.length > 0) {
    for (const { clause, lexicalModule } of deferredGoalExpansions) {
      expandClauseGoals(builder.program, clause, lexicalModule, {
        module: lexicalModule,
        filename: options.filename ?? '<input>',
      });
      acceptPreparedClause(clause, lexicalModule);
    }
    flush();
  }
  if (preparedCacheKey != null) {
    preparedBundledLibraryCache.set(preparedCacheKey, { source, clauses: preparedForCache });
  }
  return true;
}

function normalizeQualifiedClauseHead(clause, lexicalModule = 'user') {
  if (clause == null || clause.kind === 'quad' || isDirectiveClause(clause)) return clause;
  const head = clause.head;
  if (head?.type !== COMPOUND || head.name !== ':' || head.arity !== 2) return clause;
  const qualifier = head.args[0];
  const qualifiedHead = head.args[1];
  if (qualifier.type === VAR) throw new PrologError('instantiation_error');
  if (qualifier.type !== ATOM) throw new PrologError('type_error(atom)', qualifier);
  if (qualifiedHead.type !== ATOM && qualifiedHead.type !== COMPOUND) {
    throw new PrologError('type_error(callable)', qualifiedHead);
  }
  clause.head = qualifiedHead;
  clause.module = qualifier.name;
  clause.lexicalModule = lexicalModule;
  return clause;
}

function includeDirective(clause) {
  if (isCompactBinaryClause(clause) || !isDirectiveClause(clause)) return null;
  const directive = clause.head.args[0];
  return directive?.type === COMPOUND && directive.arity === 1 &&
    (directive.name === 'include' || directive.name === 'ensure_loaded')
    ? directive
    : null;
}

function moduleDirective(clause) {
  if (isCompactBinaryClause(clause) || !isDirectiveClause(clause)) return null;
  const directive = clause.head.args[0];
  if (directive?.type !== COMPOUND || directive.name !== 'module' || directive.arity !== 2) return null;
  if (directive.args[0].type !== ATOM) throw new PrologError('type_error(atom)', directive.args[0]);
  if (moduleExportIndicators(directive.args[1]) == null) {
    throw new PrologError('type_error(list)', directive.args[1]);
  }
  return { name: directive.args[0].name };
}

function useModuleDirective(clause) {
  if (isCompactBinaryClause(clause) || !isDirectiveClause(clause)) return null;
  const directive = clause.head.args[0];
  if (directive?.type !== COMPOUND || directive.name !== 'use_module' || ![1, 2].includes(directive.arity)) return null;
  const imports = directive.arity === 2 ? moduleExportIndicators(directive.args[1]) : null;
  if (directive.arity === 2 && imports == null) throw new PrologError('type_error(list)', directive.args[1]);
  return { designation: directive.args[0], imports };
}

function moduleExportIndicators(term) {
  const items = properListItems(term, new Env());
  if (items == null) return null;
  const indicators = [];
  for (const item of items) {
    // Scryer-style modules may export operators alongside predicate
    // indicators, for example op(700, xfx, #=) from library(clpz).
    // Operator visibility while parsing bundled libraries is handled by the
    // parser's imported-library operator table; module import resolution only
    // needs procedure indicators here.
    if (item.type === COMPOUND && item.name === 'op' && item.arity === 3) {
      const [priority, specifier, names] = item.args;
      const operatorNames = names.type === ATOM ? [names] : properListItems(names, new Env());
      if (priority.type !== NUMBER || !RE_DECIMAL_INT.test(priority.name) || Number(priority.name) > 1200 ||
          specifier.type !== ATOM || !['fx', 'fy', 'xf', 'yf', 'xfx', 'xfy', 'yfx'].includes(specifier.name) ||
          operatorNames == null || operatorNames.some((name) => name.type !== ATOM)) return null;
      continue;
    }
    if (item.type !== COMPOUND || !['/', '//'].includes(item.name) || item.arity !== 2) return null;
    const indicator = predicateIndicator(item.args[0], item.args[1]);
    if (!indicator) return null;
    if (item.name === '//') {
      indicator.arity += 2;
      indicator.key = `${indicator.name}/${indicator.arity}`;
      indicator.nonterminalArity = indicator.arity - 2;
    }
    indicators.push(indicator);
  }
  return indicators;
}

function sourceModuleDeclaration(text, options = {}) {
  const clauses = parseClauses(text, { ...options, sourceMetadata: false });
  return clauses.length > 0 ? moduleDirective(clauses[0]) : null;
}

function readModuleSource(designation, options) {
  if (designation.type === COMPOUND && designation.name === 'library' && designation.arity === 1 &&
      designation.args[0].type === ATOM) {
    const name = designation.args[0].name;
    const registered = standardLibrarySources.get(name);
    if (!registered) throw new PrologError('existence_error(source_sink)', designation);
    return {
      name,
      text: registered.source,
      options: { ...options, filename: registered.filename, baseDir: 'src/lib', onWarning: null },
    };
  }
  if (designation.type !== ATOM) throw new PrologError('type_error(source_sink)', designation);
  if (!fs || !path) throw new PrologError('permission_error(access, source_sink)', designation);
  const base = options.baseDir ?? currentWorkingDirectory();
  const filename = path.resolve(base, designation.name);
  let text;
  try {
    text = fs.readFileSync(filename, 'utf8');
  } catch (_) {
    throw new PrologError('existence_error(source_sink)', designation);
  }
  const declaration = sourceModuleDeclaration(text, { filename });
  if (!declaration) throw new PrologError('existence_error(module)', designation);
  return { name: declaration.name, text, options: { ...options, filename, baseDir: path.dirname(filename) } };
}

function annotateGoalModule(term, module) {
  if (!term || (term.type !== ATOM && term.type !== COMPOUND)) return term;
  term.module = module;
  const callableArguments = (term.name === ',' || term.name === ';' || term.name === '->') ? term.args
    : (term.name === 'wfs_truth' && term.arity === 2) ? [term.args[0]]
    : (['call', 'once', '\\+', 'not', 'tnot', 'catch', 'call_cleanup', 'setup_call_cleanup',
      'forall', 'findall', 'bagof', 'setof', 'countall', 'sumall',
      'aggregate_min', 'aggregate_max', 'maplist', 'phrase'].includes(term.name)
      ? term.args
      : []);
  for (const arg of callableArguments) annotateGoalModule(arg, module);
  return term;
}

function readIncludedSource(directive, options, ensured) {
  const designation = directive.args[0];
  if (designation.type !== ATOM) throw new PrologError('type_error(atom)', designation);
  if (!fs || !path) {
    throw new PrologError('permission_error(access, source_sink)', atom(designation.name));
  }
  const base = options.baseDir ?? (
    options.filename && path.isAbsolute(String(options.filename))
      ? path.dirname(path.resolve(options.filename))
      : currentWorkingDirectory()
  );
  const filename = path.resolve(base, designation.name);
  const alreadyLoaded = directive.name === 'ensure_loaded' && ensured.has(filename);
  if (directive.name === 'ensure_loaded' && !alreadyLoaded) ensured.add(filename);

  let text;
  try {
    text = fs.readFileSync(filename, 'utf8');
  } catch (_) {
    throw new PrologError('existence_error(source_sink)', atom(designation.name));
  }
  return {
    text,
    options: { ...options, filename, baseDir: path.dirname(filename) },
    alreadyLoaded,
  };
}

function isDirectiveClause(clause) {
  return clause.body.length === 0 && clause.head.type === COMPOUND &&
    clause.head.name === ':-' && clause.head.arity === 1;
}

function procedureDirectiveIndicators(clause, name, strictIso = false) {
  if (!isDirectiveClause(clause)) return null;
  const directive = clause.head.args[0];
  if (directive.type !== COMPOUND || directive.name !== name || directive.arity !== 1) return null;
  const terms = properListItems(directive.args[0], new Env()) ?? flattenDirectiveSequence(directive.args[0]);
  const indicators = terms.map((indicator) =>
    indicator.type === COMPOUND && ['/', '//'].includes(indicator.name) && indicator.arity === 2
      ? nonterminalOrPredicateIndicator(indicator)
      : null
  );
  if (indicators.some((indicator) => indicator == null)) {
    if (strictIso) throw new Error(`ISO preparation error: invalid ${name}/1 predicate indicator`);
    return [];
  }
  return indicators;
}

function dynamicDirectiveIndicators(clause) {
  return procedureDirectiveIndicators(clause, 'dynamic', false) ?? [];
}

function nonterminalOrPredicateIndicator(term) {
  const indicator = predicateIndicator(term.args[0], term.args[1]);
  if (!indicator || term.name !== '//') return indicator;
  indicator.arity += 2;
  indicator.key = `${indicator.name}/${indicator.arity}`;
  indicator.nonterminalArity = indicator.arity - 2;
  return indicator;
}

function flattenDirectiveSequence(term) {
  if (term.type === COMPOUND && term.name === ',' && term.arity === 2) {
    return [...flattenDirectiveSequence(term.args[0]), ...flattenDirectiveSequence(term.args[1])];
  }
  return [term];
}

function operatorDirective(clause) {
  if (!isDirectiveClause(clause)) return null;
  const directive = clause.head.args[0];
  if (directive.type !== COMPOUND || directive.name !== 'op' || directive.arity !== 3) return null;
  const [priority, specifier, names] = directive.args;
  if (priority.type !== 'number' || specifier.type !== ATOM) return null;
  const items = names.type === ATOM ? [names] : properListItems(names, new Env());
  if (!items || items.some((item) => item.type !== ATOM)) return null;
  return {
    priority: Number(priority.name),
    specifier: specifier.name,
    names: items.map((item) => item.name),
  };
}

function assertHeadIsDefinable(head, strictIso = false) {
  if (head.type === ATOM || head.type === COMPOUND) {
    assertPredicateIsDefinable(head.name, head.arity, strictIso);
  }
}

function assertDynamicIndicatorIsDefinable(indicator, strictIso = false) {
  assertPredicateIsDefinable(indicator.name, indicator.arity, strictIso);
}

function assertPredicateIsDefinable(name, arity, strictIso = false) {
  // false/0 is standardized as a static built-in by Corrigendum 2 and cannot
  // be redefined in either profile.
  //
  // ISO 7.4.3 requires that the predicate indicator of the head of a clause in
  // a Prolog text is not that of a built-in predicate or a control construct.
  // That subclause otherwise defers to assertz/1 and waives only the static
  // procedure error, so the built-in restriction is a separate requirement and
  // is not profile-dependent. The strict ISO registry holds exactly the Part 1
  // built-ins and control constructs, so it is consulted in every mode.
  //
  // EyeProlog's library and extension predicates are deliberately absent from
  // that registry and stay redefinable, which preserves the source
  // compatibility that user programs rely on.
  //
  // (,)/2 is a control construct (table 9) but is recognized by the parser
  // rather than the registry, so it is named here. (:-)/1-2 come from the STC
  // #56 working draft rather than published text and stay strict-only.
  const controlConstruct = name === ',' && arity === 2;
  const draftSyntaxProcedure = strictIso && name === ':-' && (arity === 1 || arity === 2);
  if ((name === 'false' && arity === 0) ||
      getStrictIsoRegistry().get(name, arity) ||
      controlConstruct ||
      draftSyntaxProcedure) {
    throw staticProcedureModificationError(name, arity);
  }
}

function staticProcedureModificationError(name, arity) {
  return new PrologError(
    'permission_error(modify, static_procedure)',
    compound('/', [atom(name), numberTerm(arity)]),
  );
}


function predicateIndicator(name, arity) {
  if (name?.type !== ATOM || arity?.type !== 'number') return null;
  if (!RE_DECIMAL_INT.test(arity.name)) return null;
  const arityNumber = Number(arity.name);
  return { name: name.name, arity: arityNumber, key: `${name.name}/${arityNumber}` };
}

export function makeProgram(source, options = {}) {
  return Program.parse(source, options);
}
