// ISO/IEC 13211-1:1995 core built-ins, including Technical Corrigenda 1-3.
import {
  ATOM, COMPOUND, NUMBER, STRING, VAR, Env,
  atom, compareTerms, compound, copyResolved, deref, emptyList,
  isDecimalInteger, listFromItems, numberTerm, numberTextFromDouble,
  properListItems, termIsGround, termToString, unify, variable, variantTerms,
} from './term.js';
import { sameNumberValue } from './number-value.js';
import {
  NumberRepresentationError, createParserOperatorState, floatRepresentationErrorFormal,
  parseGoalText, parseNumberTokenText, parseTermText,
} from './parser.js';
import { formatTermForWrite } from './write.js';
import { emptyTerminalSequence, expandDcgBody, isListOrPartialList, validateDcgEmbeddedGoals } from './dcg.js';
import { INVALID_UTF8_SENTINEL } from './io.js';
import { CharacterRepresentationError, isStrictIsoPcsCharacter, isStrictIsoPcsCodePoint } from './iso-character.js';
import { ISO_MAX_ARITY } from './iso-limits.js';
import {
  characterCodeConstantEnd, continuesGraphicToken, isTerminatingFullStop, quotedEscapeEnd,
} from './syntax-scan.js';

let isoFresh = 0;

export { PrologError, HaltSignal } from './errors.js';
import { PrologError, HaltSignal } from './errors.js';

class ThrownTerm extends Error {
  constructor(term) {
    super(`uncaught exception: ${termToString(term)}`);
    this.name = 'ThrownTerm';
    this.term = term;
  }
}

const succeed = function* ({ env }) { yield env; };
const fail = function* () {};

export const isoBuiltins = {
  register(registry) {
    registry.add('true', 0, succeed, { deterministic: true });
    registry.add('fail', 0, fail, { deterministic: true });
    registry.add('false', 0, fail, { deterministic: true });
    registry.add('!', 0, succeed, { deterministic: true });

    registry.add('=', 2, unification, { deterministic: true });
    registry.add('unify_with_occurs_check', 2, unificationWithOccursCheck, { deterministic: true });
    registry.add('\\=', 2, nonUnification, { deterministic: true });
    registry.add('subsumes_term', 2, subsumesTermBuiltin, { deterministic: true });
    registry.add('==', 2, identity, { deterministic: true });
    registry.add('\\==', 2, nonIdentity, { deterministic: true });

    for (const [name, test] of Object.entries(typeTests)) {
      registry.add(name, 1, test, { deterministic: true });
    }
    registry.add('compare', 3, compareBuiltin, { deterministic: true });
    registry.add('@<', 2, orderBuiltin((n) => n < 0), { deterministic: true });
    registry.add('@=<', 2, orderBuiltin((n) => n <= 0), { deterministic: true });
    registry.add('@>', 2, orderBuiltin((n) => n > 0), { deterministic: true });
    registry.add('@>=', 2, orderBuiltin((n) => n >= 0), { deterministic: true });
    registry.add('sort', 2, sortBuiltin, { deterministic: true });
    registry.add('keysort', 2, keysortBuiltin, { deterministic: true });

    registry.add('functor', 3, functorBuiltin, { deterministic: true });
    registry.add('arg', 3, argBuiltin, { deterministic: true });
    registry.add('=..', 2, univBuiltin, { deterministic: true });
    registry.add('copy_term', 2, copyTermBuiltin, { deterministic: true });
    registry.add('term_variables', 2, termVariablesBuiltin, { deterministic: true });
    registry.add('findall', 3, findallBuiltin, { deterministic: true });
    registry.add('bagof', 3, bagofBuiltin, { deterministicWhen: allSolutionsHasAtMostOneGroup });
    registry.add('setof', 3, setofBuiltin, { deterministicWhen: allSolutionsHasAtMostOneGroup });
    registry.add('clause', 2, clauseBuiltin, {
      shouldUse: ({ solver }) => solver.program.findGroup('clause', 2) == null,
    });
    registry.add('asserta', 1, assertBuiltin(true), { deterministic: true });
    registry.add('assertz', 1, assertBuiltin(false), { deterministic: true });
    registry.add('retract', 1, retractBuiltin);
    registry.add('retractall', 1, retractAllBuiltin, { deterministic: true });
    registry.add('abolish', 1, abolishBuiltin, { deterministic: true });
    registry.add('current_predicate', 1, currentPredicateBuiltin);
    registry.add('current_prolog_flag', 2, currentPrologFlagBuiltin);
    registry.add('set_prolog_flag', 2, setPrologFlagBuiltin, { deterministic: true });
    registry.add('op', 3, opBuiltin, {
      deterministic: true,
      shouldUse: ({ solver }) => solver.program.findGroup('op', 3) == null,
    });
    registry.add('current_op', 3, currentOpBuiltin);
    registry.add('char_conversion', 2, charConversionBuiltin, { deterministic: true });
    registry.add('current_char_conversion', 2, currentCharConversionBuiltin);
    registry.add('halt', 0, haltBuiltin, { deterministic: true });
    registry.add('halt', 1, haltBuiltin, { deterministic: true });

    registry.add('open', 3, openBuiltin, { deterministic: true });
    registry.add('open', 4, openBuiltin, { deterministic: true });
    registry.add('close', 1, closeBuiltin, { deterministic: true });
    registry.add('close', 2, closeBuiltin, { deterministic: true });
    registry.add('current_input', 1, currentInputBuiltin, { deterministic: true });
    registry.add('current_output', 1, currentOutputBuiltin, { deterministic: true });
    registry.add('set_input', 1, setCurrentStreamBuiltin('read'), { deterministic: true });
    registry.add('set_output', 1, setCurrentStreamBuiltin('write'), { deterministic: true });
    registry.add('flush_output', 0, flushOutputBuiltin, { deterministic: true });
    registry.add('flush_output', 1, flushOutputBuiltin, { deterministic: true });
    registry.add('stream_property', 2, streamPropertyBuiltin);
    registry.add('set_stream_position', 2, setStreamPositionBuiltin, { deterministic: true });
    registry.add('at_end_of_stream', 0, atEndBuiltin, { deterministic: true });
    registry.add('at_end_of_stream', 1, atEndBuiltin, { deterministic: true });
    for (const name of ['get_char', 'peek_char', 'get_code', 'peek_code', 'get_byte', 'peek_byte']) {
      registry.add(name, 1, inputUnitBuiltin(name), { deterministic: true });
      registry.add(name, 2, inputUnitBuiltin(name), { deterministic: true });
    }
    for (const name of ['put_char', 'put_code', 'put_byte']) {
      registry.add(name, 1, outputUnitBuiltin(name), { deterministic: true });
      registry.add(name, 2, outputUnitBuiltin(name), { deterministic: true });
    }
    registry.add('nl', 0, nlBuiltin, { deterministic: true });
    registry.add('nl', 1, nlBuiltin, { deterministic: true });
    registry.add('read', 1, readBuiltin, { deterministic: true });
    registry.add('read', 2, readBuiltin, { deterministic: true });
    registry.add('read_term', 2, readTermBuiltin, { deterministic: true });
    registry.add('read_term', 3, readTermBuiltin, { deterministic: true });
    for (const [name, mode] of [
      ['write', 'write'],
      ['writeq', 'writeq'],
      ['write_canonical', 'canonical'],
    ]) {
      registry.add(name, 1, writeBuiltin(mode), { deterministic: true });
      registry.add(name, 2, writeBuiltin(mode), { deterministic: true });
    }
    registry.add('write_term', 2, writeTermBuiltin, { deterministic: true });
    registry.add('write_term', 3, writeTermBuiltin, { deterministic: true });

    registry.add('atom_length', 2, atomLengthBuiltin, { deterministic: true });
    registry.add('atom_concat', 3, atomConcatBuiltin);
    registry.add('sub_atom', 5, subAtomBuiltin);
    registry.add('atom_chars', 2, atomCharsBuiltin, { deterministic: true });
    registry.add('atom_codes', 2, atomCodesBuiltin, { deterministic: true });
    registry.add('char_code', 2, charCodeBuiltin, { deterministic: true });
    registry.add('number_chars', 2, numberCharsBuiltin, { deterministic: true });
    registry.add('number_codes', 2, numberCodesBuiltin, { deterministic: true });

    registry.add('call', 1, callBuiltin, { expandGoal: expandCallGoal });
    for (let arity = 2; arity <= 8; arity++) {
      registry.add('call', arity, callClosureBuiltin, { expandGoal: expandCallClosureGoal });
    }
    registry.add('catch', 3, catchBuiltin);
    registry.add('throw', 1, throwBuiltin, { deterministic: true });
    registry.add('\\+', 1, negationBuiltin, { deterministic: true });
    registry.add('once', 1, onceBuiltin, { deterministic: true });
    registry.add('repeat', 0, repeatBuiltin);
    registry.add(';', 2, disjunctionBuiltin);
    registry.add('->', 2, ifThenBuiltin);
    registry.add('phrase', 2, phraseBuiltin);
    registry.add('phrase', 3, phraseBuiltin);

    registry.add('is', 2, isBuiltin, { deterministic: true });
    registry.add('=:=', 2, arithmeticComparison((n) => n === 0), { deterministic: true });
    registry.add('=\\=', 2, arithmeticComparison((n) => n !== 0), { deterministic: true });
    registry.add('<', 2, arithmeticComparison((n) => n < 0), { deterministic: true });
    registry.add('=<', 2, arithmeticComparison((n) => n <= 0), { deterministic: true });
    registry.add('>', 2, arithmeticComparison((n) => n > 0), { deterministic: true });
    registry.add('>=', 2, arithmeticComparison((n) => n >= 0), { deterministic: true });
  }
};

function* unification({ goal, env }) {
  const next = env.clone();
  const knownNonoccurringVariables = goal._knownNonoccurringVariables ?? null;
  if (unify(goal.args[0], goal.args[1], next, { knownNonoccurringVariables })) yield next;
}
function* unificationWithOccursCheck({ goal, env }) {
  const next = env.clone();
  // ISO unify_with_occurs_check/2 always performs finite-tree unification.
  // The implementation-specific occurs_check=error mode applies to normal
  // unification, but must not turn this ISO predicate's ordinary failure into
  // an exception.
  if (unify(goal.args[0], goal.args[1], next, { occursCheck: 'fail' })) yield next;
}
function* nonUnification({ goal, env }) {
  if (!unify(goal.args[0], goal.args[1], env.clone())) yield env;
}

function difConstraint(left, right) {
  return Object.freeze({
    kind: 'dif',
    left,
    right,
    variables(env) {
      return new Set([...termVariableNames(left, env), ...termVariableNames(right, env)]);
    },
    status(env) {
      if (identical(left, right, env)) return 'violated';
      const probe = env.clone();
      // Test structural unifiability without waking freeze/2 or other
      // attributed-variable hooks in this disposable environment.
      return unify(left, right, probe, {
        skipVariableConstraints: true,
        skipAttributeHooks: true,
      }) ? 'pending' : 'entailed';
    },
    subsumes(other, env) {
      if (other?.kind !== 'dif') return false;
      // dif(A,B) implies dif(C,D) exactly when C=D entails A=B. Apply the
      // most general finite-tree unifier for the other's forbidden equality;
      // if this equality makes our terms identical, every instance forbidden
      // by the other constraint is already forbidden by this one.
      const probe = env.clone();
      if (!unify(other.left, other.right, probe, {
        skipVariableConstraints: true,
        skipAttributeHooks: true,
      })) return true;
      return identical(left, right, probe);
    },
    residualGoal(env) {
      const [projectedLeft, projectedRight] = projectDifSubterms(left, right, env);
      return compound('dif', [projectedLeft, projectedRight]);
    },
  });
}

function projectDifSubterms(left, right, env) {
  left = deref(left, env);
  right = deref(right, env);
  while (left.type === COMPOUND && right.type === COMPOUND &&
      left.name === right.name && left.arity === right.arity) {
    let projectedIndex = -1;
    for (let index = 0; index < left.arity; index++) {
      if (identical(left.args[index], right.args[index], env)) continue;
      const probe = env.clone();
      if (unify(left.args[index], right.args[index], probe, {
        skipVariableConstraints: true,
        skipAttributeHooks: true,
      }) && identical(left, right, probe)) {
        projectedIndex = index;
        break;
      }
    }
    // If no single aligned subterm equality entails equality of the complete
    // compounds, their disequality is a genuine disjunction. Keep it whole
    // instead of inventing auxiliary terms or separate stronger constraints.
    if (projectedIndex === -1) return [left, right];
    left = deref(left.args[projectedIndex], env);
    right = deref(right.args[projectedIndex], env);
  }
  return [left, right];
}

export function* difBuiltin({ goal, env }) {
  const left = goal.args[0];
  const right = goal.args[1];
  if (identical(left, right, env)) return;

  // In EyeProlog's finite-tree model, terms that cannot unify are already
  // provably different and need no residual constraint. Otherwise attach a
  // disequality constraint to every currently unbound variable it mentions.
  // This probe must not wake goals attached to those variables.
  const probe = env.clone();
  if (!unify(left, right, probe, {
    skipVariableConstraints: true,
    skipAttributeHooks: true,
  })) {
    yield env;
    return;
  }
  const next = env.clone();
  next.addVariableConstraint(difConstraint(left, right));
  yield next;
}

function termVariableNames(term, env, names = new Set(), seen = new Set()) {
  term = deref(term, env);
  if (term.type === VAR) {
    names.add(term.name);
  } else if (term.type === COMPOUND && !seen.has(term)) {
    seen.add(term);
    for (const arg of term.args) termVariableNames(arg, env, names, seen);
  }
  return names;
}

function subsumesTerm(general, specific, env) {
  general = copyResolved(general, env);
  specific = copyResolved(specific, env);
  const protectedVariables = termVariableNames(specific, new Env());
  const substitutions = new Map();
  const pending = [[general, specific]];
  while (pending.length) {
    let [left, right] = pending.pop();
    if (left.type === VAR && substitutions.has(left.name)) left = substitutions.get(left.name);
    if (left.type === VAR) {
      // A variable shared with Specific may not be changed by the one-sided
      // substitution required by subsumes_term/2.
      if (protectedVariables.has(left.name)) {
        if (right.type !== VAR || right.name !== left.name) return false;
      } else {
        substitutions.set(left.name, right);
      }
      continue;
    }
    if (left.type !== right.type || left.arity !== right.arity) return false;
    if (left.type === NUMBER ? !sameNumberValue(left.name, right.name) : left.name !== right.name) return false;
    for (let i = left.arity - 1; i >= 0; i--) pending.push([left.args[i], right.args[i]]);
  }
  return true;
}

function* subsumesTermBuiltin({ goal, env }) {
  if (subsumesTerm(goal.args[0], goal.args[1], env)) yield env;
}
function* identity({ goal, env }) {
  if (identical(goal.args[0], goal.args[1], env)) yield env;
}
function* nonIdentity({ goal, env }) {
  if (!identical(goal.args[0], goal.args[1], env)) yield env;
}

function identical(left, right, env) {
  left = deref(left, env);
  right = deref(right, env);
  if (left.type !== right.type || left.arity !== right.arity) return false;
  if (left.type === NUMBER ? !sameNumberValue(left.name, right.name) : left.name !== right.name) return false;
  if (left.type === VAR) return left.name === right.name;
  for (let i = 0; i < left.arity; i++) if (!identical(left.args[i], right.args[i], env)) return false;
  return true;
}

const unaryTest = (predicate) => function* ({ goal, env }) {
  if (predicate(deref(goal.args[0], env), env)) yield env;
};
const typeTests = {
  var: unaryTest((t) => t.type === VAR),
  nonvar: unaryTest((t) => t.type !== VAR),
  atom: unaryTest((t) => t.type === ATOM),
  integer: unaryTest((t) => t.type === NUMBER && isDecimalInteger(t.name)),
  float: unaryTest((t) => t.type === NUMBER && !isDecimalInteger(t.name)),
  number: unaryTest((t) => t.type === NUMBER),
  atomic: unaryTest((t) => t.type === ATOM || t.type === NUMBER || t.type === STRING),
  compound: unaryTest((t) => t.type === COMPOUND),
  callable: unaryTest((t) => t.type === ATOM || t.type === COMPOUND),
  ground: unaryTest((t, env) => termIsGround(t, env)),
  acyclic_term: unaryTest((t, env) => termIsAcyclic(t, env)),
};

function termIsAcyclic(term, env) {
  const active = new Set();
  const complete = new Set();
  const stack = [[term, false]];
  while (stack.length) {
    const [candidate, leaving] = stack.pop();
    const resolved = deref(candidate, env);
    if (resolved.type !== COMPOUND) continue;
    if (leaving) {
      active.delete(resolved);
      complete.add(resolved);
      continue;
    }
    if (active.has(resolved)) return false;
    if (complete.has(resolved)) continue;
    active.add(resolved);
    stack.push([resolved, true]);
    for (let i = resolved.arity - 1; i >= 0; i--) stack.push([resolved.args[i], false]);
  }
  return true;
}

