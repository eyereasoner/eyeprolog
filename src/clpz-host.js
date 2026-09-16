// Native acceleration for the finite all_distinct subset of library(clpz).
// The public predicates, validation, and general fallbacks remain in clpz.pl;
// these private adapters only replace the expensive matching and search loops
// when the live attributed-variable store is completely understood here.

import {
  ATOM, COMPOUND, NUMBER, VAR, atom, compound, deref, isDecimalInteger,
  numberTerm, properListItems, variable,
} from './term.js';

let distinctStateId = 0;

function qualified(name, args) {
  const goal = compound(name, args);
  goal.module = 'clpz';
  return goal;
}

function conjunction(goals) {
  if (goals.length === 0) return atom('true');
  let result = goals[goals.length - 1];
  for (let index = goals.length - 2; index >= 0; index--) {
    result = compound(',', [goals[index], result]);
  }
  return result;
}

function finiteDomainValues(domain, env, output) {
  const resolved = deref(domain, env);
  if (resolved?.type !== COMPOUND) return false;
  if (resolved.name === 'from_to' && resolved.arity === 2) {
    const lower = deref(resolved.args[0], env);
    const upper = deref(resolved.args[1], env);
    if (lower?.type !== COMPOUND || lower.name !== 'n' || lower.arity !== 1 ||
        upper?.type !== COMPOUND || upper.name !== 'n' || upper.arity !== 1) return false;
    const lowerNumber = deref(lower.args[0], env);
    const upperNumber = deref(upper.args[0], env);
    if (lowerNumber.type !== NUMBER || upperNumber.type !== NUMBER ||
        !isDecimalInteger(lowerNumber.name) || !isDecimalInteger(upperNumber.name)) return false;
    const first = BigInt(lowerNumber.name);
    const last = BigInt(upperNumber.name);
    if (last < first || last - first > 30n) return false;
    for (let value = first; value <= last; value++) output.add(value);
    return true;
  }
  if (resolved.name === 'split' && resolved.arity === 3) {
    return finiteDomainValues(resolved.args[1], env, output) &&
      finiteDomainValues(resolved.args[2], env, output);
  }
  return false;
}

function clpzAttributeFor(name, env) {
  const wrapper = env.getPrologAttribute(name, 'clpz', 'clpz', 1);
  const attribute = wrapper == null ? null : deref(wrapper.args[0], env);
  return attribute?.type === COMPOUND && attribute.name === 'clpz_attr' && attribute.arity === 6
    ? attribute
    : null;
}

function activeClpzPropagators(attribute, env) {
  const props = deref(attribute.args[4], env);
  if (props?.type !== COMPOUND || props.name !== 'fd_props' || props.arity !== 3) return null;
  const result = [];
  for (const list of props.args) {
    const entries = properListItems(list, env);
    if (entries == null) return null;
    for (const entry of entries) {
      const propagator = deref(entry, env);
      if (propagator?.type !== COMPOUND || propagator.name !== 'propagator' || propagator.arity !== 2) {
        return null;
      }
      const state = deref(propagator.args[1], env);
      if (state.type === ATOM && state.name === 'dead') continue;
      const constraint = deref(propagator.args[0], env);
      if (constraint?.type !== COMPOUND || !['pdistinct', 'pexclude'].includes(constraint.name)) {
        return null;
      }
      result.push(constraint);
    }
  }
  return result;
}

function allDistinctMatchingExists(domains, ground, forcedIndex = -1, forcedValue = null) {
  if (forcedIndex >= 0 && (ground.has(forcedValue) || !domains[forcedIndex].includes(forcedValue))) return false;
  const matching = new Map();
  if (forcedIndex >= 0) matching.set(forcedValue, forcedIndex);

  const augment = (variableIndex, seen) => {
    for (const value of domains[variableIndex]) {
      if (ground.has(value) || seen.has(value)) continue;
      seen.add(value);
      const previous = matching.get(value);
      if (previous == null || (previous !== forcedIndex && augment(previous, seen))) {
        matching.set(value, variableIndex);
        return true;
      }
    }
    return false;
  };

  for (let index = 0; index < domains.length; index++) {
    if (index === forcedIndex) continue;
    if (!augment(index, new Set())) return false;
  }
  return true;
}

