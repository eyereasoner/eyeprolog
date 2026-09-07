// Static program analysis used to classify recursion, Datalog/WFS components,
// structural inputs, and negation strata.  This is build-time analysis: solver
// hot paths consume the resulting group metadata rather than recomputing it.
import { ATOM, COMPOUND, VAR } from './term.js';
import {
  clauseHasCut, compactHeadArgType, isCompactBinaryClause,
} from './program-indexing.js';

export function componentHasNegativeEdge(start, deps, negativeEdges) {
  const forward = reachableIndexes(start, deps);
  // A node is in the same SCC as `start` iff it can also reach `start`.
  // Rather than calling reachableIndexes() per-node (O(n^2)), compute the
  // reverse-reachability set from `start` over the transposed graph once.
  const backward = reachableIndexesTransposed(start, deps, forward);
  const component = new Set([...forward].filter((index) => backward.has(index)));
  return negativeEdges.some(([from, to]) => component.has(from) && component.has(to));
}

function compactClauseIsDirectRecursive(clause, group) {
  return isCompactBinaryClause(clause) && clause.bodyName === group.name && group.arity === 2;
}



function clauseIsDirectRecursive(clause, group) {
  if (isCompactBinaryClause(clause)) return compactClauseIsDirectRecursive(clause, group);
  return clause.body.some((goal) =>
    goal.type === COMPOUND && goal.name === group.name && goal.arity === group.arity
  );
}

export function componentHasCut(start, deps, groups) {
  const forward = reachableIndexes(start, deps);
  const backward = reachableIndexesTransposed(start, deps, forward);
  const component = [...forward].filter((index) => backward.has(index));
  return component.some((index) => {
    const group = groups[index];
    const directRecursive = group.clauses.some((clause) => clauseIsDirectRecursive(clause, group));
    if (!directRecursive) return group.clauses.some(clauseHasCut);
    return group.clauses.some((clause) => clauseIsDirectRecursive(clause, group) && clauseHasCut(clause));
  });
}



export function reachableIndexes(start, deps) {
  const seen = new Set();
  const stack = [start];
  while (stack.length) {
    const current = stack.pop();
    if (seen.has(current)) continue;
    seen.add(current);
    for (const next of deps[current]) if (!seen.has(next)) stack.push(next);
  }
  return seen;
}

// Returns the set of nodes in `candidates` that can reach `target` by
// traversing `deps` in reverse.  This is equivalent to asking which nodes
// in the forward-reachable set from `target` also have `target` in their
// own forward-reachable set, but computed in a single BFS over the
// transposed graph rather than one BFS per candidate node.
function reachableIndexesTransposed(target, deps, candidates) {
  // Build a transposed adjacency list restricted to the candidate set.
  const reverse = new Map();
  for (const from of candidates) {
    if (!reverse.has(from)) reverse.set(from, []);
    const edges = deps[from];
    if (edges == null) continue;
    for (const to of edges) {
      if (!candidates.has(to)) continue;
      let bucket = reverse.get(to);
      if (bucket == null) { bucket = []; reverse.set(to, bucket); }
      bucket.push(from);
    }
  }
  const seen = new Set();
  const stack = [target];
  while (stack.length) {
    const current = stack.pop();
    if (seen.has(current)) continue;
    seen.add(current);
    for (const prev of reverse.get(current) ?? []) if (!seen.has(prev)) stack.push(prev);
  }
  return seen;
}


function isFiniteDatalogArgument(term) {
  return term?.type === VAR || term?.type === ATOM || term?.type === 'string' || term?.type === 'number';
}

export function datalogDependencyClauseCount(program, group, seen = new Set()) {
  if (seen.has(group)) return 0;
  seen.add(group);
  let count = group.clauses.length;
  let compactDependencies = null;
  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) {
      if (clause.bodyName != null) (compactDependencies ??= new Set()).add(clause.bodyName);
      continue;
    }
    for (const goal of clause.body) {
      if (goal.type !== COMPOUND && goal.type !== ATOM) continue;
      const target = program.findGroup(goal.name, goal.arity, goal.module ?? group.module);
      if (target) count += datalogDependencyClauseCount(program, target, seen);
    }
  }
  for (const name of compactDependencies ?? []) {
    const target = program.findGroup(name, 2, group.module);
    if (target) count += datalogDependencyClauseCount(program, target, seen);
  }
  return count;
}

