# Allen's interval calculus

## How do two time intervals relate?

Two intervals of time can relate in exactly thirteen ways: one is before the
other, meets it, overlaps it, starts it, and so on. James Allen's 1983 interval
calculus names them. This example derives every relation between eleven
intervals from their start and end hours.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=allen-interval-calculus) ·
[Source](../allen-interval-calculus.pl)

---

# The question

Given eleven intervals on a day, each with a start and end hour, which of
Allen's relations hold between each pair?

Scheduling, logistics, and medical timelines all ask this question: did the
treatment *start* during the episode, does one shift *meet* the next, are two
meetings *equal*?

---

# The data as one table

```prolog
interval_table([
  interval(a, 10, 12),
  interval(b, 13, 15),
  interval(c, 12, 14),
  interval(d, 11, 13),
  interval(e, 10, 12),
  interval(f, 10, 11),
  interval(g, 11, 12),
  interval(h, 9, 16),
  interval(i, 16, 18),
  interval(j, 15, 16),
  interval(k, 13, 14)
]).

start(I, Start) :- interval_table(Table), member(interval(I, Start, _end), Table).
end(I, End) :- interval_table(Table), member(interval(I, _start, End), Table).
```

The intervals are one term, a list of records, rather than many unrelated
global facts. `start/2` and `end/2` read fields out of it.

---

# Seven relations and their inverses

```prolog
relation(I, before, J) :- end(I, Ei), start(J, Sj), (Ei < Sj).
relation(I, meets, J) :- end(I, E), start(J, E).
relation(I, starts, J) :-
  start(I, S), start(J, S),
  end(I, Ei), end(J, Ej),
  (Ei < Ej).
relation(I, equals, J) :-
  start(I, S), start(J, S),
  end(I, E), end(J, E).

relation(J, after, I) :- relation(I, before, J).
relation(J, metBy, I) :- relation(I, meets, J).
```

Each relation is a comparison of endpoints. The six inverse relations
(`after`, `metBy`, `overlappedBy`, `startedBy`, `contains`, `finishedBy`) are
defined from the forward ones, so no comparison is written twice. `overlaps`,
`during`, and `finishes` follow the same pattern.

---

# The answer

```sh
eyeprolog examples/allen-interval-calculus.pl
```

```text
statement(a, before, b).
statement(a, meets, c).
statement(a, equals, e).
statement(f, meets, g).
statement(f, starts, a).
statement(g, finishes, a).
statement(h, contains, a).
```

A selection from 154 answers: 11 starts, 11 ends, 11 durations, and 121
relation statements. Interval `a` (10–12) meets `c` (12–14), equals `e`, is
started by `f` (10–11), finished by `g` (11–12), and lies during `h` (9–16).

---

# The reason

```sh
eyeprolog --proof examples/allen-interval-calculus.pl
```

```text
step(relation(f, starts, a),
     rule(8),
     ['I' = f, 'J' = a, 'S' = 10, 'Ei' = 11, 'Ej' = 12],
     [start(f, 10), start(a, 10), end(f, 11), end(a, 12), 11 < 12]).
```

Interval `f` starts `a` because both start at 10 (`S = 10`) and `f` ends first,
at 11 against 12. Each endpoint fact is in turn read from the table through a
`member/2` built-in step.

---

# The check

```text
condition('C1', resolution, ok, 276).
condition('C5', re_decision, ok, 40).
condition('C7', relevance, ok, 470).
recomputed(40).
trusted(0).
claims(154).
verdict(checked).
```

All 154 claims are covered by 316 steps: 276 checked against the program and
40 built-in steps recomputed by the checker. Nothing is taken on trust.

---

# Try it

- Add `interval(l, 12, 13)` and predict its relations to `a`, `c`, and `d`.
- Which of Allen's thirteen relations never appears for this data? Add an
  interval that produces it.
- Write `disjoint(I, J)` as "before or after", and `intersects(I, J)` as its
  negation over the known intervals.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 9.
