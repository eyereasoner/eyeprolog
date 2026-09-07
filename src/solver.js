// Depth-first EyeProlog solver with builtin dispatch, memoization, and guarded recursion handling.
// Most semantic decisions still flow through unification; optimizations only select candidates earlier.
import {
  ATOM, COMPOUND, NUMBER, STRING, VAR, Env, Term, atom, compactListLength, compactVariableList, compound, cons, copyResolved, deref, emptyList,
  flattenConjunction, freshTerm, isCons, isDecimalInteger, isEmptyList, isScalar,
  numberTerm, numberTextFromDouble, properListItems, termIsGround, termToString, unify, variable, variantTerms,
} from './term.js';
import { numberValueKey, sameNumberValue } from './number-value.js';
import { PrologError, getStrictIsoRegistry } from './iso.js';
import { getEyePrologRegistry } from './standard-library.js';
import { selectClauseCandidates, selectClauseCandidatesForValues, selectGroundClauseCandidates } from './program-indexing.js';
import { StreamManager } from './io.js';
import { hardHeapLimit, softHeapLimit, usedHeapSize } from './platform.js';
import { evaluateWfs, relationForGroup, truthOfGroundGoal } from './wfs.js';
import { ISO_MAX_ARITY } from './iso-limits.js';
import { evaluatePositiveDatalog, relationForDatalogGroup, datalogCandidateIndexes } from './datalog.js';

let freshCounter = 0;
const DEFAULT_INNER_TABLE_SCOPE_LIMIT = 1024;
const GOAL_CONTINUATION_THRESHOLD = 64;
const NO_CALL_TARGET = Symbol('no-call-target');
// Conservative live-storage estimate for one generated length/2 list cell
// (cons object, argument vector, fresh variable, and its generated name).
const GENERATED_LENGTH_CELL_RESERVE_BYTES = 256;
const MAX_GENERATED_LENGTH_RESERVE_STEPS = BigInt(
  Math.floor(Number.MAX_SAFE_INTEGER / GENERATED_LENGTH_CELL_RESERVE_BYTES),
);

function qualifyTerm(term, module) {
  if (!term || (term.type !== COMPOUND && term.type !== 'atom')) return term;
  term.module = module;
  for (const arg of term.args) qualifyTerm(arg, module);
  return term;
}

function renameVariableInTerm(term, fromName, toName) {
  if (fromName === toName) return term;
  const stack = [term];
  const seen = new Set();
  while (stack.length) {
    const current = stack.pop();
    if (current == null || seen.has(current)) continue;
    seen.add(current);
    if (current.type === VAR) {
      if (current.name === fromName) current.name = toName;
      continue;
    }
    if (current.type === COMPOUND) for (const arg of current.args) stack.push(arg);
  }
  return term;
}

export function nextFreshId() {
  return ++freshCounter;
}

function raiseOccursCheckError(left, right, env) {
  // occurs_check=error is an implementation-specific STO diagnostic.  Report
  // the unrepresentable cyclic result through the standard error envelope.
  // Keep the implementation-defined context empty for stable, portable output.
  const error = new PrologError('representation_error(term)');
  error.contextTerm = emptyList();
  throw error;
}


function rejectStrictIsoStringTerms(terms, env) {
  const seen = new Set();
  const visit = (term) => {
    const resolved = deref(term, env);
    if (resolved == null || seen.has(resolved)) return;
    seen.add(resolved);
    if (resolved.type === STRING) {
      // `stringTerm()` is a normal-profile host/API term extension.  It has no
      // Part 1 abstract/token syntax, so strict execution must reject it rather
      // than silently introducing a sixth term type through the embedding API.
      throw new PrologError('representation_error(term)');
    }
    if (resolved.type === COMPOUND) {
      for (const arg of resolved.args) visit(arg);
    }
  };
  for (const term of terms) visit(term);
}

export class Solver {
  constructor(program, options = {}) {
    this.program = program;
    this.isoStrict = options.isoStrict === true || program.strictIso === true;
    // A strict processor mode must not silently admit host-registered
    // implementation-specific predicates.  Use the Part 1 + corrigenda
    // registry even when an embedder supplied the normal EyeProlog registry.
    this.registry = this.isoStrict ? getStrictIsoRegistry() : (options.registry ?? getEyePrologRegistry());
    this.userGroupCache = Object.create(null);
    this.moduleGroupCache = new Map();
    this.builtinCache = Object.create(null);
    this.mutableProgram = program.mutable === true;
    this.programRevision = this.program.revision ?? 0;
    // Normal Prolog execution must not silently acquire a semantic depth
    // bound.  Callers that need bounded exploration (for example loop probes)
    // can still pass maxDepth explicitly; exceeding such an explicit limit is
    // reported as resource_error(depth_limit) rather than logical failure.
    this.maxDepth = options.maxDepth ?? Infinity;
    this.depthLimitExceeded = false;
    this.maxInferences = options.maxInferences ?? Infinity;
    this.inferences = 0;
    // Shared only for observability: nested meta-call solvers contribute to the
    // same measurement counter without changing each solver's local inference
    // limit accounting. time/1 snapshots this counter around the measured goal.
    this.inferenceObservation = options.inferenceObservation ?? { value: 0 };
    this.inferenceLimitExceeded = false;
    // Set when the normal-profile recursion guard detects re-entry of an
    // already active variant on the current search path. Quad `loops` checks
    // use this structural evidence in addition to bounded resource probes.
    this.recursionCycleDetected = false;
    this.maxMemoryBytes = options.maxMemoryBytes ?? softHeapLimit();
    this.memoryRecovery = options.memoryRecovery ?? {
      active: false,
      reservationBytes: 0,
      checks: 0,
    };
    // Nested meta-call solvers contribute to one execution and inspect the
    // same process heap. Share their sampling deadline so each short-lived
    // child does not repeat an expensive host memory query before the parent
    // has advanced the guard interval.
    this.memoryCheckState = options.memoryCheckState ?? { nextObservation: 0 };
    // Do not impose an implicit answer cap. Infinite and very large searches are
    // part of normal Prolog semantics; callers that need a resource bound can
    // still supply solutionLimit explicitly.
    this.solutionLimit = options.solutionLimit ?? Infinity;
    this.solutionsSeen = 0;
    this.prologFlags = options.prologFlags ?? defaultPrologFlags('error', this.isoStrict);
    if (this.isoStrict) {
      for (const name of [...this.prologFlags.keys()]) {
        if (!ISO_CORE_FLAG_NAMES.has(name)) this.prologFlags.delete(name);
      }
    }
    // Record a concrete occurs-check event even when the configured action is
    // finite-tree failure rather than an exception. Quad `sto` checks can then
    // use the query's real execution as evidence without running it a second
    // time (which could repeat side effects).
    this.occursCheckObserved = false;
    this.occursCheckHandler = (left, right, env) => {
      this.occursCheckObserved = true;
      if (this.prologFlags.get('occurs_check')?.value?.name === 'error') {
        raiseOccursCheckError(left, right, env);
      }
    };
    this.attributeHookRunner = (module, attributed, other, env) =>
      this.runAttributeHook(module, attributed, other, env);
    this.charConversions = options.charConversions ?? new Map();
    if (!options.prologFlags) {
      if (['chars', 'codes', 'atom'].includes(program.doubleQuotes)) {
        this.prologFlags.get('double_quotes').value = compound(program.doubleQuotes, []);
      }
      for (const [flag, value] of program.prologFlagDirectives ?? []) {
        if (flag.type === 'var' || value.type === 'var') throw new PrologError('instantiation_error');
        if (flag.type !== 'atom') throw new PrologError('type_error(atom)', flag);
        const definition = this.prologFlags.get(flag.name);
        if (!definition) throw new PrologError('domain_error(prolog_flag)', flag);
        if (value.type !== 'atom' || !definition.allowed.includes(value.name)) {
          throw new PrologError('domain_error(flag_value)', compound('+', [flag, value]));
        }
        if (!definition.changeable) throw new PrologError('permission_error(modify, flag)', flag);
        definition.value = value;
      }
    }
    if (!options.charConversions) {
      for (const [input, output] of program.charConversionDirectives ?? []) {
        if (input.type === 'atom' && output.type === 'atom' &&
            Array.from(input.name).length === 1 && Array.from(output.name).length === 1) {
          if (input.name === output.name) this.charConversions.delete(input.name);
          else this.charConversions.set(input.name, output.name);
        }
      }
    }
    this.io = options.io ?? new StreamManager(options.ioOptions);
    // Keep generated write-variable names stable for the lifetime of one
    // top-level query. Inner/meta-call solvers share this state so separate
    // write/1, writeq/1, write_canonical/1, and write_term/2-3 calls can refer
    // to the same logical variable by the same printed name.
    this.writeVariableState = options.writeVariableState ?? { depth: 0, names: new Map(), next: 0 };
    this.solveStacks = [];
    this.active = [];
    this.cutEpoch = 0;
    this.memo = new Map();
    this.subsumptiveMemo = new Map();
    this.wfsModels = new Map();
    this.datalogModels = new Map();
    this.tableCoordinator = null;
    this.groundChainSuccess = new Set();
    this.compactChainSuccess = new Map();
    // Bounded table caches for isolated meta-call domains such as phrase/2-3.
    // They deliberately do not share the caller's general memo: a stream of
    // distinct meta-call inputs must not turn completed table variants into
    // process-lifetime roots.
    this.innerTableScopes = options.innerTableScopes ?? new Map();
    // Non-backtrackable library state (for example gensym/2 and CLP(B) node
    // identifiers) is shared by nested solvers for the lifetime of this run.
    this.nonBacktrackableBlackboard = options.nonBacktrackableBlackboard ?? new Map();
    this.stats = {
      completed_goal_lists: 0,
      solve_goals_calls: 0,
      solve_one_goal_calls: 0,
      unify_calls: 0,
      max_depth: 0,
      max_goal_count: 0,
      deterministic_builtin_successes: 0,
      deterministic_builtin_failures: 0,
      table_fixpoint_rounds: 0,
      datalog_evaluations: 0,
      datalog_rule_firings: 0,
      datalog_facts_derived: 0,
      wfs_fixpoint_rounds: 0,
      wfs_undefined_answers: 0,
    };
  }

  cloneForInnerGoal(solutionLimit = this.solutionLimit, options = {}) {
    const solver = new Solver(this.program, {
      registry: this.registry,
      maxDepth: this.maxDepth,
      maxInferences: this.maxInferences,
      maxMemoryBytes: this.maxMemoryBytes,
      memoryRecovery: this.memoryRecovery,
      memoryCheckState: this.memoryCheckState,
      solutionLimit,
      isoStrict: this.isoStrict,
      prologFlags: this.prologFlags,
      charConversions: this.charConversions,
      io: this.io,
      innerTableScopes: this.innerTableScopes,
      nonBacktrackableBlackboard: this.nonBacktrackableBlackboard,
      inferenceObservation: this.inferenceObservation,
      writeVariableState: this.writeVariableState,
    });
    if (options.tableScope != null) {
      const scope = this.innerTableScope(options.tableScope, options.tableScopeSignature ?? null);
      solver.memo = scope.memo;
      solver.subsumptiveMemo = scope.subsumptiveMemo;
    } else {
      solver.memo = this.memo;
      solver.subsumptiveMemo = this.subsumptiveMemo;
    }
    solver.wfsModels = this.wfsModels;
    solver.datalogModels = this.datalogModels;
    solver.groundChainSuccess = this.groundChainSuccess;
    solver.compactChainSuccess = this.compactChainSuccess;
    return solver;
  }

  innerTableScope(name, signature = null) {
    let scope = this.innerTableScopes.get(name);
    if (scope == null) {
      scope = { memo: new Map(), subsumptiveMemo: new Map(), signature };
      this.innerTableScopes.set(name, scope);
      return scope;
    }
    if (signature == null || scope.signature === signature) return scope;

    // Keep at most one completed invocation variant for isolated meta-call
    // domains. Reusing the same phrase/2-3 call remains fast, while a stream of
    // distinct inputs releases the previous table as one unit instead of
    // churning thousands of individual memo entries. A nested meta-call must
    // not invalidate an active fixed point, so it receives a temporary scope.
    for (const entry of scope.memo.values()) {
      if (entry?.computing === true) {
        return { memo: new Map(), subsumptiveMemo: new Map(), signature };
      }
    }
    scope.memo.clear();
    scope.subsumptiveMemo.clear();
    scope.signature = signature;
    return scope;
  }

  innerTableSignature(terms, env, prefix = '') {
    const variables = new Map();
    return prefix + terms.map((term) => canonicalTermKey(term, env, variables)).join('|');
  }

  trimInnerTableScope(name, limit = DEFAULT_INNER_TABLE_SCOPE_LIMIT) {
    const scope = this.innerTableScopes.get(name);
    if (scope == null || scope.memo.size <= limit) return;
    // Map iteration is insertion ordered. Delete completed entries directly by
    // key as we encounter them so a steady stream of distinct meta-call inputs
    // pays O(evictions), not an O(cache-size) rescan for every phrase/2 call.
    // Active fixed-point entries are skipped and can only make the cache
    // temporarily exceed its soft bound.
    for (const [key, entry] of scope.memo) {
      if (scope.memo.size <= limit) break;
      if (entry?.complete !== true || entry?.computing === true) continue;
      scope.memo.delete(key);
      if (scope.subsumptiveMemo.size !== 0) {
        for (const [broadKey, broadEntry] of scope.subsumptiveMemo) {
          if (broadEntry === entry) scope.subsumptiveMemo.delete(broadKey);
        }
      }
    }
  }

  lookupGroup(name, arity, module = 'user') {
    if (module === 'user') {
      let slots = this.userGroupCache[name];
      if (slots === undefined) this.userGroupCache[name] = slots = [];
      const cached = slots[arity];
      if (cached !== undefined) return cached === NO_CALL_TARGET ? null : cached;
      const group = this.program.findGroup(name, arity, module);
      slots[arity] = group ?? NO_CALL_TARGET;
      return group;
    }
    let byName = this.moduleGroupCache.get(module);
    if (byName == null) this.moduleGroupCache.set(module, byName = new Map());
    let byArity = byName.get(name);
    if (byArity == null) byName.set(name, byArity = []);
    const cached = byArity[arity];
    if (cached !== undefined) return cached === NO_CALL_TARGET ? null : cached;
    const group = this.program.findGroup(name, arity, module);
    byArity[arity] = group ?? NO_CALL_TARGET;
    return group;
  }

  lookupBuiltin(name, arity) {
    let slots = this.builtinCache[name];
    if (slots === undefined) this.builtinCache[name] = slots = [];
    const cached = slots[arity];
    if (cached !== undefined) return cached === NO_CALL_TARGET ? null : cached;
    const def = this.registry.get(name, arity);
    slots[arity] = def ?? NO_CALL_TARGET;
    return def;
  }

  syncProgramRevision() {
    if (!this.mutableProgram) {
      if (this.program.mutable !== true) return;
      this.mutableProgram = true;
    }
    const revision = this.program.revision ?? 0;
    if (revision === this.programRevision) return;
    this.programRevision = revision;
    this.userGroupCache = Object.create(null);
    this.moduleGroupCache.clear();
    this.builtinCache = Object.create(null);
    this.memo.clear();
    this.subsumptiveMemo.clear();
    this.wfsModels.clear();
    this.datalogModels.clear();
    this.tableCoordinator = null;
    this.groundChainSuccess.clear();
    this.compactChainSuccess.clear();
    for (const scope of this.innerTableScopes.values()) {
      scope.memo.clear();
      scope.subsumptiveMemo.clear();
    }
  }

  absorbStatsFrom(child) {
    if (!child || child === this || !child.stats) return;
    this.depthLimitExceeded ||= child.depthLimitExceeded;
    this.inferenceLimitExceeded ||= child.inferenceLimitExceeded;
    this.recursionCycleDetected ||= child.recursionCycleDetected;
    this.occursCheckObserved ||= child.occursCheckObserved;
    for (const [key, value] of Object.entries(child.stats)) {
      if (key === 'max_depth' || key === 'max_goal_count') {
        this.stats[key] = Math.max(this.stats[key] ?? 0, value ?? 0);
      } else {
        this.stats[key] = (this.stats[key] ?? 0) + (value ?? 0);
      }
    }
  }