export function isFiniteDatalogGroup(program, group, cache = new Map(), visiting = new Set()) {
  const cached = cache.get(group);
  if (cached != null) return cached;
  if (visiting.has(group)) return true;
  visiting.add(group);
  let finite = true;
  let compactDependencies = null;
  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) {
      if (clause.bodyName != null) (compactDependencies ??= new Set()).add(clause.bodyName);
      continue;
    }
    if (clause.head.type === COMPOUND && !clause.head.args.every(isFiniteDatalogArgument)) { finite = false; break; }
    if (clause.head.type !== COMPOUND && clause.head.type !== ATOM) { finite = false; break; }
    for (const goal of clause.body) {
      if (goal.type !== COMPOUND && goal.type !== ATOM) { finite = false; break; }
      if (goal.type === COMPOUND && !goal.args.every(isFiniteDatalogArgument)) { finite = false; break; }
      // Walk the whole positive dependency cone.  Requiring every reachable
      // predicate to be source-defined and flat excludes builtins/generators
      // that could manufacture an unbounded stream of fresh terms.
      const target = program.findGroup(goal.name, goal.arity, goal.module ?? group.module);
      if (!target || !isFiniteDatalogGroup(program, target, cache, visiting)) { finite = false; break; }
    }
    if (!finite) break;
  }
  if (finite) {
    for (const name of compactDependencies ?? []) {
      const target = program.findGroup(name, 2, group.module);
      if (!target || !isFiniteDatalogGroup(program, target, cache, visiting)) { finite = false; break; }
    }
  }
  visiting.delete(group);
  cache.set(group, finite);
  return finite;
}


export function isRangeRestrictedFiniteDatalogGroup(program, group, cache = new Map(), visiting = new Set()) {
  const cached = cache.get(group);
  if (cached != null) return cached;
  if (visiting.has(group)) return true;
  visiting.add(group);
  let finite = true;

  let compactDependencyResults = null;
  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) {
      const head0Variable = clause.head0Type === VAR;
      const head1Variable = clause.head1Type === VAR;
      if (clause.bodyName == null) {
        if (head0Variable || head1Variable) { finite = false; break; }
        continue;
      }
      const head0RangeRestricted = !head0Variable ||
        (clause.body0Type === VAR && clause.body0Name === clause.head0Name) ||
        (clause.body1Type === VAR && clause.body1Name === clause.head0Name);
      const head1RangeRestricted = !head1Variable ||
        (clause.body0Type === VAR && clause.body0Name === clause.head1Name) ||
        (clause.body1Type === VAR && clause.body1Name === clause.head1Name);
      if (!head0RangeRestricted || !head1RangeRestricted) {
        finite = false;
        break;
      }
      let targetFinite = compactDependencyResults?.get(clause.bodyName);
      if (targetFinite == null) {
        const target = program.findGroup(clause.bodyName, 2, group.module);
        targetFinite = target != null && isRangeRestrictedFiniteDatalogGroup(program, target, cache, visiting);
        (compactDependencyResults ??= new Map()).set(clause.bodyName, targetFinite);
      }
      if (!targetFinite) { finite = false; break; }
      continue;
    }

    const head = clause.head;
    if ((head.type !== COMPOUND && head.type !== ATOM) ||
        (head.type === COMPOUND && !head.args.every(isFiniteDatalogArgument))) {
      finite = false;
      break;
    }

    const headVariables = new Set();
    const positiveVariables = new Set();
    collectVariables(head, headVariables);
    for (const goal of clause.body) {
      if ((goal.type !== COMPOUND && goal.type !== ATOM) ||
          (goal.type === COMPOUND && !goal.args.every(isFiniteDatalogArgument))) {
        finite = false;
        break;
      }
      collectVariables(goal, positiveVariables);
      const target = program.findGroup(goal.name, goal.arity, goal.module ?? group.module);
      if (!target || !isRangeRestrictedFiniteDatalogGroup(program, target, cache, visiting)) {
        finite = false;
        break;
      }
    }
    if (!finite) break;
    for (const name of headVariables) {
      if (!positiveVariables.has(name)) {
        // Ground facts have no head variables and pass naturally. A variable
        // fact or a rule with an unbound head variable needs ordinary Prolog
        // table semantics rather than finite relational materialization.
        finite = false;
        break;
      }
    }
    if (!finite) break;
  }

  visiting.delete(group);
  cache.set(group, finite);
  return finite;
}


