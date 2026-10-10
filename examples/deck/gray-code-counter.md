# Gray-code counter

## Does this three-bit circuit count in Gray code?

A digital circuit built from AND, OR and NOT gates and three flip-flops is
written as Prolog relations. Running it for nine clock ticks shows that each
step changes exactly one bit, which is what makes a Gray code useful.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=gray-code-counter) ·
[Source](../gray-code-counter.pl)

---

# The question

A Gray-code counter steps through all eight 3-bit states so that consecutive
states differ in a single bit. That avoids glitches when several bits would
otherwise change at once. Starting from `000` and clocking nine times, which
states does this circuit visit?

---

# Gates as truth tables

```prolog
and(0, 0, 0). and(0, 1, 0). and(1, 0, 0). and(1, 1, 1).
or(0, 0, 0).  or(0, 1, 1).  or(1, 0, 1).  or(1, 1, 1).
inv(0, 1). inv(1, 0).

dff(_D, 0, Q, Q).
dff(D, 1, _q, D).
```

Each gate is just its truth table. A D flip-flop `dff/4` keeps its value when
the clock is 0 and takes the input `D` when the clock is 1.

---

# The circuit

```prolog
gcc(C, [Qa, Qb, Qc], [Za, Zb, Zc]) :-
  netb(Qa, Qb, Qc, D1, D2),
  neta(Qa, Qb, D3),
  dff(D1, C, Qa, Za),
  dff(D2, C, Qb, Zb),
  dff(D3, C, Qc, Zc).

testgcc([], _state, []).
testgcc([C|Cs], State, [Next|Rest]) :-
  gcc(C, State, Next),
  testgcc(Cs, Next, Rest).
```

`neta/3` and `netb/5` compute the flip-flop inputs from the current state.
`testgcc/3` feeds a list of clock values through the circuit and collects the
states.

---

# The answer

```sh
eyeprolog examples/gray-code-counter.pl
```

```text
isgcc([[1, 1, 1, 1, 1, 1, 1, 1, 1], [0, 0, 0]], [[0, 0, 1], [0, 1, 1], [0, 1, 0], [1, 1, 0], [1, 1, 1], [1, 0, 1], [1, 0, 0], [0, 0, 0], [0, 0, 1]]).
```

`000 → 001 → 011 → 010 → 110 → 111 → 101 → 100 → 000 → 001`: all eight
states, one bit change at a time, and back to the start.

---

# The reason

```sh
eyeprolog --proof examples/gray-code-counter.pl
```

```text
step(gcc(1, [0, 0, 0], [0, 0, 1]),
     rule(15),
     ['C' = 1,
      'Qa' = 0,
```

The first tick is one application of the circuit rule (clause 15) to state
`000` with the clock high. Below it, steps cite gate facts such as
`and(0, 0, 0)`: the proof is a gate-level trace of the whole run.

---

# The check

```text
condition('C1', resolution, ok, 44).
condition('C4', coverage, ok, 136).
steps(44).
verified(44).
recomputed(0).
trusted(0).
claims(1).
verdict(checked).
```

All 44 steps are replayed against the circuit's clauses. No arithmetic is
involved; the gates are facts, so the whole trace is checked by resolution
alone.

---

# Try it

- Hold the clock low on the third tick (`[1, 1, 0, 1, 1, 1, 1, 1, 1]`). The
  state `011` repeats once, then counting resumes.
- Write a relation that checks that two consecutive states differ in exactly
  one bit, and use it to test the whole sequence.
- Run the circuit backwards: which states lead to `[0, 0, 0]` in one tick?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 10.
