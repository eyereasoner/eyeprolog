// Shared plumbing for the finite positive-Datalog and WFS evaluators.
//
// Keep evaluator-specific relation storage and fixpoint algorithms in their
// own modules; this file only contains representation/traversal helpers whose
// semantics are common to both execution paths.

import { ATOM, COMPOUND, VAR } from './term.js';
import { numberValueKey } from './number-value.js';

export const EMPTY_ARRAY = Object.freeze([]);

export function predicateKey(module, name, arity) {
  return `${module ?? 'user'}:${name}/${arity}`;
}

export function directLiteral(goal, module) {
  if (goal?.type !== COMPOUND && goal?.type !== ATOM) return null;
  return {
    key: predicateKey(goal.module ?? module, goal.name, goal.arity),
    name: goal.name,
    arity: goal.arity,
    module: goal.module ?? module,
    args: goal.args ?? EMPTY_ARRAY,
  };
}

export function dependencyCone(program, rootGroup, literalForGoal = directLiteral) {
  const groups = [];
  const seen = new Set();
  const stack = [rootGroup];
  while (stack.length > 0) {
    const group = stack.pop();
    const key = predicateKey(group.module, group.name, group.arity);
    if (seen.has(key)) continue;
    seen.add(key);
    groups.push(group);
    for (const clause of group.clauses) {
      for (const goal of clause.body) {
        const literal = literalForGoal(goal, group.module);
        if (!literal) continue;
        const target = program.findGroup(literal.name, literal.arity, literal.module);
        if (target) stack.push(target);
      }
    }
  }
  return groups;
}

export function resolvePatternTerm(term, bindings) {
  if (term.type === VAR) return bindings.get(term.name) ?? null;
  return term;
}

export function estimateLiteral(literal, relation, bindings) {
  const candidates = relation.candidateIndexes(literal.args, bindings);
  return candidates == null ? relation.rows.length : candidates.length;
}

// Both evaluators key their row indexes by scalar identity rather than by
// term identity, so `1` and `1.0` stay distinct while two separately parsed
// occurrences of the same constant share a bucket. The cache is keyed on the
// term object and shared by both evaluators, so a term seen first by one is
// already keyed for the other.
const scalarKeyCache = new WeakMap();

export function scalarKey(term) {
  const cached = scalarKeyCache.get(term);
  if (cached != null) return cached;
  const key = term.type === 'number'
    ? `number\u0000${numberValueKey(term.name)}`
    : `${term.type}\u0000${term.name}`;
  scalarKeyCache.set(term, key);
  return key;
}

export function sameScalar(left, right) {
  return scalarKey(left) === scalarKey(right);
}

// Picks the smallest per-argument bucket a literal's already-bound arguments
// can restrict it to, or null when nothing is bound and the caller must scan
// the whole relation. `indexes` is the relation's per-argument Map array.
export function selectCandidateIndexes(indexes, args, bindings) {
  let selected = null;
  for (let i = 0; i < args.length; i++) {
    const value = resolvePatternTerm(args[i], bindings);
    if (value == null) continue;
    const bucket = indexes[i].get(scalarKey(value)) ?? EMPTY_ARRAY;
    if (selected == null || bucket.length < selected.length) selected = bucket;
    if (selected.length === 0) break;
  }
  return selected;
}