function resolvedOrder(left, right, env, variableRanks = null) {
  return compareTerms(copyResolved(left, env), copyResolved(right, env), variableRanks);
}
function* compareBuiltin({ goal, env }) {
  const order = deref(goal.args[0], env);
  if (order.type !== VAR) {
    if (order.type !== ATOM) throw new PrologError('type_error(atom)', order);
    if (!['<', '=', '>'].includes(order.name)) throw new PrologError('domain_error(order)', order);
  }
  const cmp = resolvedOrder(goal.args[1], goal.args[2], env);
  const next = env.clone();
  if (unify(goal.args[0], atom(cmp < 0 ? '<' : cmp > 0 ? '>' : '='), next)) yield next;
}
function orderBuiltin(test) {
  return function* ({ goal, env }) {
    if (test(resolvedOrder(goal.args[0], goal.args[1], env))) yield env;
  };
}

function listKind(term, env) {
  let cursor = deref(term, env);
  const seen = new Set();
  while (cursor.type === COMPOUND && cursor.name === '.' && cursor.arity === 2) {
    if (seen.has(cursor)) return 'nonlist';
    seen.add(cursor);
    cursor = deref(cursor.args[1], env);
  }
  if (cursor.type === VAR) return 'partial';
  return cursor.type === ATOM && cursor.name === '[]' ? 'list' : 'nonlist';
}

function requireProperList(term, env) {
  const value = deref(term, env);
  const kind = listKind(value, env);
  if (kind === 'partial') throw new PrologError('instantiation_error');
  if (kind !== 'list') throw new PrologError('type_error(list)', value);
  return properListItems(value, env);
}

function validateListOutput(term, env) {
  const value = deref(term, env);
  if (listKind(value, env) === 'nonlist') throw new PrologError('type_error(list)', value);
}

function* sortBuiltin({ goal, env }) {
  const items = requireProperList(goal.args[0], env);
  validateListOutput(goal.args[1], env);
  const variableRanks = new Map();
  const sorted = [...items].sort((a, b) => resolvedOrder(a, b, env, variableRanks));
  const unique = [];
  for (const item of sorted) {
    if (unique.length === 0 || resolvedOrder(unique[unique.length - 1], item, env, variableRanks) !== 0) unique.push(item);
  }
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(unique), next)) yield next;
}

function* keysortBuiltin({ goal, env }) {
  const items = requireProperList(goal.args[0], env);
  validateListOutput(goal.args[1], env);
  for (const item of items) {
    const resolved = deref(item, env);
    if (resolved.type === VAR) throw new PrologError('instantiation_error');
    if (resolved.type !== COMPOUND || resolved.name !== '-' || resolved.arity !== 2) {
      throw new PrologError('type_error(pair)', resolved);
    }
  }
  const { items: outputPrefix } = listElements(goal.args[1], env);
  for (const item of outputPrefix) {
    if (item.type === VAR) continue;
    if (item.type !== COMPOUND || item.name !== '-' || item.arity !== 2) {
      throw new PrologError('type_error(pair)', item);
    }
  }
  // Modern ECMAScript specifies a stable Array#sort, as required by keysort/2.
  // Keep one implementation-dependent variable order for this whole sorting
  // operation, as required by ISO 7.2.1.
  const variableRanks = new Map();
  const sorted = [...items].sort((a, b) =>
    resolvedOrder(deref(a, env).args[0], deref(b, env).args[0], env, variableRanks));
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(sorted), next)) yield next;
}

function requireInteger(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(integer)', value);
  return BigInt(value.name);
}
function requireAtom(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== ATOM) throw new PrologError('type_error(atom)', value);
  return value;
}

function* functorBuiltin({ goal, env }) {
  const term = deref(goal.args[0], env);
  const next = env.clone();
  if (term.type !== VAR) {
    const name = term.type === COMPOUND ? atom(term.name) : term;
    if (unify(goal.args[1], name, next) && unify(goal.args[2], numberTerm(term.arity), next)) yield next;
    return;
  }

  const name = deref(goal.args[1], env);
  const arityTerm = deref(goal.args[2], env);
  // Keep EyeProlog's deterministic construction-mode diagnostics aligned with
  // the individual 8.5.1.3 conditions. Under 7.12, a call satisfying several
  // error conditions at once does not acquire a globally mandated table order.
  if (name.type === VAR) throw new PrologError('instantiation_error');
  if (arityTerm.type === VAR) throw new PrologError('instantiation_error');
  if (name.type === COMPOUND) throw new PrologError('type_error(atomic)', name);
  if (arityTerm.type !== NUMBER || !isDecimalInteger(arityTerm.name)) {
    throw new PrologError('type_error(integer)', arityTerm);
  }
  const arity = BigInt(arityTerm.name);
  if (arity > 0n && name.type !== ATOM) throw new PrologError('type_error(atom)', name);
  if (ISO_MAX_ARITY != null && arity > BigInt(ISO_MAX_ARITY)) {
    throw new PrologError('representation_error(max_arity)');
  }
  if (arity < 0n) throw new PrologError('domain_error(not_less_than_zero)', arityTerm);
  if (arity === 0n) {
    if (unify(goal.args[0], name, next)) yield next;
    return;
  }
  // `max_arity = unbounded` means there is no ISO-visible representation
  // ceiling on compound terms.  The JavaScript host still has finite storage
  // resources, however.  In particular an Array length is limited to 2^32-1
  // and allocation can fail before that.  Report host exhaustion as the ISO
  // resource error family rather than leaking a JavaScript RangeError or
  // reintroducing an artificial max_arity limit.
  if (arity > 0xffffffffn) throw new PrologError('resource_error(memory)');
  const id = ++isoFresh;
  let args;
  try {
    args = Array.from({ length: Number(arity) }, (_, i) => variable(`__functor${id}_${i}`));
  } catch (error) {
    if (error?.name === 'RangeError') throw new PrologError('resource_error(memory)');
    throw error;
  }
  if (unify(goal.args[0], compound(name.name, args), next)) yield next;
}

function* argBuiltin({ goal, env }) {
  const indexTerm = deref(goal.args[0], env);
  const term = deref(goal.args[1], env);
  // ISO 8.5.2.3 prescribes both instantiation checks before either type
  // check.  In particular arg(a, X, _) is an instantiation error because
  // the second argument is still a variable.
  if (indexTerm.type === VAR) throw new PrologError('instantiation_error');
  if (term.type === VAR) throw new PrologError('instantiation_error');
  if (indexTerm.type !== NUMBER || !isDecimalInteger(indexTerm.name)) {
    throw new PrologError('type_error(integer)', indexTerm);
  }
  if (term.type !== COMPOUND) throw new PrologError('type_error(compound)', term);
  const index = BigInt(indexTerm.name);
  if (index < 0n) throw new PrologError('domain_error(not_less_than_zero)', indexTerm);
  if (index === 0n || index > BigInt(term.arity)) return;
  const next = env.clone();
  if (unify(goal.args[2], term.args[Number(index) - 1], next)) yield next;
}

function* univBuiltin({ goal, env }) {
  const term = deref(goal.args[0], env);
  const next = env.clone();
  if (term.type !== VAR) {
    // 8.5.3.3(b) also applies in decomposition mode: a fixed second argument
    // that is neither a list nor a partial list is an error, not failure.
    if (listKind(goal.args[1], env) === 'nonlist') {
      throw new PrologError('type_error(list)', deref(goal.args[1], env));
    }
    const items = term.type === COMPOUND ? [atom(term.name), ...term.args] : [term];
    if (unify(goal.args[1], listFromItems(items), next)) yield next;
    return;
  }
  const items = properListItems(goal.args[1], env);
  if (items == null) {
    if (isPartialList(goal.args[1], env)) throw new PrologError('instantiation_error');
    throw new PrologError('type_error(list)', deref(goal.args[1], env));
  }
  if (items.length === 0) throw new PrologError('domain_error(non_empty_list)', emptyList());
  if (items.length === 1) {
    const scalar = deref(items[0], env);
    if (scalar.type === VAR) throw new PrologError('instantiation_error');
    if (scalar.type === COMPOUND) throw new PrologError('type_error(atomic)', scalar);
    if (unify(goal.args[0], scalar, next)) yield next;
    return;
  }
  const name = requireAtom(items[0], env);
  if (ISO_MAX_ARITY != null && items.length - 1 > ISO_MAX_ARITY) {
    throw new PrologError('representation_error(max_arity)');
  }
  if (unify(goal.args[0], compound(name.name, items.slice(1)), next)) yield next;
}

function isPartialList(list, env) {
  let cursor = deref(list, env);
  while (cursor.type === COMPOUND && cursor.name === '.' && cursor.arity === 2) {
    cursor = deref(cursor.args[1], env);
  }
  return cursor.type === VAR;
}

const freshCopyGroundCache = new WeakMap();

function structurallyVariableFree(term) {
  if (term?.type === VAR) return false;
  if (term?.type !== COMPOUND) return true;
  const known = freshCopyGroundCache.get(term);
  if (known !== undefined) return known;

  const pending = [{ term, visited: false }];
  while (pending.length > 0) {
    const frame = pending.pop();
    const current = frame.term;
    if (current?.type !== COMPOUND || freshCopyGroundCache.has(current)) continue;
    if (!frame.visited) {
      pending.push({ term: current, visited: true });
      for (let index = current.args.length - 1; index >= 0; index--) {
        const child = current.args[index];
        if (child?.type === COMPOUND && !freshCopyGroundCache.has(child)) {
          pending.push({ term: child, visited: false });
        }
      }
      continue;
    }
    let ground = true;
    for (const child of current.args) {
      if (child?.type === VAR || (child?.type === COMPOUND && freshCopyGroundCache.get(child) !== true)) {
        ground = false;
        break;
      }
    }
    freshCopyGroundCache.set(current, ground);
  }
  return freshCopyGroundCache.get(term) === true;
}

function freshCopy(term, env, variables = new Map(), id = ++isoFresh) {
  const copyNode = (source) => {
    if (source.type === VAR) {
      if (!variables.has(source.name)) variables.set(source.name, variable(`__copy${id}_${variables.size}`));
      return variables.get(source.name);
    }
    if (source.type !== COMPOUND) return source;
    // Ground terms are immutable in EyeProlog. Sharing them is observably
    // equivalent to copying and avoids rebuilding large lists for assertz/1,
    // copy_term/2, bagof/findall storage, and exception terms.
    if (structurallyVariableFree(source)) return source;
    const copied = compound(source.name, new Array(source.args.length));
    // Module qualification is execution context, not logical variable state.
    // Preserve it across copy_term/2 so meta-predicate closures keep the caller
    // module they received before a library copies and later invokes them.
    if (source.module != null) copied.module = source.module;
    return copied;
  };

  const source = deref(term, env);
  const root = copyNode(source);
  if (source.type !== COMPOUND || source.args.length === 0) return root;

  // copy_term/2 is routinely used on long lists and large machine states.
  // Traverse iteratively so term depth is independent of the host call stack.
  // The map also preserves rational-tree cycles when occurs_check is disabled.
  const copies = new Map([[source, root]]);
  const pending = [{ source, target: root }];
  while (pending.length > 0) {
    const current = pending.pop();
    for (let index = 0; index < current.source.args.length; index++) {
      const childSource = deref(current.source.args[index], env);
      let child = childSource.type === COMPOUND ? copies.get(childSource) : null;
      if (child == null) {
        child = copyNode(childSource);
        if (childSource.type === COMPOUND && child !== childSource) {
          copies.set(childSource, child);
          if (childSource.args.length > 0) pending.push({ source: childSource, target: child });
        }
      }
      current.target.args[index] = child;
    }
  }
  return root;
}
function* copyTermBuiltin({ goal, env }) {
  const next = env.clone();
  if (unify(goal.args[1], freshCopy(goal.args[0], env), next)) yield next;
}
function* termVariablesBuiltin({ goal, env }) {
  let list = deref(goal.args[1], env);
  while (list.type === COMPOUND && list.name === '.' && list.arity === 2) {
    list = deref(list.args[1], env);
  }
  if (list.type !== VAR && !(list.type === ATOM && list.name === '[]')) {
    throw new PrologError('type_error(list)', deref(goal.args[1], env));
  }
  const found = [];
  const seen = new Set();
  const pending = [goal.args[0]];
  while (pending.length > 0) {
    const term = deref(pending.pop(), env);
    if (term.type === VAR) {
      if (!seen.has(term.name)) { seen.add(term.name); found.push(term); }
      continue;
    }
    for (let index = term.args.length - 1; index >= 0; index--) pending.push(term.args[index]);
  }
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(found), next)) yield next;
}

function validPredicateIndicator(term) {
  return term.type === COMPOUND && term.name === '/' && term.arity === 2 &&
    (term.args[0].type === VAR || term.args[0].type === ATOM) &&
    (term.args[1].type === VAR ||
      (term.args[1].type === NUMBER && isDecimalInteger(term.args[1].name) && BigInt(term.args[1].name) >= 0n));
}

function currentPredicateBuiltin(context) {
  const state = { pending: false };
  return withPendingState(currentPredicateSolutions(context, state), state);
}

function* currentPredicateSolutions({ solver, goal, env }, state) {
  const indicator = copyResolved(goal.args[0], env);
  if (indicator.type !== VAR && !validPredicateIndicator(indicator)) {
    throw new PrologError('type_error(predicate_indicator)', indicator);
  }
  const groups = [...solver.program.groups.values()].filter((group) =>
    indicator.type === VAR ||
    (indicator.args[0].type === VAR || indicator.args[0].name === group.name) &&
    (indicator.args[1].type === VAR || BigInt(indicator.args[1].name) === BigInt(group.arity)));
  for (let index = 0; index < groups.length; index++) {
    const group = groups[index];
    const next = env.clone();
    const candidate = compound('/', [atom(group.name), numberTerm(group.arity)]);
    if (unify(goal.args[0], candidate, next)) {
      state.pending = index + 1 < groups.length;
      yield next;
    }
  }
  state.pending = false;
}

function callableOrVariable(term, env) {
  const value = deref(term, env);
  if (value.type === VAR || value.type === ATOM || value.type === COMPOUND) return value;
  throw new PrologError('type_error(callable)', value);
}

function clauseBodyTerm(body) {
  if (body.length === 0) return atom('true');
  let result = body[body.length - 1];
  for (let i = body.length - 2; i >= 0; i--) result = compound(',', [body[i], result]);
  return result;
}

function clauseBuiltin(context) {
  const state = { pending: false };
  return withPendingState(clauseSolutions(context, state), state);
}

function* clauseSolutions({ solver, goal, env }, state) {
  const head = deref(goal.args[0], env);
  if (head.type === VAR) throw new PrologError('instantiation_error');
  if (head.type !== ATOM && head.type !== COMPOUND) throw new PrologError('type_error(callable)', head);
  const indicator = compound('/', [atom(head.name), numberTerm(head.arity)]);
  const group = solver.program.findGroup(head.name, head.arity, head.module ?? goal.module ?? 'user');
  // EyeProlog selects private-procedure access before Body callability when both
  // conditions hold. ISO 7.12 permits an implementation-dependent choice when
  // more than one error condition is simultaneously satisfied.
  //
  // A procedure defined by a Prolog text is static unless a dynamic/1
  // directive says otherwise (ISO 7.5.2 and 8.9), and clause/2 may only
  // inspect a public (dynamic) procedure (ISO 8.8.1.3). Static is therefore
  // the default in every mode, not only under --iso-strict: assert/1,
  // retract/1, and abolish/1 already reject static procedures unconditionally,
  // and clause/2 now agrees with them.
  //
  // 7.5.3 notes that a public/1 directive would be an extension, so a static
  // procedure declared public, or any user-defined procedure when the
  // default_procedure_access flag is public, stays readable here. Either way
  // the procedure remains static and cannot be modified.
  if (isProcessorStaticProcedure(solver, head) ||
      (group && !group.dynamic && !isPublicProcedure(solver, group))) {
    throw new PrologError('permission_error(access, private_procedure)', indicator);
  }
  callableOrVariable(goal.args[1], env);
  if (!group) return;
  for (let index = 0; index < group.clauses.length; index++) {
    const clause = group.clauses[index];
    const pair = compound('$clause', [clause.head, clauseBodyTerm(clause.body)]);
    const copied = freshCopy(pair, new Env());
    const next = env.clone();
    if (unify(goal.args[0], copied.args[0], next) && unify(goal.args[1], copied.args[1], next)) {
      state.pending = index + 1 < group.clauses.length;
      yield next;
    }
  }
  state.pending = false;
}

function clauseParts(term, env) {
  const value = deref(term, env);
  if (value.type === COMPOUND && value.name === ':-' && value.arity === 2) {
    return { head: deref(value.args[0], env), body: deref(value.args[1], env), rule: true };
  }
  return { head: value, body: atom('true'), rule: false };
}

function requireClauseHead(head) {
  if (head.type === VAR) throw new PrologError('instantiation_error');
  if (head.type !== ATOM && head.type !== COMPOUND) throw new PrologError('type_error(callable)', head);
}

export function convertClauseBodyTerm(term, culprit = term) {
  if (term.type === VAR) return compound('call', [term]);
  // ISO 7.6.2 converts each argument of conjunction, disjunction, and if-then
  // recursively when a term is converted to a clause body. This matters for
  // variables (which become call(Var)) and for invalid nested terms, which
  // must be rejected while assert[az]/1 performs the conversion rather than
  // being stored and failing only if that branch is later executed.
  if (term.type === COMPOUND && [',', ';', '->'].includes(term.name) && term.arity === 2) {
    return compound(term.name, [
      convertClauseBodyTerm(term.args[0], culprit),
      convertClauseBodyTerm(term.args[1], culprit),
    ]);
  }
  if (term.type !== ATOM && term.type !== COMPOUND) {
    throw new PrologError('type_error(callable)', culprit);
  }
  return term;
}