  runAttributeHook(module, attributed, other, env) {
    if (this.program.findGroup('verify_attributes', 3, module) == null) return true;
    const goalsVariable = variable(`\u0000attributeGoals${nextFreshId()}`);
    const hook = compound('verify_attributes', [attributed, other, goalsVariable]);
    qualifyTerm(hook, module);
    const child = this.cloneForInnerGoal(1);
    const iterator = child.solve([hook], env.clone(), 0);
    const result = iterator.next();
    try { iterator.return?.(); } catch (_) { /* best-effort iterator cleanup */ }
    this.absorbStatsFrom(child);
    if (result.done) return false;
    env.adopt(result.value);
    env.setOccursCheckHandler(this.occursCheckHandler);
    env.setAttributeHookRunner(this.attributeHookRunner);
    const goals = properListItems(goalsVariable, env);
    if (goals == null) throw new PrologError('type_error(list)', deref(goalsVariable, env));
    for (const goal of goals) qualifyTerm(goal, module);
    env.enqueueAttributeGoals(goals);
    return true;
  }

  attributeResidualGoals(variableTerm, env) {
    const root = deref(variableTerm, env);
    if (root.type !== VAR || !env.hasPrologAttributes(root.name)) return [];
    const residuals = [];
    for (const module of env.prologAttributeModules(root.name)) {
      if (this.program.findGroup('attribute_goals', 3, module) == null) continue;
      const goalsVariable = variable(`\u0000attributeResidual${nextFreshId()}`);
      const projection = compound('attribute_goals', [root, goalsVariable, emptyList()]);
      qualifyTerm(projection, module);
      const child = this.cloneForInnerGoal(1);
      const iterator = child.solve([projection], env.clone(), 0);
      const result = iterator.next();
      try { iterator.return?.(); } catch (_) { /* best-effort iterator cleanup */ }
      this.absorbStatsFrom(child);
      if (result.done) continue;
      const goals = properListItems(goalsVariable, result.value);
      if (goals == null) throw new PrologError('type_error(list)', deref(goalsVariable, result.value));
      const projectedRoot = deref(root, result.value);
      for (const goal of goals) {
        const residual = copyResolved(goal, result.value);
        if (projectedRoot.type === VAR) renameVariableInTerm(residual, projectedRoot.name, root.name);
        residuals.push(residual);
      }
    }
    return residuals;
  }

  runInitializations() {
    const goals = this.program.initializations ?? [];
    let index = this.program._initializationsExecutedCount ?? 0;
    for (; index < goals.length; index++) {
      let succeeded = false;
      for (const _ of this.solve([goals[index]], new Env(), 0)) {
        succeeded = true;
        break;
      }
      if (!succeeded) throw new PrologError('initialization_error');
      // Mark each successful initialization immediately. If a later one fails,
      // retrying does not repeat already completed initialization side effects.
      this.program._initializationsExecutedCount = index + 1;
    }
  }

  *solve(goals, env = new Env(), depth = 0) {
    if (!Array.isArray(goals)) goals = [goals];
    const ownsSolverBindings = env._isSolverEnv?.() !== true;
    if (ownsSolverBindings) env = env._asSolverEnv();
    env.setOccursCheckHandler(this.occursCheckHandler);
    env.setAttributeHookRunner(this.attributeHookRunner);
    if (this.isoStrict) rejectStrictIsoStringTerms(goals, env);

    const writeVariableState = this.writeVariableState;
    if (writeVariableState.depth === 0) {
      writeVariableState.names.clear();
      writeVariableState.next = 0;
    }
    writeVariableState.depth++;

    const savedActive = this.active;
    let registeredStack = null;
    try {
      const stack = [{ kind: 'goals', goals, env, depth, active: savedActive.slice() }];
      registeredStack = stack;
      this.solveStacks.push(stack);
      while (stack.length) {
      this.inferences++;
      this.inferenceObservation.value++;
      this.checkMemoryLimit();
      if (this.inferences > this.maxInferences) {
        this.inferenceLimitExceeded = true;
        break;
      }
      const frame = stack.pop();
      this.syncProgramRevision();
      if (frame.kind === 'resumeBuiltin') {
        if (this.solutionsSeen >= this.solutionLimit) continue;
        const result = frame.iterator.next();
        if (result.done) continue;
        // Predicate iterators that can identify their final answer report it
        // before yielding. Do not recreate a choicepoint that the predicate has
        // already exhausted; consumers must not need to hide such a frame later.
        if (iteratorMayHavePendingAlternatives(frame.iterator)) stack.push(frame);
        else frame.iterator.return?.();
        stack.push({
          kind: 'goals',
          goals: frame.goals,
          env: result.value,
          depth: frame.depth,
          active: frame.active,
        });
        continue;
      }
      if (frame.kind === 'unifyArgsBranch') {
        if (this.solutionsSeen >= this.solutionLimit) continue;
        const next = frame.env.clone();
        const sourceArgs = frame.freshNonGround && !frame.args.every((arg) => termIsGround(arg))
          ? freshTerm(compound('$branch_args', frame.args), nextFreshId()).args
          : frame.args;
        let ok = true;
        for (let i = 0; i < frame.goal.arity; i++) {
          this.stats.unify_calls++;
          if (!unify(frame.goal.args[i], sourceArgs[i], next)) { ok = false; break; }
        }
        if (ok) {
          stack.push({
            kind: 'goals',
            goals: frame.goals,
            env: next,
            depth: frame.depth,
            active: frame.active,
          });
        }
        continue;
      }
      if (frame.kind === 'bindBranch') {
        if (this.solutionsSeen >= this.solutionLimit) continue;
        const next = frame.env.clone();
        for (let i = 0; i < frame.names.length; i++) next.bind(frame.names[i], frame.values[i]);
        if (next._variableConstraints != null && !next.validateVariableConstraints()) continue;
        stack.push({
          kind: 'goals',
          goals: frame.goals,
          env: next,
          depth: frame.depth,
          active: frame.active,
        });
        continue;
      }
      if (frame.kind === 'userClause') {
        if (this.solutionsSeen >= this.solutionLimit) continue;
        const { clause, goal: clauseGoal, rest: clauseRest, env: clauseEnv, depth: clauseDepth,
          active: clauseActive, release, tailReleaseBeforeLast, directCutReleaseIndex } = frame;
        let next;
        if (clause.body.length === 0 && clause.groundHead) {
          const matched = sameResolvedGroundTerm(clauseGoal, clause.head, clauseEnv);
          if (matched === true) {
            stack.push({
              kind: 'goals',
              goals: [...release, ...clauseRest],
              env: clauseEnv,
              depth: clauseDepth + 1,
              active: clauseActive,
            });
            continue;
          }
          if (matched === false) continue;
        }
        if (clause.body.length === 0 && clause.scalarHead) {
          next = matchScalarFact(clauseGoal, clause.head, clauseEnv);
          if (!next) continue;
          this.stats.unify_calls++;
          stack.push({
            kind: 'goals',
            goals: [...release, ...clauseRest],
            env: next,
            depth: clauseDepth + 1,
            active: clauseActive,
          });
          continue;
        }
        const { freshHead, freshBody, headLocalFresh } = instantiateClause(clause, nextFreshId());
        next = clauseEnv.clone();
        this.stats.unify_calls++;
        if (!unify(clauseGoal, freshHead, next, { knownNonoccurringVariables: headLocalFresh })) continue;
        let nextGoals;
        if (freshBody.length === 0) {
          nextGoals = [...release, ...clauseRest];
        } else if (directCutReleaseIndex >= 0) {
          const afterCut = directCutReleaseIndex + 1;
          nextGoals = [...freshBody.slice(0, afterCut), ...release, ...freshBody.slice(afterCut), ...clauseRest];
        } else if (tailReleaseBeforeLast) {
          const tail = freshBody[freshBody.length - 1];
          next.compactForDeepContinuation?.();
          nextGoals = [...freshBody.slice(0, -1), ...release, tail, ...clauseRest];
        } else if (clauseRest.length >= GOAL_CONTINUATION_THRESHOLD ||
            clauseRest.some((goal) => goal?.kind === 'continueGoals')) {
          // Keep a large caller continuation as one opaque frame instead of
          // copying its complete pending goal list into every nested clause.
          // Small goal lists remain flat because that representation is faster
          // for ordinary shallow search.
          next.compactForDeepContinuation?.();
          nextGoals = [
            ...freshBody,
            { kind: 'continueGoals', goals: clauseRest, depth: clauseDepth, releaseActive: release.length !== 0 },
          ];
        } else {
          nextGoals = [...freshBody, ...release, ...clauseRest];
        }
        stack.push({
          kind: 'goals',
          goals: nextGoals,
          env: next,
          depth: clauseDepth + 1,
          active: clauseActive,
        });
        continue;
      }
      if (frame.kind === 'completeTableFixpointRound') {
        if (frame.revision !== this.programRevision) continue;
        frame.entry.computing = false;
        const answerCount = frame.entry.answers.length;
        if (this.tableCoordinator?.cycleSeen && answerCount > frame.answerCountBefore) {
          scheduleTableFixpointRound(stack, this, frame);
        } else {
          for (const entry of this.tableCoordinator?.entries ?? [frame.entry]) {
            entry.computing = false;
            entry.complete = true;
          }
          this.tableCoordinator = null;
          pushMemoAnswerFrames(stack, frame.entry, frame.goal, frame.rest, frame.env, frame.depth, frame.active, this);
        }
        continue;
      }
      if (frame.kind === 'completeMemo') {
        if (frame.revision !== this.programRevision) continue;
        frame.entry.computing = false;
        frame.entry.complete = true;
        continue;
      }

      goals = frame.goals;
      env = frame.env;
      env.setOccursCheckHandler(this.occursCheckHandler);
      env.setAttributeHookRunner(this.attributeHookRunner);
      depth = frame.depth;
      let active = frame.active;

      while (true) {
        this.inferences++;
        this.inferenceObservation.value++;
        this.checkMemoryLimit();
        if (this.inferences > this.maxInferences) {
          this.inferenceLimitExceeded = true;
          stack.length = 0;
          break;
        }
        this.syncProgramRevision();
        this.stats.solve_goals_calls++;
        this.stats.max_depth = Math.max(this.stats.max_depth, depth);
        this.stats.max_goal_count = Math.max(this.stats.max_goal_count, goals.length);
        if (depth > this.maxDepth) {
          this.depthLimitExceeded = true;
          throw new PrologError('resource_error(depth_limit)');
        }
        if (this.solutionsSeen >= this.solutionLimit) break;

        const pendingAttributeGoals = env.takePendingAttributeGoals?.() ?? [];
        if (pendingAttributeGoals.length > 0) {
          // Goals produced by verify_attributes/3 are invoked by the attribute
          // mechanism, not textually spliced into the caller.  Give every
          // awakened goal the same opaque cut boundary as call/1 so a delayed
          // cut cannot prune choices that were made before the suspension.
          const awakened = pendingAttributeGoals.map((pending) => compound('call', [pending]));
          goals = [...awakened, ...goals];
        }

        const readyDelays = env.takeReadyDelays();
        if (readyDelays.length > 0) {
          const awakened = readyDelays.map(({ goal, module }) => {
            const delayed = copyResolved(goal, env);
            qualifyTerm(delayed, module);
            return compound('call', [delayed]);
          });
          goals = [...awakened, ...goals];
        }

        if (goals.length === 0) {
          this.solutionsSeen++;
          this.stats.completed_goal_lists++;
          this.active = active;
          yield ownsSolverBindings && env._isSolverEnv?.() === true ? env._toPersistentEnv() : env;
          break;
        }

        const first = goals[0];
        if (first?.kind === 'continueGoals') {
          if (first.releaseActive) active = active.slice(0, -1);
          depth = first.depth;
          goals = first.goals;
          continue;
        }
        if (first?.kind === 'releaseActive') {
          active = active.slice(0, -1);
          goals = goals.slice(1);
          continue;
        }
        if (first?.kind === 'memoStore') {
          if (first.revision === this.programRevision) rememberMemoAnswer(first.entry, first.goal, env);
          if (goals.length === 1) break;
          goals = goals.slice(1);
          continue;
        }

        // EyeProlog normally solves left-to-right, but ready deterministic builtins can
        // be run early as pure filters. Stop at internal sentinels so rule-body
        // active guards are released before the caller's remaining goals are seen.
        const selectedIndex = 0;
        const goal = deref(goals[selectedIndex], env);
        const rest = selectedIndex === 0 ? goals.slice(1) : [...goals.slice(0, selectedIndex), ...goals.slice(selectedIndex + 1)];
        prepareLocalVariablesForGoal(goal, env);
        if (goal.type === 'atom' && goal.name === '!' && goal.arity === 0) {
          const marker = active[active.length - 1] ?? null;
          if (marker) marker.cutEpoch = (marker.cutEpoch ?? 0) + 1;
          else this.cutEpoch++;
          for (const solveStack of this.solveStacks) {
            for (let i = solveStack.length - 1; i >= 0; i--) {
              if (marker == null || solveStack[i].active?.includes(marker)) solveStack.splice(i, 1);
            }
          }
          goals = rest;
          depth++;
          continue;
        }
        if (goal.type === COMPOUND && goal.name === ',' && goal.arity === 2) {
          goals = [...flattenConjunction(goal), ...rest];
          depth++;
          continue;
        }
        if (!this.isoStrict && goal.type === COMPOUND && goal.name === ':' && goal.arity === 2) {
          const module = deref(goal.args[0], env);
          if (module.type === 'var') throw new PrologError('instantiation_error');
          if (module.type !== 'atom') throw new PrologError('type_error(atom)', module);
          const qualified = deref(goal.args[1], env);
          if (qualified.type !== COMPOUND && qualified.type !== 'atom') {
            throw new PrologError('type_error(callable)', qualified);
          }
          qualifyTerm(qualified, module.name);
          goals = [qualified, ...rest];
          depth++;
          continue;
        }

        if (goal.type === 'var') throw new PrologError('instantiation_error');
        const callable = goal.type === COMPOUND || goal.type === 'atom';
        if (!callable) throw new PrologError('type_error(callable)', goal);

        if (selectedIndex === 0) {
          const fused = findallLengthFusion(this, goal, rest, env);
          if (fused != null) {
            const firstResult = fused.iterator.next();
            if (firstResult.done) break;
            goals = fused.rest;
            env = firstResult.value;
            depth++;
            continue;
          }
        }

        const def = callable ? this.lookupBuiltin(goal.name, goal.arity) : null;
        this.active = active;
        const builtinReady = def && builtinIsReadyOrAuthoritative(def, this, goal, env);
        if (builtinReady && typeof def.expandGoal === 'function') {
          // Meta-calls execute in this continuation instead of hiding their
          // search behind a host-generator frame. Their real clause, control,
          // and builtin frames therefore determine whether another answer is
          // pending exactly as they do for a direct call. A fresh active marker
          // keeps cut opaque at the call/N boundary.
          const expanded = def.expandGoal({ solver: this, goal, env });
          const invocation = { goal, env: env._snapshotForSolverRead() };
          active = [...active, invocation];
          goals = [expanded, { kind: 'releaseActive' }, ...rest];
          depth++;
          continue;
        }
        if (builtinReady) {
          const deterministic = def.deterministic ||
            def.deterministicWhen?.({ solver: this, goal, env }) === true;
          const iterator = def.handler({ solver: this, goal, env });
          const firstResult = iterator.next();
          if (deterministic) {
            if (!firstResult.done) this.stats.deterministic_builtin_successes++;
            else this.stats.deterministic_builtin_failures++;
          }
          if (firstResult.done) break;
          if (!deterministic) pushResumeBuiltinFrame(stack, iterator, rest, depth + 1, active);
          goals = rest;
          env = firstResult.value;
          depth++;
          continue;
        }

        this.stats.solve_one_goal_calls++;
        const group = this.lookupGroup(goal.name, goal.arity, goal.module ?? 'user');
        if (!group) {
          if (goal.name === '-->' && goal.arity === 2) {
            throw new PrologError(
              'existence_error(procedure)',
              compound('/', [compound('-->', []), numberTerm(2)]),
            );
          }
          if (this.prologFlags.get('unknown')?.value?.name === 'error') {
            throw new PrologError(
              'existence_error(procedure)',
              compound('/', [compound(goal.name, []), numberTerm(goal.arity)]),
            );
          }
          break;
        }
        qualifyMetaArguments(goal, group);

        if (group.datalogLeastModel === true && !termIsGround(goal, env)) {
          const model = this.datalogModelFor(group);
          const relation = relationForDatalogGroup(model, group);
          const iterator = datalogAnswerSolutions(this, relation, goal, env);
          const firstResult = iterator.next();
          if (firstResult.done) break;
          pushResumeBuiltinFrame(stack, iterator, rest, depth + 1, active);
          goals = rest;
          env = firstResult.value;
          depth++;
          continue;
        }

        if (group.wfsDatalog === true) {
          const model = this.wfsModelFor(group);
          pushWfsAnswerFrames(stack, model, group, goal, rest, env, depth, active, this);
          break;
        }

        const betweenIterator = bundledBetweenIterator(this, group, goal, env);
        if (betweenIterator != null) {
          const firstResult = betweenIterator.next();
          if (firstResult.done) break;
          pushResumeBuiltinFrame(stack, betweenIterator, rest, depth + 1, active);
          goals = rest;
          env = firstResult.value;
          depth++;
          continue;
        }

        const memberIterator = bundledMemberIterator(this, group, goal, env);
        if (memberIterator != null) {
          const firstResult = memberIterator.next();
          if (firstResult.done) break;
          pushResumeBuiltinFrame(stack, memberIterator, rest, depth + 1, active);
          goals = rest;
          env = firstResult.value;
          depth++;
          continue;
        }

        const lengthIterator = bundledLengthIterator(this, group, goal, env);
        if (lengthIterator != null) {
          const firstResult = lengthIterator.next();
          if (firstResult.done) break;
          pushResumeBuiltinFrame(stack, lengthIterator, rest, depth + 1, active);
          goals = rest;
          env = firstResult.value;
          depth++;
          continue;
        }

        const ellipsisPlan = bundledEllipsisPlan(this, group, goal, rest, env);
        if (ellipsisPlan != null) {
          const firstResult = ellipsisPlan.iterator.next();
          if (firstResult.done) break;
          pushResumeBuiltinFrame(stack, ellipsisPlan.iterator, ellipsisPlan.rest, depth + 1, active);
          goals = ellipsisPlan.rest;
          env = firstResult.value;
          depth++;
          continue;
        }

        if (group.tabled) {
          const key = memoKey(goal, env, group);
          if (key.hasBound) {
            const mapKey = `${group.module}:${goal.name}/${goal.arity}:${key.text}`;
            const broadKey = `${group.module}:${goal.name}/${goal.arity}`;
            let entry = null;
            let usingBroadTable = false;
            if (group.tableAllVariants) {
              entry = this.subsumptiveMemo.get(broadKey) ?? null;
              usingBroadTable = entry != null;
              if (!entry && isMostGeneralTableGoal(goal, env)) {
                entry = makeMemoEntry(goal.arity);
                this.subsumptiveMemo.set(broadKey, entry);
                this.memo.set(mapKey, entry);
                usingBroadTable = true;
              }
            }
            if (!entry) {
              entry = this.memo.get(mapKey);
              if (!entry) {
                entry = makeMemoEntry(goal.arity);
                this.memo.set(mapKey, entry);
              }
            }
            if (this.tableCoordinator) this.tableCoordinator.entries.add(entry);
            if (entry.complete) {
              pushMemoAnswerFrames(stack, entry, goal, rest, env, depth, active, this);
              break;
            }
            if (!entry.computing) {
              if (!this.tableCoordinator) {
                this.tableCoordinator = { entry, cycleSeen: false, entries: new Set([entry]) };
                scheduleTableFixpointRound(stack, this, { entry, group, goal, rest, env, depth, active, mapKey });
              } else {
                entry.computing = true;
                stack.push({ kind: 'completeMemo', entry, revision: this.programRevision });
                pushUserGoalUncachedFrames(stack, this, group, goal, [{ kind: 'memoStore', entry, goal, revision: this.programRevision }, ...rest], env, depth, active, mapKey);
              }
              break;
            }
            if (this.tableCoordinator && (usingBroadTable || activeTableKeyIn(mapKey, active))) {
              this.tableCoordinator.cycleSeen = true;
            }
            pushMemoAnswerFrames(stack, entry, goal, rest, env, depth, active, this);
            break;
          }
        }

        if (!group.tabled && tryPushScalarFactRunFrames(stack, this, [goal, ...rest], env, depth, active)) break;
        // When indexing leaves exactly one cut-free clause, enter it directly
        // instead of allocating a resumable clause-choice frame. This keeps
        // ordinary deterministic recursion on the interpreter's tight loop.
        if (!group.tabled && groupNeedsActiveFrame(group) === false) {
          const candidates = selectClauseCandidates(group, goal, env);
          const candidateCount = clauseCandidateLength(candidates.primary) +
            clauseCandidateLength(candidates.fallback);
          if (candidateCount === 1) {
            const clause = clauseCandidateLength(candidates.primary) === 1
              ? clauseCandidateAt(candidates.primary, 0)
              : clauseCandidateAt(candidates.fallback, 0);
            const { freshHead, freshBody, headLocalFresh } = instantiateClause(clause, nextFreshId());
            const next = env.clone();
            this.stats.unify_calls++;
            if (!unify(goal, freshHead, next, { knownNonoccurringVariables: headLocalFresh })) break;
            if (freshBody.length === 0) {
              goals = rest;
            } else if (rest.length >= GOAL_CONTINUATION_THRESHOLD ||
                rest.some((pending) => pending?.kind === 'continueGoals')) {
              next.compactForDeepContinuation?.();
              goals = [...freshBody, { kind: 'continueGoals', goals: rest, depth, releaseActive: false }];
            } else {
              goals = [...freshBody, ...rest];
            }
            env = next;
            depth++;
            continue;
          }
        }
        pushUserGoalUncachedFrames(stack, this, group, goal, rest, env, depth, active);
        break;
      }
      }
    } catch (error) {
      const normalized = normalizeHostResourceError(error);
      if (normalized instanceof PrologError && normalized.formal === 'resource_error(memory)') {
        // Unwinding makes query-local terms unreachable, but hosts are free to
        // postpone collection. Give the shared solver family bounded breathing
        // room on its next query so a GC can observe those released references.
        if (!this.memoryRecovery.active) {
          this.memoryRecovery.active = true;
          this.memoryRecovery.reservationBytes = 1024 * 1024;
          this.memoryRecovery.checks = 16;
        }
      }
      throw normalized;
    } finally {
      const stackIndex = this.solveStacks.indexOf(registeredStack);
      if (stackIndex >= 0) this.solveStacks.splice(stackIndex, 1);
      this.active = savedActive;
      writeVariableState.depth = Math.max(0, writeVariableState.depth - 1);
      if (writeVariableState.depth === 0) {
        writeVariableState.names.clear();
        writeVariableState.next = 0;
      }
    }
  }

