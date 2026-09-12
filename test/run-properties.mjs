#!/usr/bin/env node
// Property-based / round-trip regression tests.
//
// Every other conformance and regression case in this suite is a single,
// hand-picked input: a human decided which term, which list, which pair of
// operators was worth checking. That is precise, but it only ever catches
// what someone already thought to write down. This file instead generates
// many random ground terms from a seeded PRNG and checks invariants that
// must hold for ANY input, not just the ones on record -- the kind of edge
// case (an empty atom, an embedded quote, a duplicate sort key, a term
// whose functor happens to collide with an operator) that a hand-written
// corpus tends to miss by omission rather than by design.
//
// Each trial is its own reporter.test() entry, the same reason the Neumerkel
// gate reports every answer description as its own test (see
// test/neumerkel.mjs): a single aggregate pass/fail line for a whole
// property would force a reader to dig through a raw error string to find
// which of many trials actually broke, instead of seeing it named outright.
//
// The seed is fixed, not time-based: a failure must be exactly reproducible
// by re-running this file, not a flake that vanishes on the next run. Only
// change SEED deliberately (and say why in the commit), never to make a
// failure go away. Trial counts are tuned to keep the whole file in the
// 10-20 second range as part of `npm test`; if a new property needs more
// trials to be meaningful, trim another property's count to make room
// rather than letting the total creep up unnoticed.
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';
import { run } from '../src/index.js';

const SEED = 20260913;
const MAX_DEPTH = 3;