function procedureIndicator(head) {
  return compound('/', [atom(head.name), numberTerm(head.arity)]);
}

function isGrammarRuleProcedure(solver, head) {
  return !solver.isoStrict && head.name === '-->' && head.arity === 2;
}

// A user-defined procedure is readable by clause/2 when it was declared public
// or when the processor grants access to every user-defined procedure.
function isPublicProcedure(solver, group) {
  if (group.public) return true;
  return solver.prologFlags?.get('default_procedure_access')?.value?.name === 'public';
}

function isProcessorStaticProcedure(solver, head) {
  // Conjunction is an ISO control construct (7.5/Table 9) but is executed
  // directly by the solver rather than through the builtin registry.  The
  // source syntax functors (:-)/1-2 likewise have processor-defined roles and
  // STC #56 calls for protecting them from database modification. Keep these
  // in the same static/private family for strict runtime database operations.
  const strictSyntaxProcedure = solver.isoStrict && (
    (head.name === ',' && head.arity === 2) ||
    (head.name === ':-' && (head.arity === 1 || head.arity === 2))
  );
  return Boolean(solver.registry.get(head.name, head.arity)) ||
    isGrammarRuleProcedure(solver, head) ||
    strictSyntaxProcedure;
}

function assertModifiable(solver, head, module = 'user') {
  const group = solver.program.findGroup(head.name, head.arity, head.module ?? module);
  if (isProcessorStaticProcedure(solver, head) || (group && !group.dynamic)) {
    throw new PrologError('permission_error(modify, static_procedure)', procedureIndicator(head));
  }
}

function assertBuiltin(atStart) {
  return function* ({ solver, goal, env }) {
    const parts = clauseParts(goal.args[0], env);
    requireClauseHead(parts.head);
    const body = convertClauseBodyTerm(parts.body);
    assertModifiable(solver, parts.head, goal.module ?? 'user');
    const copied = freshCopy(compound('$clause', [parts.head, body]), env);
    solver.program.insertDynamicClause({
      head: copied.args[0],
      module: copied.args[0].module ?? goal.module ?? 'user',
      body: copied.args[1].type === ATOM && copied.args[1].name === 'true'
        ? []
        : [copied.args[1]],
    }, atStart);
    yield env;
  };
}

function retractBuiltin(context) {
  const state = { pending: true };
  const iterator = retractSolutions(context, state);
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}

function* retractSolutions({ solver, goal, env }, state) {
  const parts = clauseParts(goal.args[0], env);
  requireClauseHead(parts.head);
  const group = solver.program.findGroup(parts.head.name, parts.head.arity, parts.head.module ?? goal.module ?? 'user');
  if (isProcessorStaticProcedure(solver, parts.head) || (group && !group.dynamic)) {
    throw new PrologError('permission_error(modify, static_procedure)', procedureIndicator(parts.head));
  }
  if (!group) {
    state.pending = false;
    return;
  }
  // ISO logical update view: this call keeps the clauses that were visible
  // when it began. A later retract/1 may erase one of those clauses from the
  // live procedure, but must not invalidate this call's pending alternatives.
  const matches = [];
  for (const clause of [...group.clauses]) {
    const copied = freshCopy(compound('$clause', [clause.head, clauseBodyTerm(clause.body)]), new Env());
    const next = env.clone();
    if (!unify(parts.head, copied.args[0], next)) continue;
    if (parts.rule && !unify(parts.body, copied.args[1], next)) continue;
    if (!parts.rule && !(copied.args[1].type === ATOM && copied.args[1].name === 'true')) continue;
    matches.push({ clause, next: next._toPersistentEnv?.() ?? next });
  }
  for (let index = 0; index < matches.length; index++) {
    const { clause, next } = matches[index];
    solver.program.removeDynamicClause(group, clause);
    state.pending = index + 1 < matches.length;
    yield next;
  }
  state.pending = false;
}

function* retractAllBuiltin({ solver, goal, env }) {
  const head = deref(goal.args[0], env);
  requireClauseHead(head);
  const group = solver.program.findGroup(head.name, head.arity, head.module ?? goal.module ?? 'user');
  if (isProcessorStaticProcedure(solver, head) || (group && !group.dynamic)) {
    throw new PrologError('permission_error(modify, static_procedure)', procedureIndicator(head));
  }
  if (group) {
    for (const clause of [...group.clauses]) {
      if (unify(head, freshCopy(clause.head, new Env()), env.clone())) {
        solver.program.removeDynamicClause(group, clause);
      }
    }
  }
  yield env;
}

function predicateIndicatorParts(term, env) {
  const indicator = deref(term, env);
  if (indicator.type === VAR) throw new PrologError('instantiation_error');
  if (indicator.type !== COMPOUND || indicator.name !== '/' || indicator.arity !== 2) {
    throw new PrologError('type_error(predicate_indicator)', indicator);
  }
  const name = deref(indicator.args[0], env);
  const arity = deref(indicator.args[1], env);
  if (name.type === VAR || arity.type === VAR) throw new PrologError('instantiation_error');
  if (arity.type !== NUMBER || !isDecimalInteger(arity.name)) throw new PrologError('type_error(integer)', arity);
  if (name.type !== ATOM) throw new PrologError('type_error(atom)', name);
  const integer = BigInt(arity.name);
  if (integer < 0n) throw new PrologError('domain_error(not_less_than_zero)', arity);
  if (ISO_MAX_ARITY != null && integer > BigInt(ISO_MAX_ARITY)) {
    throw new PrologError('representation_error(max_arity)');
  }
  // Actual clause arities are ordinary JavaScript array lengths. For a very
  // large predicate indicator that names no existing procedure, retain the
  // exact integer in the map key instead of rounding it through Number.
  const runtimeArity = integer <= BigInt(Number.MAX_SAFE_INTEGER) ? Number(integer) : integer;
  return { name: name.name, arity: runtimeArity, indicator };
}

function* abolishBuiltin({ solver, goal, env }) {
  const target = predicateIndicatorParts(goal.args[0], env);
  const module = goal.module ?? 'user';
  const group = solver.program.findGroup(target.name, target.arity, module);
  if (isProcessorStaticProcedure(solver, target) || (group && !group.dynamic)) {
    throw new PrologError('permission_error(modify, static_procedure)', target.indicator);
  }
  solver.program.abolishDynamicGroup(target.name, target.arity, module);
  yield env;
}

function currentPrologFlagBuiltin(context) {
  const state = { pending: false };
  return withPendingState(currentPrologFlagSolutions(context, state), state);
}

function* currentPrologFlagSolutions({ solver, goal, env }, state) {
  const flag = deref(goal.args[0], env);
  if (flag.type !== VAR && flag.type !== ATOM) throw new PrologError('type_error(atom)', flag);
  if (flag.type === ATOM && !solver.prologFlags.has(flag.name)) {
    throw new PrologError('domain_error(prolog_flag)', flag);
  }
  const definitions = [...solver.prologFlags]
    .filter(([name, definition]) => definition.value != null && (flag.type === VAR || flag.name === name));
  for (let index = 0; index < definitions.length; index++) {
    const [name, definition] = definitions[index];
    // ISO 7.11.1.1: when bounded=false, max_integer and min_integer have no
    // current value and current_prolog_flag/2 must therefore not enumerate
    // them. The definitions remain registered so attempts to change these
    // non-changeable flags still receive the normal flag error handling.
    const next = env.clone();
    if (unify(goal.args[0], atom(name), next) && unify(goal.args[1], definition.value, next)) {
      state.pending = index + 1 < definitions.length;
      yield next;
    }
  }
  state.pending = false;
}

function* setPrologFlagBuiltin({ solver, goal, env }) {
  const flag = deref(goal.args[0], env);
  const value = deref(goal.args[1], env);
  if (flag.type === VAR || value.type === VAR) throw new PrologError('instantiation_error');
  if (flag.type !== ATOM) throw new PrologError('type_error(atom)', flag);
  const definition = solver.prologFlags.get(flag.name);
  if (!definition) throw new PrologError('domain_error(prolog_flag)', flag);
  const expectedType = definition.valueType ?? ATOM;
  if (value.type !== expectedType || !definition.allowed.includes(value.name)) {
    throw new PrologError('domain_error(flag_value)', compound('+', [flag, value]));
  }
  if (!definition.changeable) throw new PrologError('permission_error(modify, flag)', flag);
  definition.value = atom(value.name);
  yield env;
}

const operatorSpecifiers = new Set(['fx', 'fy', 'xf', 'yf', 'xfx', 'xfy', 'yfx']);

function opListPreflight(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type === ATOM) return { value, items: [value], proper: true, atom: true };
  const { items, tail } = listElements(value, env);
  if (tail.type === VAR || items.some((item) => item.type === VAR)) {
    throw new PrologError('instantiation_error');
  }
  const proper = tail.type === ATOM && tail.name === '[]';
  return { value, items, proper, atom: false };
}

function* opBuiltin({ solver, goal, env }) {
  const priorityTerm = deref(goal.args[0], env);
  const specifierTerm = deref(goal.args[1], env);

  // Keep EyeProlog's selected 8.14.3.3 overlap order deterministic. Each
  // individual condition remains observable; ISO 7.12 leaves the choice
  // implementation dependent when several error conditions hold at once.
  if (priorityTerm.type === VAR) throw new PrologError('instantiation_error');
  if (specifierTerm.type === VAR) throw new PrologError('instantiation_error');
  const operator = opListPreflight(goal.args[2], env);

  if (priorityTerm.type !== NUMBER || !isDecimalInteger(priorityTerm.name)) {
    throw new PrologError('type_error(integer)', priorityTerm);
  }
  if (specifierTerm.type !== ATOM) throw new PrologError('type_error(atom)', specifierTerm);
  if (!operator.atom && !operator.proper) throw new PrologError('type_error(list)', operator.value);
  for (const item of operator.items) {
    if (item.type !== ATOM) throw new PrologError('type_error(atom)', item);
  }

  const priorityBig = BigInt(priorityTerm.name);
  if (priorityBig < 0n || priorityBig > 1200n) {
    throw new PrologError('domain_error(operator_priority)', priorityTerm);
  }
  if (!operatorSpecifiers.has(specifierTerm.name)) {
    throw new PrologError('domain_error(operator_specifier)', specifierTerm);
  }

  const priority = Number(priorityBig);
  const specifier = specifierTerm.name;
  for (const name of operator.items) {
    if (name.name === ',') {
      throw new PrologError('permission_error(modify, operator)', name);
    }
    if (name.name === '[]' || name.name === '{}') {
      throw new PrologError('permission_error(create, operator)', name);
    }
    if (name.name === '|' && priority !== 0 &&
        (!(specifier === 'xfx' || specifier === 'xfy' || specifier === 'yfx') || priority < 1001)) {
      throw new PrologError('permission_error(create, operator)', name);
    }
    const infix = specifier === 'xfx' || specifier === 'xfy' || specifier === 'yfx';
    const postfix = specifier === 'xf' || specifier === 'yf';
    if (priority !== 0 && [...solver.program.operators.values()].some((definition) =>
      definition.name === name.name &&
      ((infix && (definition.specifier === 'xf' || definition.specifier === 'yf')) ||
       (postfix && (definition.specifier === 'xfx' || definition.specifier === 'xfy' || definition.specifier === 'yfx'))))) {
      throw new PrologError('permission_error(create, operator)', name);
    }
    solver.program.defineOperator(priority, specifier, name.name);
  }
  yield env;
}

function currentOpBuiltin(context) {
  const state = { pending: false };
  return withPendingState(currentOpSolutions(context, state), state);
}

function* currentOpSolutions({ solver, goal, env }, state) {
  const priority = deref(goal.args[0], env);
  const specifier = deref(goal.args[1], env);
  const name = deref(goal.args[2], env);
  // ISO 8.14.4.3 defines the first two argument errors by domain, not by
  // their underlying atom/integer representation type.
  if (priority.type !== VAR &&
      (priority.type !== NUMBER || !isDecimalInteger(priority.name) ||
       BigInt(priority.name) < 0n || BigInt(priority.name) > 1200n)) {
    throw new PrologError('domain_error(operator_priority)', priority);
  }
  if (specifier.type !== VAR &&
      (specifier.type !== ATOM || !operatorSpecifiers.has(specifier.name))) {
    throw new PrologError('domain_error(operator_specifier)', specifier);
  }
  if (name.type !== VAR && name.type !== ATOM) throw new PrologError('type_error(atom)', name);
  const definitions = [...solver.program.operators.values()].filter((definition) =>
    (priority.type === VAR || BigInt(priority.name) === BigInt(definition.priority)) &&
    (specifier.type === VAR || specifier.name === definition.specifier) &&
    (name.type === VAR || name.name === definition.name));
  for (let index = 0; index < definitions.length; index++) {
    const definition = definitions[index];
    const next = env.clone();
    if (unify(goal.args[0], numberTerm(definition.priority), next) &&
        unify(goal.args[1], atom(definition.specifier), next) &&
        unify(goal.args[2], atom(definition.name), next)) {
      state.pending = index + 1 < definitions.length;
      yield next;
    }
  }
  state.pending = false;
}

function conversionCharacter(term, env, current = false, solver = null) {
  const value = deref(term, env);
  if (value.type === VAR) {
    if (current) return value;
    throw new PrologError('instantiation_error');
  }
  if (!oneChar(value)) {
    if (current) throw new PrologError('type_error(character)', value);
    throw new PrologError('representation_error(character)');
  }
  if (solver?.isoStrict && !isStrictIsoPcsCharacter(value.name)) {
    throw new PrologError('representation_error(character)', value);
  }
  return value;
}
function* charConversionBuiltin({ solver, goal, env }) {
  // ISO 8.14.5.3 checks both arguments for instantiation before testing
  // either character representation.
  const inputTerm = deref(goal.args[0], env);
  const outputTerm = deref(goal.args[1], env);
  if (inputTerm.type === VAR) throw new PrologError('instantiation_error');
  if (outputTerm.type === VAR) throw new PrologError('instantiation_error');
  const input = conversionCharacter(inputTerm, env, false, solver);
  const output = conversionCharacter(outputTerm, env, false, solver);
  if (input.name === output.name) solver.charConversions.delete(input.name);
  else solver.charConversions.set(input.name, output.name);
  yield env;
}
function currentCharConversionBuiltin(context) {
  const state = { pending: false };
  return withPendingState(currentCharConversionSolutions(context, state), state);
}

function* currentCharConversionSolutions({ solver, goal, env }, state) {
  const input = conversionCharacter(goal.args[0], env, true, solver);
  const output = conversionCharacter(goal.args[1], env, true, solver);
  const conversions = [...solver.charConversions].filter(([from, to]) =>
    (input.type === VAR || input.name === from) && (output.type === VAR || output.name === to));
  for (let index = 0; index < conversions.length; index++) {
    const [from, to] = conversions[index];
    const next = env.clone();
    if (unify(input, atom(from), next) && unify(output, atom(to), next)) {
      state.pending = index + 1 < conversions.length;
      yield next;
    }
  }
  state.pending = false;
}
function* haltBuiltin({ goal, env }) {
  const code = goal.arity === 0 ? 0n : requireInteger(goal.args[0], env);
  throw new HaltSignal(Number(code));
}

function streamHandle(id) {
  return compound('$stream', [numberTerm(id)]);
}

function streamReference(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type === ATOM) return value.name;
  if (value.type === COMPOUND && value.name === '$stream' && value.arity === 1 &&
      value.args[0].type === NUMBER && isDecimalInteger(value.args[0].name)) {
    return Number(value.args[0].name);
  }
  throw new PrologError('domain_error(stream_or_alias)', value);
}

function streamTermReference(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) return null;
  if (value.type === COMPOUND && value.name === '$stream' && value.arity === 1 &&
      value.args[0].type === NUMBER && isDecimalInteger(value.args[0].name)) {
    return Number(value.args[0].name);
  }
  throw new PrologError('domain_error(stream)', value);
}

function requireStream(solver, term, env, mode = null) {
  const culprit = deref(term, env);
  const stream = solver.io.resolve(streamReference(term, env));
  if (!stream) throw new PrologError('existence_error(stream)', culprit);
  if (mode) {
    const readable = stream.readable ?? stream.mode === 'read';
    const writable = stream.writable ?? (stream.mode === 'write' || stream.mode === 'append');
    if ((mode === 'read' && !readable) || (mode === 'write' && !writable)) {
      throw new PrologError(`permission_error(${mode === 'read' ? 'input' : 'output'}, stream)`, culprit);
    }
  }
  return stream;
}

function optionList(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  const items = properListItems(value, env);
  if (items == null) {
    if (isPartialList(value, env)) throw new PrologError('instantiation_error');
    throw new PrologError('type_error(list)', value);
  }
  return items.map((item) => deref(item, env));
}

// Keep read_term/3 and write_term/3 diagnostics deterministic and make every
// 8.14 error condition independently testable. ISO 7.12 leaves the choice
// implementation dependent when several error conditions hold simultaneously,
// so this preflight order is an EyeProlog processor choice rather than a claim
// that the textual order of an error table is globally mandatory.
function preflightOptionList(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  const { items, tail } = listElements(value, env);
  if (tail.type === VAR || items.some((item) => item.type === VAR)) {
    throw new PrologError('instantiation_error');
  }
  const proper = tail.type === ATOM && tail.name === '[]';
  return { value, items, proper };
}