  hasPendingAlternatives(excludedStacks = null) {
    // Choicepoints are represented by actual pending frames. Predicate
    // iterators discard an exhausted resume frame before yielding their final
    // answer, so observers never need to reinterpret or conceal stack entries.
    // Control builtins can exclude their caller's pre-existing stacks when
    // inspecting a nested branch.
    return this.solveStacks.some((stack) => !excludedStacks?.has(stack) && stack.length !== 0);
  }

  fastCountGoal(goal, env) {
    return fastCountPureGoal(this, goal, env);
  }

  fastGroundGoalTruth(goal, env) {
    return fastGroundPureGoalTruth(this, goal, env);
  }

  datalogModelFor(group) {
    let model = this.datalogModels.get(group);
    if (model) return model;
    model = evaluatePositiveDatalog(this.program, group);
    this.stats.datalog_evaluations++;
    this.stats.datalog_rule_firings += model.ruleFirings;
    this.stats.datalog_facts_derived += model.derivedFacts;
    for (const member of model.groups) {
      if (!this.datalogModels.has(member)) this.datalogModels.set(member, model);
    }
    this.datalogModels.set(group, model);
    return model;
  }

  wfsModelFor(group) {
    let model = this.wfsModels.get(group);
    if (model) return model;
    model = evaluateWfs(this.program, group);
    this.stats.wfs_fixpoint_rounds += model.rounds;
    this.wfsModels.set(group, model);
    return model;
  }

  *solveWfsGoal(group, goal, rest, env, depth) {
    const model = this.wfsModelFor(group);
    const relation = relationForGroup(model, group, 'upper');
    const lower = relationForGroup(model, group, 'lower');
    if (!relation) return;
    for (const row of relation.rows) {
      const next = env.clone();
      let ok = true;
      for (let i = 0; i < goal.arity; i++) {
        this.stats.unify_calls++;
        if (!unify(goal.args[i], row[i], next)) { ok = false; break; }
      }
      if (!ok) continue;
      if (!lower?.has(row)) {
        this.stats.wfs_undefined_answers++;
        continue;
      }
      yield* this.solve(rest, next, depth + 1);
      if (this.solutionsSeen >= this.solutionLimit) return;
    }
  }

  *solveTabledNegation(argument, env) {
    const truth = this.groundGoalTruth(argument, env);
    if (truth === 'true') return;
    if (truth === 'undefined') {
      this.stats.wfs_undefined_answers++;
      return;
    }
    yield env;
  }

  groundGoalTruth(argument, env) {
    let invoked = copyResolved(argument, env);
    while (invoked.type === COMPOUND && invoked.name === ':' && invoked.arity === 2) {
      const module = invoked.args[0];
      if (module.type === VAR) throw new PrologError('instantiation_error');
      if (module.type !== 'atom') throw new PrologError('type_error(atom)', module);
      invoked = invoked.args[1];
      if (invoked.type !== COMPOUND && invoked.type !== 'atom') {
        throw new PrologError('type_error(callable)', invoked);
      }
      qualifyTerm(invoked, module.name);
    }
    if (invoked.type === VAR) throw new PrologError('instantiation_error');
    if (invoked.type !== COMPOUND && invoked.type !== 'atom') {
      throw new PrologError('type_error(callable)', invoked);
    }
    if (!termIsGround(invoked)) throw new PrologError('instantiation_error');
    const group = this.program.findGroup(invoked.name, invoked.arity, invoked.module ?? 'user');
    if (group?.wfsDatalog === true) {
      const model = this.wfsModelFor(group);
      return truthOfGroundGoal(model, invoked);
    }

    // Outside an unstratified WFS component, a ground goal has the ordinary
    // two-valued result after the positive goal is evaluated.
    const child = this.cloneForInnerGoal(1);
    for (const _ of child.solve([invoked], env.clone(), 0)) {
      this.absorbStatsFrom(child);
      return 'true';
    }
    this.absorbStatsFrom(child);
    return 'false';
  }

  activeVariant(goal, env) {
    return activeVariantIn(goal, env, this.active);
  }

  checkMemoryLimit(force = false) {
    const observation = this.inferenceObservation.value;
    if (!force && observation < this.memoryCheckState.nextObservation) return;
    this.memoryCheckState.nextObservation = observation + 256;
    if (!Number.isFinite(this.maxMemoryBytes)) return;
    const used = usedHeapSize();
    if (used != null && used < this.maxMemoryBytes) this.finishMemoryRecovery();
    if (used != null && used >= this.currentMemoryLimit()) {
      if (this.memoryRecovery.active && this.memoryRecovery.checks > 0) {
        this.memoryRecovery.checks--;
        return;
      }
      throw new PrologError('resource_error(memory)');
    }
  }

  checkMemoryReservation(bytes) {
    if (!Number.isFinite(this.maxMemoryBytes) || !Number.isFinite(bytes) || bytes <= 0) return;
    const used = usedHeapSize();
    if (used != null && used < this.maxMemoryBytes) this.finishMemoryRecovery();
    if (used != null && bytes > Math.max(0, this.currentMemoryLimit() - used)) {
      if (this.memoryRecovery.active && bytes <= this.memoryRecovery.reservationBytes) {
        this.memoryRecovery.reservationBytes -= bytes;
        return;
      }
      throw new PrologError('resource_error(memory)');
    }
  }

  currentMemoryLimit() {
    if (!this.memoryRecovery.active) return this.maxMemoryBytes;
    // Retain at least five percent of the actual host ceiling for error
    // construction and unwinding. For an embedder-supplied lower soft limit,
    // cap the temporary recovery window as well.
    const hostSafetyLimit = hardHeapLimit() * 0.95;
    const recoveryAllowance = Math.max(8 * 1024 * 1024, this.maxMemoryBytes * 0.125);
    return Math.min(hostSafetyLimit, this.maxMemoryBytes + recoveryAllowance);
  }

  finishMemoryRecovery() {
    this.memoryRecovery.active = false;
    this.memoryRecovery.reservationBytes = 0;
    this.memoryRecovery.checks = 0;
  }

  *solveUserGoal(goal, rest, env, depth) {
    this.stats.solve_one_goal_calls++;
    if (depth > this.maxDepth) {
      this.depthLimitExceeded = true;
      throw new PrologError('resource_error(depth_limit)');
    }
    if (this.solutionsSeen >= this.solutionLimit) return;
    if (goal.type !== COMPOUND && goal.type !== 'atom') return;
    const group = this.program.findGroup(goal.name, goal.arity, goal.module ?? 'user');
    if (!group) return;
    qualifyMetaArguments(goal, group);
    if (group.datalogLeastModel === true && !termIsGround(goal, env)) {
      yield* this.solveDatalogGoal(group, goal, rest, env, depth);
      return;
    }
    if (group.wfsDatalog === true) {
      yield* this.solveWfsGoal(group, goal, rest, env, depth);
      return;
    }
    if (group.tabled) {
      yield* this.solveMemoizedGoal(group, goal, rest, env, depth);
      return;
    }
    yield* this.solveUserGoalUncached(group, goal, rest, env, depth);
  }

  *solveDatalogGoal(group, goal, rest, env, depth) {
    const model = this.datalogModelFor(group);
    const relation = relationForDatalogGroup(model, group);
    for (const next of datalogAnswerSolutions(this, relation, goal, env)) {
      yield* this.solve(rest, next, depth + 1);
      if (this.solutionsSeen >= this.solutionLimit) return;
    }
  }

  *solveMemoizedGoal(group, goal, rest, env, depth) {
    yield* this.solve([goal, ...rest], env, depth);
  }

  *solveUserGoalUncached(group, goal, rest, env, depth) {
    // Program indexes provide candidate clauses, but every candidate is still
    // freshened and unified below. The index is a performance hint, not a
    // semantic shortcut.
    const candidates = selectClauseCandidates(group, goal, env);
    for (const pass of [candidates.primary, candidates.fallback]) {
      for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(pass); candidateIndex++) {
        const clause = clauseCandidateAt(pass, candidateIndex);
        if (clause.body.length === 0 && clause.scalarHead) {
          const next = matchScalarFact(goal, clause.head, env);
          if (!next) continue;
          this.stats.unify_calls++;
          yield* this.solve(rest, next, depth + 1);
          if (this.solutionsSeen >= this.solutionLimit) return;
          continue;
        }
        if (headCannotMatch(goal, clause.head, env)) continue;
        const { freshHead, freshBody, headLocalFresh } = instantiateClause(clause, nextFreshId());
        const next = env.clone();
        this.stats.unify_calls++;
        if (!unify(goal, freshHead, next, { knownNonoccurringVariables: headLocalFresh })) continue;
        if (freshBody.length === 0) {
          yield* this.solve(rest, next, depth + 1);
        } else if (!groupNeedsActiveFrame(group)) {
          for (const bodyEnv of this.solve(freshBody, next, depth + 1)) {
            if (this.solutionsSeen > 0) this.solutionsSeen--;
            yield* this.solve(rest, bodyEnv, depth + 1);
            if (this.solutionsSeen >= this.solutionLimit) break;
          }
        } else {
          yield* this.solveRuleBodyThenRest(goal, env, freshBody, rest, next, depth);
        }
        if (this.solutionsSeen >= this.solutionLimit) return;
      }
    }
  }
  *solveRuleBodyThenRest(goal, goalEnv, body, rest, env, depth) {
    // Match the C engine's active-call lifetime: the active guard protects
    // expansion of the current rule body, but it must be released before
    // the caller's remaining goals are solved. Keeping the goal active
    // through rest goals over-prunes valid transitive/recursive derivations.
    this.active.push({ goal, env: goalEnv._snapshotForSolverRead() });
    for (const bodyEnv of this.solve(body, env, depth + 1)) {
      if (this.solutionsSeen > 0) this.solutionsSeen--;
      this.active.pop();
      yield* this.solve(rest, bodyEnv, depth + 1);
      this.active.push({ goal, env: goalEnv._snapshotForSolverRead() });
      if (this.solutionsSeen >= this.solutionLimit) break;
    }
    this.active.pop();
  }

}

function normalizeHostResourceError(error) {
  if (error?.name !== 'RangeError') return error;
  const message = String(error?.message ?? '');
  // V8 reports exhausted Map/Set capacity as a host RangeError.  ISO 7.12.2 h
  // requires processor resource exhaustion to surface as resource_error/1,
  // with the resource atom implementation dependent.  A finite host capacity
  // ceiling is reported as `memory`; reserve `finite_memory` for the separate
  // convention where no finite amount of memory can complete the computation.
  if (/^(?:Map|Set) maximum size exceeded$/.test(message)) {
    return new PrologError('resource_error(memory)');
  }
  return error;
}