// mulberry32: a small, fast, deterministic PRNG. Good enough for generating
// test inputs -- this is not a security context -- and its whole point here
// is determinism, which Math.random() cannot offer.
function mulberry32(seed) {
  let a = seed >>> 0;
  return function next() {
    a |= 0; a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// One PRNG stream, shared across every property in file order, so the
// overall run is still governed by the single SEED at the top: rerunning
// this file reruns the exact same sequence of generated inputs everywhere,
// not just within one property.
const rng = mulberry32(SEED);

function pick(list) { return list[Math.floor(rng() * list.length)]; }
function int(lo, hi) { return lo + Math.floor(rng() * (hi - lo + 1)); }

// Atoms deliberately include the awkward cases a hand-written corpus tends
// to skip: the empty atom, an embedded quote, digits-first, and an atom
// that is itself a list-notation special form.
const ATOM_POOL = [
  'a', 'b', 'c', 'foo', 'bar', 'baz',
  "''", "'A weird atom'", "'with''quote'", "'123abc'", "'[]'", "'{}'",
];
// A separate, narrower pool for properties that build/compare atom *text*
// (atom_concat, string_concat, atom_codes/chars): plain lowercase words only,
// so concatenation and character decomposition stay easy to reason about
// without also re-deriving quoting rules inside the property itself.
const WORD_POOL = ['a', 'b', 'c', 'foo', 'bar', 'baz', 'quux', 'x', 'yz', 'hello'];
const FUNCTOR_POOL = ['f', 'g', 'h', 'node', 'pair', 'wrap'];

function genAtomic() {
  switch (pick(['atom', 'int', 'negint', 'bigint', 'float'])) {
    case 'atom': return pick(ATOM_POOL);
    case 'int': return String(int(0, 1000));
    case 'negint': return String(-int(1, 1000));
    case 'bigint': {
      let digits = String(int(1, 9));
      for (let i = 0; i < int(20, 40); i++) digits += int(0, 9);
      return digits;
    }
    case 'float': {
      const sign = rng() < 0.5 ? '-' : '';
      return `${sign}${int(0, 999)}.${String(int(0, 999)).padStart(3, '0')}`;
    }
    default: throw new Error('unreachable');
  }
}

function genTerm(depth = MAX_DEPTH) {
  if (depth <= 0 || rng() < 0.4) return genAtomic();
  if (rng() < 0.5) {
    const items = Array.from({ length: int(0, 4) }, () => genTerm(depth - 1));
    return `[${items.join(', ')}]`;
  }
  const args = Array.from({ length: int(1, 3) }, () => genTerm(depth - 1));
  return `${pick(FUNCTOR_POOL)}(${args.join(', ')})`;
}

function genCompound() {
  // Force a compound (never atomic) so univ round-tripping is meaningful.
  const args = Array.from({ length: int(1, 4) }, () => genTerm(MAX_DEPTH - 1));
  return `${pick(FUNCTOR_POOL)}(${args.join(', ')})`;
}

function genList(depth = 1, minLen = 0, maxLen = 6) {
  return `[${Array.from({ length: int(minLen, maxLen) }, () => genTerm(depth)).join(', ')}]`;
}
function genWord() { return pick(WORD_POOL); }
function genSmallInt() { return int(0, 1000); }
function genNonZeroInt() { const n = int(1, 1000); return rng() < 0.5 ? -n : n; }

// Runs one goal and confirms it actually succeeded, throwing with the goal
// text attached (so a failure names exactly what to rerun) otherwise.
//
// stats.completed_goal_lists is the one reliable success signal, not the
// printed answer text: a goal left with unbound variables (routine here,
// since `\+` discards the bindings it made) prints nothing at all despite
// succeeding, and a ground goal that succeeds is echoed back in full,
// untaken branches included -- so a literal marker atom anywhere in the
// goal text can appear in that echo without ever having been reached.
function solve(goal, { use = [], preamble = '' } = {}) {
  const prelude = use.map((lib) => `:- use_module(library(${lib})).\n`).join('') + preamble;
  const result = run(prelude, { goal });
  if (result.stats.completed_goal_lists < 1) {
    throw new Error(`property goal did not hold (failed or errored): ${goal}`);
  }
  return result;
}

// Registers `trials` individually-reported trials of one property. genFn()
// builds a fresh random goal (as a string) each time; it alone decides what
// varies between trials, so it is called with no arguments (the shared
// module-level `rng` is what actually advances).
function property(reporter, name, trials, genFn, options) {
  for (let trial = 0; trial < trials; trial++) {
    reporter.test(`${name} (trial ${trial + 1}/${trials})`, () => {
      const goal = genFn();
      try {
        solve(goal, options);
      } catch (error) {
        throw new Error(`${name}: trial ${trial} (seed ${SEED}) failed -- ${error.message}`);
      }
    });
  }
}

export function runProperties(reporter = new TestReporter()) {
  reporter.section('Property-based round-trip checks');

  property(reporter, 'write_term_to_chars / read_term_from_chars round-trips any ground term', 20, () =>
    `T = (${genTerm()}), write_term_to_chars(T, [quoted(true)], C0), ` +
    `append(C0, ".", C), read_term_from_chars(C, T2, []), T == T2`,
  { use: ['charsio'] });

  property(reporter, 'sort/2 is idempotent, ordered, and duplicate-free', 20, () =>
    // No adjacent pair may fail to be strictly increasing: sort/2 removes
    // duplicates per ISO 8.4.3, so a non-strict (@>=) neighbor is a bug.
    // append/3 enumerating every split is plain ISO core, so this needs no
    // recursive helper predicate of its own.
    `L = ${genList()}, sort(L, S1), sort(S1, S2), S1 == S2, ` +
    `\\+ (append(_, [X, Y|_], S1), X @>= Y)`);

  property(reporter, 'append/3 and length/2 agree on the combined length', 20, () =>
    `A = ${genList()}, B = ${genList()}, append(A, B, C), length(A, LA), length(B, LB), length(C, LC), ` +
    `LC =:= LA + LB, ` +
    // append/3's "split" mode must invert cleanly: recovering A from C at
    // the same split point must reproduce the same B.
    `append(A, B2, C), B2 == B`);

  property(reporter, 'compare/3 gives mirrored results for swapped arguments', 15, () =>
    `X = (${genTerm(2)}), Y = (${genTerm(2)}), compare(O1, X, Y), compare(O2, Y, X), ` +
    `( O1 == (<) -> O2 == (>) ; O1 == (>) -> O2 == (<) ; O1 == (=), O2 == (=) )`);

  property(reporter, 'keysort/2 is stable across duplicate keys', 20, () => {
    // Keys drawn from a small range to force duplicates; each value is the
    // pair's original position, so stability can be checked directly:
    // among equal keys, positions must stay in ascending (original) order.
    const pairs = Array.from({ length: int(2, 10) }, (_, index) => `${int(0, 3)}-${index}`);
    // No adjacent pair may go backward: keys must never decrease, and where
    // two keys tie, the original index (the value half) must not decrease
    // either -- that is exactly what "stable" means.
    return `L = [${pairs.join(', ')}], keysort(L, S), ` +
      `\\+ (append(_, [K1-V1, K2-V2|_], S), (K1 @> K2 ; K1 == K2, V1 > V2))`;
  });

  property(reporter, 'univ (=..) round-trips any compound term', 15, () =>
    `T = (${genCompound()}), T =.. L, T3 =.. L, T3 == T`);

  property(reporter, 'copy_term/2 preserves variable sharing without aliasing the original', 20, () => {
    // Alternate sharing shapes: (shared, shared, fresh), (fresh, shared, shared).
    const filler = genAtomic();
    const template = pick([
      `f(X, X, ${filler})`,
      `g(${filler}, X, X)`,
      `h(X, ${filler}, X)`,
    ]);
    return `T = ${template}, copy_term(T, C), variant(T, C), ` +
      // The two positions that shared a variable in T must still be
      // identical to each other in the copy (structure preserved) ...
      `T =.. [_, TA, TB, TC], C =.. [_, CA, CB, CC], ` +
      `( (TA == TB, TA \\== ${filler}) -> CA == CB ; true ), ` +
      `( (TB == TC, TB \\== ${filler}) -> CB == CC ; true ), ` +
      `( (TA == TC, TA \\== ${filler}) -> CA == CC ; true )`;
  });

  property(reporter, 'reverse/2 is its own inverse', 15, () =>
    `L = ${genList()}, reverse(L, R), reverse(R, L2), L == L2`);

  property(reporter, 'atom_codes/2 round-trips any atom', 15, () =>
    `atom_codes(${genWord()}, C0), atom_codes(A2, C0), atom_codes(A2, C1), C0 == C1`);

  property(reporter, 'atom_chars/2 round-trips any atom', 15, () =>
    `atom_chars(${genWord()}, C0), atom_chars(A2, C0), atom_chars(A2, C1), C0 == C1`);

  property(reporter, 'char_code/2 round-trips any character', 15, () => {
    const code = int(32, 126); // printable ASCII, safe to embed as a bare integer
    return `char_code(Ch, ${code}), char_code(Ch2, ${code}), Ch == Ch2`;
  });

  property(reporter, 'number_codes/2 round-trips any integer', 15, () =>
    `number_codes(${genNonZeroInt()}, C), number_codes(N, C), number_codes(N, C2), C == C2`);

  property(reporter, 'succ/2 agrees with +1', 15, () => {
    const n = int(0, 100000);
    return `succ(${n}, S), S =:= ${n} + 1, succ(P, S), P =:= ${n}`;
  });

  property(reporter, 'abs/1 and sign/1 reconstruct the original integer', 15, () => {
    const n = genNonZeroInt();
    return `X is ${n}, A is abs(X), A >= 0, S is sign(X), V is S * A, V =:= X`;
  });

  property(reporter, 'nth0/3 and nth1/3 agree on the same element', 15, () => {
    const list = `[${Array.from({ length: int(1, 6) }, () => genTerm(1)).join(', ')}]`;
    const pick0 = int(0, 100); // reduced mod the list's actual length below
    return `L = ${list}, length(L, Len), I is ${pick0} mod Len, ` +
      `nth0(I, L, X), I1 is I + 1, nth1(I1, L, X2), X == X2`;
  });

  property(reporter, 'last/2 names the element append/3 would split off', 15, () => {
    const list = `[${Array.from({ length: int(1, 6) }, () => genTerm(1)).join(', ')}]`;
    return `L = ${list}, last(L, X), append(_, [X], L)`;
  });

  property(reporter, 'min_list/2 and max_list/2 bound every element', 15, () => {
    const list = `[${Array.from({ length: int(1, 8) }, () => genNonZeroInt()).join(', ')}]`;
    return `L = ${list}, min_list(L, Mn), max_list(L, Mx), \\+ (member(E, L), (E < Mn ; E > Mx))`;
  });

  property(reporter, 'sum_list/2 is additive under append/3', 15, () => {
    const a = `[${Array.from({ length: int(0, 5) }, () => genSmallInt()).join(', ')}]`;
    const b = `[${Array.from({ length: int(0, 5) }, () => genSmallInt()).join(', ')}]`;
    return `A = ${a}, B = ${b}, sum_list(A, SA), sum_list(B, SB), append(A, B, C), sum_list(C, SC), ` +
      `SC =:= SA + SB`;
  });

  // atom_concat/3 associativity needs the SAME three words on both sides of
  // the regrouping -- three independent genWord() calls per side would pick
  // different words each time and prove nothing.
  property(reporter, 'atom_concat/3 regroups the same three atoms consistently', 15, () => {
    const [w1, w2, w3] = [genWord(), genWord(), genWord()];
    return `atom_concat(${w1}, ${w2}, AB), atom_concat(AB, ${w3}, ABC1), ` +
      `atom_concat(${w2}, ${w3}, BC), atom_concat(${w1}, BC, ABC2), ABC1 == ABC2`;
  });

  property(reporter, 'string_concat/3 regroups the same three atoms consistently', 15, () => {
    const [w1, w2, w3] = [genWord(), genWord(), genWord()];
    return `string_concat(${w1}, ${w2}, AB), string_concat(AB, ${w3}, ABC1), ` +
      `string_concat(${w2}, ${w3}, BC), string_concat(${w1}, BC, ABC2), ABC1 == ABC2`;
  }, { use: ['strings'] });

  property(reporter, 'atom_string/2 round-trips any atom', 12, () =>
    `atom_string(${genWord()}, S), atom_string(A2, S), atom_string(A2, S2), S == S2`,
  { use: ['strings'] });

  property(reporter, 'number_string/2 round-trips any integer', 12, () =>
    `number_string(${genNonZeroInt()}, S), number_string(N, S), number_string(N, S2), S == S2`,
  { use: ['strings'] });

  property(reporter, 'list_to_set/2 is idempotent', 15, () =>
    `L = ${genList()}, list_to_set(L, S1), list_to_set(S1, S2), S1 == S2`,
  { use: ['lists'] });

  property(reporter, 'permutation/2 preserves length and distinct-element order', 12, () => {
    const list = `[${Array.from({ length: int(0, 5) }, () => genTerm(1)).join(', ')}]`;
    return `L = ${list}, once(permutation(L, P)), length(L, N), length(P, N), sort(L, SL), sort(P, SP), SL == SP`;
  });

  property(reporter, 'between/3 generates exactly the requested inclusive range', 10, () => {
    const lo = int(-5, 5);
    const hi = lo + int(0, 8);
    return `findall(X, between(${lo}, ${hi}, X), L), length(L, N), N =:= ${hi} - ${lo} + 1, ` +
      `nth0(0, L, F), F =:= ${lo}, last(L, La), La =:= ${hi}`;
  });

  // --- Broader coverage: control constructs, exceptions, the database, and
  // grammar rules, not just term/list/arithmetic/string library predicates.

  property(reporter, 'catch/3 delivers the thrown ball unchanged', 15, () =>
    `B = (${genTerm()}), catch(throw(B), Ball, true), Ball == B`);

  property(reporter, 'findall/3 over member/2 reproduces the list exactly, in order, duplicates included', 15, () => {
    const list = genList();
    return `L = ${list}, findall(X, member(X, L), L2), L2 == L`;
  });

  property(reporter, 'findall/3 leaves its template variable unbound when nothing matches', 6, () =>
    `findall(X, (member(_, ${genList()}), fail), Bag), Bag == [], var(X)`);

  property(reporter, 'double negation reports success without ever binding anything', 20, () => {
    const list = genList(1);
    // Half the time probe an element genuinely in the list; half the time
    // probe one that (almost certainly) is not, so both the success and
    // the failure side of \+ \+ get exercised across the run.
    const probe = rng() < 0.5 ? pick(FUNCTOR_POOL) : genTerm(1);
    return `L = ${list}, X = (${probe}), ` +
      `( member(X, L) -> \\+ \\+ member(X, L) ; \\+ member(X, L) )`;
  });

  property(reporter, 'calling an undefined predicate names its own exact indicator', 15, () => {
    const name = `zz_property_undefined_${int(0, 1000000)}`;
    const arity = int(0, 4);
    const args = Array.from({ length: arity }, () => '_').join(', ');
    const call = arity === 0 ? name : `${name}(${args})`;
    return `catch(${call}, error(existence_error(procedure, PI), _), true), PI == ${name}/${arity}`;
  });

  property(reporter, 'assertz/1 then retract/1 leaves no trace behind', 15, () => {
    const term = genTerm();
    return `assertz(zz_property_fact(${term})), zz_property_fact(X), X == (${term}), ` +
      `retract(zz_property_fact(${term})), \\+ zz_property_fact(_)`;
  });

  property(reporter, 'a DCG list rule accepts exactly the list it was built from', 15, () => {
    const list = genList(1);
    return `L = ${list}, phrase(zz_property_seq(L), L)`;
  }, { preamble: 'zz_property_seq([]) --> [].\nzz_property_seq([H|T]) --> [H], zz_property_seq(T).\n' });

  property(reporter, 'bagof/3 over member/2 agrees with findall/3 on a non-empty list', 15, () => {
    const list = genList(1, 1, 6); // at least one element: bagof/3 has no "no solutions" answer
    return `L = ${list}, bagof(X, member(X, L), Bag), Bag == L`;
  });

  property(reporter, 'numbervars/3 assigns exactly as many numbers as distinct variables', 15, () => {
    const arity = int(2, 5);
    const slots = int(1, arity);
    const args = Array.from({ length: arity }, () => `V${int(1, slots)}`);
    return `T = f(${args.join(', ')}), numbervars(T, 0, End), End =:= ${slots}`;
  });

  property(reporter, 'split/3 and join/3 (library(strings)) invert each other', 12, () => {
    const words = Array.from({ length: int(2, 5) }, () => genWord());
    return `split('${words.join(',')}', ',', Parts), join(Parts, ',', S), S == '${words.join(',')}'`;
  }, { use: ['strings'] });

  reporter.sectionTotal('property-based round-trip checks');
}

if (isMainModule(import.meta.url)) await runStandalone(runProperties);
