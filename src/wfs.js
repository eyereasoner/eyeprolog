// Finite Datalog well-founded semantics (WFS) evaluator.
//
// This module deliberately targets the function-free, range-restricted subset
// marked by Program#markRecursivePredicates as group.wfsDatalog.  It uses the
// alternating-fixpoint characterization of WFS: starting from an upper bound on
// possible atoms, repeatedly compute the least model of the Gelfond-Lifschitz
// reduct.  The final lower relation contains unconditional truths; the final
// upper relation contains truths plus undefined (conditional) answers.
//
// Keeping this separate from ordinary \+/1 is intentional.  Only explicit
// tnot/1 participates in WFS, matching the common tabled-negation convention.

import { ATOM, COMPOUND, VAR } from './term.js';
import {
  EMPTY_ARRAY,
  dependencyCone,
  directLiteral,
  estimateLiteral,
  predicateKey,
  sameScalar,
  scalarKey,
  selectCandidateIndexes,
} from './datalog-common.js';

function tupleKey(tuple) {
  return tuple.map(scalarKey).join('\u0001');
}

class Relation {
  constructor(arity) {
    this.arity = arity;
    this.rows = [];
    this.keys = new Set();
    this.indexes = Array.from({ length: arity }, () => new Map());
  }

  add(tuple) {
    const key = tupleKey(tuple);
    if (this.keys.has(key)) return false;
    const rowIndex = this.rows.length;
    this.keys.add(key);
    this.rows.push(tuple);
    for (let i = 0; i < tuple.length; i++) {
      const keyPart = scalarKey(tuple[i]);
      let bucket = this.indexes[i].get(keyPart);
      if (!bucket) {
        bucket = [];
        this.indexes[i].set(keyPart, bucket);
      }
      bucket.push(rowIndex);
    }
    return true;
  }

  has(tuple) {
    return this.keys.has(tupleKey(tuple));
  }

  candidateIndexes(args, bindings) {
    return selectCandidateIndexes(this.indexes, args, bindings);
  }
}

function emptyRelations(groups) {
  const relations = new Map();
  for (const group of groups) {
    relations.set(predicateKey(group.module, group.name, group.arity), new Relation(group.arity));
  }
  return relations;
}

function copyBaseRelations(base, groups) {
  const relations = emptyRelations(groups);
  for (const [key, relation] of base) {
    const target = relations.get(key);
    if (!target) continue;
    for (const row of relation.rows) target.add(row);
  }
  return relations;
}


function negativeLiteral(goal, module) {
  if (goal?.type !== COMPOUND || goal.name !== 'tnot' || goal.arity !== 1) return null;
  return directLiteral(goal.args[0], module);
}

function dependencyLiteral(goal, module) {
  return negativeLiteral(goal, module) ?? directLiteral(goal, module);
}

function compileProgram(program, rootGroup) {
  const groups = dependencyCone(program, rootGroup, dependencyLiteral);
  const base = emptyRelations(groups);
  const rules = [];

  for (const group of groups) {
    const headKey = predicateKey(group.module, group.name, group.arity);
    for (const clause of group.clauses) {
      if (clause.body.length === 0) {
        const tuple = clause.head.args ?? EMPTY_ARRAY;
        // Program analysis already guarantees ground scalar facts in the WFS
        // cone. Keep the guard so malformed dynamic input cannot corrupt a model.
        if (tuple.every((term) => term.type !== VAR && (term.type === ATOM || term.type === 'number' || term.type === 'string'))) {
          base.get(headKey)?.add(tuple);
        }
        continue;
      }

      const positives = [];
      const negatives = [];
      for (const goal of clause.body) {
        const neg = negativeLiteral(goal, group.module);
        if (neg) negatives.push(neg);
        else {
          const pos = directLiteral(goal, group.module);
          if (pos) positives.push(pos);
        }
      }
      rules.push({
        head: {
          key: headKey,
          args: clause.head.args ?? EMPTY_ARRAY,
        },
        positives,
        negatives,
      });
    }
  }

  return { groups, base, rules };
}


function matchTuple(args, tuple, bindings) {
  let next = null;
  for (let i = 0; i < args.length; i++) {
    const pattern = args[i];
    if (pattern.type === VAR) {
      const current = (next ?? bindings).get(pattern.name);
      if (current != null) {
        if (!sameScalar(current, tuple[i])) return null;
      } else {
        if (next == null) next = new Map(bindings);
        next.set(pattern.name, tuple[i]);
      }
      continue;
    }
    if (!sameScalar(pattern, tuple[i])) return null;
  }
  return next ?? bindings;
}