function qualifyMetaArguments(goal, group) {
  const callerModule = goal.module ?? 'user';
  for (const mode of group.metaArgumentModes ?? []) {
    const argument = goal.args[mode.index];
    if (argument == null) continue;
    if (mode.kind === 'context') {
      // ISO/IEC 13211-2 amendment (2013), 6.2.5.7: ':' arguments are
      // visibly prefixed with the current source/calling module. Preserve an
      // already explicit qualification, otherwise wrap even a variable so a
      // later binding retains the caller context and Module:Goal inspection
      // observes the standardized term shape.
      if (!(argument.type === COMPOUND && argument.name === ':' && argument.arity === 2)) {
        goal.args[mode.index] = compound(':', [atom(callerModule), argument]);
      }
      continue;
    }
    if (mode.kind === 'closure' && (argument.type === COMPOUND || argument.type === ATOM)) {
      qualifyTerm(argument, callerModule);
    }
  }
}

const ISO_CORE_FLAG_NAMES = new Set([
  'bounded', 'integer_rounding_function', 'char_conversion', 'debug',
  'max_integer', 'min_integer', 'max_arity', 'unknown', 'double_quotes',
]);

function defaultPrologFlags(unknown = 'error', strictIso = false) {
  const flags = new Map([
    ['bounded', { value: compound('false', []), allowed: ['true', 'false'], changeable: false }],
    ['integer_rounding_function', { value: compound('toward_zero', []), allowed: ['down', 'toward_zero'], changeable: false }],
    ['char_conversion', { value: compound('on', []), allowed: ['on', 'off'], changeable: true }],
    ['debug', { value: compound('off', []), allowed: ['on', 'off'], changeable: true }],
    ['max_integer', { value: null, allowed: [], changeable: false }],
    ['min_integer', { value: null, allowed: [], changeable: false }],
    ['max_arity', ISO_MAX_ARITY == null
      ? { value: compound('unbounded', []), allowed: ['unbounded'], valueType: ATOM, changeable: false }
      : { value: numberTerm(ISO_MAX_ARITY), allowed: [String(ISO_MAX_ARITY)], valueType: NUMBER, changeable: false }],
    ['unknown', { value: compound(unknown, []), allowed: ['error', 'fail', 'warning'], changeable: true }],
    ['double_quotes', { value: compound('chars', []), allowed: ['chars', 'codes', 'atom'], changeable: true }],
    ['occurs_check', { value: compound('true', []), allowed: ['true', 'error'], changeable: true }],
    // ISO 7.5.2 makes every user-defined procedure static, and therefore
    // private, unless declared otherwise. Setting this flag to public grants
    // clause/2 access to all of them at once, which meta-interpreters need
    // without having to enumerate every predicate in a public/1 directive.
    // The procedures stay static: assert/1 and retract/1 still refuse them.
    ['default_procedure_access', { value: compound('private', []), allowed: ['private', 'public'], changeable: true }],
  ]);
  if (strictIso) {
    flags.delete('occurs_check');
    flags.delete('default_procedure_access');
  }
  return flags;
}


function makeMemoEntry(arity = 0) {
  return {
    computing: false,
    complete: false,
    answers: [],
    answerKeys: new Set(),
    answerIndexes: Array.from({ length: arity }, () => new Map()),
    answerVariableFallbacks: Array.from({ length: arity }, () => []),
  };
}

function memoAnswerScalarKey(term) {
  if (term?.type !== 'atom' && term?.type !== 'string' && term?.type !== 'number') return null;
  return `${term.type}\u0000${term.type === 'number' ? numberValueKey(term.name) : term.name}`;
}

function isMostGeneralTableGoal(goal, env) {
  const seen = new Set();
  for (const arg of goal.args) {
    const value = derefForLocal(arg, env);
    if (value.type !== 'var' || seen.has(value.name)) return false;
    seen.add(value.name);
  }
  return true;
}

function scheduleTableFixpointRound(stack, solver, frame) {
  solver.stats.table_fixpoint_rounds++;
  solver.tableCoordinator.cycleSeen = false;
  for (const entry of solver.tableCoordinator.entries) {
    entry.computing = false;
    entry.complete = false;
  }
  frame.entry.computing = true;
  const nextFrame = {
    kind: 'completeTableFixpointRound',
    revision: solver.programRevision,
    entry: frame.entry,
    group: frame.group,
    goal: frame.goal,
    rest: frame.rest,
    env: frame.env,
    depth: frame.depth,
    active: frame.active,
    answerCountBefore: frame.entry.answers.length,
  };
  stack.push(nextFrame);
  pushUserGoalUncachedFrames(
    stack,
    solver,
    frame.group,
    frame.goal,
    [{ kind: 'memoStore', entry: frame.entry, goal: frame.goal, revision: solver.programRevision }],
    frame.env,
    frame.depth,
    frame.active,
    frame.mapKey,
  );
}


function pushMemoAnswerFrames(stack, entry, goal, rest, env, depth, active, solver) {
  let selected = null;
  for (let position = 0; position < goal.arity; position++) {
    const value = derefForLocal(goal.args[position], env);
    const key = memoAnswerScalarKey(value);
    if (key == null) continue;
    const bucket = entry.answerIndexes[position]?.get(key) ?? [];
    const fallback = entry.answerVariableFallbacks[position] ?? [];
    const candidateLength = bucket.length + fallback.length;
    if (selected == null || candidateLength < selected.length) {
      selected = { bucket, fallback, length: candidateLength };
    }
  }
  const pushReplay = (answerIndex) => {
    stack.push({
      kind: 'unifyArgsBranch',
      goal,
      args: entry.answers[answerIndex],
      freshNonGround: true,
      goals: rest,
      env,
      depth: depth + 1,
      active,
    });
  };
  if (selected != null) {
    for (let i = selected.fallback.length - 1; i >= 0; i--) pushReplay(selected.fallback[i]);
    for (let i = selected.bucket.length - 1; i >= 0; i--) pushReplay(selected.bucket[i]);
    return;
  }
  for (let answerIndex = entry.answers.length - 1; answerIndex >= 0; answerIndex--) pushReplay(answerIndex);
}

function pushUserGoalUncachedFrames(stack, solver, group, goal, rest, env, depth, active, tableMapKey = null) {
  if (group.fastPi && pushFastPiFrames(stack, goal, rest, env, depth, active)) return;
  if (tryPushGroundScalarRuleFrame(stack, solver, group, goal, rest, env, depth, active)) return;
  if (tryPushGroundChainFrames(stack, solver, group, goal, rest, env, depth, active)) return;
  const candidates = selectClauseCandidates(group, goal, env);
  const candidateCount = clauseCandidateLength(candidates.primary) + clauseCandidateLength(candidates.fallback);
  const frames = [];
  // Active frames serve two purposes: they delimit cut and detect variants in
  // recursive user predicates. Delay the invocation snapshot until a reachable
  // cut/guard actually needs one; ordinary cut-free recursion avoids it.
  for (const pass of [candidates.primary, candidates.fallback]) {
    for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(pass); candidateIndex++) {
      const clause = clauseCandidateAt(pass, candidateIndex);
      if (candidateCount > 1 && headCannotMatch(goal, clause.head, env)) continue;
      // Do not speculatively unify alternative heads. With attributed variables,
      // head unification can run verify_attributes/3, queue wakeups, fail, or
      // throw. Those effects are observable and must occur only if Prolog search
      // actually reaches this clause (in particular after earlier cuts).
      frames.push({
        kind: 'userClause',
        clause,
        goal,
        rest,
        env,
        depth,
      });
    }
  }
  // Traditional depth-first mode disables recursive-cycle guards. A cut
  // boundary is then needed only if an actually reachable clause contains a
  // cut. Scalar indexes often narrow a mixed predicate to one cut-free
  // recursive clause; do not copy the whole active path at every such layer.
  const traditionalDepthFirst = !group.tabled;
  const guarded = traditionalDepthFirst
    ? (group.hasCut === true && frames.some((frame) => clauseHasCutForTailRelease(frame.clause)))
    : groupNeedsActiveFrame(group);
  const release = guarded ? [{ kind: 'releaseActive' }] : [];
  const nextActive = guarded
    ? [...active, { goal, env: env._snapshotForSolverRead(), tableMapKey }]
    : active;
  for (const frame of frames) {
    frame.active = nextActive;
    frame.release = release;
    frame.tailReleaseBeforeLast = traditionalDepthFirst && guarded &&
      clauseCanReleaseActiveBeforeTailCall(group, frame.clause);
    frame.directCutReleaseIndex = traditionalDepthFirst && guarded
      ? clauseDirectCutReleaseIndex(frame.clause) : -1;
  }
  for (let i = frames.length - 1; i >= 0; i--) stack.push(frames[i]);
}


function instantiatePlanNode(node, variables) {
  if (node.variableSlot != null) return variables[node.variableSlot];
  const args = new Array(node.args.length);
  for (let index = 0; index < args.length; index++) {
    args[index] = instantiatePlanNode(node.args[index], variables);
  }
  const term = new Term(node.type, node.name, args);
  if (node.module != null) term.module = node.module;
  return term;
}

function freshSetForVariableSlots(slots, variables) {
  if (slots.length === 0) return null;
  const names = new Array(slots.length);
  for (let index = 0; index < slots.length; index++) names[index] = variables[slots[index]].name;
  return names.length <= 4 ? new SmallFreshVariableSet(names) : new Set(names);
}

function instantiateClause(clause, id) {
  let plan = clause._instantiationPlan;
  if (plan == null) {
    const variableSlots = new Map();
    const variableNames = [];
    const compile = (term) => {
      if (term.type === VAR) {
        let slot = variableSlots.get(term.name);
        if (slot == null) {
          slot = variableNames.length;
          variableSlots.set(term.name, slot);
          variableNames.push(term.name);
        }
        return { variableSlot: slot };
      }
      return {
        type: term.type,
        name: term.name,
        module: term.module,
        args: term.args.map(compile),
      };
    };
    const localFreshPlan = clauseLocalFreshPlan(clause);
    const head = compile(clause.head);
    const body = clause.body.map(compile);
    const slotsFor = (names) => names.map((name) => variableSlots.get(name)).filter((slot) => slot != null);
    const bodyProofIndexes = [];
    for (let index = 0; index < clause.body.length; index++) {
      if (goalUsesFirstUseProof(clause.body[index])) bodyProofIndexes.push(index);
    }
    plan = clause._instantiationPlan = {
      head,
      body,
      variableNames,
      headLocalSlots: slotsFor(localFreshPlan.head),
      bodyLocalSlots: localFreshPlan.body.map(slotsFor),
      bodyProofIndexes,
    };
  }

  const variables = new Array(plan.variableNames.length);
  for (let index = 0; index < variables.length; index++) {
    variables[index] = variable(`${plan.variableNames[index]}#${id}`);
  }
  const freshHead = instantiatePlanNode(plan.head, variables);
  const freshBody = new Array(plan.body.length);
  for (let index = 0; index < freshBody.length; index++) {
    freshBody[index] = instantiatePlanNode(plan.body[index], variables);
  }
  const headLocalFresh = freshSetForVariableSlots(plan.headLocalSlots, variables);
  for (let proofIndex = 0; proofIndex < plan.bodyProofIndexes.length; proofIndex++) {
    const index = plan.bodyProofIndexes[proofIndex];
    const goal = freshBody[index];
    const knownNonoccurringVariables = freshSetForVariableSlots(plan.bodyLocalSlots[index] ?? [], variables);
    if (knownNonoccurringVariables == null || goal?.type !== COMPOUND) continue;
    attachKnownNonoccurringVariables(goal, knownNonoccurringVariables);
  }
  return { freshHead, freshBody, headLocalFresh };
}

function attachKnownNonoccurringVariables(term, knownNonoccurringVariables) {
  if (term?.type !== COMPOUND) return;
  if (term.name === '=' && term.arity === 2) {
    term._knownNonoccurringVariables = knownNonoccurringVariables;
  } else if ((term.name === 'get_atts' && term.arity === 2)
    || (term.name === 'get_attr' && term.arity === 3)
    || (term.name === '$get_attr_list' && term.arity === 2)
    || (term.name === '$get_from_attr_list' && term.arity === 3)) {
    term._firstUseVariables = knownNonoccurringVariables;
  }
  if ((term.name === ',' || term.name === ';' || term.name === '->') && term.arity === 2) {
    attachKnownNonoccurringVariables(term.args[0], knownNonoccurringVariables);
    attachKnownNonoccurringVariables(term.args[1], knownNonoccurringVariables);
  } else if (term.name === '\\+' && term.arity === 1) {
    attachKnownNonoccurringVariables(term.args[0], knownNonoccurringVariables);
  } else if (term.name === ':' && term.arity === 2) {
    attachKnownNonoccurringVariables(term.args[1], knownNonoccurringVariables);
  }
}

function clauseLocalFreshPlan(clause) {
  if (clause._localFreshPlan != null) return clause._localFreshPlan;
  const seen = new Set();
  const planForTerm = (term) => {
    const counts = new Map();
    const stack = [term];
    while (stack.length > 0) {
      const current = stack.pop();
      if (current?.type === VAR) {
        counts.set(current.name, (counts.get(current.name) ?? 0) + 1);
        continue;
      }
      if (current?.type !== COMPOUND) continue;
      for (let index = 0; index < current.arity; index++) stack.push(current.args[index]);
    }
    const local = [];
    for (const [name, count] of counts) {
      if (!seen.has(name) && count === 1) local.push(name);
      seen.add(name);
    }
    return local;
  };
  const head = planForTerm(clause.head);
  const body = clause.body.map(planForTerm);
  return clause._localFreshPlan = { head, body };
}

function freshVariableSet(names, freshVariables) {
  if (names.length === 0) return null;
  const fresh = [];
  for (const name of names) {
    const term = freshVariables.get(name);
    if (term != null) fresh.push(term.name);
  }
  if (fresh.length === 0) return null;
  // Most clauses introduce only one or two first-use variables. A tiny linear
  // membership object avoids allocating and populating an OrderedHashSet on
  // every invocation; use the native Set once linear lookup would lose.
  return fresh.length <= 4 ? new SmallFreshVariableSet(fresh) : new Set(fresh);
}

class SmallFreshVariableSet {
  constructor(values) {
    this.values = values;
  }

  has(value) {
    for (let index = 0; index < this.values.length; index++) {
      if (this.values[index] === value) return true;
    }
    return false;
  }
}

function goalUsesFirstUseProof(term) {
  if (term?.type !== COMPOUND) return false;
  if ((term.name === '=' && term.arity === 2)
    || (term.name === 'get_atts' && term.arity === 2)
    || (term.name === 'get_attr' && term.arity === 3)
    || (term.name === '$get_attr_list' && term.arity === 2)
    || (term.name === '$get_from_attr_list' && term.arity === 3)) return true;
  if ((term.name === ',' || term.name === ';' || term.name === '->') && term.arity === 2) {
    return goalUsesFirstUseProof(term.args[0]) || goalUsesFirstUseProof(term.args[1]);
  }
  if (term.name === '\\+' && term.arity === 1) return goalUsesFirstUseProof(term.args[0]);
  if (term.name === ':' && term.arity === 2) return goalUsesFirstUseProof(term.args[1]);
  return false;
}

function attachBodyLocalFreshVariables(freshBody, plan, freshVariables) {
  const attach = (term, knownNonoccurringVariables) => {
    if (term?.type !== COMPOUND) return;
    if (term.name === '=' && term.arity === 2) {
      term._knownNonoccurringVariables = knownNonoccurringVariables;
    } else if ((term.name === 'get_atts' && term.arity === 2)
      || (term.name === 'get_attr' && term.arity === 3)
      || (term.name === '$get_attr_list' && term.arity === 2)
      || (term.name === '$get_from_attr_list' && term.arity === 3)) {
      term._firstUseVariables = knownNonoccurringVariables;
    }
    // Goal expansion commonly wraps a primitive in a conjunction or
    // if-then-else. Preserve the proof on the executable child; attaching it
    // only to the outer control term leaves get_atts/2 unable to use it.
    if ((term.name === ',' || term.name === ';' || term.name === '->') && term.arity === 2) {
      attach(term.args[0], knownNonoccurringVariables);
      attach(term.args[1], knownNonoccurringVariables);
    } else if (term.name === '\\+' && term.arity === 1) {
      attach(term.args[0], knownNonoccurringVariables);
    } else if (term.name === ':' && term.arity === 2) {
      attach(term.args[1], knownNonoccurringVariables);
    }
  };
  for (let index = 0; index < freshBody.length; index++) {
    const goal = freshBody[index];
    if (!goalUsesFirstUseProof(goal)) continue;
    const knownNonoccurringVariables = freshVariableSet(plan[index] ?? [], freshVariables);
    if (knownNonoccurringVariables == null || goal?.type !== COMPOUND) continue;
    // Host builtins that only unify an output with already-existing logical
    // data can use the same first-use proof without treating the variable as a
    // WAM-style local across the whole call. This is especially important for
    // get_atts/2: CLP(Z) attributes are large trees that would otherwise be
    // traversed once per freshly introduced pattern variable.
    attach(goal, knownNonoccurringVariables);
  }
}