export function isFiniteWfsDatalogGroup(program, group, cache = new Map(), visiting = new Set()) {
  const cached = cache.get(group);
  if (cached != null) return cached;
  if (visiting.has(group)) return true;
  visiting.add(group);
  let finite = true;

  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) {
      if (clause.bodyName != null) {
        const target = program.findGroup(clause.bodyName, 2, group.module);
        if (!target || !isFiniteWfsDatalogGroup(program, target, cache, visiting)) { finite = false; break; }
      }
      continue;
    }
    if ((clause.head.type !== COMPOUND && clause.head.type !== ATOM) ||
        (clause.head.type === COMPOUND && !clause.head.args.every(isFiniteDatalogArgument))) {
      finite = false;
      break;
    }

    const positiveVariables = new Set();
    const requiredVariables = new Set();
    collectVariables(clause.head, requiredVariables);
    for (const goal of clause.body) {
      if (goal.type !== COMPOUND && goal.type !== ATOM) { finite = false; break; }
      if (goal.type === COMPOUND && goal.name === 'tnot' && goal.arity === 1) {
        const inner = goal.args[0];
        if ((inner.type !== COMPOUND && inner.type !== ATOM) ||
            (inner.type === COMPOUND && !inner.args.every(isFiniteDatalogArgument))) {
          finite = false;
          break;
        }
        collectVariables(inner, requiredVariables);
        const target = program.findGroup(inner.name, inner.arity, inner.module ?? group.module);
        if (!target || !isFiniteWfsDatalogGroup(program, target, cache, visiting)) { finite = false; break; }
        continue;
      }
      // WFS is explicit. Ordinary \+/1 and not/1 retain NAF and therefore
      // disqualify this component from the WFS evaluator.
      if (goal.type === COMPOUND && (goal.name === '\\+' || goal.name === 'not')) {
        finite = false;
        break;
      }
      if (goal.type === COMPOUND && !goal.args.every(isFiniteDatalogArgument)) { finite = false; break; }
      collectVariables(goal, positiveVariables);
      const target = program.findGroup(goal.name, goal.arity, goal.module ?? group.module);
      if (!target || !isFiniteWfsDatalogGroup(program, target, cache, visiting)) { finite = false; break; }
    }
    if (!finite) break;
    for (const name of requiredVariables) {
      if (!positiveVariables.has(name)) { finite = false; break; }
    }
    if (!finite) break;
  }

  visiting.delete(group);
  cache.set(group, finite);
  return finite;
}

function collectVariables(term, output) {
  if (!term) return;
  if (term.type === VAR) {
    output.add(term.name);
    return;
  }
  for (const arg of term.args ?? []) collectVariables(arg, output);
}

export function inferStructuralInputPositions(group) {
  let firstPatternedPosition = -1;
  let firstLinkedInputPosition = -1;
  const changed = new Uint8Array(group.arity);

  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) {
      if (!compactClauseIsDirectRecursive(clause, group)) continue;
      for (let index = 0; index < 2; index++) {
        const headType = compactHeadArgType(clause, index);
        if (headType !== VAR && (firstPatternedPosition < 0 || index < firstPatternedPosition)) {
          firstPatternedPosition = index;
        }
      }
      continue;
    }

    changed.fill(0);
    let recursive = false;
    for (const goal of clause.body) {
      if (goal.type !== COMPOUND || goal.name !== group.name || goal.arity !== group.arity) continue;
      recursive = true;
      for (let index = 0; index < group.arity; index++) {
        if (!sameClauseTerm(clause.head.args[index], goal.args[index])) changed[index] = 1;
      }
    }
    if (!recursive) continue;

    for (let index = 0; index < group.arity; index++) {
      const headArg = clause.head.args[index];
      if (headArg.type !== 'var' && (firstPatternedPosition < 0 || index < firstPatternedPosition)) firstPatternedPosition = index;
      if (headArg.type !== 'var' || changed[index] === 0) continue;
      for (let patternIndex = 0; patternIndex < group.arity; patternIndex++) {
        if (patternIndex === index) continue;
        const pattern = clause.head.args[patternIndex];
        if (pattern.type !== 'var' && termContainsVariable(pattern, headArg.name)) {
          if (firstLinkedInputPosition < 0 || index < firstLinkedInputPosition) firstLinkedInputPosition = index;
          break;
        }
      }
    }
  }
  if (firstLinkedInputPosition >= 0) return [[firstLinkedInputPosition]];
  if (firstPatternedPosition >= 0) return [[firstPatternedPosition]];
  return Array.from({ length: group.arity }, (_, index) => index);
}