function forEachPositiveBinding(positives, relations, callback, bindings = new Map(), remaining = null) {
  if (remaining == null) remaining = positives.map((_, index) => index);
  if (remaining.length === 0) {
    callback(bindings);
    return;
  }

  let bestPos = 0;
  let bestEstimate = Infinity;
  for (let position = 0; position < remaining.length; position++) {
    const literal = positives[remaining[position]];
    const relation = relations.get(literal.key);
    const estimate = relation ? estimateLiteral(literal, relation, bindings) : 0;
    if (estimate < bestEstimate) {
      bestEstimate = estimate;
      bestPos = position;
      if (estimate === 0) return;
    }
  }

  const literalIndex = remaining[bestPos];
  const literal = positives[literalIndex];
  const relation = relations.get(literal.key);
  if (!relation) return;
  const candidates = relation.candidateIndexes(literal.args, bindings);
  const nextRemaining = remaining.length === 1
    ? EMPTY_ARRAY
    : [...remaining.slice(0, bestPos), ...remaining.slice(bestPos + 1)];

  if (candidates == null) {
    for (let rowIndex = 0; rowIndex < relation.rows.length; rowIndex++) {
      const next = matchTuple(literal.args, relation.rows[rowIndex], bindings);
      if (next) forEachPositiveBinding(positives, relations, callback, next, nextRemaining);
    }
    return;
  }
  for (const rowIndex of candidates) {
    const next = matchTuple(literal.args, relation.rows[rowIndex], bindings);
    if (next) forEachPositiveBinding(positives, relations, callback, next, nextRemaining);
  }
}

function instantiateTuple(args, bindings) {
  const tuple = [];
  for (const arg of args) {
    const value = arg.type === VAR ? bindings.get(arg.name) : arg;
    if (value == null || value.type === VAR) return null;
    tuple.push(value);
  }
  return tuple;
}

function blockedByNegative(negatives, blockerRelations, bindings) {
  if (!blockerRelations) return false;
  for (const literal of negatives) {
    const relation = blockerRelations.get(literal.key);
    if (!relation) continue;
    const tuple = instantiateTuple(literal.args, bindings);
    if (tuple == null) return true; // range restriction should make this unreachable
    if (relation.has(tuple)) return true;
  }
  return false;
}

function gamma(compiled, blockerRelations = null) {
  const relations = copyBaseRelations(compiled.base, compiled.groups);
  let changed = true;
  while (changed) {
    changed = false;
    for (const rule of compiled.rules) {
      const headRelation = relations.get(rule.head.key);
      if (!headRelation) continue;
      forEachPositiveBinding(rule.positives, relations, (bindings) => {
        if (blockedByNegative(rule.negatives, blockerRelations, bindings)) return;
        const tuple = instantiateTuple(rule.head.args, bindings);
        if (tuple != null && headRelation.add(tuple)) changed = true;
      });
    }
  }
  return relations;
}

function relationSetsEqual(left, right) {
  if (left.size !== right.size) return false;
  for (const [key, leftRelation] of left) {
    const rightRelation = right.get(key);
    if (!rightRelation || leftRelation.keys.size !== rightRelation.keys.size) return false;
    for (const tuple of leftRelation.keys) if (!rightRelation.keys.has(tuple)) return false;
  }
  return true;
}

export function evaluateWfs(program, rootGroup) {
  const compiled = compileProgram(program, rootGroup);

  // Positive closure with tnot erased is an upper bound on every atom that can
  // participate in the WFS model, avoiding construction of the full Herbrand
  // cross product for predicates of arity > 1.
  let upper = gamma(compiled, null);
  let lower = emptyRelations(compiled.groups);
  let rounds = 0;

  while (true) {
    rounds++;
    const nextLower = gamma(compiled, upper);
    const nextUpper = gamma(compiled, nextLower);
    if (relationSetsEqual(lower, nextLower) && relationSetsEqual(upper, nextUpper)) {
      lower = nextLower;
      upper = nextUpper;
      break;
    }
    lower = nextLower;
    upper = nextUpper;
  }

  return { lower, upper, rounds, groups: compiled.groups };
}

export function relationForGroup(model, group, kind = 'upper') {
  const relations = kind === 'lower' ? model.lower : model.upper;
  return relations.get(predicateKey(group.module, group.name, group.arity)) ?? null;
}

export function truthOfGroundGoal(model, goal) {
  const key = predicateKey(goal.module ?? 'user', goal.name, goal.arity);
  const tuple = goal.args ?? EMPTY_ARRAY;
  const lower = model.lower.get(key);
  if (lower?.has(tuple)) return 'true';
  const upper = model.upper.get(key);
  if (upper?.has(tuple)) return 'undefined';
  return 'false';
}