function prepareLocalVariablesForGoal(goal, env) {
  // A DCG local is globalized if later source places it inside a structure.
  // Inspect the small fresh goal syntax rather than dereferencing large data.
  if (env.hasLocalVariables() && goal?.type === COMPOUND) {
    const pending = [];
    for (const argument of goal.args) if (argument?.type === COMPOUND) pending.push(argument);
    while (pending.length !== 0) {
      const current = pending.pop();
      for (const argument of current.args ?? []) {
        if (argument?.type === VAR) {
          const root = derefForLocal(argument, env);
          if (root.type === VAR && env.isLocalVariable(root.name)) env.demoteLocalVariable(root.name);
        } else if (argument?.type === COMPOUND) {
          pending.push(argument);
        }
      }
    }
  }
  env.markLocalVariables(goal?._localFirstUseVariables ?? null);
}

function clauseDirectCutReleaseIndex(clause) {
  if (clause?.compactBinary === true) return -1;
  let lastDirectCut = -1;
  for (let index = 0; index < clause.body.length; index++) {
    const goal = clause.body[index];
    if (goal?.type === ATOM && goal.name === '!') {
      lastDirectCut = index;
      continue;
    }
    if (termContainsCutForRelease(goal)) return -1;
  }
  return lastDirectCut;
}

function termContainsCutForRelease(term) {
  if (term?.type === ATOM) return term.name === '!';
  if (term?.type !== COMPOUND) return false;
  const pending = [...term.args];
  while (pending.length > 0) {
    const current = pending.pop();
    if (current?.type === ATOM && current.name === '!') return true;
    if (current?.type === COMPOUND) for (const arg of current.args) pending.push(arg);
  }
  return false;
}

function clauseCanReleaseActiveBeforeTailCall(group, clause) {
  if (clauseHasCutForTailRelease(clause)) return false;
  if (group.clauses[group.clauses.length - 1] !== clause || clause.body.length === 0) return false;
  const tail = clause.body[clause.body.length - 1];
  return tail?.type === COMPOUND && tail.name === group.name && tail.arity === group.arity &&
    (tail.module ?? group.module) === group.module;
}

function clauseHasCutForTailRelease(clause) {
  if (clause?.compactBinary === true) return false;
  const pending = [...clause.body];
  while (pending.length > 0) {
    const current = pending.pop();
    if (current?.type === ATOM && current.name === '!') return true;
    if (current?.type === COMPOUND) for (const arg of current.args) pending.push(arg);
  }
  return false;
}

function groupNeedsActiveFrame(group) {
  // A direct recursive call that consumes the tail of a matched list cannot
  // revisit an earlier finite-tree call. It needs neither a cycle guard nor an
  // O(depth) copy of the active-call stack at every element.
  if (group.listTailRecursive === true && group.hasCut !== true) return false;
  // User code may observe the surrounding control context through later cuts,
  // so only apply this planning shortcut to the fixed bundled-library graph.
  if (group.bundledLibrary !== true) return true;
  // A frame is also required above a cut-bearing callee. The disjunction
  // builtin uses the caller marker to distinguish a callee-local cut from a
  // cut in its own branch. null means dependency analysis was intentionally
  // disabled (strict mode or a newly mutated group), so remain conservative.
  return group.cutReachable !== false || (group.recursive && !group.linearNumeric);
}

function datalogAnswerSolutions(solver, relation, goal, env) {
  const state = { pending: false };
  const iterator = datalogAnswerGenerator(solver, relation, goal, env, state);
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}

function* datalogAnswerGenerator(solver, relation, goal, env, state) {
  if (!relation) return;
  const candidates = datalogCandidateIndexes(
    relation,
    goal.args ?? [],
    env,
    derefForLocal,
    memoAnswerScalarKey,
  );
  const indexes = candidates == null
    ? { length: relation.rows.length, at: (index) => index }
    : { length: candidates.length, at: (index) => candidates[index] };
  for (let position = 0; position < indexes.length; position++) {
    const rowIndex = indexes.at(position);
    const row = relation.rows[rowIndex];
    const next = env.clone();
    let matches = true;
    for (let i = 0; i < goal.arity; i++) {
      solver.stats.unify_calls++;
      if (!unify(goal.args[i], row[i], next)) {
        matches = false;
        break;
      }
    }
    if (!matches) continue;
    state.pending = position + 1 < indexes.length;
    yield next;
  }
  state.pending = false;
}

function pushWfsAnswerFrames(stack, model, group, goal, rest, env, depth, active, solver) {
  const relation = relationForGroup(model, group, 'upper');
  const lower = relationForGroup(model, group, 'lower');
  if (!relation) return;
  for (let rowIndex = relation.rows.length - 1; rowIndex >= 0; rowIndex--) {
    const row = relation.rows[rowIndex];
    if (!lower?.has(row)) {
      solver.stats.wfs_undefined_answers++;
      continue;
    }
    stack.push({
      kind: 'unifyArgsBranch',
      goal,
      args: row,
      freshNonGround: false,
      goals: rest,
      env,
      depth: depth + 1,
      active,
    });
  }
}

function bundledBetweenIterator(solver, group, goal, env) {
  if (solver.registry.eyePrologLibrary !== true ||
      group.module !== 'between' || group.name !== 'between' || group.arity !== 3 ||
      group.bundledLibrary !== true || group.clauses.length !== 1) {
    return null;
  }

  // The portable library(between) definition is kept as the semantic
  // source of between/3. Its recursive helper, however, carries the output
  // variable through one fresh clause instance per integer. With persistent
  // environments that builds a growing variable-alias chain, so dereferencing
  // the generated value in the caller repeatedly revisits all earlier frames.
  // Enumerate the canonical bundled relation directly while leaving user
  // definitions and non-EyeProlog registries on the ordinary Prolog path.
  const state = { pending: false };
  const iterator = bundledBetweenSolutions(solver, goal, env, state);
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}

function requireBetweenInteger(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) {
    throw new PrologError('type_error(integer)', value);
  }
  return BigInt(value.name);
}

function* bundledBetweenSolutions(solver, goal, env, state) {
  const lower = requireBetweenInteger(goal.args[0], env);
  const upper = requireBetweenInteger(goal.args[1], env);
  const requested = deref(goal.args[2], env);

  if (requested.type !== VAR) {
    if (requested.type !== NUMBER || !isDecimalInteger(requested.name)) {
      throw new PrologError('type_error(integer)', requested);
    }
    const value = BigInt(requested.name);
    if (value >= lower && value <= upper) yield env;
    return;
  }

  for (let value = lower; value <= upper; value++) {
    const next = env.clone();
    solver.stats.unify_calls++;
    if (unify(goal.args[2], numberTerm(value), next)) {
      state.pending = value < upper;
      yield next;
    }
  }
  state.pending = false;
}

function bundledMemberIterator(solver, group, goal, env) {
  if (solver.registry.eyePrologLibrary !== true ||
      group.module !== 'lists' || group.name !== 'member' || group.arity !== 2 ||
      group.bundledLibrary !== true || group.clauses.length !== 2) {
    return null;
  }

  // Attributed and delayed list variables retain the ordinary clause path so
  // their hooks and wake-up boundaries remain source-defined. Plain proper,
  // partial, and improper lists can all follow the canonical two-clause
  // relation lazily without first traversing the spine.
  if (env._prologAttributes != null || env._delays != null) return null;
  const state = { pending: false };
  const iterator = bundledMemberSolutions(solver, goal, env, state);
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}

function* bundledMemberSolutions(solver, goal, env, state) {
  let cursor = deref(goal.args[1], env);
  while (isCons(cursor)) {
    const item = cursor.args[0];
    cursor = deref(cursor.args[1], env);
    const next = env.clone();
    solver.stats.unify_calls++;
    if (unify(goal.args[0], item, next)) {
      // The tail itself is the pending search state. Do not inspect it for a
      // future successful unification: an untried list position remains a
      // choicepoint even when resuming it will eventually fail.
      state.pending = isCons(cursor) || cursor.type === VAR;
      yield next;
    }
  }
  if (cursor.type === VAR) {
    const openTail = cursor;
    const id = nextFreshId();
    let candidate = cons(goal.args[0], variable(`__member${id}_tail`));
    for (let before = 0n; ; before++) {
      const next = env.clone();
      solver.stats.unify_calls++;
      if (unify(openTail, candidate, next)) {
        state.pending = true;
        yield next;
      }
      candidate = cons(variable(`__member${id}_head_${before}`), candidate);
      generatedLengthAllocationCheckpoint(solver, before + 1n);
    }
  }
  state.pending = false;
}

function bundledEllipsisPlan(solver, group, goal, rest, env) {
  if (solver.registry.eyePrologLibrary !== true ||
      group.module !== 'iso_ext' || group.name !== '...' || group.arity !== 2 ||
      group.bundledLibrary !== true || group.clauses.length !== 2) {
    return null;
  }

  // length/2 and other native constructors can leave a known finite list as a
  // compact spine.  The ordinary ... //0 relation simply enumerates every
  // suffix of such a list; doing that directly avoids clause freshening and
  // recursive solver depth for every consumed element.  Non-compact and open
  // list cases retain the ordinary Prolog definition.
  const input = deref(goal.args[0], env);
  if (compactListLength(input) == null) return null;

  // A following binary identity relation is just a zero-width DCG hand-off.
  // Fuse it by asking .../2 for that relation's required output directly.
  // This is a structural optimization: any one-clause p(X,Y):-X=Y (or p(X,X).)
  // qualifies, not just a predicate named epsilon/2.
  if (rest.length > 0) {
    const continuation = deref(rest[0], env);
    if (continuation?.type === COMPOUND && continuation.arity === 2) {
      const continuationGroup = solver.program.findGroup(
        continuation.name, continuation.arity, continuation.module ?? goal.module ?? 'user',
      );
      if (isBinaryIdentityGroup(continuationGroup)) {
        const output = deref(goal.args[1], env);
        const continuationInput = deref(continuation.args[0], env);
        if (output.type === VAR && continuationInput.type === VAR && output.name === continuationInput.name &&
            output.name.startsWith('\u0000dcg')) {
          return {
            iterator: bundledEllipsisIterator(solver, continuation.args[1], input, env),
            rest: rest.slice(1),
          };
        }
      }
    }
  }

  return { iterator: bundledEllipsisIterator(solver, goal.args[1], input, env), rest };
}

function bundledEllipsisIterator(solver, output, input, env) {
  const state = { pending: false };
  const iterator = bundledEllipsisSolutions(solver, output, input, env, state);
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}

function isBinaryIdentityGroup(group) {
  if (group == null || group.arity !== 2 || group.clauses.length !== 1 || group.hasCut === true) return false;
  const clause = group.clauses[0];
  const left = clause.head?.args?.[0];
  const right = clause.head?.args?.[1];
  if (left?.type !== VAR || right?.type !== VAR) return false;
  if (clause.body.length === 0) return left.name === right.name;
  if (clause.body.length !== 1) return false;
  const equality = clause.body[0];
  if (equality?.type !== COMPOUND || equality.name !== '=' || equality.arity !== 2) return false;
  const a = equality.args[0];
  const b = equality.args[1];
  if (a?.type !== VAR || b?.type !== VAR) return false;
  return (a.name === left.name && b.name === right.name) ||
    (a.name === right.name && b.name === left.name);
}

function* bundledEllipsisSolutions(solver, output, input, env, state) {
  let cursor = input;
  const requestedOutput = deref(output, env);

  // A fixed empty remainder is the important DCG scanner case. Still walk the
  // actual compact spine so this remains a real tail-consumption benchmark,
  // but avoid allocating a speculative environment for every suffix that is
  // structurally incapable of matching [].
  if (isEmptyList(requestedOutput)) {
    while (!isEmptyList(cursor)) {
      if (!isCons(cursor)) return;
      cursor = deref(cursor.args[1], env);
    }
    yield env;
    return;
  }

  while (true) {
    const next = env.clone();
    solver.stats.unify_calls++;
    if (unify(output, cursor, next)) {
      state.pending = isCons(cursor);
      yield next;
    }
    if (isEmptyList(cursor)) return;
    if (!isCons(cursor)) return;
    cursor = deref(cursor.args[1], env);
  }
}

function bundledLengthIterator(solver, group, goal, env) {
  if (solver.registry.eyePrologLibrary !== true ||
      group.module !== 'lists' || group.name !== 'length' || group.arity !== 2 ||
      group.bundledLibrary !== true || group.clauses.length !== 2) {
    return null;
  }

  // Delayed and constrained variables need the ordinary solver's wake-up
  // points. The fast path is deliberately limited to plain finite-tree terms.
  if (env._prologAttributes != null) return null;
  const length = deref(goal.args[1], env);
  if (length.type === VAR && env._delays?.has(length.name)) return null;

  let cursor = deref(goal.args[0], env);
  // findall/3 can return an internal compact proper-list spine.  Its length is
  // already known; do not expand millions of lazy cons cells merely to decide
  // whether the bundled length/2 fast path is applicable.
  if (compactListLength(cursor) == null) {
    while (isCons(cursor)) {
      cursor = deref(cursor.args[1], env);
    }
    if (cursor.type === VAR) {
      if (env._delays?.has(cursor.name)) return null;
      if (length.type === VAR && cursor.name === length.name) return null;
    }
  }
  const state = {
    // length(OpenList, Length) has an unbounded succession of longer lists.
    // All other accepted fast-path modes are semidet.
    pending: length.type === VAR && cursor.type === VAR,
  };
  const iterator = bundledLengthSolutions(solver, goal, env);
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}

function* bundledLengthSolutions(solver, goal, env) {
  const requestedLength = deref(goal.args[1], env);
  if (requestedLength.type !== VAR) {
    if (requestedLength.type !== NUMBER || !isDecimalInteger(requestedLength.name)) {
      throw new PrologError('type_error(integer)', requestedLength);
    }
    const length = BigInt(requestedLength.name);
    if (length < 0n) throw new PrologError('domain_error(not_less_than_zero)', requestedLength);
    yield* fixedLengthSolutions(solver, goal.args[0], length, env);
    return;
  }

  yield* generatedLengthSolutions(solver, goal.args[0], goal.args[1], env);
}

function* fixedLengthSolutions(solver, list, length, env) {
  let cursor = deref(list, env);
  const compactLength = compactListLength(cursor);
  if (compactLength != null) {
    if (compactLength === length) yield env;
    return;
  }
  let remaining = length;
  let steps = 0n;
  while (isCons(cursor)) {
    if (remaining === 0n) return;
    remaining--;
    cursor = deref(cursor.args[1], env);
    lengthAllocationCheckpoint(solver, ++steps);
  }
  if (isEmptyList(cursor)) {
    if (remaining === 0n) yield env;
    return;
  }
  if (cursor.type !== VAR) return;

  // A source-level anonymous variable occurs nowhere else, so materializing
  // its list cannot affect any subsequent goal or answer substitution.
  if (isAnonymousVariable(cursor)) {
    yield env;
    return;
  }

  if (remaining > BigInt(Number.MAX_SAFE_INTEGER)) throw new PrologError('resource_error(memory)');
  const id = nextFreshId();
  // Keep an unobserved fixed-length list as one compact skeleton. Unification,
  // list predicates, and readback expand it one cell at a time if its elements
  // are actually inspected.
  solver.checkMemoryReservation(256);
  const suffix = compactVariableList(remaining, `__length${id}_`);
  const next = env.clone();
  solver.stats.unify_calls++;
  // The compact skeleton contains only freshly generated variables, so the
  // dereferenced tail variable is known not to occur in it. Reuse the same
  // proven-nonoccurrence path as source-level first-use unification.
  const knownNonoccurringVariables = new Set([cursor.name]);
  if (unify(cursor, suffix, next, { knownNonoccurringVariables })) yield next;
}