function requireProperOptionList(preflight) {
  if (!preflight.proper) throw new PrologError('type_error(list)', preflight.value);
  return preflight.items;
}

function optionAtom(option, name) {
  if (option.type !== COMPOUND || option.name !== name || option.arity !== 1) return null;
  return option.args[0];
}

function openOptions(term, env) {
  const result = {};
  for (const option of optionList(term, env)) {
    if (option.type === VAR) throw new PrologError('instantiation_error');
    let value;
    if ((value = optionAtom(option, 'type'))) {
      value = deref(value, env);
      if (value.type === VAR) throw new PrologError('instantiation_error');
      if (value.type !== ATOM || !['text', 'binary'].includes(value.name)) {
        throw new PrologError('domain_error(stream_option)', option);
      }
      result.type = value.name;
    } else if ((value = optionAtom(option, 'alias'))) {
      value = deref(value, env);
      if (value.type === VAR) throw new PrologError('instantiation_error');
      if (value.type !== ATOM) throw new PrologError('domain_error(stream_option)', option);
      result.alias = value.name;
    } else if ((value = optionAtom(option, 'reposition'))) {
      value = deref(value, env);
      if (value.type === VAR) throw new PrologError('instantiation_error');
      if (value.type !== ATOM || !['true', 'false'].includes(value.name)) throw new PrologError('domain_error(stream_option)', option);
      result.reposition = value.name === 'true';
    } else if ((value = optionAtom(option, 'eof_action'))) {
      value = deref(value, env);
      if (value.type === VAR) throw new PrologError('instantiation_error');
      if (value.type !== ATOM || !['error', 'eof_code', 'reset'].includes(value.name)) throw new PrologError('domain_error(stream_option)', option);
      result.eof_action = value.name;
    } else {
      throw new PrologError('domain_error(stream_option)', option);
    }
  }
  return result;
}

function streamOptionHasRequiredVariable(option, env) {
  option = deref(option, env);
  if (option.type !== COMPOUND || option.arity !== 1 ||
      !['type', 'alias', 'reposition', 'eof_action'].includes(option.name)) return false;
  return deref(option.args[0], env).type === VAR;
}

function* openBuiltin({ solver, goal, env }) {
  const source = deref(goal.args[0], env);
  const mode = deref(goal.args[1], env);
  const streamTarget = deref(goal.args[2], env);
  const optionTerm = goal.arity === 3 ? emptyList() : goal.args[3];

  // ISO 8.11.5.3 + Corrigenda 2/3. Keep each required condition observable
  // on its own. When several conditions hold, the order below is EyeProlog's
  // deterministic 7.12 processor choice unless a procedural rule constrains it.
  if (source.type === VAR) throw new PrologError('instantiation_error');
  if (mode.type === VAR) throw new PrologError('instantiation_error');
  const preflight = preflightOptionList(optionTerm, env);
  if (preflight.items.some((option) => streamOptionHasRequiredVariable(option, env))) {
    throw new PrologError('instantiation_error');
  }
  if (mode.type !== ATOM) throw new PrologError('type_error(atom)', mode);
  const optionItems = requireProperOptionList(preflight);
  if (streamTarget.type !== VAR) throw new PrologError('uninstantiation_error', streamTarget);
  if (source.type !== ATOM) throw new PrologError('domain_error(source_sink)', source);
  if (!['read', 'write', 'append'].includes(mode.name)) throw new PrologError('domain_error(io_mode)', mode);
  const options = goal.arity === 3 ? {} : openOptions(optionTerm, env);
  if (options.alias && solver.io.resolve(options.alias)) {
    throw new PrologError('permission_error(open, source_sink)', compound('alias', [atom(options.alias)]));
  }
  let stream;
  try {
    stream = solver.io.open(source.name, mode.name, options);
  } catch (error) {
    if (error?.code === 'ENOENT' && mode.name === 'read') {
      throw new PrologError('existence_error(source_sink)', source);
    }
    throw new PrologError('permission_error(open, source_sink)', source);
  }
  const next = env.clone();
  if (unify(goal.args[2], streamHandle(stream.id), next)) yield next;
  else solver.io.close(stream);
}

function* closeBuiltin({ solver, goal, env }) {
  const reference = deref(goal.args[0], env);
  if (reference.type === VAR) throw new PrologError('instantiation_error');
  const optionTerm = goal.arity === 2 ? goal.args[1] : emptyList();
  const preflight = preflightOptionList(optionTerm, env);
  if (preflight.items.some((option) => {
    const force = optionAtom(option, 'force');
    return force != null && deref(force, env).type === VAR;
  })) throw new PrologError('instantiation_error');
  const options = requireProperOptionList(preflight);
  streamReference(goal.args[0], env);
  let forceClose = false;
  for (const option of options) {
    const force = optionAtom(option, 'force');
    const value = force && deref(force, env);
    if (!value || value.type !== ATOM || !['true', 'false'].includes(value.name)) {
      throw new PrologError('domain_error(close_option)', option);
    }
    // 8.11.6.1(a) is presence-based: if there is a force(true) option,
    // resource/system close errors are ignored.  A later force(false) does
    // not cancel an earlier force(true).
    forceClose ||= value.name === 'true';
  }
  const stream = requireStream(solver, goal.args[0], env);
  if (!stream.standard) {
    try {
      solver.io.close(stream);
    } catch (_) {
      if (!forceClose) throw new PrologError('system_error');
      solver.io.discard(stream);
    }
    if (solver.io.currentInput === stream.id) solver.io.currentInput = 0;
    if (solver.io.currentOutput === stream.id) solver.io.currentOutput = 1;
  }
  yield env;
}

function* currentInputBuiltin({ solver, goal, env }) {
  const value = deref(goal.args[0], env);
  if (value.type !== VAR) {
    const id = streamTermReference(goal.args[0], env);
    const stream = solver.io.resolve(id);
    if (!stream) throw new PrologError('domain_error(stream)', value);
    if (stream.id === solver.io.currentInput) yield env;
    return;
  }
  const next = env.clone();
  if (unify(goal.args[0], streamHandle(solver.io.currentInput), next)) yield next;
}
function* currentOutputBuiltin({ solver, goal, env }) {
  const value = deref(goal.args[0], env);
  if (value.type !== VAR) {
    const id = streamTermReference(goal.args[0], env);
    const stream = solver.io.resolve(id);
    if (!stream) throw new PrologError('domain_error(stream)', value);
    if (stream.id === solver.io.currentOutput) yield env;
    return;
  }
  const next = env.clone();
  if (unify(goal.args[0], streamHandle(solver.io.currentOutput), next)) yield next;
}

function setCurrentStreamBuiltin(mode) {
  return function* ({ solver, goal, env }) {
    const stream = requireStream(solver, goal.args[0], env, mode);
    if (mode === 'read') solver.io.currentInput = stream.id;
    else solver.io.currentOutput = stream.id;
    yield env;
  };
}
function* flushOutputBuiltin({ solver, goal, env }) {
  const stream = goal.arity === 0
    ? solver.io.resolve(solver.io.currentOutput)
    : requireStream(solver, goal.args[0], env, 'write');
  try {
    solver.io.flush(stream);
  } catch (_) {
    throw new PrologError('system_error');
  }
  yield env;
}

function streamEndState(stream) {
  if (stream.pastEnd) return 'past';
  if (stream.position < stream.content.length) return 'not';
  if (stream.remoteEnded === true) return 'at';
  if (typeof stream.interactiveReadUnit === 'function') return 'not';
  return 'at';
}

function streamProperties(stream) {
  const properties = [
    compound('mode', [atom(stream.mode)]),
    compound('type', [atom(stream.type)]),
    compound('reposition', [atom(stream.reposition ? 'true' : 'false')]),
    compound('eof_action', [atom(stream.eofAction)]),
    compound('position', [numberTerm(stream.reportedPosition ?? stream.position)]),
  ];
  const readable = stream.readable ?? stream.mode === 'read';
  const writable = stream.writable ?? (stream.mode === 'write' || stream.mode === 'append');
  if (readable) properties.push(atom('input'));
  if (writable) properties.push(atom('output'));
  properties.push(compound('end_of_stream', [atom(streamEndState(stream))]));
  if (stream.alias) properties.push(compound('alias', [atom(stream.alias)]));
  if (stream.path) properties.push(compound('file_name', [atom(stream.path)]));
  return properties;
}
function* setStreamPositionBuiltin({ solver, goal, env }) {
  const reference = deref(goal.args[0], env);
  if (reference.type === VAR) throw new PrologError('instantiation_error');
  let position = deref(goal.args[1], env);
  if (position.type === VAR) throw new PrologError('instantiation_error');
  streamReference(goal.args[0], env);
  if (!solver.isoStrict && position.type === COMPOUND && position.name === 'position' && position.arity === 1) {
    // Historical EyeProlog convenience form.  Strict Part 1 mode uses only
    // the implementation-defined integer stream-position terms returned by
    // stream_property/2.
    position = deref(position.args[0], env);
  }
  if (position.type === VAR || position.type !== NUMBER || !isDecimalInteger(position.name)) {
    throw new PrologError('domain_error(stream_position)', position);
  }
  const offset = BigInt(position.name);
  if (offset < 0n) throw new PrologError('domain_error(stream_position)', position);
  const stream = requireStream(solver, goal.args[0], env);
  if (!stream.reposition) throw new PrologError('permission_error(reposition, stream)', reference);
  if (offset > BigInt(stream.content.length)) throw new PrologError('domain_error(stream_position)', position);
  stream.position = Number(offset);
  stream.pastEnd = false;
  yield env;
}

function isStreamPropertyPattern(value) {
  if (value.type === VAR) return true;
  if (value.type === ATOM) return value.name === 'input' || value.name === 'output';
  return value.type === COMPOUND && value.arity === 1 && [
    'file_name', 'mode', 'alias', 'position', 'end_of_stream', 'eof_action', 'reposition', 'type',
  ].includes(value.name);
}

function streamPropertyBuiltin(context) {
  const state = { pending: false };
  return withPendingState(streamPropertySolutions(context, state), state);
}

function* streamPropertySolutions({ solver, goal, env }, state) {
  const reference = deref(goal.args[0], env);
  const propertyPattern = deref(goal.args[1], env);
  let fixedStreamId = null;
  if (reference.type !== VAR) {
    // 8.11.8.1 enumerates (Stream, Property) pairs for currently open
    // streams. A ground term with the implementation's stream-term shape is
    // still a stream-term even when its stream is no longer open; in that
    // case the enumeration simply has no matching pair. domain_error(stream)
    // is reserved for a term which is not a stream-term at all.
    fixedStreamId = streamTermReference(goal.args[0], env);
  }
  if (!isStreamPropertyPattern(propertyPattern)) {
    throw new PrologError('domain_error(stream_property)', propertyPattern);
  }
  const streams = reference.type === VAR
    ? [...solver.io.streams.values()]
    : [solver.io.resolve(fixedStreamId)].filter(Boolean);
  const candidates = [];
  for (const stream of streams) {
    for (const property of streamProperties(stream)) {
      if (propertyPattern.type === VAR ||
          (property.type === propertyPattern.type && property.name === propertyPattern.name)) {
        candidates.push([stream, property]);
      }
    }
  }
  for (let index = 0; index < candidates.length; index++) {
    const [stream, property] = candidates[index];
    const next = env.clone();
    if (unify(goal.args[0], streamHandle(stream.id), next) && unify(goal.args[1], property, next)) {
      state.pending = index + 1 < candidates.length;
      yield next;
    }
  }
  state.pending = false;
}

function inputStreamFor(solver, goal, env) {
  return goal.arity === 1 ? solver.io.resolve(solver.io.currentInput) : requireStream(solver, goal.args[0], env, 'read');
}
function outputStreamFor(solver, goal, env) {
  return goal.arity === 1 ? solver.io.resolve(solver.io.currentOutput) : requireStream(solver, goal.args[0], env, 'write');
}
function* atEndBuiltin({ solver, goal, env }) {
  // at_end_of_stream/1 is bootstrapped in Part 1 from the end_of_stream/1
  // stream property and therefore accepts any open stream-or-alias; it is not
  // an input-only operation.
  const stream = goal.arity === 0 ? solver.io.resolve(solver.io.currentInput) : requireStream(solver, goal.args[0], env);
  if (streamEndState(stream) !== 'not') yield env;
}
function validStrictInputCharacterCode(value, solver) {
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) return false;
  const code = BigInt(value.name);
  if (code === -1n) return true;
  if (code < 0n || code > 0x10ffffn || (code >= 0xd800n && code <= 0xdfffn)) return false;
  return !solver.isoStrict || isStrictIsoPcsCodePoint(Number(code));
}

function preflightInputUnitTarget(name, target, env, solver) {
  const value = deref(target, env);
  if (name.endsWith('char')) {
    if (value.type !== VAR && !(oneChar(value) || (value.type === ATOM && value.name === 'end_of_file'))) {
      throw new PrologError('type_error(in_character)', value);
    }
    if (value.type === ATOM && oneChar(value) && solver.isoStrict && !isStrictIsoPcsCharacter(value.name)) {
      throw new PrologError('type_error(in_character)', value);
    }
  } else if (name.endsWith('code')) {
    // Keep the selected 8.12 overlap behavior stable: integer type validation
    // is done here, while the in-character-code repertoire check is deferred
    // until after stream/entity diagnostics. ISO 7.12 permits this processor
    // choice when those error conditions overlap.
    if (value.type !== VAR && (value.type !== NUMBER || !isDecimalInteger(value.name))) {
      throw new PrologError('type_error(integer)', value);
    }
  } else {
    if (value.type !== VAR) {
      if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(in_byte)', value);
      const byte = BigInt(value.name);
      if (byte !== -1n && (byte < 0n || byte > 255n)) throw new PrologError('type_error(in_byte)', value);
    }
  }
  return value;
}

function inputUnitBuiltin(name) {
  return function* ({ solver, goal, env }) {
    const explicit = goal.arity === 2;
    if (explicit && deref(goal.args[0], env).type === VAR) throw new PrologError('instantiation_error');
    const target = goal.args[goal.arity - 1];
    preflightInputUnitTarget(name, target, env, solver);
    const stream = inputStreamFor(solver, goal, env);
    const binary = name.endsWith('byte');
    if (binary && stream.type !== 'binary') {
      throw new PrologError('permission_error(input, text_stream)', streamHandle(stream.id));
    }
    if (!binary && stream.type !== 'text') {
      throw new PrologError('permission_error(input, binary_stream)', streamHandle(stream.id));
    }
    if (stream.pastEnd && stream.eofAction === 'error') {
      throw new PrologError('permission_error(input, past_end_of_stream)', streamHandle(stream.id));
    }
    if (stream.pastEnd && stream.eofAction === 'reset') {
      if (typeof stream.interactiveReadUnit !== 'function') stream.position = 0;
      stream.pastEnd = false;
    }
    const peek = name.startsWith('peek');
    if (stream.position >= stream.content.length && typeof stream.interactiveReadUnit === 'function') {
      solver.io.refill(stream);
    }
    let unit;
    try {
      unit = solver.io.readUnit(stream, peek);
    } catch (error) {
      if (error?.name === 'InvalidCharacterEncodingError') throw new PrologError('representation_error(character)');
      throw error;
    }
    if (unit == null && !peek) stream.pastEnd = true;
    if (!binary && unit != null && solver.isoStrict && !isStrictIsoPcsCharacter(unit)) {
      throw new PrologError('representation_error(character)');
    }
    // EyeProlog deliberately defers this representation check until after
    // stream and input-entity diagnostics. ISO 7.12 permits that deterministic
    // choice when several 8.12 error conditions hold simultaneously.
    const targetValue = deref(target, env);
    if (name.endsWith('code') && targetValue.type !== VAR &&
        !validStrictInputCharacterCode(targetValue, solver)) {
      throw new PrologError('representation_error(in_character_code)');
    }
    const result = unit == null
      ? (binary ? numberTerm(-1) : name.endsWith('code') ? numberTerm(-1) : atom('end_of_file'))
      : binary ? numberTerm(unit) : name.endsWith('code') ? numberTerm(unit.codePointAt(0)) : atom(unit);
    const next = env.clone();
    if (unify(target, result, next)) yield next;
  };
}

