// Native search-plan construction for library(clpb). Formula construction and
// BDD propagation remain in clpb.pl; this adapter replaces its interpreted
// variable sorting and Boolean enumeration with an equivalent goal tree.

import { COMPOUND, NUMBER, VAR, atom, compound, deref, numberTerm, properListItems } from './term.js';

function conjunction(goals) {
  if (goals.length === 0) return atom('true');
  let result = goals[goals.length - 1];
  for (let index = goals.length - 2; index >= 0; index--) result = compound(',', [goals[index], result]);
  return result;
}

function variableIndex(term, env) {
  const wrapper = env.getPrologAttribute(term.name, 'clpb', 'clpb', 1);
  const attribute = wrapper == null ? null : deref(wrapper.args[0], env);
  if (attribute?.type !== COMPOUND || attribute.name !== 'index_root' || attribute.arity !== 2) return 0n;
  const index = deref(attribute.args[0], env);
  return index.type === NUMBER ? BigInt(index.name) : 0n;
}

function expandLabeling({ solver, goal, env }) {
  const items = properListItems(goal.args[0], env) ?? [];
  const variables = [];
  for (let position = 0; position < items.length; position++) {
    const value = deref(items[position], env);
    if (value.type === VAR) variables.push({ term: value, index: variableIndex(value, env), position });
  }
  variables.sort((left, right) => left.index < right.index ? -1 : left.index > right.index ? 1 : left.position - right.position);
  solver.stats.clpb_native_labelings++;
  return conjunction(variables.map(({ term }) => compound(';', [
    compound('=', [term, numberTerm(0)]),
    compound('=', [term, numberTerm(1)]),
  ])));
}

function* unreachable() {
  throw new Error('CLP adapter expansion was not applied');
}

export const clpbHostBuiltins = {
  register(registry) {
    registry.add('eyeprolog__clpb_labeling', 1, unreachable, {
      expandGoal: expandLabeling,
      eyePrologLibrary: true,
    });
  },
};
