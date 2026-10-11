// User-defined source expansion for the normal EyeProlog profile.
//
// This deliberately sits beside program preparation rather than inside the
// term kernel. A small, fresh Solver executes already-loaded expansion hooks
// against the partially built Program. The solver itself imports clause-index
// helpers directly, so this compiler service does not introduce a module cycle.

import {
  ATOM, COMPOUND, Env, Term, VAR, atom, compound, deref, variable, variantTerms,
} from './term.js';
import { modulePredicateKey } from './program-indexing.js';
import { Solver } from './solver.js';
import { clauseToSourceTerm, sourceTermToClauses } from './expansion-builtins.js';
import { PrologError } from './errors.js';

let expansionFresh = 0;
const MAX_EXPANSION_DEPTH = 64;
const MAX_EXPANSION_INFERENCES = 1_000_000;

function exactHookGroup(program, module, name) {
  return program.groups.get(modulePredicateKey(module, name, 2)) ?? null;
}

function hookModules(module) {
  return module === 'user' ? ['user'] : [module, 'user'];
}

function inputVariableNames(term) {
  const names = new Set();
  const stack = [term];
  const seen = new Set();
  while (stack.length > 0) {
    const current = stack.pop();
    if (current == null || seen.has(current)) continue;
    seen.add(current);
    if (current.type === VAR) {
      names.add(current.name);
      continue;
    }
    if (current.type === COMPOUND) {
      for (const arg of current.args) stack.push(arg);
    }
  }
  return names;
}

function copyHookResult(term, env, inputNames) {
  const rootNames = new Map();
  for (const name of inputNames) {
    const root = deref(variable(name), env);
    if (root.type === VAR && !rootNames.has(root.name)) rootNames.set(root.name, name);
  }
  const copy = (value) => {
    const resolved = deref(value, env);
    if (resolved.type === VAR) return variable(rootNames.get(resolved.name) ?? resolved.name);
    const copied = resolved.type === COMPOUND && resolved.arity === 0
      ? atom(resolved.name)
      : new Term(resolved.type, resolved.name, resolved.args.map(copy));
    if (resolved.module != null) copied.module = resolved.module;
    return copied;
  };
  return copy(term);
}

// Whether some clause of a hook could unify with `input` as its first
// argument. A clause whose first argument has another type, name or arity
// cannot, so when none can the hook does not run at all: a library such as
// CLP(Z) expands only its own goals, and asking a fresh solver about every
// other clause and goal of a program cost more than loading it.
function hookMayApply(group, input) {
  if (input?.type === VAR) return true;
  for (const clause of group.clauses) {
    const first = clause.head?.args?.[0];
    if (first == null || first.type === VAR) return true;
    if (first.type !== input.type || first.name !== input.name) continue;
    if (first.type !== COMPOUND || first.args.length === input.args.length) return true;
  }
  return false;
}

function runHook(program, module, name, input, loadContext = null) {
  for (const owner of hookModules(module)) {
    const group = exactHookGroup(program, owner, name);
    if (group == null || group.clauses.length === 0) continue;
    if (!hookMayApply(group, input)) continue;

    const output = variable(`\u0000source-expansion:${++expansionFresh}`);
    const goal = compound(name, [input, output]);
    goal.module = owner;
    const solver = new Solver(program, {
      solutionLimit: Infinity,
      maxInferences: MAX_EXPANSION_INFERENCES,
      sourceLoadContext: loadContext,
    });
    const inputNames = inputVariableNames(input);
    for (const answer of solver.solve([goal], new Env())) {
      return copyHookResult(output, answer, inputNames);
    }
  }
  return null;
}

function sourceTermsAreVariants(left, right) {
  return variantTerms(left, new Env(), right, new Env());
}

function expandTermRecursively(program, module, term, loadContext, depth) {
  if (depth > MAX_EXPANSION_DEPTH) throw new PrologError('resource_error(source_expansion)');
  const expanded = runHook(program, module, 'term_expansion', term, loadContext);
  if (expanded == null) return sourceTermToClauses(term);

  const clauses = sourceTermToClauses(expanded);
  if (clauses.length === 1 && sourceTermsAreVariants(term, clauseToSourceTerm(clauses[0]))) return clauses;
  const result = [];
  for (const clause of clauses) {
    const generatedTerm = clauseToSourceTerm(clause);
    result.push(...expandTermRecursively(program, module, generatedTerm, loadContext, depth + 1));
  }
  return result;
}

export function expandSourceClause(program, clause, module = 'user', loadContext = null) {
  const sourceTerm = clauseToSourceTerm(clause);
  if (sourceTerm == null) return { expanded: false, clauses: [clause] };
  if (exactHookGroup(program, module, 'term_expansion') == null &&
      (module === 'user' || exactHookGroup(program, 'user', 'term_expansion') == null)) {
    return { expanded: false, clauses: [clause] };
  }
  const first = runHook(program, module, 'term_expansion', sourceTerm, loadContext);
  if (first == null) return { expanded: false, clauses: [clause] };

  const firstClauses = sourceTermToClauses(first);
  if (firstClauses.length === 1 && sourceTermsAreVariants(sourceTerm, clauseToSourceTerm(firstClauses[0]))) {
    return { expanded: false, clauses: [clause] };
  }
  const result = [];
  for (const generated of firstClauses) {
    const generatedTerm = clauseToSourceTerm(generated);
    result.push(...expandTermRecursively(program, module, generatedTerm, loadContext, 1));
  }
  return { expanded: true, clauses: result };
}

function isCallable(term) {
  return term?.type === ATOM || term?.type === COMPOUND;
}

function expandGoalChildren(program, goal, module, loadContext, depth) {
  if (goal.type !== COMPOUND) return goal;

  if (goal.name === ':' && goal.arity === 2) {
    const qualifier = deref(goal.args[0], new Env());
    if (qualifier.type === VAR) return goal;
    if (qualifier.type !== ATOM) return goal;
    const child = expandGoalRecursively(program, goal.args[1], qualifier.name, loadContext, depth + 1);
    return compound(':', [goal.args[0], child]);
  }

  if ([',', ';', '->'].includes(goal.name) && goal.arity === 2) {
    return compound(goal.name, [
      expandGoalRecursively(program, goal.args[0], module, loadContext, depth + 1),
      expandGoalRecursively(program, goal.args[1], module, loadContext, depth + 1),
    ]);
  }
  if (goal.name === '\\+' && goal.arity === 1) {
    return compound('\\+', [expandGoalRecursively(program, goal.args[0], module, loadContext, depth + 1)]);
  }
  return goal;
}

function expandGoalRecursively(program, goal, module, loadContext, depth = 0) {
  if (depth > MAX_EXPANSION_DEPTH) throw new PrologError('resource_error(source_expansion)');
  const resolved = deref(goal, new Env());
  if (!isCallable(resolved)) return resolved;

  const expanded = runHook(program, module, 'goal_expansion', resolved, loadContext);
  if (expanded != null) {
    if (!isCallable(expanded)) throw new PrologError('type_error(callable)', expanded);
    if (sourceTermsAreVariants(resolved, expanded)) return expandGoalChildren(program, resolved, module, loadContext, depth);
    return expandGoalRecursively(program, expanded, module, loadContext, depth + 1);
  }
  return expandGoalChildren(program, resolved, module, loadContext, depth);
}

export function expandClauseGoals(program, clause, lexicalModule = 'user', loadContext = null) {
  if (!Array.isArray(clause.body) || clause.body.length === 0) return clause;
  clause.body = clause.body.map((goal) =>
    expandGoalRecursively(program, goal, lexicalModule, loadContext));
  return clause;
}
