// Indexed semi-naive evaluator for finite, range-restricted positive Datalog.
//
// Program analysis marks only large function-free recursive dependency cones
// for this path.  Rows are derived once and propagated through an agenda; each
// newly-added row fires only the rule occurrences that mention its predicate.
// This avoids replaying the whole recursive program on every table round.

import { VAR } from './term.js';
import { numberValueKey } from './number-value.js';
import {
  EMPTY_ARRAY,
  dependencyCone,
  directLiteral,
  estimateLiteral,
  predicateKey,
  resolvePatternTerm,
} from './datalog-common.js';

const scalarKeyCache = new WeakMap();

function scalarKey(term) {
  const cached = scalarKeyCache.get(term);
  if (cached != null) return cached;
  const key = term.type === 'number'
    ? `number\u0000${numberValueKey(term.name)}`
    : `${term.type}\u0000${term.name}`;
  scalarKeyCache.set(term, key);
  return key;
}

function sameScalar(left, right) {
  return scalarKey(left) === scalarKey(right);
}

class DatalogRelation {
  constructor(arity) {
    this.arity = arity;
    this.rows = [];
    this.keys = arity > 2 ? new Set() : null;
    this.unaryKeys = arity === 1 ? new Set() : null;
    this.binaryKeys = arity === 2 ? new Map() : null;
    this.indexes = Array.from({ length: arity }, () => new Map());
  }

  containsKeys(parts) {
    if (this.arity === 0) return this.rows.length !== 0;
    if (this.arity === 1) return this.unaryKeys.has(parts[0]);
    if (this.arity === 2) return this.binaryKeys.get(parts[0])?.has(parts[1]) === true;
    return this.keys.has(parts.join('\u0001'));
  }

  rememberKeys(parts) {
    if (this.arity === 0) return;
    if (this.arity === 1) {
      this.unaryKeys.add(parts[0]);
      return;
    }
    if (this.arity === 2) {
      let seconds = this.binaryKeys.get(parts[0]);
      if (seconds == null) this.binaryKeys.set(parts[0], seconds = new Set());
      seconds.add(parts[1]);
      return;
    }
    this.keys.add(parts.join('\u0001'));
  }

  add(tuple) {
    const parts = tuple.map(scalarKey);
    if (this.containsKeys(parts)) return false;
    this.rememberKeys(parts);
    this.appendRow(tuple, parts);
    return true;
  }

  addProjected(args, bindings) {
    const tuple = new Array(args.length);
    const parts = new Array(args.length);
    for (let i = 0; i < args.length; i++) {
      const value = args[i].type === VAR ? bindings.get(args[i].name) : args[i];
      if (value == null || value.type === VAR) return null;
      tuple[i] = value;
      parts[i] = scalarKey(value);
    }
    if (this.containsKeys(parts)) return null;
    this.rememberKeys(parts);
    this.appendRow(tuple, parts);
    return tuple;
  }

  appendRow(tuple, parts) {
    const rowIndex = this.rows.length;
    this.rows.push(tuple);
    for (let i = 0; i < tuple.length; i++) {
      let bucket = this.indexes[i].get(parts[i]);
      if (bucket == null) this.indexes[i].set(parts[i], bucket = []);
      bucket.push(rowIndex);
    }
  }

  has(tuple) {
    return this.containsKeys(tuple.map(scalarKey));
  }

  candidateIndexes(args, bindings) {
    let selected = null;
    for (let i = 0; i < args.length; i++) {
      const value = resolvePatternTerm(args[i], bindings);
      if (value == null) continue;
      const bucket = this.indexes[i].get(scalarKey(value)) ?? EMPTY_ARRAY;
      if (selected == null || bucket.length < selected.length) selected = bucket;
      if (selected.length === 0) break;
    }
    return selected;
  }
}


function compileProgram(program, rootGroup) {
  const groups = dependencyCone(program, rootGroup);
  const relations = new Map();
  const rules = [];
  const triggers = new Map();

  for (const group of groups) {
    const key = predicateKey(group.module, group.name, group.arity);
    relations.set(key, new DatalogRelation(group.arity));
  }

  for (const group of groups) {
    const headKey = predicateKey(group.module, group.name, group.arity);
    for (const clause of group.clauses) {
      const headArgs = clause.head.args ?? EMPTY_ARRAY;
      if (clause.body.length === 0) continue;
      const body = clause.body.map((goal) => directLiteral(goal, group.module));
      if (body.some((literal) => literal == null)) continue;
      const rule = { headKey, headArgs, body };
      rules.push(rule);
      for (let index = 0; index < body.length; index++) {
        const key = body[index].key;
        let entries = triggers.get(key);
        if (entries == null) triggers.set(key, entries = []);
        entries.push({ rule, literalIndex: index });
      }
    }
  }

  return { groups, relations, rules, triggers };
}