export function hasStrictListTailRecursion(group) {
  let foundRecursiveCall = false;
  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) return false;
    for (let goalIndex = 0; goalIndex < clause.body.length; goalIndex++) {
      const goal = clause.body[goalIndex];
      if (goal.type !== COMPOUND || goal.name !== group.name || goal.arity !== group.arity) continue;
      foundRecursiveCall = true;
      const decreases = goal.args.some((argument, index) => {
        const head = clause.head.args[index];
        if (head?.type === COMPOUND && head.name === '.' && head.arity === 2 &&
            head.args[1]?.type === VAR && argument?.type === VAR &&
            head.args[1].name === argument.name) return true;
        // DCG expansion represents [_], nt as Input = [_|Tail], nt(Tail,...).
        // Treat that normalized prefix unification as the same strict list-tail
        // decrease so phrase/2-3 can choose a non-tabled fast path for new
        // inputs while retaining ordinary tabling for repeated invocations.
        if (head?.type !== VAR || argument?.type !== VAR) return false;
        for (let prefixIndex = 0; prefixIndex < goalIndex; prefixIndex++) {
          const prefix = clause.body[prefixIndex];
          if (prefix?.type !== COMPOUND || prefix.name !== '=' || prefix.arity !== 2) continue;
          for (const [left, right] of [[prefix.args[0], prefix.args[1]], [prefix.args[1], prefix.args[0]]]) {
            if (left?.type !== VAR || left.name !== head.name ||
                right?.type !== COMPOUND || right.name !== '.' || right.arity !== 2 ||
                right.args[1]?.type !== VAR) continue;
            if (right.args[1].name === argument.name) return true;
          }
        }
        return false;
      });
      if (!decreases) return false;
    }
  }
  return foundRecursiveCall;
}

export function hasLinearNumericRecursion(group) {
  let recursiveClause = null;
  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) {
      if (clause.head0Type !== VAR || clause.head1Type !== VAR) return false;
      if (!compactClauseIsDirectRecursive(clause, group)) continue;
      if (recursiveClause) return false;
      recursiveClause = clause;
      continue;
    }
    for (const arg of clause.head.args) if (arg.type !== 'var') return false;
    let recursive = false;
    for (const goal of clause.body) {
      if (goal.type === COMPOUND && goal.name === group.name && goal.arity === group.arity) {
        recursive = true;
        break;
      }
    }
    if (!recursive) continue;
    if (recursiveClause) return false;
    recursiveClause = clause;
  }
  return recursiveClause != null && !isCompactBinaryClause(recursiveClause) && recursiveClause.body.some((goal) =>
    goal.type === COMPOUND && goal.name === 'is' && goal.arity === 2
  );
}

export function isPiAccumulator(group) {
  return group.name === 'pi' && group.arity === 5 && group.clauses.some((clause) =>
    !isCompactBinaryClause(clause) && clause.body.some((goal) => goal.type === COMPOUND && goal.name === 'is' && goal.arity === 2)
  );
}

export function isPortableBetweenGenerator(group) {
  return group.name === 'eyeprolog__between' && group.arity === 3 &&
    group.clauses.length > 0 &&
    group.clauses.every((clause) => clause.eyePrologLibraryPortable === true);
}

function termContainsVariable(term, name) {
  if (term.type === 'var') return term.name === name;
  return term.args.some((arg) => termContainsVariable(arg, name));
}

function sameClauseTerm(left, right) {
  if (left.type !== right.type || left.name !== right.name || left.args.length !== right.args.length) return false;
  return left.args.every((arg, index) => sameClauseTerm(arg, right.args[index]));
}



export function directGoalDependencyKey(goal) {
  if (goal.type === ATOM) return `${goal.name}/0`;
  if (goal.type !== COMPOUND) return null;
  if (goal.name === ',' && goal.arity === 2) return null;
  if ((goal.name === '\\+' || goal.name === 'not' || goal.name === 'tnot') && goal.arity === 1) return null;
  if (goal.name === 'once' && goal.arity === 1) return null;
  if (goal.name === 'forall' && goal.arity === 2) return null;
  if ((goal.name === 'findall' || goal.name === 'sumall') && goal.arity === 3) return null;
  if (goal.name === 'countall' && goal.arity === 2) return null;
  if ((goal.name === 'aggregate_min' || goal.name === 'aggregate_max') && goal.arity === 5) return null;
  return `${goal.name}/${goal.arity}`;
}

// ISO 13211-1, 7.1.6.3: `V1^V2^...^Goal` has the iterated goal Goal.
function iteratedGoal(goal) {
  let current = goal;
  while (current?.type === COMPOUND && current.name === '^' && current.arity === 2) {
    current = current.args[1];
  }
  return current;
}

