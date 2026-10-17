# Global constraints over integers

## How do whole-problem constraints describe tables, schedules, costs, and tours?

Some conditions are about a whole group of variables at once: "these values
must form one round trip", "this pair must come from a table". CLP(Z) calls
them **global constraints**. This example puts four of them to work in four
small puzzles.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpz-global-constraints) ·
[Source](../clpz-global-constraints.pl)

---

# The question

Each clause of `advanced_clpz/2` poses one small problem:

- **table:** which partner values are compatible with 4?
- **schedule:** at what times can three tasks start without overlapping?
- **cardinality:** how can three slots be filled with two 1s and one 3, and
  what does each choice cost?
- **circuit:** which successor list visits four places in one tour?

---

# A compatibility table and a tour

```prolog
advanced_clpz(table, compatible(4, Y, Distinct)) :-
  tuples_in([[X, Y]], [[1, 2], [1, 5], [4, 0], [4, 3]]),
  X = 4,
  nvalue(Distinct, [X, Y]),
  labeling([], [Y]).

advanced_clpz(circuit, successors(Values)) :-
  Values = [A, B, _, _],
  circuit(Values),
  A #= 2,
  B #= 3,
  labeling([ff], Values).
```

`tuples_in/2` restricts a pair to the rows of a table; `nvalue/2` counts
distinct values. In `circuit/1`, position *i* holds the successor of place *i*,
and the whole list must form a single cycle through all places.

---

# A schedule and a costed assignment

```prolog
advanced_clpz(schedule, starts([A, B, C])) :-
  [A, B, C] ins 0..3,
  lex_chain([[A, B], [B, C]]),
  serialized([A, B, C], [1, 2, 1]),
  A #< B,
  B #< C,
  labeling([ff], [A, B, C]).

advanced_clpz(cardinality, assignment(Values, Cost, Order)) :-
  Values = [_, _, _],
  global_cardinality(Values, [1-2, 3-1],
    [cost(Cost, [[5, 1], [2, 4], [3, 6]])]),
  labeling([ff], Values),
  zcompare(Order, Cost, 10).
```

`serialized/2` keeps tasks with durations 1, 2, and 1 from overlapping.
`global_cardinality/3` fixes how often each value occurs and charges a cost
per slot and value. `zcompare/3` compares that cost with 10.

---

# The answer

```sh
eyeprolog examples/clpz-global-constraints.pl
```

```text
advanced_clpz(table, compatible(4, 0, 2)).
advanced_clpz(table, compatible(4, 3, 2)).
advanced_clpz(schedule, starts([0, 1, 3])).
advanced_clpz(cardinality, assignment([1, 1, 3], 13, >)).
advanced_clpz(cardinality, assignment([1, 3, 1], 12, >)).
advanced_clpz(cardinality, assignment([3, 1, 1], 6, <)).
advanced_clpz(circuit, successors([2, 3, 4, 1])).
```

Two table partners for 4, one schedule, three costed assignments, and the
single tour 1 → 2 → 3 → 4 → 1.

---

# The reason

```text
step(advanced_clpz(table, compatible(4, 0, 2)),
     rule(1),
     ['Y' = 0, 'Distinct' = 2, 'X' = 4],
     [tuples_in([[4, 0]], [[1, 2], [1, 5], [4, 0], [4, 3]]),
      4 = 4,
      nvalue(2, [4, 0]),
      labeling([], [0])]).
step(tuples_in([[4, 0]], [[1, 2], [1, 5], [4, 0], [4, 3]]), builtin, [], []).
```

`compatible(4, 0, 2)` holds by the first rule: `[4, 0]` is a row of the table,
and the pair has two distinct values. Each constraint appears with its final
values filled in.

---

# The check

```text
condition('C1', resolution, ok, 7).
condition('C5', re_decision, ok, 40).
steps(47).
recomputed(34).
composed(6).
trusted(0).
verdict(checked).
```

All 7 rule steps resolve, and the checker recomputes 34 constraint steps on
their ground values: once the variables are bound, each global constraint is a
plain test. The 6 `control` steps are the branches the compiled constraints
took, each composed from the goals it rests on. Nothing is trusted.

---

# Try it

- Remove `B #= 3` from the circuit clause. A second tour appears:
  `successors([2, 4, 1, 3])`.
- Add `[4, 7]` to the compatibility table and predict the new answers.
- Change the task durations in `serialized/2` to `[2, 2, 1]`. Does a schedule
  within `0..3` still exist?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
