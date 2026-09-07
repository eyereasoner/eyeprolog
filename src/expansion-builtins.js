// Generic source-expansion helpers exposed to Prolog code.
//
// expand_term/2 provides the system part of source expansion that libraries
// such as Scryer's CLP(Z) use while generating predicates. User-defined
// term_expansion/2 and goal_expansion/2 are invoked by program preparation in
// source-expansion.js; keeping this builtin independent of Solver avoids an
// import cycle through the standard-library registry.

import {
  ATOM, COMPOUND, Env, atom, compound, copyResolved, deref, flattenConjunction, unify,
} from './term.js';
import { expandDcgRuleClause } from './dcg.js';
import { PrologError } from './errors.js';

function conjunctionFromGoals(goals) {
  if (goals.length === 0) return atom('true');
  let body = goals[goals.length - 1];
  for (let index = goals.length - 2; index >= 0; index--) {
    body = compound(',', [goals[index], body]);
  }
  return body;
}

export function clauseToSourceTerm(clause) {
  if (clause == null || clause.kind === 'quad') return null;
  if (!Array.isArray(clause.body) || clause.body.length === 0) return clause.head;
  return compound(':-', [clause.head, conjunctionFromGoals(clause.body)]);
}

export function sourceTermToClauses(term, env = new Env()) {
  term = deref(term, env);
  const list = sourceTermList(term, env);
  if (list != null) {
    const clauses = [];
    for (const item of list) clauses.push(...sourceTermToClauses(item, env));
    return clauses;
  }
  if (term.type === COMPOUND && term.name === ':-' && term.arity === 2) {
    const head = deref(term.args[0], env);
    const body = deref(term.args[1], env);
    return [{ head, body: body.type === ATOM && body.name === 'true' ? [] : flattenConjunction(body) }];
  }
  if (term.type === COMPOUND && term.name === ':-' && term.arity === 1) {
    return [{ head: term, body: [] }];
  }
  if (term.type === COMPOUND && term.name === '?-' && term.arity >= 1) {
    return [{ head: term, body: [] }];
  }
  if (term.type !== ATOM && term.type !== COMPOUND) {
    throw new PrologError('type_error(callable)', term);
  }
  return [{ head: term, body: [] }];
}

function sourceTermList(term, env) {
  const items = [];
  const seen = new Set();
  let cursor = deref(term, env);
  while (cursor.type === COMPOUND && cursor.name === '.' && cursor.arity === 2) {
    if (seen.has(cursor)) throw new PrologError('type_error(list)', term);
    seen.add(cursor);
    items.push(deref(cursor.args[0], env));
    cursor = deref(cursor.args[1], env);
  }
  if (cursor.type === ATOM && cursor.name === '[]') return items;
  return null;
}

function systemExpandTerm(term, module = 'user') {
  const resolved = deref(term, new Env());
  if (resolved.type === COMPOUND && resolved.name === '-->' && resolved.arity === 2) {
    const expanded = expandDcgRuleClause({ head: resolved, body: [] }, module);
    if (expanded == null) return resolved;
    return clauseToSourceTerm(expanded);
  }
  return resolved;
}

function* expandTermBuiltin({ goal, env }) {
  const input = deref(goal.args[0], env);
  if (input.type === 'var') throw new PrologError('instantiation_error');
  // expand_term/2 operates on the current logical value of the whole term.
  // Resolve nested variable bindings as well as the outer term so generated
  // DCG heads/bodies passed through local variables are seen instantiated.
  const expanded = systemExpandTerm(copyResolved(input, env), goal.module ?? 'user');
  const next = env.clone();
  if (unify(goal.args[1], expanded, next)) yield next;
}

function* expandGoalBuiltin({ goal, env }) {
  const input = deref(goal.args[0], env);
  if (input.type === 'var') throw new PrologError('instantiation_error');
  const next = env.clone();
  if (unify(goal.args[1], input, next)) yield next;
}

export const expansionBuiltins = {
  register(registry) {
    registry.add('expand_term', 2, expandTermBuiltin, { deterministic: true, eyePrologLibrary: true });
    registry.add('expand_goal', 2, expandGoalBuiltin, { deterministic: true, eyePrologLibrary: true });
  },
};