function* generatedLengthSolutions(solver, list, length, env) {
  let cursor = deref(list, env);
  const compactLength = compactListLength(cursor);
  if (compactLength != null) {
    const next = bindGeneratedLength(solver, length, compactLength, env);
    if (next != null) yield next;
    return;
  }
  let count = 0n;
  let steps = 0n;
  while (isCons(cursor)) {
    count++;
    cursor = deref(cursor.args[1], env);
    lengthAllocationCheckpoint(solver, ++steps);
  }
  if (isEmptyList(cursor)) {
    const next = bindGeneratedLength(solver, length, count, env);
    if (next != null) yield next;
    return;
  }
  if (cursor.type !== VAR) return;

  if (isAnonymousVariable(cursor)) {
    for (let value = count; ; value++) {
      const next = bindGeneratedLength(solver, length, value, env);
      if (next != null) yield next;
    }
  }

  const id = nextFreshId();
  let suffix = emptyList();
  // Every generated suffix is built from fresh variables and therefore cannot
  // contain the caller's dereferenced tail variable. Share the general
  // proven-nonoccurrence unification path instead of bypassing unify() here.
  const knownNonoccurringVariables = new Set([cursor.name]);
  for (let extra = 0n; ; extra++) {
    const next = env.clone();
    if (!unify(cursor, suffix, next, { knownNonoccurringVariables })) return;
    const answer = bindGeneratedLength(solver, length, count + extra, next);
    if (answer != null) yield answer;
    suffix = cons(variable(`__length${id}_${extra}`), suffix);
    generatedLengthAllocationCheckpoint(solver, extra + 1n);
  }
}

function bindGeneratedLength(solver, length, value, env) {
  const next = env.clone();
  solver.stats.unify_calls++;
  return unify(length, numberTerm(value), next) ? next : null;
}

function isAnonymousVariable(term) {
  return term.type === VAR && term.name.startsWith('__anon');
}

function lengthAllocationCheckpoint(solver, steps) {
  if ((steps & 255n) === 0n) solver.checkMemoryLimit(true);
}

function generatedLengthAllocationCheckpoint(solver, steps) {
  if ((steps & 255n) !== 0n) return;
  // The open-ended generator retains its current list spine between answers.
  // Reserve room proportional to that live spine so the protected length/2
  // call raises resource_error(memory) before its caller's outer solver hits
  // the same heap limit. This makes the error catchable by catch/3.
  const estimatedSpineBytes = steps > MAX_GENERATED_LENGTH_RESERVE_STEPS
    ? Number.MAX_SAFE_INTEGER
    : Number(steps) * GENERATED_LENGTH_CELL_RESERVE_BYTES;
  solver.checkMemoryReservation(estimatedSpineBytes);
  solver.checkMemoryLimit(true);
}

function pushFastPiFrames(stack, goal, rest, env, depth, active) {
  const values = goal.args.map((arg) => deref(arg, env));
  if ([0, 1, 2, 4].some((index) => values[index].type !== 'number')) return false;
  let a = Number(values[0].name);
  const b = Number(values[1].name);
  let sum = Number(values[2].name);
  let sign = Number(values[4].name);
  if (![a, b, sum, sign].every(Number.isFinite) || a > b) return true;
  while (a < b) {
    sum += sign / (2 * a * (2 * a + 1) * (2 * a + 2));
    a += 1;
    sign = -sign;
  }
  const next = env.clone();
  if (!unify(goal.args[3], numberTerm(numberTextFromDouble(sum)), next)) return true;
  stack.push({ kind: 'goals', goals: rest, env: next, depth: depth + 1, active });
  return true;
}



function fastGroundPureGoalTruth(solver, goal, env = new Env(), visiting = new Set()) {
  if (!termIsGround(goal, env)) return null;
  const resolved = copyResolved(goal, env);
  if (resolved.type !== COMPOUND && resolved.type !== 'atom') return null;
  const group = solver.program.findGroup(resolved.name, resolved.arity, resolved.module ?? 'user');
  if (!group || group.hasCut || group.wfsDatalog) return null;

  if (group.datalogLeastModel === true) {
    const model = solver.datalogModelFor(group);
    const relation = relationForDatalogGroup(model, group);
    return relation?.has(resolved.args ?? []) ?? false;
  }

  if (group.scalarFactsOnly) {
    const candidates = selectGroundClauseCandidates(group, resolved);
    for (let index = 0; index < clauseCandidateLength(candidates); index++) {
      const clause = clauseCandidateAt(candidates, index);
      if (matchGroundClause(resolved, clause)?.done) return true;
    }
    return false;
  }

  if (group.recursive || group.tabled) return null;
  const key = `${group.module}:${group.name}/${group.arity}`;
  if (visiting.has(key)) return null;
  const nextVisiting = new Set(visiting);
  nextVisiting.add(key);

  const candidates = selectGroundClauseCandidates(group, resolved);
  for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(candidates); candidateIndex++) {
    const clause = clauseCandidateAt(candidates, candidateIndex);
    const bindings = new Map();
    let headMatches = true;
    for (let i = 0; i < resolved.arity; i++) {
      const pattern = clause.head.args[i];
      const value = resolved.args[i];
      if (pattern.type === 'var') {
        const previous = bindings.get(pattern.name);
        if (previous == null) bindings.set(pattern.name, value);
        else if (!sameGroundTerm(previous, value)) { headMatches = false; break; }
      } else if (isScalarTerm(pattern)) {
        if (!sameScalarTerm(pattern, value)) { headMatches = false; break; }
      } else {
        return null;
      }
    }
    if (!headMatches) continue;

    let clauseTrue = true;
    for (const body of clause.body) {
      if (body.type !== COMPOUND && body.type !== 'atom') return null;
      const args = [];
      for (const arg of body.args ?? []) {
        if (arg.type === 'var') {
          const value = bindings.get(arg.name);
          if (value == null) return null;
          args.push(value);
        } else if (isScalarTerm(arg)) {
          args.push(arg);
        } else {
          return null;
        }
      }
      const bodyGoal = body.type === 'atom' ? body : compound(body.name, args);
      if (body.module != null) bodyGoal.module = body.module;
      const truth = fastGroundPureGoalTruth(solver, bodyGoal, new Env(), nextVisiting);
      if (truth == null) return null;
      if (!truth) { clauseTrue = false; break; }
    }
    if (clauseTrue) return true;
  }
  return false;
}

function termReferencesResolvedVariable(term, variableName, env) {
  const pending = [term];
  const seen = new Set();
  while (pending.length > 0) {
    const value = derefForLocal(pending.pop(), env);
    if (value.type === 'var') {
      if (value.name === variableName) return true;
      continue;
    }
    if (value.type !== COMPOUND || seen.has(value)) continue;
    seen.add(value);
    for (const arg of value.args) pending.push(arg);
  }
  return false;
}

function envHasObservableAliasTo(variableName, env) {
  for (const [name, value] of env?._bindingEntries?.() ?? []) {
    if (name !== variableName && termReferencesResolvedVariable(value, variableName, env)) return true;
  }
  return false;
}

function* fusedFindallLengthSolutions(solver, innerGoal, countArg, env) {
  const invoked = copyResolved(innerGoal, env);
  if (invoked.type !== COMPOUND && invoked.type !== 'atom') return;
  let count = fastCountPureGoal(solver, invoked, env);
  if (count != null) {
    // findall/3's existing collector intentionally carries a ten-million
    // solution safety cap. Preserve that observable bound in the fused path.
    if (count > 10000000n) count = 10000000n;
  } else {
    const child = solver.cloneForInnerGoal(10000000);
    count = 0n;
    try {
      for (const _ of child.solve([invoked], env.clone(), 0)) count++;
    } finally {
      solver.absorbStatsFrom(child);
    }
  }
  const next = env.clone();
  if (unify(countArg, numberTerm(count), next)) yield next;
}

function findallLengthFusion(solver, goal, rest, env) {
  if (goal.type !== COMPOUND || goal.name !== 'findall' || goal.arity !== 3 || rest.length === 0) return null;
  const bag = derefForLocal(goal.args[2], env);
  if (bag.type !== 'var') return null;

  const lengthGoal = derefForLocal(rest[0], env);
  if (lengthGoal.type !== COMPOUND || lengthGoal.name !== 'length' || lengthGoal.arity !== 2) return null;
  const lengthGroup = solver.program.findGroup('length', 2, lengthGoal.module ?? 'user');
  if (!lengthGroup || lengthGroup.bundledLibrary !== true ||
      lengthGroup.module !== 'lists') return null;
  const lengthList = derefForLocal(lengthGoal.args[0], env);
  const countArg = derefForLocal(lengthGoal.args[1], env);
  if (lengthList.type !== 'var' || lengthList.name !== bag.name || countArg.type !== 'var') return null;
  if (envHasObservableAliasTo(bag.name, env)) return null;

  // The bag may be elided only when no other part of the computation can
  // observe it.  In particular, sharing it with Template or Goal changes
  // findall/3's variable-scoping behavior and must stay on the ordinary path.
  if (termReferencesResolvedVariable(goal.args[0], bag.name, env) ||
      termReferencesResolvedVariable(goal.args[1], bag.name, env) ||
      termReferencesResolvedVariable(lengthGoal.args[1], bag.name, env)) return null;
  for (let i = 1; i < rest.length; i++) {
    if (termReferencesResolvedVariable(rest[i], bag.name, env)) return null;
  }

  return {
    iterator: fusedFindallLengthSolutions(solver, goal.args[1], lengthGoal.args[1], env),
    rest: rest.slice(1),
  };
}

function countPlanTermIsFlat(term) {
  return term?.type === 'var' || isScalarTerm(term);
}

function expandPureCountGoal(solver, goal, callerModule, visiting, budget) {
  if ((goal.type !== COMPOUND && goal.type !== 'atom') ||
      !(goal.args ?? []).every(countPlanTermIsFlat)) return null;
  const group = solver.program.findGroup(goal.name, goal.arity, goal.module ?? callerModule ?? 'user');
  if (!group || group.hasCut || group.recursive || group.tabled || group.wfsDatalog || group.datalogLeastModel) return null;
  if (group.scalarFactsOnly) return [{ equalities: [], leaves: [{ goal, group }] }];

  const key = `${group.module}:${group.name}/${group.arity}`;
  if (visiting.has(key)) return null;
  const nextVisiting = new Set(visiting);
  nextVisiting.add(key);
  const out = [];

  for (const clause of group.clauses) {
    if (budget.remaining-- <= 0) return null;
    const id = nextFreshId();
    const variables = new Map();
    const head = freshTerm(clause.head, `count${id}`, variables);
    const body = clause.body.map((term) => freshTerm(term, `count${id}`, variables));
    if (!(head.args ?? []).every(countPlanTermIsFlat)) return null;
    let branches = [{
      equalities: (goal.args ?? []).map((arg, index) => [arg, head.args[index]]),
      leaves: [],
    }];

    for (const bodyGoal of body) {
      const expanded = expandPureCountGoal(solver, bodyGoal, group.module, nextVisiting, budget);
      if (expanded == null) return null;
      const combined = [];
      for (const left of branches) {
        for (const right of expanded) {
          combined.push({
            equalities: [...left.equalities, ...right.equalities],
            leaves: [...left.leaves, ...right.leaves],
          });
          if (combined.length > 4096) return null;
        }
      }
      branches = combined;
    }
    out.push(...branches);
    if (out.length > 4096) return null;
  }
  return out;
}

function countPlanDeref(term, env, bindings) {
  let current = term;
  const seen = new Set();
  while (current?.type === 'var') {
    if (seen.has(current.name)) break;
    seen.add(current.name);
    const local = bindings.get(current.name);
    if (local !== undefined) {
      current = local;
      continue;
    }
    const outer = env.get(current.name);
    if (outer !== undefined) {
      current = outer;
      continue;
    }
    break;
  }
  return current;
}

function countPlanUnify(left, right, env, bindings, trail) {
  const a = countPlanDeref(left, env, bindings);
  const b = countPlanDeref(right, env, bindings);
  if (a.type === 'var') {
    if (b.type === 'var' && a.name === b.name) return true;
    bindings.set(a.name, b);
    trail.push(a.name);
    return true;
  }
  if (b.type === 'var') {
    bindings.set(b.name, a);
    trail.push(b.name);
    return true;
  }
  return sameScalarTerm(a, b);
}

function undoCountBindings(bindings, trail, start) {
  for (let i = trail.length - 1; i >= start; i--) bindings.delete(trail[i]);
  trail.length = start;
}

function countLeafCandidateParts(leaf, env, bindings) {
  const positions = [];
  const values = [];
  for (let i = 0; i < leaf.goal.arity; i++) {
    const value = countPlanDeref(leaf.goal.args[i], env, bindings);
    if (!isScalarTerm(value)) continue;
    positions.push(i);
    values.push(value);
  }
  return selectClauseCandidatesForValues(leaf.group, positions, values);
}

function countCandidateTotal(parts) {
  return clauseCandidateLength(parts.primary) + clauseCandidateLength(parts.fallback);
}

function fastCountBranch(branch, env) {
  const bindings = new Map();
  const trail = [];
  for (const [left, right] of branch.equalities) {
    if (!countPlanUnify(left, right, env, bindings, trail)) return 0n;
  }

  let numberCount = 0;
  let bigCount = null;
  const increment = () => {
    if (bigCount != null) {
      bigCount++;
    } else if (numberCount < Number.MAX_SAFE_INTEGER) {
      numberCount++;
    } else {
      bigCount = BigInt(numberCount) + 1n;
    }
  };

  const remaining = branch.leaves.map((_, index) => index);
  const visit = (active) => {
    if (active.length === 0) {
      increment();
      return;
    }

    let bestPosition = 0;
    let bestParts = null;
    let bestLength = Infinity;
    for (let position = 0; position < active.length; position++) {
      const leaf = branch.leaves[active[position]];
      const parts = countLeafCandidateParts(leaf, env, bindings);
      const length = countCandidateTotal(parts);
      if (length < bestLength) {
        bestLength = length;
        bestPosition = position;
        bestParts = parts;
        if (length === 0) return;
      }
    }

    const leafIndex = active[bestPosition];
    const leaf = branch.leaves[leafIndex];
    const nextActive = active.length === 1
      ? []
      : [...active.slice(0, bestPosition), ...active.slice(bestPosition + 1)];
    for (const pass of [bestParts.primary, bestParts.fallback]) {
      for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(pass); candidateIndex++) {
        const clause = clauseCandidateAt(pass, candidateIndex);
        const start = trail.length;
        let ok = true;
        for (let i = 0; i < leaf.goal.arity; i++) {
          if (!countPlanUnify(leaf.goal.args[i], clause.head.args[i], env, bindings, trail)) {
            ok = false;
            break;
          }
        }
        if (ok) visit(nextActive);
        undoCountBindings(bindings, trail, start);
      }
    }
  };

  visit(remaining);
  return bigCount ?? BigInt(numberCount);
}

function fastCountPureGoal(solver, goal, env) {
  if (solver.isoStrict || solver.solutionLimit !== Infinity || solver.maxInferences !== Infinity ||
      env._variableConstraints != null || env._prologAttributes != null || (env._delays != null && env._delays.size !== 0)) return null;
  const budget = { remaining: 8192 };
  const branches = expandPureCountGoal(solver, goal, goal.module ?? 'user', new Set(), budget);
  if (branches == null) return null;
  let count = 0n;
  for (const branch of branches) count += fastCountBranch(branch, env);
  return count;
}

function tryPushScalarFactRunFrames(stack, solver, goals, env, depth, active) {
  if (env._prologAttributes != null) return false;
  // Consecutive scalar-fact lookups are common in data-heavy joins.  Short
  // joins are fastest when their continuation frames are materialized locally;
  // wide joins can explode combinatorially, so they are streamed lazily.
  let runLength = 0;
  const groups = [];
  while (runLength < goals.length) {
    const goal = goals[runLength];
    if (!goal || goal.kind === 'releaseActive' || goal.kind === 'memoStore' || goal.kind === 'continueGoals') break;
    if (goal.type !== COMPOUND) break;
    const def = solver.lookupBuiltin(goal.name, goal.arity);
    if (def) break;
    const group = solver.lookupGroup(goal.name, goal.arity, goal.module ?? 'user');
    if (!group || group.tabled || !group.scalarFactsOnly) break;
    groups.push(group);
    runLength++;
  }
  if (runLength < 2) return false;

  const runGoals = goals.slice(0, runLength);
  const rest = goals.slice(runLength);
  if (runLength >= 4) {
    pushStreamingScalarFactRun(stack, solver, runGoals, groups, rest, env, depth, active);
    return true;
  }

  const localStack = [{ index: 0, names: [], values: [], depth }];
  const frames = [];
  const frameLimit = 100000;
  while (localStack.length) {
    const state = localStack.pop();
    solver.stats.max_depth = Math.max(solver.stats.max_depth, state.depth);
    if (state.index === runLength) {
      frames.push({
        kind: 'bindBranch',
        names: state.names,
        values: state.values,
        goals: rest,
        env,
        depth: state.depth,
        active,
      });
      if (frames.length > frameLimit) {
        // Do not repeat the old bug of abandoning the optimization and then
        // re-solving through the generic engine.  Restart this rare oversized
        // short join as a streaming local join instead.
        pushStreamingScalarFactRun(stack, solver, runGoals, groups, rest, env, depth, active);
        return true;
      }
      continue;
    }

    const goal = runGoals[state.index];
    solver.stats.solve_one_goal_calls++;
    const candidates = selectScalarFactCandidates(groups[state.index], goal, env, state.names, state.values);
    const nextStates = [];
    for (const pass of [candidates.primary, candidates.fallback]) {
      for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(pass); candidateIndex++) {
        const clause = clauseCandidateAt(pass, candidateIndex);
        const match = matchScalarFactLocal(goal, clause.head, env, state.names, state.values);
        if (!match) continue;
        solver.stats.unify_calls++;
        nextStates.push({ index: state.index + 1, names: match.names, values: match.values, depth: state.depth + 1 });
      }
    }
    for (let i = nextStates.length - 1; i >= 0; i--) localStack.push(nextStates[i]);
    if (solver.solutionsSeen >= solver.solutionLimit) break;
  }

  for (let i = frames.length - 1; i >= 0; i--) stack.push(frames[i]);
  return true;
}

