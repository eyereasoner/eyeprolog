# Propositional Dynamic Logic

## Can every way of acting reach the garden, or only some?

A robot stands in a hall behind a locked door. Programs such as "unlock, then
open, then walk" change the state of the world. Propositional Dynamic Logic
asks whether *some* run or *every* run of a program ends where a formula
holds, and this example answers seven such questions with a small,
assert-free interpreter.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=propositional-dynamic-logic) ·
[Source](../propositional-dynamic-logic.pl)

---

# The question

**Propositional Dynamic Logic (PDL)** reasons about programs and what they
achieve. It has two modalities:

- `<Program>Phi`, *diamond*: some run of the program reaches a state where
  `Phi` holds;
- `[Program]Phi`, *box*: every run of the program reaches such a state.

Programs combine with sequence, choice, repetition (`*`), and tests.

---

# States and actions

```prolog
transition(unlock, S0, S1) :-
    member(door(locked), S0),
    select(door(locked), S0, Rest),
    S1 = [door(unlocked) | Rest].
```

A state is just a list of true propositions, such as
`[at(hall), door(locked)]`. Actions relate an old state to a new one. Nothing
is asserted or retracted; the world is data passed from call to call.

---

# Programs as Prolog control

```prolog
run(seq(A, B), S0, S2) :-
    run(A, S0, S1),
    run(B, S1, S2).
run(choice(A, _), S0, S1) :- run(A, S0, S1).
run(choice(_, B), S0, S1) :- run(B, S0, S1).
run(star(_), S, S).
run(star(A), S0, S2) :-
    run(A, S0, S1),
    run(star(A), S1, S2).
```

Sequence is conjunction, choice is two clauses, and repetition is recursion.
The modalities follow directly:

```prolog
diamond(Program, Formula, S0) :- run(Program, S0, S1), holds(Formula, S1).
box(Program, Formula, S0) :- \+ (run(Program, S0, S1), \+ holds(Formula, S1)).
```

Box is "no run ends where the formula fails".

---

# The answer

```sh
eyeprolog examples/propositional-dynamic-logic.pl
```

```text
answer(true, true, true, false, true, true, true).
```

In order: the full path reaches the garden; `[open_door]at(garden)` is
**vacuously true** from a locked door, because `open_door` has no run there;
walking from an open door always reaches the garden; with a choice between
walking and waiting, box fails but diamond holds; waiting any number of times
stays in the hall; and a test-guarded walk works.

---

# The reason

```text
step(boolean(box(open_door, at(garden), [at(hall), door(locked)]), true),
     rule(18),
     ['Goal' = box(open_door, at(garden), [at(hall), door(locked)])],
     [call(box(open_door, at(garden), [at(hall), door(locked)])), !]).
step(\+ run(open_door, [at(hall), door(locked)], __anon3), absent, [], []).
```

The vacuous box holds by calling `box/3`, and the proof records separately that
`open_door` has no run from the locked state. A `false` value in the answer is
recorded differently: it comes from the fallback clause `boolean(_, false)`,
so the proof shows the default, not the failed search that led to it.

---

# The check

```text
condition('C1', resolution, ok, 8).
condition('C5', re_decision, ok, 3).
obligation(absent, theory_scoped, \+ run(open_door, [at(hall), door(locked)], A)).
obligation(builtin, theory_scoped, call(box(open_door, at(garden), [at(hall), door(locked)]))).
trusted(7).
verdict(checked_with_obligations).
```

Eight steps replay and three are recomputed. Seven are **obligations**:
meta-calls of `diamond/3` and `box/3`, and one negation, which depend on this
program's own clauses and so cannot be re-decided independently. The check
names them instead of hiding them.

---

# Try it

- Remove the `wait` transition. The answer becomes all `true`: with only the
  walking branch left, box and diamond agree.
- Add a `close_door` action and ask whether `<star(choice(open_door, close_door))>door(open)`
  holds from an unlocked door.
- Explain why `[open_door]at(garden)` being true from a locked door does not
  mean the door can be opened.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22.
