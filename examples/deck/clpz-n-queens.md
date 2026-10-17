# N queens with constraints

## How can N queens share a board without attacking each other?

Place N chess queens on an N × N board so that no two share a row, a column,
or a diagonal. Integer constraints describe the board, and a short labeling
search finds every placement.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpz-n-queens) ·
[Source](../clpz-n-queens.pl)

---

# The question

A queen attacks along its row, its column, and both diagonals. Which
placements of N queens leave every queen safe? The example solves the
four-queens puzzle by search and checks a known eight-queens solution.

---

# The representation

```prolog
queens(Size, Rows) :-
  length(Rows, Size),
  Rows ins 1..Size,
  all_distinct(Rows),
  safe_diagonals(Rows),
  labeling([ff], Rows).
```

The list position is the column and the value is the row, so two queens can
never share a column. `all_distinct/1` keeps rows apart. Only diagonals are
left, and `labeling([ff], Rows)` searches, choosing the most constrained
column first ("first fail").

---

# The diagonals

```prolog
safe_from(_, [], _).
safe_from(Row, [Other|Rows], Distance) :-
  Row #\= Other + Distance,
  Row #\= Other - Distance,
  NextDistance is Distance + 1,
  safe_from(Row, Rows, NextDistance).
```

Two queens `Distance` columns apart share a diagonal exactly when their rows
differ by `Distance`. The constraints are posted before any row is chosen, so
each choice immediately removes the attacked squares from the other columns.

---

# The answer

```sh
eyeprolog examples/clpz-n-queens.pl
```

```text
queens8_witness([1, 5, 8, 6, 3, 7, 2, 4]).
queens(4, [2, 4, 1, 3]).
queens(4, [3, 1, 4, 2]).
```

Four queens have exactly two placements, mirror images of each other.
`queens8_witness/1` does not search: it fills in a known eight-queens solution
first and lets the constraints confirm it.

---

# The reason

```text
step(queens(8, [1, 5, 8, 6, 3, 7, 2, 4]),
     rule(2),
     ['Size' = 8, 'Rows' = [1, 5, 8, 6, 3, 7, 2, 4]],
     [length([1, 5, 8, 6, 3, 7, 2, 4], 8),
      [1, 5, 8, 6, 3, 7, 2, 4] ins 1..8,
      all_distinct([1, 5, 8, 6, 3, 7, 2, 4]),
      safe_diagonals([1, 5, 8, 6, 3, 7, 2, 4]),
      labeling([ff], [1, 5, 8, 6, 3, 7, 2, 4])]).
```

The eight-queens placement is valid by the `queens/2` rule: eight rows, all
in range, all distinct, and safe on the diagonals. Further steps prove
`safe_diagonals/1` one queen pair at a time.

---

# The check

```text
condition('C1', resolution, ok, 76).
condition('C4', coverage, ok, 602).
condition('C5', re_decision, ok, 262).
steps(338).
trusted(0).
verdict(checked).
```

338 steps: 76 resolve against program clauses, 106 constraint steps are
recomputed on their ground values, and 156 `control` steps record which branch
of each compiled diagonal test was taken, composed from the goals it rests on.
The checker confirms every diagonal test without repeating the search.

---

# Try it

- Ask `--goal 'queens(5, R)'`: there are 10 placements. For 6 queens there are
  only 4.
- Break the witness: `--goal 'queens8_witness([1,5,8,6,3,7,2,5])'` gives no
  answer. Which constraint rejects it?
- Replace `[ff]` by `[]` in `labeling/2` and compare `--stats` for
  `queens(8, R)`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