function matchTupleMutable(args, tuple, bindings) {
  const added = [];
  for (let i = 0; i < args.length; i++) {
    const pattern = args[i];
    if (pattern.type === VAR) {
      const current = bindings.get(pattern.name);
      if (current != null) {
        if (!sameScalar(current, tuple[i])) {
          for (let j = added.length - 1; j >= 0; j--) bindings.delete(added[j]);
          return null;
        }
      } else {
        bindings.set(pattern.name, tuple[i]);
        added.push(pattern.name);
      }
      continue;
    }
    if (!sameScalar(pattern, tuple[i])) {
      for (let j = added.length - 1; j >= 0; j--) bindings.delete(added[j]);
      return null;
    }
  }
  return added;
}

function undoBindings(bindings, added) {
  for (let i = added.length - 1; i >= 0; i--) bindings.delete(added[i]);
}


function forEachBinding(body, relations, callback, bindings, remaining) {
  if (remaining.length === 0) {
    callback(bindings);
    return;
  }

  let bestPosition = 0;
  let bestEstimate = Infinity;
  for (let position = 0; position < remaining.length; position++) {
    const literal = body[remaining[position]];
    const relation = relations.get(literal.key);
    const estimate = relation == null ? 0 : estimateLiteral(literal, relation, bindings);
    if (estimate < bestEstimate) {
      bestEstimate = estimate;
      bestPosition = position;
      if (estimate === 0) return;
    }
  }

  const literalIndex = remaining[bestPosition];
  const literal = body[literalIndex];
  const relation = relations.get(literal.key);
  if (!relation) return;
  const candidates = relation.candidateIndexes(literal.args, bindings);
  const nextRemaining = remaining.length === 1
    ? EMPTY_ARRAY
    : [...remaining.slice(0, bestPosition), ...remaining.slice(bestPosition + 1)];

  if (candidates == null) {
    for (let rowIndex = 0; rowIndex < relation.rows.length; rowIndex++) {
      const added = matchTupleMutable(literal.args, relation.rows[rowIndex], bindings);
      if (added) {
        forEachBinding(body, relations, callback, bindings, nextRemaining);
        undoBindings(bindings, added);
      }
    }
    return;
  }

  for (const rowIndex of candidates) {
    const added = matchTupleMutable(literal.args, relation.rows[rowIndex], bindings);
    if (added) {
      forEachBinding(body, relations, callback, bindings, nextRemaining);
      undoBindings(bindings, added);
    }
  }
}


export function evaluatePositiveDatalog(program, rootGroup) {
  const compiled = compileProgram(program, rootGroup);
  const agenda = [];
  let ruleFirings = 0;
  let derivedFacts = 0;

  const add = (key, tuple) => {
    const relation = compiled.relations.get(key);
    if (!relation || !relation.add(tuple)) return false;
    agenda.push({ key, tuple });
    derivedFacts++;
    return true;
  };

  // Seed all EDB/source facts in the dependency cone. Source order is retained
  // within each predicate relation, which keeps answer enumeration stable.
  for (const group of compiled.groups) {
    const key = predicateKey(group.module, group.name, group.arity);
    for (const clause of group.clauses) {
      if (clause.body.length !== 0) continue;
      const tuple = clause.head.args ?? EMPTY_ARRAY;
      if (tuple.every((term) => term.type !== VAR)) add(key, tuple);
    }
  }

  for (let cursor = 0; cursor < agenda.length; cursor++) {
    const event = agenda[cursor];
    const triggerEntries = compiled.triggers.get(event.key) ?? EMPTY_ARRAY;
    for (const { rule, literalIndex } of triggerEntries) {
      const fixed = rule.body[literalIndex];
      const bindings = new Map();
      if (!matchTupleMutable(fixed.args, event.tuple, bindings)) continue;
      const remaining = [];
      for (let i = 0; i < rule.body.length; i++) if (i !== literalIndex) remaining.push(i);
      ruleFirings++;
      forEachBinding(rule.body, compiled.relations, (completeBindings) => {
        const relation = compiled.relations.get(rule.headKey);
        const tuple = relation?.addProjected(rule.headArgs, completeBindings) ?? null;
        if (tuple != null) {
          agenda.push({ key: rule.headKey, tuple });
          derivedFacts++;
        }
      }, bindings, remaining);
    }
  }

  return {
    relations: compiled.relations,
    groups: compiled.groups,
    ruleFirings,
    derivedFacts,
  };
}

export function relationForDatalogGroup(model, group) {
  return model.relations.get(predicateKey(group.module, group.name, group.arity)) ?? null;
}

export function datalogCandidateIndexes(relation, goalArgs, env, derefValue, scalarKeyForTerm) {
  let selected = null;
  for (let i = 0; i < goalArgs.length; i++) {
    const value = derefValue(goalArgs[i], env);
    if (value?.type !== 'atom' && value?.type !== 'string' && value?.type !== 'number') continue;
    const key = scalarKeyForTerm ? scalarKeyForTerm(value) : scalarKey(value);
    const bucket = relation.indexes[i].get(key) ?? EMPTY_ARRAY;
    if (selected == null || bucket.length < selected.length) selected = bucket;
    if (selected.length === 0) break;
  }
  return selected;
}