function distinctExpansion(goal, env) {
  const members = properListItems(goal.args[0], env);
  if (members == null || members.length > 16) return null;
  const variables = [];
  const domains = [];
  const variableNames = new Set();
  const ground = new Set();
  for (const member of members) {
    const value = deref(member, env);
    if (value.type === NUMBER && isDecimalInteger(value.name)) {
      const integer = BigInt(value.name);
      if (ground.has(integer)) return atom('false');
      ground.add(integer);
      continue;
    }
    if (value.type !== VAR || variableNames.has(value.name)) return atom('false');
    const attribute = clpzAttributeFor(value.name, env);
    if (attribute == null) return null;
    const values = new Set();
    if (!finiteDomainValues(attribute.args[3], env, values) || values.size === 0 || values.size > 30) return null;
    variableNames.add(value.name);
    variables.push(value);
    domains.push([...values]);
  }
  if (!allDistinctMatchingExists(domains, ground)) return atom('false');

  const removals = [];
  for (let index = 0; index < variables.length; index++) {
    for (const value of domains[index]) {
      if (ground.has(value) || !allDistinctMatchingExists(domains, ground, index, value)) {
        removals.push([variables[index], value]);
      }
    }
  }
  if (removals.length === 0) return compound('=', [goal.args[1], goal.args[2]]);
  const goals = [];
  let state = goal.args[1];
  for (let index = 0; index < removals.length; index++) {
    const nextState = index + 1 === removals.length
      ? goal.args[2]
      : variable(`__clpz_distinct_state_${++distinctStateId}`);
    goals.push(qualified('neq_num', [removals[index][0], numberTerm(removals[index][1]), state, nextState]));
    state = nextState;
  }
  return conjunction(goals);
}

function finiteAllDistinctModel(items, env) {
  const variableNames = [];
  const variableIndexes = new Map();
  for (const item of items) {
    const value = deref(item, env);
    if (value.type === NUMBER && isDecimalInteger(value.name)) continue;
    if (value.type !== VAR || variableIndexes.has(value.name)) return null;
    variableIndexes.set(value.name, variableNames.length);
    variableNames.push(value.name);
  }
  if (variableNames.length === 0 || env._prologAttributes?.size !== variableNames.length) return null;

  const domainSets = [];
  const constraints = new Map();
  for (const name of variableNames) {
    const modules = env._prologAttributes.get(name);
    if (modules?.size !== 1 || !modules.has('clpz') || modules.get('clpz')?.size !== 1) return null;
    const attribute = clpzAttributeFor(name, env);
    if (attribute == null) return null;
    const values = new Set();
    if (!finiteDomainValues(attribute.args[3], env, values) || values.size === 0) return null;
    domainSets.push(values);
    const propagators = activeClpzPropagators(attribute, env);
    if (propagators == null) return null;
    for (const constraint of propagators) {
      if (constraint.name !== 'pdistinct') continue;
      const members = properListItems(constraint.args[0], env);
      if (members == null) return null;
      const keyParts = [];
      const normalized = [];
      for (const member of members) {
        const value = deref(member, env);
        if (value.type === VAR) {
          const index = variableIndexes.get(value.name);
          if (index == null) return null;
          keyParts.push(`v${index}`);
          normalized.push(index);
        } else if (value.type === NUMBER && isDecimalInteger(value.name)) {
          const integer = BigInt(value.name);
          keyParts.push(`n${integer}`);
          normalized.push(integer);
        } else return null;
      }
      constraints.set(keyParts.join(','), normalized);
    }
  }
  if (constraints.size === 0) return null;
  const universe = [...new Set(domainSets.flatMap((set) => [...set]))].sort((a, b) => a < b ? -1 : a > b ? 1 : 0);
  if (universe.length === 0 || universe.length > 30) return null;
  const bits = new Map(universe.map((value, index) => [value, 2 ** index]));
  const domains = domainSets.map((set) => {
    let mask = 0;
    for (const value of set) mask += bits.get(value);
    return mask;
  });
  const groups = [];
  for (const members of constraints.values()) {
    let groundMask = 0;
    const variables = [];
    const seenVariables = new Set();
    for (const member of members) {
      if (typeof member === 'number') {
        if (seenVariables.has(member)) return null;
        seenVariables.add(member);
        variables.push(member);
      } else {
        const bit = bits.get(member);
        if (bit == null || (groundMask & bit) !== 0) return null;
        groundMask |= bit;
      }
    }
    groups.push({ variables, groundMask });
  }
  return { variableNames, universe, domains, groups };
}

function bitCount(mask) {
  let count = 0;
  while (mask !== 0) {
    mask &= mask - 1;
    count++;
  }
  return count;
}