function preflightOutputUnitValue(name, target, env) {
  const value = deref(target, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (name === 'put_char') {
    if (!oneChar(value)) throw new PrologError('type_error(character)', value);
    return value;
  }
  if (name === 'put_byte') {
    if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(byte)', value);
    const byte = BigInt(value.name);
    if (byte < 0n || byte > 255n) throw new PrologError('type_error(byte)', value);
    return value;
  }
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(integer)', value);
  return value;
}

function outputUnitBuiltin(name) {
  return function* ({ solver, goal, env }) {
    const explicit = goal.arity === 2;
    if (explicit && deref(goal.args[0], env).type === VAR) throw new PrologError('instantiation_error');
    const value = preflightOutputUnitValue(name, goal.args[goal.arity - 1], env);
    const stream = outputStreamFor(solver, goal, env);
    if (name === 'put_char') {
      if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
      if (solver.isoStrict && !isStrictIsoPcsCharacter(value.name)) {
        throw new PrologError('representation_error(character)', value);
      }
      solver.io.writeUnit(stream, value.name);
    } else if (name === 'put_byte') {
      if (stream.type !== 'binary') throw new PrologError('permission_error(output, text_stream)', streamHandle(stream.id));
      solver.io.writeUnit(stream, Number(value.name));
    } else {
      if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
      const code = BigInt(value.name);
      if (code < 0n || code > 0x10ffffn || (code >= 0xd800n && code <= 0xdfffn)) {
        throw new PrologError('representation_error(character_code)');
      }
      if (solver.isoStrict && !isStrictIsoPcsCodePoint(Number(code))) {
        throw new PrologError('representation_error(character_code)');
      }
      solver.io.writeUnit(stream, String.fromCodePoint(Number(code)));
    }
    yield env;
  };
}

function* nlBuiltin({ solver, goal, env }) {
  const stream = goal.arity === 0
    ? solver.io.resolve(solver.io.currentOutput)
    : requireStream(solver, goal.args[0], env, 'write');
  if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
  solver.io.writeUnit(stream, '\n');
  yield env;
}

function activeCharConverter(solver) {
  if (solver.prologFlags.get('char_conversion')?.value?.name !== 'on' || solver.charConversions.size === 0) {
    return null;
  }
  return (character) => solver.charConversions.get(character) ?? character;
}

function* termTextCandidates(stream, solver) {
  const source = String(stream.content);
  const convert = activeCharConverter(solver);
  let quote = null, lineComment = false, blockComment = false;
  for (let i = stream.position; i < source.length; i++) {
    const ch = source[i], next = source[i + 1];
    // The PCS is shared by normal and strict modes (issue #67). UTF-16
    // source indexing here must not reject one half of a supplementary scalar.
    // Character/code predicates validate scalar boundaries where a character
    // value is actually required.
    // Text streams preserve invalid UTF-8 bytes as an impossible Unicode
    // sentinel.  read/1-2 and read_term/2-3 must surface the same character
    // representation error as get_char/1-2 instead of misclassifying the
    // undecodable byte as malformed Prolog syntax (issue #64).
    if (stream.strictUtf8 && ch === INVALID_UTF8_SENTINEL) {
      throw new PrologError('representation_error(character)');
    }
    if (lineComment) { if (ch === '\n') lineComment = false; continue; }
    if (blockComment) { if (ch === '*' && next === '/') { blockComment = false; i++; } continue; }
    if (quote) {
      if (ch === '\\') i = quotedEscapeEnd(source, i);
      else if (ch !== ' ' && /^[\u0000-\u001f\u007f]$/.test(ch)) {
        // Literal layout characters are not quoted characters (6.4.2.1).
        // Surface the lexical error immediately even when there is no later
        // full stop; otherwise read/1 would misreport malformed input as EOF.
        yield { text: source.slice(stream.position, i + 1), end: i + 1, lexicalError: true };
        return;
      }
      else if (ch === quote && next === quote) i++;
      else if (ch === quote) quote = null;
      continue;
    }
    const characterCodeEnd = characterCodeConstantEnd(source, i);
    if (characterCodeEnd != null) { i = characterCodeEnd; continue; }
    if (ch === '%') { lineComment = true; continue; }
    // Comment openers are recognized between tokens. Within a maximal
    // graphic token, as in `//*`, the slash and star remain atom characters.
    if (ch === '/' && next === '*' && !continuesGraphicToken(source, i)) {
      blockComment = true;
      i++;
      continue;
    }
    if (ch === "'" || ch === '"') { quote = ch; continue; }
    if (isTerminatingFullStop(source, i, convert)) {
      yield { text: source.slice(stream.position, i + 1), end: i + 1 };
    }
  }
}
function hasNonLayoutRemainder(source, start) {
  return lastNonLayoutIndex(source, start) >= start;
}
function lastNonLayoutIndex(source, start = 0) {
  const ignored = /[\u0000-\u0020\u007f]+|%[^\n]*(?:\n|$)|\/\*[\s\S]*?\*\//g;
  ignored.lastIndex = start;
  let cursor = start;
  let last = -1;
  for (let match = ignored.exec(source); match != null; match = ignored.exec(source)) {
    if (match.index > cursor) last = match.index - 1;
    cursor = match.index + match[0].length;
  }
  if (cursor < source.length) last = source.length - 1;
  return last;
}
function convertedTermText(text, solver) {
  if (solver.prologFlags.get('char_conversion')?.value?.name !== 'on' || solver.charConversions.size === 0) return text;
  let result = '', quote = null;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i], next = text[i + 1];
    if (quote) {
      result += ch;
      if (ch === '\\') {
        const end = quotedEscapeEnd(text, i);
        if (end > i) result += text.slice(i + 1, end + 1);
        i = end;
      } else if (ch === quote && next === quote) {
        result += next;
        i++;
      } else if (ch === quote) {
        quote = null;
      }
    } else if (ch === "'" || ch === '"') {
      quote = ch;
      result += ch;
    } else {
      result += solver.charConversions.get(ch) ?? ch;
    }
  }
  return result;
}

function scopeReadTerm(term) {
  // A term read from a stream has its own variable set (ISO 7.10.3).  Parser
  // variable names cannot be used as environment identities here: a caller
  // such as read(X) and an input term X=a would otherwise share the same `X`
  // and incorrectly attempt the cyclic unification X=(X=a).  Use an internal
  // name containing NUL, which cannot occur in Prolog source, while retaining
  // the spelling and occurrence count required by read_term/3 metadata.
  const scope = ++isoFresh;
  const bySourceName = new Map();
  const variables = [];

  const copy = (item) => {
    if (item.type === VAR) {
      let record = bySourceName.get(item.name);
      if (record == null) {
        const scoped = variable(`\u0000read:${scope}:${variables.length}`);
        scoped.displayName = item.name;
        record = {
          sourceName: item.name,
          term: scoped,
          count: 0,
          anonymous: item.name.startsWith('__anon'),
        };
        bySourceName.set(item.name, record);
        variables.push(record);
      }
      record.count++;
      return record.term;
    }
    if (item.type !== COMPOUND) return item;
    return compound(item.name, item.args.map(copy));
  };

  return { term: copy(term), variables };
}

function parseReadTermText(text, solver) {
  const converted = convertedTermText(text, solver);
  // A standalone number needs no general term parser or operator tables.
  // Reuse the same bounded numeric scanner as number_chars/2 so stream reads
  // and number conversion agree on every accepted numeric token. The stream
  // scanner has already established that the final full stop is a candidate
  // terminator; trim only ISO layout immediately before that terminator.
  const numericText = converted.slice(0, -1).replace(/[\u0009-\u000d\u0020]+$/, '');
  let numericTerm;
  try {
    numericTerm = parseIsoNumber(numericText, { isoStrict: solver.isoStrict });
  } catch (error) {
    // parseIsoNumber/1 exposes Prolog errors to number_chars/2. The stream
    // reader's candidate loop instead recognizes parser representation errors
    // and must not reinterpret overflow as a later syntax error.
    if (error instanceof PrologError) throw new NumberRepresentationError(error.formal);
    throw error;
  }
  if (numericTerm != null) return numericTerm;

  const operatorState = createParserOperatorState(solver.program.operators.values(), false);
  return parseTermText(converted, {
    operatorState,
    isoStrict: solver.isoStrict,
    doubleQuotes: solver.prologFlags.get('double_quotes')?.value?.name ?? 'chars',
    // The stream scanner supplies one candidate ending at this full stop.
    // Earlier ambiguous dots must remain available to maximal graphic tokens.
    readTermEnd: converted.length - 1,
  });
}

export function isCompleteReadTermText(text, solver) {
  try {
    parseReadTermText(text, solver);
    return true;
  } catch (_) {
    return false;
  }
}

function readTermFromStream(stream, solver) {
  if (stream.pastEnd && stream.eofAction === 'error') {
    throw new PrologError('permission_error(input, past_end_of_stream)', streamHandle(stream.id));
  }
  if (stream.pastEnd && stream.eofAction === 'reset') {
    if (typeof stream.interactiveReadTerm !== 'function') stream.position = 0;
    stream.pastEnd = false;
  }
  let requestedInteractiveTerm = false;
  while (true) {
    let sawCandidate = false;
    let lastCandidateEnd = stream.position;
    try {
      for (const candidate of termTextCandidates(stream, solver)) {
        sawCandidate = true;
        lastCandidateEnd = candidate.end;
        if (candidate.lexicalError) {
          stream.position = candidate.end;
          throw new PrologError('syntax_error(read_term)');
        }
        try {
          const term = parseReadTermText(candidate.text, solver);
          stream.position = candidate.end;
          return scopeReadTerm(term);
        } catch (error) {
          if (error instanceof NumberRepresentationError || error instanceof CharacterRepresentationError) {
            throw new PrologError(error.formal);
          }
          // A dot inside a graphic operator, such as =.., is only a possible
          // terminator. Keep scanning until a complete term parses.
        }
      }
    } catch (error) {
      // A synthetic input boundary uses an invalid-character sentinel after
      // the required peek character. If a complete candidate already ended
      // at that boundary but did not parse, the term itself is malformed;
      // consume it and report syntax_error rather than blaming the sentinel.
      if (sawCandidate && Number.isInteger(stream.syntheticInputBoundary) &&
          lastCandidateEnd === stream.syntheticInputBoundary && error?.name === 'PrologError' &&
          error.formal === 'representation_error(character)') {
        stream.position = lastCandidateEnd;
        throw new PrologError('syntax_error(read_term)');
      }
      throw error;
    }

    // Streams backed by a synchronous refill hook (for example TCP sockets)
    // may need more input before the current term becomes complete. Refill and
    // rescan until a complete term is available or the underlying stream ends.
    if (stream.continuousRefill === true && typeof stream.interactiveReadUnit === 'function' && stream.remoteEnded !== true) {
      if (solver.io.refill(stream)) continue;
    }

    // The interactive top level may attach a synchronous reader to the
    // standard user_input stream. Ask it for one complete read-term only when
    // this read operation actually reaches the end of buffered input. This is
    // deliberately a stream hook, not goal-shape recognition, so conjunctions
    // and reads reached through user predicates behave the same as read/1.
    if (!sawCandidate && !requestedInteractiveTerm &&
        typeof stream.interactiveReadTerm === 'function') {
      requestedInteractiveTerm = true;
      const text = stream.interactiveReadTerm();
      if (text != null) {
        stream.content += String(text);
        stream.pastEnd = false;
        continue;
      }
    }

    const source = String(stream.content);
    const remainderStart = stream.position;
    stream.position = source.length;
    if (!sawCandidate) {
      if (hasNonLayoutRemainder(source, remainderStart)) throw new PrologError('syntax_error(read_term)');
      stream.pastEnd = true;
      return { term: atom('end_of_file'), variables: [] };
    }
    throw new PrologError('syntax_error(read_term)');
  }
}

function* readBuiltin({ solver, goal, env }) {
  const stream = inputStreamFor(solver, goal, env);
  if (stream.type !== 'text') throw new PrologError('permission_error(input, binary_stream)', streamHandle(stream.id));
  const next = env.clone();
  const { term } = readTermFromStream(stream, solver);
  if (unify(goal.args[goal.arity - 1], term, next)) yield next;
}
function validateReadOptions(options) {
  for (const option of options) {
    if (option.type !== COMPOUND || option.arity !== 1 ||
        !['variables', 'variable_names', 'singletons'].includes(option.name)) {
      throw new PrologError('domain_error(read_option)', option);
    }
  }
}

function* readTermBuiltin({ solver, goal, env }) {
  const optionTerm = goal.args[goal.arity - 1];
  const streamTerm = goal.arity === 3 ? deref(goal.args[0], env) : null;

  // EyeProlog's selected 8.14.1.3 overlap order. Each listed error condition
  // is covered independently; 7.12 makes simultaneous-error selection
  // implementation dependent unless another procedural requirement constrains it.
  if (streamTerm?.type === VAR) throw new PrologError('instantiation_error');
  const preflight = preflightOptionList(optionTerm, env);
  if (goal.arity === 3) streamReference(goal.args[0], env);
  const options = requireProperOptionList(preflight);
  validateReadOptions(options);

  const stream = goal.arity === 2
    ? solver.io.resolve(solver.io.currentInput)
    : requireStream(solver, goal.args[0], env, 'read');
  if (stream.type !== 'text') throw new PrologError('permission_error(input, binary_stream)', streamHandle(stream.id));

  const target = goal.args[goal.arity - 2];
  const { term, variables } = readTermFromStream(stream, solver);
  const next = env.clone();
  if (!unify(target, term, next)) return;
  for (const option of options) {
    let value;
    if (option.name === 'variables') {
      value = listFromItems(variables.map((item) => item.term));
    } else if (option.name === 'variable_names') {
      value = listFromItems(variables
        .filter((item) => !item.anonymous)
        .map((item) => compound('=', [atom(item.sourceName), item.term])));
    } else {
      value = listFromItems(variables
        .filter((item) => !item.anonymous && item.count === 1)
        .map((item) => compound('=', [atom(item.sourceName), item.term])));
    }
    if (!unify(option.args[0], value, next)) return;
  }
  yield next;
}
function defaultTermWriteOptions(mode) {
  if (mode === 'writeq') return { quoted: true, ignoreOps: false, numbervars: true, variableNames: new Map(), compact: true, minimalOperatorSpacing: true, operatorAtomsAsArgs: true, doubleQuotes: null };
  if (mode === 'canonical') return { quoted: true, ignoreOps: true, numbervars: false, variableNames: new Map(), compact: true, minimalOperatorSpacing: true, operatorAtomsAsArgs: true, doubleQuotes: null };
  if (mode === 'write_term') return { quoted: false, ignoreOps: false, numbervars: false, variableNames: new Map(), compact: true, minimalOperatorSpacing: true, operatorAtomsAsArgs: true, doubleQuotes: null };
  return { quoted: false, ignoreOps: false, numbervars: true, variableNames: new Map(), compact: true, minimalOperatorSpacing: true, operatorAtomsAsArgs: true, doubleQuotes: null };
}

function writeOptionBoolean(value, env, option) {
  value = deref(value, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== ATOM || !['true', 'false'].includes(value.name)) {
    throw new PrologError('domain_error(write_option)', copyResolved(option, env));
  }
  return value.name === 'true';
}

function writeVariableNames(value, env, option) {
  value = deref(value, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  const items = properListItems(value, env);
  if (items == null) {
    if (isPartialList(value, env)) throw new PrologError('instantiation_error');
    throw new PrologError('domain_error(write_option)', copyResolved(option, env));
  }
  const names = new Map();
  for (const item of items) {
    const pair = deref(item, env);
    if (pair.type === VAR) throw new PrologError('instantiation_error');
    if (pair.type !== COMPOUND || pair.name !== '=' || pair.arity !== 2) {
      throw new PrologError('domain_error(write_option)', copyResolved(option, env));
    }
    const name = deref(pair.args[0], env);
    const target = deref(pair.args[1], env);
    if (name.type === VAR) throw new PrologError('instantiation_error');
    if (name.type !== ATOM) {
      throw new PrologError('domain_error(write_option)', copyResolved(option, env));
    }
    // Corrigendum 3 permits any term on the right. Only variables can name a
    // variable being written; retain the leftmost applicable entry.
    if (target.type === VAR && !names.has(target.name)) names.set(target.name, name.name);
  }
  return names;
}

function termWriteOptionsFromItems(options, env, mode = 'write_term', solver = null) {
  const result = defaultTermWriteOptions(mode);
  for (const option of options) {
    if (option.type !== COMPOUND || option.arity !== 1) {
      throw new PrologError('domain_error(write_option)', copyResolved(option, env));
    }
    if (option.name === 'quoted') result.quoted = writeOptionBoolean(option.args[0], env, option);
    else if (option.name === 'ignore_ops') result.ignoreOps = writeOptionBoolean(option.args[0], env, option);
    else if (option.name === 'numbervars') result.numbervars = writeOptionBoolean(option.args[0], env, option);
    else if (option.name === 'variable_names') result.variableNames = writeVariableNames(option.args[0], env, option);
    else if (option.name === 'double_quotes' && !solver?.isoStrict) {
      result.doubleQuotes = writeOptionBoolean(option.args[0], env, option);
    } else if (option.name === 'spacing' && !solver?.isoStrict) {
      result.minimalOperatorSpacing = !writeOptionBoolean(option.args[0], env, option);
    } else {
      throw new PrologError('domain_error(write_option)', copyResolved(option, env));
    }
  }
  return result;
}


function writeBuiltin(mode) {
  return function* ({ solver, goal, env }) {
    const stream = outputStreamFor(solver, goal, env);
    if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
    const options = defaultTermWriteOptions(mode);
    solver.io.writeUnit(stream, formatTermForWrite(goal.args[goal.arity - 1], env, {
      ...options,
      generateVariableNames: true,
      variableNameState: solver.writeVariableState,
      operators: solver.program.operators.values(),
      doubleBar: !solver.isoStrict,
    }));
    yield env;
  };
}
function* writeTermBuiltin({ solver, goal, env }) {
  const optionTerm = goal.args[goal.arity - 1];
  const streamTerm = goal.arity === 3 ? deref(goal.args[0], env) : null;

  // EyeProlog's selected 8.14.2.3 overlap order. Each listed error condition
  // is covered independently; 7.12 makes simultaneous-error selection
  // implementation dependent unless another procedural requirement constrains it.
  if (streamTerm?.type === VAR) throw new PrologError('instantiation_error');
  const preflight = preflightOptionList(optionTerm, env);
  const optionItems = requireProperOptionList(preflight);
  if (goal.arity === 3) streamReference(goal.args[0], env);
  const options = termWriteOptionsFromItems(optionItems, env, 'write_term', solver);

  const stream = goal.arity === 2
    ? solver.io.resolve(solver.io.currentOutput)
    : requireStream(solver, goal.args[0], env, 'write');
  if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
  if (options.doubleQuotes === true) {
    options.doubleQuotes = solver.prologFlags.get('double_quotes')?.value?.name ?? 'chars';
  } else {
    options.doubleQuotes = null;
  }
  solver.io.writeUnit(stream, formatTermForWrite(goal.args[goal.arity - 2], env, {
    ...options,
    generateVariableNames: true,
    variableNameState: solver.writeVariableState,
    operators: solver.program.operators.values(),
    doubleBar: !solver.isoStrict,
  }));
  yield env;
}

function resolvedOrVariable(term, env, expected) {
  const value = deref(term, env);
  if (value.type !== VAR && value.type !== expected) {
    throw new PrologError(`type_error(${expected === ATOM ? 'atom' : 'number'})`, value);
  }
  return value;
}

function characters(text) {
  return Array.from(text);
}

function* atomLengthBuiltin({ goal, env }) {
  const value = deref(goal.args[0], env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== ATOM) throw new PrologError('type_error(atom)', value);
  const length = deref(goal.args[1], env);
  if (length.type !== VAR && (length.type !== NUMBER || !isDecimalInteger(length.name))) {
    throw new PrologError('type_error(integer)', length);
  }
  if (length.type === NUMBER && BigInt(length.name) < 0n) {
    throw new PrologError('domain_error(not_less_than_zero)', length);
  }
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(characters(value.name).length), next)) yield next;
}