export function collectGoalDependencies(goal, negated, traverseConditionals = false, wfs = false) {
  if (goal.type === ATOM) return [{ key: `${goal.name}/0`, name: goal.name, arity: 0, module: goal.module, negative: negated, wfs }];
  if (goal.type !== COMPOUND) return [];
  if (goal.name === ',' && goal.arity === 2) {
    return [
      ...collectGoalDependencies(goal.args[0], negated, traverseConditionals, wfs),
      ...collectGoalDependencies(goal.args[1], negated, traverseConditionals, wfs),
    ];
  }
  if (traverseConditionals && (goal.name === ';' || goal.name === '->') && goal.arity === 2) {
    return [
      ...collectGoalDependencies(goal.args[0], negated, true, wfs),
      ...collectGoalDependencies(goal.args[1], negated, true, wfs),
    ];
  }
  if ((goal.name === '\\+' || goal.name === 'not') && goal.arity === 1) {
    return collectGoalDependencies(goal.args[0], !negated, traverseConditionals, wfs);
  }
  if (goal.name === 'tnot' && goal.arity === 1) {
    return collectGoalDependencies(goal.args[0], !negated, traverseConditionals, true);
  }
  if (goal.name === 'once' && goal.arity === 1) {
    return collectGoalDependencies(goal.args[0], negated, traverseConditionals, wfs);
  }
  if (goal.name === 'forall' && goal.arity === 2) {
    return [
      ...collectGoalDependencies(goal.args[0], negated, traverseConditionals, wfs),
      ...collectGoalDependencies(goal.args[1], negated, traverseConditionals, wfs),
    ];
  }
  if ((goal.name === 'findall' || goal.name === 'sumall') && goal.arity === 3) {
    return collectGoalDependencies(goal.args[1], negated, traverseConditionals, wfs);
  }
  if ((goal.name === 'bagof' || goal.name === 'setof') && goal.arity === 3) {
    // The goal argument is an iterated-goal term (ISO 13211-1, 7.1.6.3), so
    // strip its `^` qualifiers before recording the call it really performs.
    return collectGoalDependencies(iteratedGoal(goal.args[1]), negated, traverseConditionals, wfs);
  }
  if (goal.name === 'countall' && goal.arity === 2) {
    return collectGoalDependencies(goal.args[0], negated, traverseConditionals, wfs);
  }
  if ((goal.name === 'aggregate_min' || goal.name === 'aggregate_max') && goal.arity === 5) {
    return collectGoalDependencies(goal.args[2], negated, traverseConditionals, wfs);
  }
  return [{ key: `${goal.name}/${goal.arity}`, name: goal.name, arity: goal.arity, module: goal.module, negative: negated, wfs }];
}

export function stronglyConnectedComponents(adjacency) {
  let index = 0;
  const stack = [];
  const onStack = new Set();
  const indexes = new Map();
  const lowlinks = new Map();
  const components = [];

  function visit(v) {
    indexes.set(v, index);
    lowlinks.set(v, index);
    index++;
    stack.push(v);
    onStack.add(v);

    for (const w of adjacency[v]) {
      if (!indexes.has(w)) {
        visit(w);
        lowlinks.set(v, Math.min(lowlinks.get(v), lowlinks.get(w)));
      } else if (onStack.has(w)) {
        lowlinks.set(v, Math.min(lowlinks.get(v), indexes.get(w)));
      }
    }

    if (lowlinks.get(v) === indexes.get(v)) {
      const component = [];
      while (true) {
        const w = stack.pop();
        onStack.delete(w);
        component.push(w);
        if (w === v) break;
      }
      components.push(component);
    }
  }

  for (let v = 0; v < adjacency.length; v++) {
    if (!indexes.has(v)) visit(v);
  }
  return components;
}

export function computeNegationStrata(groups, edges, indexByKey) {
  const strata = new Map(groups.map((group) => [`${group.name}/${group.arity}`, 0]));
  if (groups.length === 0) return strata;

  for (let pass = 0; pass < groups.length; pass++) {
    let changed = false;
    for (const edge of edges) {
      if (!indexByKey.has(edge.from) || !indexByKey.has(edge.to)) continue;
      const fromStratum = strata.get(edge.from) ?? 0;
      const required = (strata.get(edge.to) ?? 0) + (edge.negative ? 1 : 0);
      if (fromStratum < required) {
        strata.set(edge.from, required);
        changed = true;
      }
    }
    if (!changed) return strata;
  }
  return new Map(groups.map((group) => [`${group.name}/${group.arity}`, null]));
}