function pushStreamingScalarFactRun(stack, solver, runGoals, groups, rest, env, depth, active) {
  const iterator = scalarFactRunSolutions(solver, runGoals, groups, env, depth, active);
  const first = iterator.next();
  if (first.done) return;
  pushResumeBuiltinFrame(stack, iterator, rest, depth + runGoals.length, active);
  stack.push({
    kind: 'goals',
    goals: rest,
    env: first.value,
    depth: depth + runGoals.length,
    active,
  });
}

function scalarFactRunSolutions(solver, goals, groups, env, depth, active) {
  const state = { pending: false };
  const iterator = scalarFactRunGenerator(solver, goals, groups, env, depth, active, state);
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}

function* scalarFactRunGenerator(solver, goals, groups, env, depth, active, pendingState) {
  const localStack = [{ index: 0, names: [], values: [] }];
  while (localStack.length) {
    const state = localStack.pop();
    solver.stats.max_depth = Math.max(solver.stats.max_depth, depth + state.index);
    if (state.index === goals.length) {
      const next = env.clone();
      for (let i = 0; i < state.names.length; i++) next.bind(state.names[i], state.values[i]);
      if (next._variableConstraints != null && !next.validateVariableConstraints()) continue;
      pendingState.pending = localStack.length !== 0;
      yield next;
      continue;
    }

    const goal = goals[state.index];
    solver.stats.solve_one_goal_calls++;
    const candidates = selectScalarFactCandidates(groups[state.index], goal, env, state.names, state.values);
    const nextStates = [];
    for (const pass of [candidates.primary, candidates.fallback]) {
      for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(pass); candidateIndex++) {
        const clause = clauseCandidateAt(pass, candidateIndex);
        const match = matchScalarFactLocal(goal, clause.head, env, state.names, state.values);
        if (!match) continue;
        solver.stats.unify_calls++;
        nextStates.push({ index: state.index + 1, names: match.names, values: match.values });
      }
    }
    for (let i = nextStates.length - 1; i >= 0; i--) localStack.push(nextStates[i]);
    if (solver.solutionsSeen >= solver.solutionLimit) return;
  }
  pendingState.pending = false;
}


function activeMightContain(goal, active) {
  if (active.length === 0 || goal.type !== COMPOUND) return false;
  for (const entry of active) {
    const activeGoal = entry.goal;
    if (activeGoal?.type === COMPOUND && activeGoal.name === goal.name && activeGoal.arity === goal.arity) return true;
  }
  return false;
}

function envWithLocal(env, names, values) {
  if (names.length === 0) return env;
  return {
    has(name) { return names.includes(name) || env.has(name); },
    get(name) {
      const index = names.indexOf(name);
      return index >= 0 ? values[index] : env.get(name);
    },
  };
}

function selectScalarFactCandidates(group, goal, env, names, values) {
  const positions = [];
  const boundValues = [];
  for (let i = 0; i < goal.arity; i++) {
    const arg = derefScalarMatch(goal.args[i], env, names, values);
    if (!isScalarTerm(arg)) continue;
    positions.push(i);
    boundValues.push(arg);
  }
  return selectClauseCandidatesForValues(group, positions, boundValues);
}

function matchScalarFactLocal(goal, head, env, names, values) {
  if (goal.type !== COMPOUND || head.type !== COMPOUND) return null;
  if (goal.name !== head.name || goal.arity !== head.arity) return null;

  let nextNames = names;
  let nextValues = values;
  for (let i = 0; i < goal.arity; i++) {
    const factArg = head.args[i];
    const arg = derefScalarMatch(goal.args[i], env, nextNames, nextValues);
    if (arg.type === 'var') {
      if (nextNames === names) {
        nextNames = names.slice();
        nextValues = values.slice();
      }
      nextNames.push(arg.name);
      nextValues.push(factArg);
      continue;
    }
    if (!sameScalarTerm(arg, factArg)) return null;
  }
  return { names: nextNames, values: nextValues };
}

function matchScalarFact(goal, head, env) {
  if (env._prologAttributes != null) {
    const next = env.clone();
    if (!unify(goal, head, next)) return null;
    return next;
  }
  // A scalar ground fact has no variables to freshen and no compound structure
  // to traverse. Match the goal arguments directly and clone only after the
  // candidate has succeeded.
  if (goal.type !== COMPOUND || head.type !== COMPOUND) return null;
  if (goal.name !== head.name || goal.arity !== head.arity) return null;

  const names = [];
  const values = [];
  for (let i = 0; i < goal.arity; i++) {
    const factArg = head.args[i];
    let arg = derefScalarMatch(goal.args[i], env, names, values);
    if (arg.type === 'var') {
      names.push(arg.name);
      values.push(factArg);
      continue;
    }
    if (!sameScalarTerm(arg, factArg)) return null;
  }

  const next = env.clone();
  for (let i = 0; i < names.length; i++) next.bind(names[i], values[i]);
  if (next._variableConstraints != null && !next.validateVariableConstraints()) return null;
  return next;
}

function derefScalarMatch(term, env, names, values) {
  let current = term;
  const seen = new Set();
  while (current?.type === 'var') {
    if (seen.has(current.name)) break;
    seen.add(current.name);
    const localIndex = names.indexOf(current.name);
    if (localIndex >= 0) { current = values[localIndex]; continue; }
    if (env.has(current.name)) { current = env.get(current.name); continue; }
    break;
  }
  return current;
}

function scalarSetContainer() {
  return { atom: new Set(), string: new Set(), number: new Set() };
}

function compactChainCacheFor(solver, group, first) {
  let groupCache = solver.compactChainSuccess.get(group);
  if (!groupCache) {
    groupCache = { atom: new Map(), string: new Map(), number: new Map() };
    solver.compactChainSuccess.set(group, groupCache);
  }
  const byFirstName = groupCache[first.type];
  let cache = byFirstName.get(first.name);
  if (!cache) {
    cache = scalarSetContainer();
    byFirstName.set(first.name, cache);
  }
  return cache;
}

function rememberCompactChainSuccess(cache, seen) {
  for (const type of ['atom', 'string', 'number']) {
    let index = 0;
    const values = seen[type];
    const last = values.size - 1;
    for (const name of values) {
      if ((index & 63) === 0 || index === last) cache[type].add(name);
      index++;
    }
  }
}

function compactIndexBucket(index, type, name) {
  if (type === 'atom') return index.atomBuckets.get(name) ?? null;
  if (type === 'string') return index.stringBuckets.get(name) ?? null;
  if (type === 'number') return index.numberBuckets.get(name) ?? null;
  return null;
}

function tryPushCompactBinaryChainFrames(stack, solver, group, goal, rest, env, depth, active) {
  if (goal.type !== COMPOUND || goal.arity !== 2) return false;
  // This fast path follows deterministic compact binary chains selected by a
  // scalar second argument. In addition to a scalar first argument, accept an
  // unbound first variable when every recursive rule carries that variable
  // through unchanged. The latter is the common taxonomy form p(X,nN) :-
  // p(X,nN-1): it can be walked iteratively and X is bound only by the base
  // fact, avoiding thousands of recursive Env/active-frame allocations.
  const first = derefForLocal(goal.args[0], env);
  const second = derefForLocal(goal.args[1], env);
  const firstScalar = isScalarTerm(first);
  const firstVariable = first?.type === 'var';
  if ((!firstScalar && !firstVariable) || !['atom', 'string', 'number'].includes(second?.type)) return false;
  // Preserve the established cached scalar-chain semantics inside an active
  // invocation. The variable-carry chain below does not use cross-call caches
  // and is safe in an active meta-call because it still checks its own cycles.
  if (firstScalar && active.length !== 0) return false;

  const index = group.argIndexes[1];
  if (!index?.sawScalar || index.fallback.length !== 0) return false;

  if (firstVariable) {
    const seen = scalarSetContainer();
    let secondType = second.type;
    let secondName = second.name;
    let currentDepth = depth;
    while (true) {
      if (solver.solutionsSeen >= solver.solutionLimit) return true;
      solver.stats.max_depth = Math.max(solver.stats.max_depth, currentDepth);
      const seenSet = seen[secondType];
      if (!seenSet) return true;
      if (seenSet.has(secondName)) {
        solver.recursionCycleDetected = true;
        return true;
      }
      seenSet.add(secondName);

      const candidates = compactIndexBucket(index, secondType, secondName);
      if (clauseCandidateLength(candidates) !== 1) return false;
      const clause = clauseCandidateAt(candidates, 0);
      if (clause?.compactBinary !== true || clause.headName !== group.name) return false;
      if (clause.head1Type !== secondType || clause.head1Name !== secondName) return true;

      if (clause.bodyName == null) {
        const next = env.clone();
        // A variable base fact leaves the carried query variable unconstrained;
        // a scalar base fact binds it exactly as ordinary clause unification.
        if (clause.head0Type !== 'var') {
          if (!unify(goal.args[0], clause.head.args[0], next)) return true;
          if (next._variableConstraints != null && !next.validateVariableConstraints()) return true;
        }
        stack.push({ kind: 'goals', goals: rest, env: next, depth: depth + 1, active });
        return true;
      }

      if (clause.bodyName !== group.name || clause.head0Type !== 'var' ||
          clause.body0Type !== 'var' || clause.body0Name !== clause.head0Name ||
          !['atom', 'string', 'number'].includes(clause.body1Type)) return false;

      secondType = clause.body1Type;
      secondName = clause.body1Name;
      currentDepth++;
    }
  }

  let secondType = second.type;
  let secondName = second.name;
  const cache = compactChainCacheFor(solver, group, first);
  const seen = scalarSetContainer();
  let currentDepth = depth;

  while (true) {
    if (solver.solutionsSeen >= solver.solutionLimit) return true;
    solver.stats.max_depth = Math.max(solver.stats.max_depth, currentDepth);
    const seenSet = seen[secondType];
    if (!seenSet) return true;
    if (seenSet.has(secondName)) {
      solver.recursionCycleDetected = true;
      return true;
    }
    if (cache[secondType].has(secondName)) {
      rememberCompactChainSuccess(cache, seen);
      stack.push({ kind: 'goals', goals: rest, env, depth: depth + 1, active });
      return true;
    }
    seenSet.add(secondName);

    const candidates = compactIndexBucket(index, secondType, secondName);
    if (clauseCandidateLength(candidates) !== 1) return false;
    const clause = clauseCandidateAt(candidates, 0);
    if (clause?.compactBinary !== true || clause.headName !== group.name) return false;
    if (clause.head1Type !== secondType || clause.head1Name !== secondName) return true;
    if (clause.head0Type !== 'var' &&
        (clause.head0Type !== first.type || clause.head0Name !== first.name)) return true;

    if (clause.bodyName == null) {
      rememberCompactChainSuccess(cache, seen);
      stack.push({ kind: 'goals', goals: rest, env, depth: depth + 1, active });
      return true;
    }
    if (clause.bodyName !== group.name || clause.head0Type !== 'var' ||
        clause.body0Type !== 'var' || clause.body0Name !== clause.head0Name ||
        !['atom', 'string', 'number'].includes(clause.body1Type)) return false;

    secondType = clause.body1Type;
    secondName = clause.body1Name;
    currentDepth++;
  }
}

function tryPushGroundScalarRuleFrame(stack, solver, group, goal, rest, env, depth, active) {
  // A fully-ground call to a single flat rule can be checked without freshening
  // the rule or allocating an Env for every body literal.  This is especially
  // valuable for data-validation joins such as rb(A,B,C,D,E) in ORB Join2.
  // Reject ineligible rule shapes before recursively resolving the goal. Most
  // library predicates have several clauses, and CLP(Z) calls are commonly
  // large non-ground structures for which that groundness walk is pure cost.
  if (group.clauses.length !== 1) return false;
  const clause = group.clauses[0];
  if (clause?.compactBinary === true || clause.body.length < 2 || clause.head.type !== COMPOUND) return false;
  if (clause.head.name !== goal.name || clause.head.arity !== goal.arity) return false;
  if (!termIsGround(goal, env)) return false;

  const bindings = new Map();
  const resolvedGoal = copyResolved(goal, env);
  for (let i = 0; i < clause.head.arity; i++) {
    const pattern = clause.head.args[i];
    const value = resolvedGoal.args[i];
    if (pattern.type === 'var') {
      const previous = bindings.get(pattern.name);
      if (previous == null) bindings.set(pattern.name, value);
      else if (!sameGroundTerm(previous, value)) return true;
    } else if (isScalarTerm(pattern)) {
      if (!sameGroundTerm(pattern, value)) return true;
    } else {
      return false;
    }
  }

  for (const body of clause.body) {
    if (body.type !== COMPOUND) return false;
    const args = [];
    for (const arg of body.args) {
      if (arg.type === 'var') {
        const value = bindings.get(arg.name);
        if (value == null) return false;
        args.push(value);
      } else if (isScalarTerm(arg)) {
        args.push(arg);
      } else {
        return false;
      }
    }
    const bodyGroup = solver.program.findGroup(body.name, body.arity, body.module ?? group.module);
    if (!bodyGroup || bodyGroup.tabled || !bodyGroup.scalarFactsOnly) return false;
    const bodyGoal = compound(body.name, args);
    const candidates = selectGroundClauseCandidates(bodyGroup, bodyGoal);
    let matches = 0;
    for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(candidates); candidateIndex++) {
      const fact = clauseCandidateAt(candidates, candidateIndex);
      const matched = matchGroundClause(bodyGoal, fact);
      if (matched?.done) {
        matches++;
        if (matches > 1) return false; // Preserve duplicate-proof semantics.
      }
    }
    if (matches === 0) return true;
  }

  stack.push({ kind: 'goals', goals: rest, env, depth: depth + 1, active });
  return true;
}

function tryPushGroundChainFrames(stack, solver, group, goal, rest, env, depth, active) {
  // Explicitly tabled predicates must pass through the table coordinator; do
  // not replace their recursion with the deterministic chain shortcut.
  if (group.tabled) return false;
  if (tryPushCompactBinaryChainFrames(stack, solver, group, goal, rest, env, depth, active)) return true;
  // Compress deterministic ground single-goal chains such as deep taxonomy
  // proofs: a(ind, n100000) -> a(ind, n99999) -> ... -> a(ind, n0).
  // This is a search-control optimization only. It fires only while each step
  // has exactly one matching clause and a single ground body goal; otherwise the
  // normal clause path below remains authoritative.
  // The chain matcher below only propagates variables bound to flat scalar
  // head arguments (or literal scalars). Keep this optimization on that flat
  // domain. Resolving the top-level arguments first proves groundness when all
  // of them are scalars and avoids recursively walking arbitrary CLP(Z) terms
  // only to reject them immediately afterward.
  const resolvedArgs = new Array(goal.arity);
  for (let index = 0; index < goal.arity; index++) {
    const resolved = derefForLocal(goal.args[index], env);
    if (!isScalarTerm(resolved)) return false;
    resolvedArgs[index] = resolved;
  }

  const baseEnv = env;
  let currentGroup = group;
  let currentGoal = compound(goal.name, resolvedArgs);
  let currentDepth = depth;
  const currentEnv = new Env();
  const seen = new Set();

  while (true) {
    // The compressed path is iterative and protected by `seen`, so it does not
    // consume JavaScript recursion depth the way the ordinary solver path does.
    // Keep recording the logical depth for diagnostics, but do not cut off long
    // finite taxonomy chains with the recursive maxDepth guard.
    if (solver.solutionsSeen >= solver.solutionLimit) return true;
    solver.stats.max_depth = Math.max(solver.stats.max_depth, currentDepth);
    const key = groundChainKey(currentGoal);
    if (seen.has(key)) {
      // The shortcut cannot preserve ordinary Prolog's behavior for a cyclic
      // non-tabled chain. Fall back to the generic depth-first engine instead
      // of turning the cycle into failure.
      return false;
    }
    if (solver.groundChainSuccess.has(key)) {
      rememberGroundChainSuccess(solver, seen);
      stack.push({ kind: 'goals', goals: rest, env: baseEnv, depth: depth + 1, active });
      return true;
    }
    seen.add(key);

    const candidates = selectGroundClauseCandidates(currentGroup, currentGoal);
    const matches = [];
    for (const pass of [candidates]) {
      for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(pass); candidateIndex++) {
        const clause = clauseCandidateAt(pass, candidateIndex);
        if (headCannotMatch(currentGoal, clause.head, currentEnv)) continue;
        const match = matchGroundClause(currentGoal, clause);
        if (match === undefined) return false;
        if (match === null) continue;
        matches.push(match);
        if (matches.length > 1) return false;
      }
    }

    if (matches.length !== 1) return false;
    const match = matches[0];
    if (match.done) {
      rememberGroundChainSuccess(solver, seen);
      stack.push({ kind: 'goals', goals: rest, env: baseEnv, depth: depth + 1, active });
      return true;
    }
    const resolvedNextGoal = match.nextGoal;
    const nextGroup = solver.program.findGroup(resolvedNextGoal.name, resolvedNextGoal.arity, resolvedNextGoal.module ?? 'user');
    if (!nextGroup) return false;

    currentGoal = resolvedNextGoal;
    currentGroup = nextGroup;
    currentDepth++;
  }
}