function atomConcatBuiltin(context) {
  const state = { pending: false };
  return withPendingState(atomConcatSolutions(context, state), state);
}

function* atomConcatSolutions({ goal, env }, state) {
  const first = deref(goal.args[0], env);
  const second = deref(goal.args[1], env);
  const whole = deref(goal.args[2], env);
  // ISO 8.16.2.3 puts the two under-instantiation modes ahead of all atom
  // type diagnostics.
  if (first.type === VAR && whole.type === VAR) throw new PrologError('instantiation_error');
  if (second.type === VAR && whole.type === VAR) throw new PrologError('instantiation_error');
  if (first.type !== VAR && first.type !== ATOM) throw new PrologError('type_error(atom)', first);
  if (second.type !== VAR && second.type !== ATOM) throw new PrologError('type_error(atom)', second);
  if (whole.type !== VAR && whole.type !== ATOM) throw new PrologError('type_error(atom)', whole);

  const candidates = [];
  if (whole.type === ATOM && first.type === VAR && second.type === VAR) {
    const chars = characters(whole.name);
    for (let i = 0; i <= chars.length; i++) candidates.push([chars.slice(0, i).join(''), chars.slice(i).join(''), whole.name]);
  } else if (first.type === ATOM && second.type === ATOM) {
    candidates.push([first.name, second.name, first.name + second.name]);
  } else if (first.type === ATOM && whole.type === ATOM && whole.name.startsWith(first.name)) {
    candidates.push([first.name, whole.name.slice(first.name.length), whole.name]);
  } else if (second.type === ATOM && whole.type === ATOM && whole.name.endsWith(second.name)) {
    candidates.push([whole.name.slice(0, whole.name.length - second.name.length), second.name, whole.name]);
  }
  for (let index = 0; index < candidates.length; index++) {
    const [a, b, c] = candidates[index];
    const next = env.clone();
    if (unify(goal.args[0], atom(a), next) && unify(goal.args[1], atom(b), next) &&
        unify(goal.args[2], atom(c), next)) {
      state.pending = index + 1 < candidates.length;
      yield next;
    }
  }
  state.pending = false;
}

function optionalInteger(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) return null;
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(integer)', value);
  return BigInt(value.name);
}

function subAtomBuiltin(context) {
  const state = { pending: false };
  return withPendingState(subAtomSolutions(context, state), state);
}

function* subAtomSolutions({ goal, env }, state) {
  const source = deref(goal.args[0], env);
  if (source.type === VAR) throw new PrologError('instantiation_error');
  if (source.type !== ATOM) throw new PrologError('type_error(atom)', source);
  const sub = deref(goal.args[4], env);
  if (sub.type !== VAR && sub.type !== ATOM) throw new PrologError('type_error(atom)', sub);
  // ISO 8.16.3.3 prescribes all type checks before the non-negative domain
  // checks, in Before/Length/After order.
  const before = optionalInteger(goal.args[1], env);
  const length = optionalInteger(goal.args[2], env);
  const after = optionalInteger(goal.args[3], env);
  if (before != null && before < 0n) {
    throw new PrologError('domain_error(not_less_than_zero)', deref(goal.args[1], env));
  }
  if (length != null && length < 0n) {
    throw new PrologError('domain_error(not_less_than_zero)', deref(goal.args[2], env));
  }
  if (after != null && after < 0n) {
    throw new PrologError('domain_error(not_less_than_zero)', deref(goal.args[3], env));
  }
  const chars = characters(source.name);
  let starts;
  if (before != null) {
    starts = before <= BigInt(chars.length) ? [Number(before)] : [];
  } else if (length != null && after != null) {
    const onlyStart = BigInt(chars.length) - length - after;
    starts = onlyStart >= 0n ? [Number(onlyStart)] : [];
  } else {
    const maximumStart = length != null
      ? BigInt(chars.length) - length
      : after != null ? BigInt(chars.length) - after : BigInt(chars.length);
    starts = maximumStart < 0n
      ? []
      : Array.from({ length: Number(maximumStart) + 1 }, (_, index) => index);
  }
  for (let startIndex = 0; startIndex < starts.length; startIndex++) {
    const start = starts[startIndex];
    let sizes;
    if (length != null) {
      sizes = length <= BigInt(chars.length - start) ? [Number(length)] : [];
    } else if (after != null) {
      const onlySize = BigInt(chars.length - start) - after;
      sizes = onlySize >= 0n ? [Number(onlySize)] : [];
    } else {
      sizes = Array.from({ length: chars.length - start + 1 }, (_, index) => index);
    }
    for (let sizeIndex = 0; sizeIndex < sizes.length; sizeIndex++) {
      const size = sizes[sizeIndex];
      const remaining = chars.length - start - size;
      if (after != null && after !== BigInt(remaining)) continue;
      const text = chars.slice(start, start + size).join('');
      if (sub.type === ATOM && sub.name !== text) continue;
      const next = env.clone();
      if (unify(goal.args[1], numberTerm(start), next) &&
          unify(goal.args[2], numberTerm(size), next) &&
          unify(goal.args[3], numberTerm(remaining), next) &&
          unify(goal.args[4], atom(text), next)) {
        state.pending = sizeIndex + 1 < sizes.length || startIndex + 1 < starts.length;
        yield next;
      }
    }
  }
  state.pending = false;
}

function listElements(term, env) {
  const items = [];
  let cursor = deref(term, env);
  while (cursor.type === COMPOUND && cursor.name === '.' && cursor.arity === 2) {
    items.push(deref(cursor.args[0], env));
    cursor = deref(cursor.args[1], env);
  }
  return { items, tail: cursor };
}

function oneChar(value) {
  return value.type === ATOM && characters(value.name).length === 1;
}

function validCharacterCode(value, solver = null) {
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) return false;
  const code = BigInt(value.name);
  if (code < 0n || code > 0x10ffffn || (code >= 0xd800n && code <= 0xdfffn)) return false;
  return !solver?.isoStrict || isStrictIsoPcsCodePoint(Number(code));
}

function listToAtomInput(list, env, kind, solver = null) {
  const whole = deref(list, env);
  const { items, tail } = listElements(list, env);
  // Corrigendum 2 distinguishes a partial list from an improper one: only
  // the former precedes the complete-list type check. Variables in a proper
  // list prefix are checked after that list-shape diagnostic.
  if (tail.type === VAR) throw new PrologError('instantiation_error');
  if (tail.type !== ATOM || tail.name !== '[]') throw new PrologError('type_error(list)', whole);
  if (items.some((item) => item.type === VAR)) throw new PrologError('instantiation_error');
  if (kind === 'chars') {
    const invalid = items.find((item) => !oneChar(item));
    if (invalid) throw new PrologError('type_error(character)', invalid);
    if (solver?.isoStrict) {
      const outsidePcs = items.find((item) => !isStrictIsoPcsCharacter(item.name));
      if (outsidePcs) throw new PrologError('representation_error(character)', outsidePcs);
    }
    return items.map((item) => item.name).join('');
  }
  const nonInteger = items.find((item) => item.type !== NUMBER || !isDecimalInteger(item.name));
  if (nonInteger) throw new PrologError('type_error(integer)', nonInteger);
  const invalid = items.find((item) => !validCharacterCode(item, solver));
  if (invalid) throw new PrologError('representation_error(character_code)');
  return items.map((item) => String.fromCodePoint(Number(item.name))).join('');
}

function atomListBuiltin(kind) {
  return function* ({ solver, goal, env }) {
    const value = deref(goal.args[0], env);
    if (value.type !== VAR && value.type !== ATOM) throw new PrologError('type_error(atom)', value);
    const list = deref(goal.args[1], env);
    if (value.type === VAR && list.type === VAR) throw new PrologError('instantiation_error');
    const next = env.clone();
    if (value.type === ATOM) {
      const { items: supplied, tail } = listElements(list, env);
      if (tail.type !== VAR && !(tail.type === ATOM && tail.name === '[]')) {
        throw new PrologError('type_error(list)', list);
      }
      const invalid = supplied.find((item) => item.type !== VAR &&
        (kind === 'chars' ? !oneChar(item) :
          item.type !== NUMBER || !isDecimalInteger(item.name) || !validCharacterCode(item, solver)));
      if (invalid) {
        if (kind === 'chars') throw new PrologError('type_error(character)', invalid);
        if (invalid.type !== NUMBER || !isDecimalInteger(invalid.name)) {
          throw new PrologError('type_error(integer)', invalid);
        }
        throw new PrologError('representation_error(character_code)');
      }
      if (solver.isoStrict && characters(value.name).some((ch) => !isStrictIsoPcsCharacter(ch))) {
        throw new PrologError('representation_error(character)', value);
      }
      const items = characters(value.name).map((ch) =>
        kind === 'chars' ? atom(ch) : numberTerm(ch.codePointAt(0)));
      if (unify(goal.args[1], listFromItems(items), next)) yield next;
      return;
    }
    if (unify(goal.args[0], atom(listToAtomInput(list, env, kind, solver)), next)) yield next;
  };
}
const atomCharsBuiltin = atomListBuiltin('chars');
const atomCodesBuiltin = atomListBuiltin('codes');

function* charCodeBuiltin({ solver, goal, env }) {
  const char = deref(goal.args[0], env);
  const code = deref(goal.args[1], env);
  if (char.type === VAR && code.type === VAR) throw new PrologError('instantiation_error');
  if (char.type !== VAR && !oneChar(char)) throw new PrologError('type_error(character)', char);
  if (char.type === ATOM && solver.isoStrict && !isStrictIsoPcsCharacter(char.name)) {
    throw new PrologError('representation_error(character)', char);
  }
  if (code.type !== VAR && (code.type !== NUMBER || !isDecimalInteger(code.name))) {
    throw new PrologError('type_error(integer)', code);
  }
  if (code.type !== VAR && !validCharacterCode(code, solver)) throw new PrologError('representation_error(character_code)');
  const next = env.clone();
  if (char.type === ATOM) {
    if (unify(goal.args[1], numberTerm(char.name.codePointAt(0)), next)) yield next;
  } else if (unify(goal.args[0], atom(String.fromCodePoint(Number(code.name))), next)) yield next;
}

function skipNumberLayout(text, start) {
  let position = start;
  while (true) {
    while (position < text.length && /[\u0000-\u0020\u007f]/.test(text[position])) {
      position++;
    }
    if (text[position] === '%') {
      const newline = text.indexOf('\n', position + 1);
      if (newline < 0) return text.length;
      position = newline + 1;
      continue;
    }
    if (text.startsWith('/*', position)) {
      const end = text.indexOf('*/', position + 2);
      if (end < 0) return text.length;
      position = end + 2;
      continue;
    }
    return position;
  }
}

function quotedNumberSign(text, start) {
  if (text[start] !== "'") return null;
  let position = start + 1;
  let value = '';
  while (position < text.length) {
    let character = text[position++];
    if (character === "'") {
      if (text[position] === "'") {
        position++;
        value += "'";
        continue;
      }
      return { value, position };
    }
    if (character !== '\\') {
      value += character;
      continue;
    }
    if (position >= text.length) return null;
    character = text[position++];
    if (character === '\n') continue;
    const controls = { a: '\x07', b: '\b', r: '\r', f: '\f', t: '\t', n: '\n', v: '\v' };
    if (controls[character] != null) {
      value += controls[character];
      continue;
    }
    value += character;
  }
  return null;
}

function parseIsoNumber(text, options = {}) {
  if (text.length === 0) return null;
  let position = skipNumberLayout(text, 0);
  let sign = '';

  if (text[position] === '-') {
    const next = text[position + 1] ?? '';
    // Every token class may carry leading layout (6.4).  Thus a negative
    // number may have layout between the name `-` and its numeric token.  A
    // `%...\n` comment can start immediately after `-` because `%` cannot
    // continue a graphic name token.  In contrast `/*...*/` cannot start
    // there without separating layout: `/` *can* continue the graphic token,
    // and the eager-consumer rule therefore keeps `-/**/1` ill-formed (the
    // number_chars continuation corpus case 24).
    if (/[\u0000-\u0020\u007f]/.test(next) || next === '%') {
      position = skipNumberLayout(text, position + 1);
      sign = '-';
    }
  } else {
    const quoted = quotedNumberSign(text, position);
    if (quoted?.value === '-') {
      position = skipNumberLayout(text, quoted.position);
      sign = '-';
    }
  }

  const numericText = `${sign}${text.slice(position)}`;
  // 8.16.7/8.16.8 parse the character sequence according to the syntax rules
  // for numbers and negative numbers (6.3.1.1/6.3.1.2), not as an arbitrary
  // term whose value happens to be numeric. Every such number starts with a
  // decimal digit after an optional negative sign, so parenthesized terms such
  // as `(0)` or `-(0)` must be rejected before the general term parser sees
  // them. This keeps the parser reuse below from admitting grouping syntax.
  if (!/^-?\d/.test(numericText)) return null;
  // ISO floating-point syntax requires a decimal fraction before an exponent.
  if (/^-?\d+[eE][+-]?\d+$/.test(numericText)) return null;
  try {
    const value = parseNumberTokenText(numericText, options);
    if (isDecimalInteger(value.name)) return numberTerm(BigInt(value.name).toString());
    const finite = Number(value.name);
    if (!Number.isFinite(finite)) return null;
    return numberTerm(numberTextFromDouble(finite));
  } catch (error) {
    if (error instanceof NumberRepresentationError) throw new PrologError(error.formal);
    return null;
  }
}

function sameNumber(left, right) {
  return sameNumberValue(left.name, right.name);
}

function canonicalNumberText(value) {
  if (isDecimalInteger(value.name)) return BigInt(value.name).toString();
  const finite = Number(value.name);
  // ISO 13211-1 has a single floating-point zero: a source spelling with a
  // minus sign does not denote a distinct -0.0 value.  Generate the same
  // character sequence for both spellings so converting that sequence back
  // cannot make number_chars/2 change its own subsequent output.
  if (finite === 0) return '0.0';
  if (Number.isFinite(finite) && /^-?\d+\.\d+(?:[eE][+-]?\d+)?$/.test(value.name)) {
    return value.name;
  }
  const text = numberTextFromDouble(finite);
  if (text == null) throw new PrologError(floatRepresentationErrorFormal(value.name));
  return text;
}

function numberListText(list, env, kind, valueIsBound, solver = null) {
  const whole = deref(list, env);
  const { items, tail } = listElements(list, env);
  const proper = tail.type === ATOM && tail.name === '[]';
  // Corrigendum 2 orders conversion-mode instantiation errors specially:
  // a partial list is diagnosed before its fixed prefix, while an improper
  // non-list is diagnosed before a variable element in that prefix.
  if (!valueIsBound && tail.type === VAR) throw new PrologError('instantiation_error');
  if (tail.type !== VAR && !proper) throw new PrologError('type_error(list)', whole);
  if (!valueIsBound && items.some((item) => item.type === VAR)) {
    throw new PrologError('instantiation_error');
  }

  const invalid = items.find((item) => item.type !== VAR &&
    (kind === 'chars' ? !oneChar(item) : !validCharacterCode(item, solver)));
  if (invalid) {
    if (kind === 'chars') throw new PrologError('type_error(character)', invalid);
    if (invalid.type !== NUMBER || !isDecimalInteger(invalid.name)) {
      throw new PrologError('type_error(integer)', invalid);
    }
    throw new PrologError('representation_error(character_code)');
  }

  const hasVariable = tail.type === VAR || items.some((item) => item.type === VAR);
  if (hasVariable) return null;
  return items.map((item) => kind === 'chars'
    ? item.name
    : String.fromCodePoint(Number(item.name))).join('');
}

