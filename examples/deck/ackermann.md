# Ackermann

## How fast can a tiny recursive definition grow?

The Ackermann function is the classic example of a computable function that
grows faster than any loop nest can express. This example defines it through a
ladder of hyperoperations (successor, addition, multiplication,
exponentiation, and beyond) and computes twelve values, one of them with 19,729
digits.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=ackermann) ·
[Source](../ackermann.pl)

---

# The question

What is `ackermann(X, Y)` for a dozen chosen inputs, from `[0, 0]` up to
`[4, 2]` and `[5, 0]`?

Each level of the ladder repeats the level below it: addition repeats the
successor, multiplication repeats addition, exponentiation repeats
multiplication. From level 4 on, the numbers explode.

---

# The hyperoperation ladder

```prolog
hyper(0, Y, _z, A) :- (A is Y + 1).
hyper(1, Y, Z, A) :- (A is Y + Z).
hyper(2, Y, Z, A) :- (A is Y * Z).
hyper(3, Y, Z, A) :- (A is Z ^ Y).

hyper(X, 0, _z, 1) :- (X > 3).
hyper(X, Y, Z, A) :-
  (X > 3),
  (Y \= 0),
  (B is Y - 1),
  hyper(X, B, Z, C),
  (D is X - 1),
  hyper(D, C, Z, A).
```

Levels 0–3 use arithmetic directly. A higher level `X` with count `Y` is
defined by computing level `X` with count `Y - 1` and feeding the result into
level `X - 1`. Integers have arbitrary precision, so nothing overflows.

---

# The Ackermann offset

```prolog
ackermann(X, Y, A) :-
  (B is Y + 3),
  hyper(X, B, 2, C),
  (A is C - 3).

ackermann([X, Y], A) :-
  ack_case(X, Y),
  ackermann(X, Y, A).
```

The identity `ackermann(X, Y) = hyper(X, Y + 3, 2) - 3` connects the two-argument
Ackermann function to the ladder. The `ack_case/2` facts list the inputs to
compute, so the query is finite.

---

# The answer

```sh
eyeprolog examples/ackermann.pl
```

```text
ackermann([0, 0], 1).
ackermann([0, 6], 7).
ackermann([1, 2], 4).
ackermann([1, 7], 9).
ackermann([2, 2], 7).
ackermann([2, 9], 21).
ackermann([3, 4], 125).
ackermann([4, 0], 13).
ackermann([4, 1], 65533).
ackermann([5, 0], 65533).
```

Twelve answers in all. The two not shown are `ackermann([3, 1000], …)`, a
302-digit number, and `ackermann([4, 2], …)`, which is 2^65536 − 3 and has
19,729 digits. See [the full output](../output/ackermann.pl).

---

# The reason

```sh
eyeprolog --proof examples/ackermann.pl
```

```text
step(ackermann(0, 0, 1),
     rule(1),
     ['X' = 0, 'Y' = 0, 'A' = 1, 'B' = 3, 'C' = 4],
     [3 is 0 + 3, hyper(0, 3, 2, 4), 1 is 4 - 3]).
step(hyper(0, 3, 2, 4), rule(2), ['Y' = 3, 'A' = 4], [4 is 3 + 1]).
step(4 is 3 + 1, builtin, [], []).
```

`ackermann(0, 0)` is 1 because 0 + 3 = 3, the successor of 3 is 4, and
4 − 3 = 1. Rule steps name the clause and bindings; arithmetic steps are
marked `builtin`.

---

# The check

```text
condition('C1', resolution, ok, 59).
condition('C5', re_decision, ok, 43).
condition('C7', relevance, ok, 114).
recomputed(43).
trusted(0).
verdict(checked).
```

The checker verifies 59 rule and fact steps against their clauses and
**recomputes** all 43 arithmetic steps itself, in a program that holds none of
the example's clauses. Nothing is taken on trust, not even the 19,729-digit
result.

---

# Try it

- Add `ack_case(3, 10).` and predict the answer from `hyper(3, …)`: it is
  2^13 − 3.
- Why does the program list its inputs as `ack_case/2` facts instead of
  generating `X` and `Y` with `between/3`?
- Time `ack_case(4, 2)` with `--stats`. Which part of the work is recursion and
  which is big-integer arithmetic?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 27.