function clauseCandidateLength(candidate) {
  return candidate == null ? 0 : Array.isArray(candidate) ? candidate.length : 1;
}

function clauseCandidateAt(candidate, index) {
  return Array.isArray(candidate) ? candidate[index] : index === 0 ? candidate : undefined;
}

function matchGroundClause(goal, clause) {
  if (clause.head.type !== COMPOUND || goal.type !== COMPOUND) return undefined;
  if (clause.head.name !== goal.name || clause.head.arity !== goal.arity) return null;
  if (goal.arity === 2) return matchGroundBinaryClause(goal, clause);

  const names = [];
  const values = [];
  for (let i = 0; i < goal.arity; i++) {
    const headArg = clause.head.args[i];
    const goalArg = goal.args[i];
    if (headArg.type === 'var') {
      let index = names.indexOf(headArg.name);
      if (index < 0) {
        names.push(headArg.name);
        values.push(goalArg);
      } else if (!sameGroundTerm(values[index], goalArg)) {
        return null;
      }
    } else if (isScalarTerm(headArg)) {
      if (!sameGroundTerm(headArg, goalArg)) return null;
    } else {
      return undefined;
    }
  }

  if (clause.body.length === 0) return { done: true };
  if (clause.body.length !== 1) return undefined;
  const bodyGoal = clause.body[0];
  if (bodyGoal.type !== COMPOUND) return undefined;
  const args = [];
  for (const arg of bodyGoal.args) {
    if (arg.type === 'var') {
      const index = names.indexOf(arg.name);
      if (index < 0) return undefined;
      args.push(values[index]);
    } else if (isScalarTerm(arg)) {
      args.push(arg);
    } else {
      return undefined;
    }
  }
  return { nextGoal: compound(bodyGoal.name, args) };
}

function matchGroundBinaryClause(goal, clause) {
  const headArgs = clause.head.args;
  const goalArgs = goal.args;
  for (let i = 0; i < 2; i++) {
    const headArg = headArgs[i];
    if (headArg.type === 'var') {
      for (let j = 0; j < i; j++) {
        if (headArgs[j].type === 'var' && headArgs[j].name === headArg.name &&
            !sameGroundTerm(goalArgs[j], goalArgs[i])) return null;
      }
    } else if (isScalarTerm(headArg)) {
      if (!sameGroundTerm(headArg, goalArgs[i])) return null;
    } else {
      return undefined;
    }
  }

  if (clause.body.length === 0) return { done: true };
  if (clause.body.length !== 1) return undefined;
  const bodyGoal = clause.body[0];
  if (bodyGoal.type !== COMPOUND) return undefined;
  const bodyArgs = new Array(bodyGoal.arity);
  for (let i = 0; i < bodyGoal.arity; i++) {
    const arg = bodyGoal.args[i];
    if (arg.type === 'var') {
      let found = false;
      for (let j = 0; j < 2; j++) {
        if (headArgs[j].type === 'var' && headArgs[j].name === arg.name) {
          bodyArgs[i] = goalArgs[j];
          found = true;
          break;
        }
      }
      if (!found) return undefined;
    } else if (isScalarTerm(arg)) {
      bodyArgs[i] = arg;
    } else {
      return undefined;
    }
  }
  return { nextGoal: compound(bodyGoal.name, bodyArgs) };
}

// isScalar is imported from term.js; use it as the canonical scalar test.
const isScalarTerm = isScalar;

function sameScalarTerm(left, right) {
  return isScalar(left) && isScalar(right) && left.type === right.type &&
    (left.type === 'number' ? sameNumberValue(left.name, right.name) : left.name === right.name);
}

function sameGroundTerm(left, right) {
  const pending = [[left, right]];
  while (pending.length > 0) {
    const [a, b] = pending.pop();
    if (a?.type !== b?.type) return false;
    if (a?.type === 'number' ? !sameNumberValue(a.name, b.name) : a?.name !== b?.name) return false;
    const arity = a?.args?.length ?? 0;
    if (arity !== (b?.args?.length ?? 0)) return false;
    for (let index = 0; index < arity; index++) pending.push([a.args[index], b.args[index]]);
  }
  return true;
}

function sameResolvedGroundTerm(left, right, env) {
  const pending = [[left, right]];
  while (pending.length > 0) {
    let [a, b] = pending.pop();
    a = derefForLocal(a, env);
    if (a?.type === 'var') return null;
    if (a?.type !== b?.type) return false;
    if (a?.type === 'number' ? !sameNumberValue(a.name, b.name) : a?.name !== b?.name) return false;
    const arity = a?.args?.length ?? 0;
    if (arity !== (b?.args?.length ?? 0)) return false;
    for (let index = 0; index < arity; index++) pending.push([a.args[index], b.args[index]]);
  }
  return true;
}

function groundChainKey(term) {
  if (term?.type === COMPOUND) {
    const parts = [`${term.name}/${term.arity}`];
    for (let i = 0; i < term.arity; i++) parts.push(groundChainKey(term.args[i]));
    return parts.join('');
  }
  return `${term?.type ?? ''}:${term?.name ?? ''}`;
}

function rememberGroundChainSuccess(solver, seen) {
  // Cache a sparse set of checkpoints. This preserves fast reuse of long
  // deterministic chains without retaining every intermediate goal.
  let index = 0;
  const last = seen.size - 1;
  for (const key of seen) {
    if ((index & 63) === 0 || index === last) solver.groundChainSuccess.add(key);
    index++;
  }
}

function rememberMemoAnswer(entry, goal, env) {
  const variables = new Map();
  const answerKeys = [];
  const answerArgs = goal.args.map((arg) => {
    const answer = copyResolvedWithKey(arg, env, variables);
    answerKeys.push(answer.key);
    return answer.term;
  });
  const key = answerKeys.join('\x1f');
  if (entry.answerKeys.has(key)) return;
  entry.answerKeys.add(key);
  const answerIndex = entry.answers.length;
  entry.answers.push(answerArgs);
  for (let position = 0; position < answerArgs.length; position++) {
    const value = answerArgs[position];
    const scalarKey = memoAnswerScalarKey(value);
    if (scalarKey != null) {
      const index = entry.answerIndexes[position];
      let bucket = index.get(scalarKey);
      if (bucket == null) index.set(scalarKey, bucket = []);
      bucket.push(answerIndex);
    } else if (value.type === 'var') {
      entry.answerVariableFallbacks[position].push(answerIndex);
    }
  }
}

function activeTableKeyIn(mapKey, active) {
  for (let index = active.length - 1; index >= 0; index--) {
    if (active[index]?.tableMapKey === mapKey) return true;
  }
  return false;
}

function activeVariantIn(goal, env, active) {
  if (active.length === 0) return false;
  let goalShape = null;
  for (const entry of active) {
    const candidate = entry.goal;
    // Variant calls must have the same predicate indicator. Avoid walking
    // large matrix/list arguments for every unrelated active predicate.
    if (candidate?.type !== goal.type || candidate?.name !== goal.name ||
        candidate?.arity !== goal.arity ||
        (candidate?.module ?? 'user') !== (goal.module ?? 'user')) continue;
    goalShape ??= variantShape(goal, env);
    entry.variantShape ??= variantShape(candidate, entry.env);
    if (goalShape !== entry.variantShape) continue;
    if (variantTerms(goal, env, candidate, entry.env)) return true;
  }
  return false;
}

function variantShape(term, env) {
  if (term?.type !== COMPOUND) return '0';
  return term.args.map((arg) => variantArgumentSize(arg, env)).join(',');
}

const rawProperListLengths = new WeakMap();

function rawProperListLength(term) {
  const compactLength = compactListLength(term);
  if (compactLength != null) return compactLength;
  if (!isCons(term)) return null;
  const cells = [];
  const seen = new WeakSet();
  let cursor = term;
  let suffixLength = 0;
  while (isCons(cursor)) {
    const cached = rawProperListLengths.get(cursor);
    if (cached != null) {
      suffixLength = cached;
      break;
    }
    if (seen.has(cursor)) return null;
    seen.add(cursor);
    cells.push(cursor);
    // Only cache the raw spine. A variable tail may resolve differently in
    // separate environments and therefore needs the general shape walk.
    cursor = cursor.args[1];
  }
  if (!isEmptyList(cursor) && rawProperListLengths.get(cursor) == null) return null;
  for (let index = cells.length - 1; index >= 0; index--) {
    rawProperListLengths.set(cells[index], ++suffixLength);
  }
  return rawProperListLengths.get(term) ?? suffixLength;
}

function variantArgumentSize(term, env) {
  const resolved = derefForLocal(term, env);
  const listLength = rawProperListLength(resolved);
  if (listLength != null) return `list:${listLength}`;
  const pending = [{ term, exit: false }];
  const ancestors = new WeakSet();
  let size = 0;
  while (pending.length > 0) {
    const item = pending.pop();
    if (item.exit) {
      ancestors.delete(item.term);
      continue;
    }
    const current = derefForLocal(item.term, env);
    size++;
    if (current?.type === COMPOUND) {
      // Finite terms get an exact size, which cheaply distinguishes successive
      // tails of a long list. Keep cyclic terms conservative so the exact
      // variant check remains authoritative.
      if (ancestors.has(current)) return '*';
      ancestors.add(current);
      pending.push({ term: current, exit: true });
      for (let index = current.arity - 1; index >= 0; index--) {
        pending.push({ term: current.args[index], exit: false });
      }
    }
  }
  return size;
}


function builtinIsReadyOrAuthoritative(def, solver, goal, env) {
  if (typeof def.shouldUse === 'function' && !def.shouldUse({ solver, goal, env })) return false;
  if (typeof def.ready !== 'function') return true;
  if (def.ready(goal, env)) return true;
  return !def.fallbackWhenNotReady;
}

function iteratorMayHavePendingAlternatives(iterator) {
  const predicate = iterator?.hasPendingAlternatives;
  // An unannotated suspended iterator is itself an untried continuation.
  // Advancing it here would speculatively execute Prolog search (and possibly
  // effects) merely to discover whether a later answer succeeds.
  return typeof predicate !== 'function' || predicate.call(iterator) !== false;
}

function pushResumeBuiltinFrame(stack, iterator, goals, depth, active) {
  if (!iteratorMayHavePendingAlternatives(iterator)) {
    // Finish the suspended generator now so its finally blocks release child
    // solvers, aggregate statistics, and perform predicate-local cleanup.
    iterator.return?.();
    return;
  }
  stack.push({ kind: 'resumeBuiltin', iterator, goals, depth, active });
}

function selectReadyDeterministicBuiltin(goals, env, registry) {
  for (let i = 0; i < goals.length; i++) {
    const goal = goals[i];
    if (goal?.kind === 'releaseActive' || goal?.kind === 'memoStore' || goal?.kind === 'continueGoals') return 0;
    // A first-use proof is derived from source goal order. Do not move a later
    // deterministic builtin across that equality: doing so could touch one of
    // its proven-fresh variables before the checked binding executes.
    if (goal?._knownNonoccurringVariables != null) return 0;
    if (goal.type !== COMPOUND && goal.type !== 'atom') continue;
    const def = registry.get(goal.name, goal.arity);
    if (!def?.deterministic || typeof def.ready !== 'function') continue;
    if (typeof def.shouldUse === 'function') continue;
    if (def.ready(goal, env)) return i;
  }
  return 0;
}

function headCannotMatch(goal, head, env) {
  if (goal.type !== COMPOUND || head.type !== COMPOUND) return false;
  if (goal.name !== head.name || goal.arity !== head.arity) return true;
  for (let i = 0; i < goal.arity; i++) {
    if (goalHeadTermsCannotMatch(goal.args[i], head.args[i], env)) return true;
  }
  return false;
}

function goalHeadTermsCannotMatch(goalTerm, headTerm, env) {
  const pending = [[goalTerm, headTerm]];
  while (pending.length > 0) {
    const [goalItem, headItem] = pending.pop();
    const actual = derefForLocal(goalItem, env);
    if (actual.type === VAR || headItem.type === VAR) continue;
    if (actual.type !== headItem.type || actual.name !== headItem.name || actual.arity !== headItem.arity) return true;
    if (actual.type !== COMPOUND) continue;
    for (let index = 0; index < actual.arity; index++) {
      pending.push([actual.args[index], headItem.args[index]]);
    }
  }
  return false;
}

function derefForLocal(term, env) {
  let current = term;
  while (current.type === 'var') {
    const next = env.get(current.name);
    if (next === undefined) break;
    current = next;
  }
  return current;
}

function memoKey(goal, env, group = null) {
  const required = group?.tableInputPositions ?? [];
  const ground = goal.args.map((arg) => termIsGround(arg, env));
  const hasBound = group?.tableAllVariants === true || (required.length > 0
    ? required.some((index) => ground[index])
    : ground.some(Boolean));
  if (!hasBound) return { hasBound: false, text: '' };

  const variables = new Map();
  const parts = goal.args.map((arg) => canonicalTermKey(arg, env, variables));
  return { hasBound, text: parts.join('|') };
}

function canonicalTermKey(term, env, variables) {
  // Memo keys are needed before deciding whether a recursive call is tabled.
  // Build them iteratively: a perfectly ordinary bound list can be deeper than
  // JavaScript's native call stack even though the solver itself is iterative.
  const key = [];
  const pending = [{ kind: 'term', term }];
  while (pending.length > 0) {
    const item = pending.pop();
    if (item.kind === 'text') {
      key.push(item.text);
      continue;
    }
    const value = derefForLocal(item.term, env);
    if (value.type === 'var') {
      let id = variables.get(value.name);
      if (id == null) {
        id = variables.size;
        variables.set(value.name, id);
      }
      key.push(`var:${id}`);
      continue;
    }
    if (!value.args?.length) {
      key.push(`${value.type}:${value.name}`);
      continue;
    }
    key.push(`${value.type}:${value.name}(`);
    pending.push({ kind: 'text', text: ')' });
    for (let index = value.args.length - 1; index >= 0; index--) {
      if (index < value.args.length - 1) pending.push({ kind: 'text', text: ',' });
      pending.push({ kind: 'term', term: value.args[index] });
    }
  }
  return key.join('');
}

function copyResolvedWithKey(term, env, variables) {
  const value = derefForLocal(term, env);
  if (value.type === 'var') {
    let id = variables.get(value.name);
    if (id == null) {
      id = variables.size;
      variables.set(value.name, id);
    }
    return { term: termModuleCache.variable(value.name), key: `var:${id}` };
  }
  if (!value.args?.length) {
    // Atomic terms are immutable in the solver.  Share them across table
    // answers instead of allocating a fresh host object for every cell of a
    // large closure such as tc/2.
    return { term: value, key: `${value.type}:${value.name}` };
  }
  const children = value.args.map((arg) => copyResolvedWithKey(arg, env, variables));
  return {
    term: termModuleCache.compound(value.name, children.map((child) => child.term)),
    key: `${value.type}:${value.name}(${children.map((child) => child.key).join(',')})`,
  };
}

// Avoid circular import surprises in older Node loaders.
import * as termModuleCache from './term.js';