function allDistinctMaskMatchingExists(domains, group, forcedIndex = -1, forcedBit = 0) {
  if (forcedIndex >= 0 && ((domains[forcedIndex] & forcedBit) === 0 ||
      (group.groundMask & forcedBit) !== 0)) return false;
  const matching = new Map();
  if (forcedIndex >= 0) matching.set(forcedBit, forcedIndex);
  const augment = (variableIndex, seen) => {
    let remaining = domains[variableIndex] & ~group.groundMask;
    while (remaining !== 0) {
      const bit = remaining & -remaining;
      remaining &= ~bit;
      if (seen.has(bit)) continue;
      seen.add(bit);
      const previous = matching.get(bit);
      if (previous == null || (previous !== forcedIndex && augment(previous, seen))) {
        matching.set(bit, variableIndex);
        return true;
      }
    }
    return false;
  };
  for (const index of group.variables) {
    if (index === forcedIndex) continue;
    if (!augment(index, new Set())) return false;
  }
  return true;
}

function propagateAllDistinct(domains, groups) {
  let changed = true;
  while (changed) {
    changed = false;
    for (const group of groups) {
      if (!allDistinctMaskMatchingExists(domains, group)) return false;
      for (const index of group.variables) {
        const domain = domains[index];
        let reduced = domain;
        let remaining = domain;
        while (remaining !== 0) {
          const bit = remaining & -remaining;
          remaining &= ~bit;
          if ((group.groundMask & bit) !== 0 ||
              !allDistinctMaskMatchingExists(domains, group, index, bit)) reduced &= ~bit;
        }
        if (reduced === 0) return false;
        if (reduced !== domain) {
          domains[index] = reduced;
          changed = true;
        }
      }
    }
  }
  return true;
}

function* finiteAllDistinctSearch(solver, model, domains, iterations) {
  if (!propagateAllDistinct(domains, model.groups)) return;
  let selected = -1;
  let selectedSize = Infinity;
  for (let index = 0; index < domains.length; index++) {
    const size = bitCount(domains[index]);
    if (size > 1 && size < selectedSize) {
      selected = index;
      selectedSize = size;
    }
  }
  if (selected < 0) {
    yield domains;
    return;
  }
  if ((++iterations.value & 1023) === 0) solver.checkMemoryLimit(true);
  const bit = domains[selected] & -domains[selected];
  const assigned = domains.slice();
  assigned[selected] = bit;
  yield* finiteAllDistinctSearch(solver, model, assigned, iterations);
  const rejected = domains.slice();
  rejected[selected] &= ~bit;
  yield* finiteAllDistinctSearch(solver, model, rejected, iterations);
}

function* nativeLabeling({ solver, goal, env }) {
  const model = goal._clpzModel;
  for (const solution of finiteAllDistinctSearch(solver, model, model.domains.slice(), { value: 0 })) {
    const next = env.clone();
    next._prologAttributes = null;
    for (let index = 0; index < model.variableNames.length; index++) {
      const valueIndex = 31 - Math.clz32(solution[index]);
      next.bind(model.variableNames[index], numberTerm(model.universe[valueIndex]));
    }
    yield next;
  }
}

function expandLabeling({ solver, goal, env }) {
  const options = properListItems(goal.args[0], env);
  const option = options?.length === 1 ? deref(options[0], env) : null;
  const items = properListItems(goal.args[1], env);
  const model = option?.type === ATOM && option.name === 'ff' && items != null
    ? finiteAllDistinctModel(items, env)
    : null;
  if (model == null) return qualified('labeling_portable', goal.args);
  solver.stats.clpz_native_labelings++;
  const native = compound('eyeprolog__clpz_labeling_native', goal.args);
  native._clpzModel = model;
  return native;
}

function expandDistinct({ solver, goal, env }) {
  const expanded = distinctExpansion(goal, env);
  if (expanded == null) return qualified('distinct_portable', goal.args);
  solver.stats.clpz_native_distinct_propagations++;
  return expanded;
}

function* unreachable() {
  throw new Error('CLP adapter expansion was not applied');
}

export const clpzHostBuiltins = {
  register(registry) {
    registry.add('eyeprolog__clpz_labeling', 2, unreachable, {
      expandGoal: expandLabeling,
      eyePrologLibrary: true,
    });
    registry.add('eyeprolog__clpz_labeling_native', 2, nativeLabeling, { eyePrologLibrary: true });
    registry.add('eyeprolog__clpz_distinct', 3, unreachable, {
      expandGoal: expandDistinct,
      eyePrologLibrary: true,
    });
  },
};