const numberSyntaxError = new PrologError('syntax_error(number)');

function numberListBuiltin(kind) {
  return function* ({ solver, goal, env }) {
    const value = deref(goal.args[0], env);
    if (value.type !== VAR && value.type !== NUMBER) throw new PrologError('type_error(number)', value);
    const list = deref(goal.args[1], env);
    if (value.type === VAR && list.type === VAR) throw new PrologError('instantiation_error');
    const text = numberListText(list, env, kind, value.type === NUMBER, solver);
    if (value.type === NUMBER) {
      if (text != null) {
        const parsed = parseIsoNumber(text, { isoStrict: solver?.isoStrict === true });
        if (parsed == null) throw numberSyntaxError;
        if (sameNumber(value, parsed)) yield env.clone();
        return;
      }
      const items = characters(canonicalNumberText(value)).map((ch) =>
        kind === 'chars' ? atom(ch) : numberTerm(ch.codePointAt(0)));
      const next = env.clone();
      if (unify(goal.args[1], listFromItems(items), next)) yield next;
      return;
    }
    const parsed = parseIsoNumber(text, { isoStrict: solver?.isoStrict === true });
    if (parsed == null) throw numberSyntaxError;
    const next = env.clone();
    if (unify(goal.args[0], parsed, next)) yield next;
  };
}
const numberCharsBuiltin = numberListBuiltin('chars');
const numberCodesBuiltin = numberListBuiltin('codes');

class FindallListTerm {
  constructor(items, offset = 0) {
    this.type = COMPOUND;
    this.name = '.';
    this._items = items;
    this._offset = offset;
    this._compactLength = BigInt(items.length - offset);
    this._args = null;
  }
  get arity() { return 2; }
  get args() {
    if (this._args == null) {
      const next = this._offset + 1;
      this._args = [
        typeof this._items.get === 'function' ? this._items.get(this._offset) : this._items[this._offset],
        next >= this._items.length ? emptyList() : new FindallListTerm(this._items, next),
      ];
    }
    return this._args;
  }
}

class FlatCompoundFindallItems {
  constructor(template) {
    this.name = template.name;
    this.arity = template.arity;
    this.columns = Array.from({ length: this.arity }, () => []);
  }
  get length() {
    return this.arity === 0 ? 0 : this.columns[0].length;
  }
  push(template, env) {
    const values = new Array(this.arity);
    for (let i = 0; i < this.arity; i++) {
      const value = deref(template.args[i], env);
      if (value.type === VAR || value.type === COMPOUND) return false;
      values[i] = value;
    }
    for (let i = 0; i < this.arity; i++) this.columns[i].push(values[i]);
    return true;
  }
  get(index) {
    return compound(this.name, this.columns.map((column) => column[index]));
  }
  materialize() {
    const out = new Array(this.length);
    for (let i = 0; i < out.length; i++) out[i] = this.get(i);
    return out;
  }
}

function findallListFromItems(items) {
  return items.length === 0 ? emptyList() : new FindallListTerm(items);
}

function flatFindallTemplate(template) {
  return template.type === COMPOUND && template.arity > 0 &&
    template.args.every((arg) => arg.type !== COMPOUND)
    ? new FlatCompoundFindallItems(template)
    : null;
}

function* findallBuiltin({ solver, goal, env }) {
  const [template, innerGoal, bag] = goal.args;
  // EyeProlog validates Goal before Instances when both are erroneous. ISO 7.12
  // makes simultaneous-error selection implementation dependent; this order is
  // a documented/tested processor choice, not a blanket table-order rule.
  const invoked = callable(innerGoal, env);
  assertListOrPartial(bag, env);
  const collector = solver.cloneForInnerGoal(10000000);
  let compact = flatFindallTemplate(template);
  let collected = compact == null ? [] : null;
  for (const answerEnv of collector.solve([invoked], env.clone(), 0)) {
    if (compact != null && compact.push(template, answerEnv)) continue;
    if (compact != null) {
      collected = compact.materialize();
      compact = null;
    }
    collected.push(freshCopy(template, answerEnv));
  }
  solver.absorbStatsFrom(collector);
  const next = env.clone();
  if (unify(bag, findallListFromItems(compact ?? collected), next)) yield next;
}

function collectVariableNames(term, env, names = new Set()) {
  term = deref(term, env);
  if (term.type === VAR) {
    names.add(term.name);
  } else {
    for (const arg of term.args) collectVariableNames(arg, env, names);
  }
  return names;
}

function bagGoalParts(term, env) {
  const quantified = new Set();
  let iterated = deref(term, env);
  while (iterated.type === COMPOUND && iterated.name === '^' && iterated.arity === 2) {
    collectVariableNames(iterated.args[0], env, quantified);
    iterated = deref(iterated.args[1], env);
  }
  return { iterated: callable(iterated, env), quantified };
}

function assertListOrPartial(term, env) {
  if (properListItems(term, env) != null || isPartialList(term, env)) return;
  throw new PrologError('type_error(list)', deref(term, env));
}

function freeVariables(goal, template, quantified, env) {
  const templateNames = collectVariableNames(template, env);
  const goalNames = collectVariableNames(goal, env);
  return [...goalNames]
    .filter((name) => !templateNames.has(name) && !quantified.has(name))
    .map(variable);
}

function sameWitness(left, right) {
  return variantTerms(left, new Env(), right, new Env());
}

function sortedUnique(items) {
  const variableRanks = new Map();
  const compare = (left, right) => compareTerms(left, right, variableRanks);
  const sorted = [...items].sort(compare);
  return sorted.filter((item, index) => index === 0 || compare(sorted[index - 1], item) !== 0);
}

function allSolutionsBuiltin(asSet) {
  return function allSolutions(context) {
    const state = { pending: false };
    return withPendingState(allSolutionsGroups(context, asSet, state), state);
  };
}

function* allSolutionsGroups({ solver, goal, env }, asSet, state) {
  // EyeProlog validates the iterated goal before Instances. ISO 7.12 makes
  // simultaneous-error selection implementation dependent; keep this stable as
  // a processor choice rather than describing it as mandatory table ordering.
  const { iterated, quantified } = bagGoalParts(goal.args[1], env);
  assertListOrPartial(goal.args[2], env);
  const free = freeVariables(iterated, goal.args[0], quantified, env);
  const collector = solver.cloneForInnerGoal(10000000);
  const groups = [];
  for (const answerEnv of collector.solve([iterated], env.clone(), 0)) {
    const copied = freshCopy(compound('$bag', [
      compound('$witness', free),
      goal.args[0],
    ]), answerEnv);
    let group = groups.find((candidate) => sameWitness(candidate.witness, copied.args[0]));
    if (!group) {
      group = { witness: copied.args[0], templates: [] };
      groups.push(group);
      group.templates.push(copied.args[1]);
    } else {
      const alignment = new Env();
      unify(copied.args[0], group.witness, alignment);
      group.templates.push(copyResolved(copied.args[1], alignment));
    }
  }
  solver.absorbStatsFrom(collector);
  for (let index = 0; index < groups.length; index++) {
    const group = groups[index];
    const next = env.clone();
    let matches = true;
    for (let i = 0; i < free.length; i++) {
      if (!unify(free[i], group.witness.args[i], next)) { matches = false; break; }
    }
    const templates = asSet ? sortedUnique(group.templates) : group.templates;
    if (matches && unify(goal.args[2], listFromItems(templates), next)) {
      state.pending = index + 1 < groups.length;
      yield next;
    }
  }
  state.pending = false;
}
const bagofBuiltin = allSolutionsBuiltin(false);
const setofBuiltin = allSolutionsBuiltin(true);

function allSolutionsHasAtMostOneGroup({ goal, env }) {
  try {
    const { iterated, quantified } = bagGoalParts(goal.args[1], env);
    return freeVariables(iterated, goal.args[0], quantified, env).length === 0;
  } catch (_) {
    // Leave error selection and reporting to the builtin itself.
    return false;
  }
}

function callable(term, env) {
  term = deref(term, env);
  if (term.type === VAR) throw new PrologError('instantiation_error');
  if (term.type !== ATOM && term.type !== COMPOUND) throw new PrologError('type_error(callable)', term);
  validateControlCallable(term, term, env);
  return term;
}

function withPendingState(iterator, state) {
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}
function validateControlCallable(term, culprit, env) {
  // Only control constructs need their nested goals validated at meta-call
  // entry. Walk them iteratively and dereference each nested goal lazily so
  // passing a callable that contains a very deep data term (for example
  // phrase(a, List) with an 8k-cell List) never consumes the JavaScript stack.
  const pending = [term];
  while (pending.length > 0) {
    const current = deref(pending.pop(), env);
    if (current.type !== COMPOUND || ![',', ';', '->'].includes(current.name) || current.arity !== 2) continue;
    for (let index = current.arity - 1; index >= 0; index--) {
      const argument = deref(current.args[index], env);
      // A variable nested in a control construct is not an error at call/1
      // entry: an earlier goal may instantiate it before execution reaches
      // that position. If it is still unbound when selected, the solver then
      // raises instantiation_error at that point, after any preceding effects.
      // Non-variable non-callables are different: ISO call/1 validates those
      // eagerly and reports the whole control term as the culprit.
      if (argument.type === VAR) continue;
      if (argument.type !== ATOM && argument.type !== COMPOUND) {
        throw new PrologError('type_error(callable)', copyResolved(culprit, env));
      }
      pending.push(argument);
    }
  }
}
function convertMetaCallBodyTerm(term, env, module) {
  // ISO term-to-body conversion is applied when call/1 begins, before any
  // goal in the converted body is executed. An unbound variable occurring as
  // a body goal therefore becomes call(Var) at that point. If an earlier goal
  // later binds Var to !, the resulting call(!) has its own opaque cut scope
  // instead of turning into a textual cut in the enclosing meta-call.
  //
  // Build the converted control tree iteratively so a deeply nested sequence
  // of conjunctions/disjunctions cannot consume the JavaScript call stack.
  const convertNode = (input, inheritedModule) => {
    const resolved = deref(input, env);
    const effectiveModule = resolved.module ?? inheritedModule;
    if (resolved.type === VAR) {
      const wrapped = compound('call', [resolved]);
      wrapped.module = effectiveModule;
      return { term: wrapped, source: null, module: effectiveModule };
    }
    if (resolved.type !== ATOM && resolved.type !== COMPOUND) {
      throw new PrologError('type_error(callable)', term);
    }
    if (resolved.type === COMPOUND && [',', ';', '->'].includes(resolved.name) && resolved.arity === 2) {
      const converted = compound(resolved.name, [...resolved.args]);
      converted.module = effectiveModule;
      return { term: converted, source: resolved, module: effectiveModule };
    }
    return { term: resolved, source: null, module: effectiveModule };
  };

  const root = convertNode(term, module);
  const pending = root.source == null ? [] : [root];
  while (pending.length > 0) {
    const current = pending.pop();
    for (let index = 0; index < 2; index++) {
      const child = convertNode(current.source.args[index], current.module);
      current.term.args[index] = child.term;
      if (child.source != null) pending.push(child);
    }
  }
  return root.term;
}

function expandCallGoal({ goal, env }) {
  const invoked = callable(goal.args[0], env);
  const module = invoked.module ?? goal.module ?? 'user';
  const converted = convertMetaCallBodyTerm(invoked, env, module);
  if (converted.module == null) converted.module = module;
  return converted;
}
function* callBuiltin(context) {
  const { solver, env } = context;
  const invoked = expandCallGoal(context);
  const child = solver.cloneForInnerGoal();
  try {
    yield* child.solve([invoked], env, 0);
  } finally {
    solver.absorbStatsFrom(child);
  }
}
function expandCallClosureGoal({ goal, env }) {
  const closure = callable(goal.args[0], env);
  const existing = closure.type === COMPOUND ? closure.args : [];
  const extra = goal.args.slice(1);
  if (ISO_MAX_ARITY != null && existing.length + extra.length > ISO_MAX_ARITY) {
    throw new PrologError('representation_error(max_arity)');
  }
  const invoked = compound(closure.name, [...existing, ...extra]);
  invoked.module = closure.module ?? goal.module ?? 'user';
  return invoked;
}
function* callClosureBuiltin(context) {
  const { solver, env } = context;
  const invoked = expandCallClosureGoal(context);
  const child = solver.cloneForInnerGoal();
  try {
    yield* child.solve([invoked], env, 0);
  } finally {
    solver.absorbStatsFrom(child);
  }
}

export function* countAllBuiltin({ solver, goal, env }) {
  const requested = deref(goal.args[1], env);
  // Validate Count before inspecting or executing Goal. This preserves the
  // expected error priority for e.g. countall(throw(x), -1).
  if (requested.type !== VAR) {
    if (requested.type !== NUMBER || !isDecimalInteger(requested.name)) {
      throw new PrologError('type_error(integer)', requested);
    }
    if (BigInt(requested.name) < 0n) {
      throw new PrologError('domain_error(not_less_than_zero)', requested);
    }
  }

  const invoked = callable(goal.args[0], env);
  let count = solver.fastCountGoal?.(invoked, env) ?? null;
  if (count == null) {
    const child = solver.cloneForInnerGoal();
    count = 0n;
    try {
      for (const _ of child.solve([invoked], env.clone(), 0)) count++;
    } finally {
      solver.absorbStatsFrom(child);
    }
  }

  const next = env.clone();
  if (unify(goal.args[1], numberTerm(count), next)) yield next;
}

function monotonicMilliseconds() {
  return globalThis.performance?.now?.() ?? Date.now();
}

function writeElapsedTime(solver, startedAt, inferences) {
  const stream = solver.io.resolve(solver.io.currentOutput);
  if (stream?.type !== 'text') throw new PrologError('permission_error(output, binary_stream)');
  const elapsedSeconds = Math.max(0, monotonicMilliseconds() - startedAt) / 1000;
  const mlips = elapsedSeconds > 0 ? inferences / elapsedSeconds / 1_000_000 : 0;
  solver.io.writeUnit(
    stream,
    `% Time elapsed ${elapsedSeconds.toFixed(3)}s, ${inferences} Inferences, ${mlips.toFixed(3)} MLips\n`,
  );
}

export function timeBuiltin(context) {
  const state = { pending: true };
  return withPendingState(timeSolutions(context, state), state);
}

function* timeSolutions({ solver, goal, env }, state) {
  const invoked = callable(goal.args[0], env);
  const child = solver.cloneForInnerGoal();
  let startedAt = monotonicMilliseconds();
  let startedInferences = child.inferenceObservation.value;
  let yieldedAny = false;
  try {
    for (const answerEnv of child.solve([invoked], env, 0)) {
      writeElapsedTime(solver, startedAt, child.inferenceObservation.value - startedInferences);
      yieldedAny = true;
      state.pending = child.hasPendingAlternatives();
      yield answerEnv;
      if (!state.pending) return;
      // A resumed time/1 measures only the work required to reach the next
      // answer, so nondeterministic calls get one timing line per solution.
      startedAt = monotonicMilliseconds();
      startedInferences = child.inferenceObservation.value;
    }
    state.pending = false;
    // A call that fails without producing an answer still reports the work.
    if (!yieldedAny) writeElapsedTime(solver, startedAt, child.inferenceObservation.value - startedInferences);
  } finally {
    solver.absorbStatsFrom(child);
  }
}

export function callNthBuiltin(context) {
  const state = { pending: true };
  return withPendingState(callNthSolutions(context, state), state);
}

function* callNthSolutions({ solver, goal, env }, state) {
  const requestedTerm = deref(goal.args[1], env);
  // Zero is the one Nth value that fails before Goal is inspected.
  if (requestedTerm.type === NUMBER && isDecimalInteger(requestedTerm.name) && BigInt(requestedTerm.name) === 0n) {
    state.pending = false;
    return;
  }

  const invoked = callable(goal.args[0], env);
  let requested = null;
  if (requestedTerm.type !== VAR) {
    if (requestedTerm.type !== NUMBER || !isDecimalInteger(requestedTerm.name)) {
      throw new PrologError('type_error(integer)', requestedTerm);
    }
    requested = BigInt(requestedTerm.name);
    if (requested < 0n) throw new PrologError('domain_error(not_less_than_zero)', requestedTerm);
  }

  const child = solver.cloneForInnerGoal();
  let nth = 0n;
  try {
    for (const answerEnv of child.solve([invoked], env, 0)) {
      nth++;
      if (requested != null && nth < requested) continue;
      const next = answerEnv.clone();
      if (unify(goal.args[1], numberTerm(nth.toString()), next)) {
        state.pending = requested == null && child.hasPendingAlternatives();
        yield next;
        if (requested != null || !state.pending) return;
      }
    }
    state.pending = false;
  } finally {
    solver.absorbStatsFrom(child);
  }
}

function residueSnapshot(env) {
  const attributes = new Map();
  for (const name of env.attributedVariableNames?.() ?? []) {
    attributes.set(name, env.prologAttributes(name));
  }
  const delays = new Map();
  for (const name of env.delayedVariableNames?.() ?? []) {
    delays.set(name, env.delayedGoals(name));
  }
  const constraints = new Map();
  for (const constraint of env.variableConstraints?.() ?? []) {
    constraints.set(constraint, [...constraint.variables(env)]);
  }
  return { attributes, delays, constraints };
}

function sameAttributeEntries(before, after) {
  if (before == null || before.length !== after.length) return false;
  for (let i = 0; i < after.length; i++) {
    if (before[i].module !== after[i].module || before[i].attribute !== after[i].attribute) return false;
  }
  return true;
}

function sameDelayEntries(before, after) {
  if (before == null || before.length !== after.length) return false;
  for (let i = 0; i < after.length; i++) if (before[i] !== after[i]) return false;
  return true;
}

function residueVariablesSince(snapshot, env) {
  const names = [];
  const seen = new Set();
  const add = (name) => {
    const root = deref(variable(name), env);
    if (root.type !== VAR || seen.has(root.name)) return;
    seen.add(root.name);
    names.push(root);
  };

  for (const name of env.attributedVariableNames?.() ?? []) {
    const after = env.prologAttributes(name);
    if (!sameAttributeEntries(snapshot.attributes.get(name), after)) add(name);
  }
  for (const name of env.delayedVariableNames?.() ?? []) {
    const after = env.delayedGoals(name);
    if (!sameDelayEntries(snapshot.delays.get(name), after)) add(name);
  }
  for (const constraint of env.variableConstraints?.() ?? []) {
    const after = [...constraint.variables(env)];
    const before = snapshot.constraints.get(constraint);
    const unchanged = before != null && before.length === after.length && before.every((name, index) => name === after[index]);
    if (unchanged) continue;
    for (const name of after) add(name);
  }
  return names;
}

export function callResidueVarsBuiltin({ solver, goal, env }) {
  const invoked = callable(goal.args[0], env);
  if (invoked.module == null) invoked.module = goal.module ?? 'user';
  const snapshot = residueSnapshot(env);
  const child = solver.cloneForInnerGoal();
  let pending = true;
  // The wrapper iterator is resumable even for a deterministic Goal. Expose
  // the child's actual search state so the solver does not install a phantom
  // choicepoint after the final answer.
  const iterator = (function* residueSolutions() {
    try {
      for (const answerEnv of child.solve([invoked], env, 0)) {
        pending = child.hasPendingAlternatives();
        const next = answerEnv.clone();
        if (unify(goal.args[1], listFromItems(residueVariablesSince(snapshot, answerEnv)), next)) {
          yield next;
          if (!pending) return;
        }
      }
      pending = false;
    } finally {
      solver.absorbStatsFrom(child);
    }
  })();
  iterator.hasPendingAlternatives = () => pending;
  return iterator;
}

function freezeBuiltin(context) {
  const state = { pending: true };
  return withPendingState(freezeSolutions(context, state), state);
}

function* freezeSolutions({ solver, goal, env }, state) {
  const watched = deref(goal.args[0], env);
  if (watched.type !== VAR) {
    const child = solver.cloneForInnerGoal();
    try {
      for (const answerEnv of child.solve([callable(goal.args[1], env)], env, 0)) {
        state.pending = child.hasPendingAlternatives();
        yield answerEnv;
        if (!state.pending) return;
      }
      state.pending = false;
    } finally {
      solver.absorbStatsFrom(child);
    }
    return;
  }
  const next = env.clone();
  next.delay(watched.name, goal.args[1], goal.module ?? 'user');
  state.pending = false;
  yield next;
}

function phraseBuiltin(context) {
  const state = { pending: true };
  return withPendingState(phraseSolutions(context, state), state);
}

function* phraseSolutions({ solver, goal, env }, state) {
  const grammarBody0 = deref(goal.args[0], env);
  if (grammarBody0.type === VAR) throw new PrologError('instantiation_error');
  if (grammarBody0.type !== ATOM && grammarBody0.type !== COMPOUND) {
    throw new PrologError('type_error(callable)', grammarBody0);
  }
  // Resolve nested bindings in dynamically supplied nonterminals. This keeps
  // variables shared by an enclosing clause visible to the DCG expander while
  // preserving unbound variables by name.
  const grammarBody = copyResolved(grammarBody0, env);
  const input = goal.args[1];
  const requestedOutput = goal.arity === 2 ? emptyTerminalSequence() : goal.args[2];
  validateDcgEmbeddedGoals(grammarBody, input, requestedOutput);
  // ISO/IEC TS 13211-3:2025, 8.18.1.3 g and h permit these checks
  // and specify type_error(list, S) for invalid terminal-sequence arguments.
  // EyeProlog elects to perform both optional checks consistently, including
  // improper lists. The upstream quads allow non-checking outcomes too; the
  // dedicated regression matrix requires our exact diagnostics.
  // See conformance-report.md and issue #94.
  if (!isListOrPartialList(input, env)) {
    throw new PrologError('type_error(list)', deref(input, env));
  }
  if (!isListOrPartialList(requestedOutput, env)) {
    throw new PrologError('type_error(list)', deref(requestedOutput, env));
  }

  // phrase/2 fixes the remainder to [] from the outset. phrase/3 keeps a
  // private output variable and delays the final unification so its third
  // argument remains steadfast as required by the Part 3 execution model.
  const finalOutput = goal.arity === 2
    ? requestedOutput
    : variable(`\u0000phrase:${++isoFresh}`);
  const expanded = expandDcgBody(grammarBody, input, finalOutput, {
    env,
    // A meta-predicate wrapper qualifies its grammar argument at the call
    // site.  Preserve that qualification instead of replacing it with the
    // lexical module of the wrapper's phrase/2 call.
    module: grammarBody.module ?? goal.module ?? 'user',
  });
  const finish = goal.arity === 2 ? null : compound('=', [finalOutput, requestedOutput]);
  // If a DCG nonterminal is explicitly tabled, keep its tables in a
  // phrase-local scope keyed by the whole invocation. Repeatedly testing the
  // same grammar/input can reuse its completed table, while switching to a
  // distinct input drops the previous invocation as one unit.
  const phraseModule = grammarBody.module ?? goal.module ?? 'user';
  const tableScopeSignature = solver.innerTableSignature(
    [grammarBody, input, requestedOutput],
    env,
    `${phraseModule}:`,
  );
  const child = solver.cloneForInnerGoal(solver.solutionLimit, {
    tableScope: 'phrase',
    tableScopeSignature,
  });
  try {
    for (const answerEnv of child.solve(finish == null ? [expanded] : [expanded, finish], env, 0)) {
      state.pending = child.hasPendingAlternatives();
      yield answerEnv;
      if (!state.pending) return;
    }
    state.pending = false;
  } finally {
    solver.absorbStatsFrom(child);
    solver.trimInnerTableScope('phrase');
  }
}
const defaultErrorContext = atom('eyeprolog');

function parseFormalErrorTerm(text) {
  const open = text.indexOf('(');
  if (open === -1) return atom(text);
  const name = text.slice(0, open);
  const inner = text.slice(open + 1, -1);
  const args = [];
  let start = 0;
  let depth = 0;
  for (let i = 0; i <= inner.length; i++) {
    const ch = inner[i];
    if (ch === '(') depth++;
    else if (ch === ')') depth--;
    else if ((ch === ',' || i === inner.length) && depth === 0) {
      args.push(parseFormalErrorTerm(inner.slice(start, i).trim()));
      start = i + 1;
    }
  }
  return compound(name, args);
}

function hasDefaultGroundErrorShape(error) {
  return error.formalTerm == null && error.culprit == null && error.contextTerm == null;
}

export function formalErrorTerm(error) {
  // Reused processor errors can occur hundreds of thousands of times in a
  // caught failure loop. Cache their immutable ground error/2 term on the
  // error object itself instead of rebuilding the same tree on every catch.
  if (hasDefaultGroundErrorShape(error) && error._groundErrorTerm != null) {
    return error._groundErrorTerm;
  }

  const context = error.contextTerm ?? defaultErrorContext;
  let formal = error.formalTerm ?? parseFormalErrorTerm(error.formal);
  if (error.culprit != null) {
    if (formal.type === COMPOUND) formal = compound(formal.name, [...formal.args, error.culprit]);
    else if (formal.type === ATOM && formal.name === 'uninstantiation_error') {
      formal = compound(formal.name, [error.culprit]);
    }
  }
  const term = compound('error', [formal, context]);
  if (hasDefaultGroundErrorShape(error)) error._groundErrorTerm = term;
  return term;
}

function prologErrorBall(error) {
  const term = formalErrorTerm(error);
  // Ground terms are immutable from unification's perspective: bindings are
  // recorded only in the catcher Env, so copying them is unnecessary.
  if (hasDefaultGroundErrorShape(error) || termIsGround(term)) return term;
  return freshCopy(term, new Env());
}
function catchBuiltin(context) {
  const state = { pending: true };
  return withPendingState(catchSolutions(context, state), state);
}

function* catchSolutions({ solver, goal, env }, state) {
  let child = null;
  try {
    // Corrigendum 2 removed catch/3's own callability errors so that errors
    // raised while converting/executing the protected goal are catchable.
    const invoked = callable(goal.args[0], env);
    const direct = solver.registry.get(invoked.name, invoked.arity);
    if (direct?.deterministic && (direct.shouldUse == null || direct.shouldUse({ solver, goal: invoked, env }))) {
      // A deterministic builtin has no choice points whose lifetime must be
      // isolated in a child solver. Running it directly avoids constructing a
      // complete Solver for hot caught failures such as number_chars/2 syntax
      // probes, while the cloned environment keeps catch/3's rollback boundary.
      const iterator = direct.handler({ solver, goal: invoked, env: env.clone() });
      const result = iterator.next();
      if (result.done) solver.stats.deterministic_builtin_failures++;
      else {
        solver.stats.deterministic_builtin_successes++;
        state.pending = false;
        yield result.value;
      }
      state.pending = false;
      return;
    }
    child = solver.cloneForInnerGoal();
    for (const answerEnv of child.solve([invoked], env.clone(), 0)) {
      state.pending = child.hasPendingAlternatives();
      yield answerEnv;
      if (!state.pending) return;
    }
    state.pending = false;
  } catch (error) {
    const ball = error instanceof ThrownTerm
      ? error.term
      : error instanceof PrologError
        ? prologErrorBall(error)
        : null;
    if (ball == null) throw error;
    const recovered = env.clone();
    if (!unify(goal.args[1], ball, recovered)) throw error;
    const recovery = callable(goal.args[2], recovered);
    if (recovery.type === ATOM && (recovery.name === 'false' || recovery.name === 'fail')) {
      state.pending = false;
      return;
    }
    if (recovery.type === ATOM && recovery.name === 'true') {
      state.pending = false;
      yield recovered;
      return;
    }
    yield* solveControlBranch(solver, recovery, recovered,
      (pending) => { state.pending = pending; });
    state.pending = false;
  } finally {
    if (child != null) solver.absorbStatsFrom(child);
  }
}
function* throwBuiltin({ goal, env }) {
  const ball = deref(goal.args[0], env);
  if (ball.type === VAR) throw new PrologError('instantiation_error');
  // ISO throw/1 copies the thrown term before control unwinds. Freshen
  // variables so the catcher cannot retain aliases to the protected goal.
  throw new ThrownTerm(freshCopy(ball, env));
}
function* onceBuiltin({ solver, goal, env }) {
  const child = solver.cloneForInnerGoal(1);
  for (const answer of child.solve([callable(goal.args[0], env)], env.clone(), 0)) {
    solver.absorbStatsFrom(child);
    yield answer;
    return;
  }
  solver.absorbStatsFrom(child);
}
function repeatBuiltin({ env }) {
  const iterator = (function* repeatSolutions() {
    while (true) yield env;
  })();
  iterator.hasPendingAlternatives = () => true;
  return iterator;
}
function* negationBuiltin({ solver, goal, env }) {
  const invoked = callable(goal.args[0], env);
  const direct = solver.registry.get(invoked.name, invoked.arity);
  if (direct?.deterministic && (direct.shouldUse == null || direct.shouldUse({ solver, goal: invoked, env }))) {
    const iterator = direct.handler({ solver, goal: invoked, env: env.clone() });
    const result = iterator.next();
    if (result.done) {
      solver.stats.deterministic_builtin_failures++;
      yield env;
    } else {
      solver.stats.deterministic_builtin_successes++;
    }
    return;
  }
  const fastTruth = solver.fastGroundGoalTruth?.(invoked, env) ?? null;
  if (fastTruth != null) {
    if (!fastTruth) yield env;
    return;
  }
  for (const _ of solver.cloneForInnerGoal(1).solve([invoked], env.clone(), 0)) return;
  yield env;
}
function* solveControlBranch(solver, goal, env, observePending = null) {
  const existingStacks = new Set(solver.solveStacks);
  for (const answer of solver.solve([callable(goal, env)], env, 0)) {
    // A branch answer is internal to its enclosing control construct. The
    // surrounding solve will count the completed control goal after the
    // builtin yields it. Leaving both counts in place makes a bounded search
    // such as once/1 or negation stop before it can observe the branch answer.
    if (solver.solutionsSeen > 0) solver.solutionsSeen--;
    observePending?.(solver.hasPendingAlternatives(existingStacks));
    yield answer;
  }
}
function disjunctionBuiltin(context) {
  const state = { pending: true };
  const iterator = disjunctionSolutions(context, state);
  iterator.hasPendingAlternatives = () => state.pending;
  return iterator;
}
function* disjunctionSolutions({ solver, goal, env }, state) {
  const left = deref(goal.args[0], env);
  if (left.type === COMPOUND && left.name === '->' && left.arity === 2) {
    for (const conditionEnv of solver.cloneForInnerGoal(1).solve([callable(left.args[0], env)], env.clone(), 0)) {
      yield* solveControlBranch(solver, left.args[1], conditionEnv,
        (pending) => { state.pending = pending; });
      state.pending = false;
      return;
    }
    yield* solveControlBranch(solver, goal.args[1], env.clone(),
      (pending) => { state.pending = pending; });
    state.pending = false;
    return;
  }
  const marker = solver.active[solver.active.length - 1] ?? null;
  const markerCutEpoch = marker?.cutEpoch ?? 0;
  const solverCutEpoch = solver.cutEpoch;
  yield* solveControlBranch(solver, goal.args[0], env.clone(), (pending) => {
    const cutThisScope = marker == null
      ? solver.cutEpoch !== solverCutEpoch
      : (marker.cutEpoch ?? 0) !== markerCutEpoch;
    state.pending = pending || !cutThisScope;
  });
  const cutThisScope = marker == null
    ? solver.cutEpoch !== solverCutEpoch
    : (marker.cutEpoch ?? 0) !== markerCutEpoch;
  if (cutThisScope) {
    state.pending = false;
    return;
  }
  yield* solveControlBranch(solver, goal.args[1], env.clone(),
    (pending) => { state.pending = pending; });
  state.pending = false;
}
function ifThenBuiltin(context) {
  const state = { pending: true };
  return withPendingState(ifThenSolutions(context, state), state);
}

function* ifThenSolutions({ solver, goal, env }, state) {
  for (const conditionEnv of solver.cloneForInnerGoal(1).solve([callable(goal.args[0], env)], env.clone(), 0)) {
    yield* solveControlBranch(solver, goal.args[1], conditionEnv,
      (pending) => { state.pending = pending; });
    state.pending = false;
    return;
  }
  state.pending = false;
}

export { arithmeticValueTerm, evaluateArithmetic, compareArithmeticValues } from './iso-arithmetic.js';
import { isBuiltin, arithmeticComparison } from './iso-arithmetic.js';


export class BuiltinRegistry {
  constructor() {
    this.defs = new Map();
  }

  add(name, arity, handler, options = {}) {
    this.defs.set(`${name}/${arity}`, {
      name,
      arity,
      handler,
      deterministic: options.deterministic ?? false,
      deterministicWhen: options.deterministicWhen ?? null,
      expandGoal: options.expandGoal ?? null,
      ready: options.ready ?? null,
      fallbackWhenNotReady: options.fallbackWhenNotReady ?? false,
      shouldUse: options.shouldUse ?? null,
      eyePrologLibrary: options.eyePrologLibrary ?? false,
    });
    return this;
  }

  get(name, arity) {
    return this.defs.get(`${name}/${arity}`) ?? null;
  }

  remove(name, arity) {
    this.defs.delete(`${name}/${arity}`);
    return this;
  }
}

export function createDefaultRegistry() {
  const registry = new BuiltinRegistry();
  isoBuiltins.register(registry);
  return registry;
}

// ISO/IEC 13211-1:1995 + Corrigenda 1-3 only.  phrase/2-3 and grammar-rule
// expansion belong to the separate grammar-rule specification, while the
// EyeProlog standard-library/CLP(Z) adapters are registered elsewhere.
export function createStrictIsoRegistry() {
  return createDefaultRegistry()
    .remove('phrase', 2)
    .remove('phrase', 3);
}

let defaultRegistry = null;
let strictIsoRegistry = null;

export function getDefaultRegistry() {
  if (defaultRegistry == null) defaultRegistry = createDefaultRegistry();
  return defaultRegistry;
}

export function getStrictIsoRegistry() {
  if (strictIsoRegistry == null) strictIsoRegistry = createStrictIsoRegistry();
  return strictIsoRegistry;
}
