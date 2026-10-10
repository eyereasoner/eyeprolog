# Sudoku with integer constraints

## Can constraints solve one of the hardest known Sudokus?

AI Escargot is a well-known difficult 9 × 9 Sudoku. EyeProlog states the
rules of Sudoku as integer constraints, and a first-fail search fills in the
grid from its 23 clues to the unique solution.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpz-sudoku-9x9) ·
[Source](../clpz-sudoku-9x9.pl)

---

# The question

Fill every empty cell with a digit 1–9 so that each row, each column, and each
3 × 3 block contains every digit exactly once. The puzzle fixes 23 cells; the
other 58 must be found.

---

# The rules as constraints

```prolog
sudoku9_rows([]).
sudoku9_rows([Row|Rows]) :-
  Row ins 1..9,
  all_distinct(Row),
  sudoku9_rows(Rows).

sudoku9_block_row([], [], []).
sudoku9_block_row([A, B, C|As], [D, E, F|Bs], [G, H, I|Cs]) :-
  all_distinct([A, B, C, D, E, F, G, H, I]),
  sudoku9_block_row(As, Bs, Cs).
```

Every cell is an integer variable in `1..9`. `all_distinct/1` states "all
different" for each row, each column (the transposed rows), and each block,
taking three cells from each of three rows at a time.

---

# Putting it together

```prolog
sudoku9(Rows) :-
  Rows = [
    [1, _, _, _, _, 7, _, 9, _],
    [_, 3, _, _, 2, _, _, _, 8],
    …
  ],
  sudoku9_rows(Rows),
  sudoku9_transpose(Rows, Columns),
  sudoku9_rows_distinct(Columns),
  sudoku9_blocks(Rows),
  sudoku9_flatten(Rows, Cells),
  labeling([ff], Cells).
```

The clues are written straight into the grid; `_` marks an empty cell. All
constraints are posted before `labeling([ff], Cells)` starts guessing, always
at the cell with the fewest remaining candidates.

---

# The answer

```sh
eyeprolog examples/clpz-sudoku-9x9.pl
```

```text
sudoku9([[1, 6, 2, 8, 5, 7, 4, 9, 3], [5, 3, 4, 1, 2, 9, 6, 7, 8], [7, 8, 9, 6, 4, 3, 5, 2, 1], [4, 7, 5, 3, 1, 2, 9, 8, 6], [9, 1, 3, 5, 8, 6, 7, 4, 2], [6, 2, 8, 7, 9, 4, 1, 3, 5], [3, 5, 6, 4, 7, 8, 2, 1, 9], [2, 4, 1, 9, 3, 5, 8, 6, 7], [8, 9, 7, 2, 6, 1, 3, 5, 4]]).
```

One solution, row by row. No shortcut is involved: the run searches from the
clues.

---

# The reason

```text
step(all_distinct([1, 6, 2, 8, 5, 7, 4, 9, 3]), builtin, [], []).
step(all_distinct([1, 6, 2, 5, 3, 4, 7, 8, 9]), builtin, [], []).
```

The proof records the solved grid and then every rule it satisfies. The first
step says the top row holds nine different digits; the second says the same of
the top-left block (1, 6, 2 / 5, 3, 4 / 7, 8, 9). Further steps cover every
other row, column, and block.

---

# The check

```text
condition('C1', resolution, ok, 227).
condition('C5', re_decision, ok, 38).
steps(265).
trusted(0).
verdict(checked).
```

The checker replays 227 rule steps and recomputes 38 `all_distinct/1` and
related built-in steps on the filled-in grid. Checking a solved Sudoku is
easy; finding it was the hard part, and the proof does not need to repeat the
search.

---

# Try it

- Remove the clue `1` in the top-left corner. Is the solution still unique?
  Count the answers with `findall/3`.
- Replace `labeling([ff], Cells)` by `labeling([], Cells)` and compare
  `--stats`.
- Enter an easy newspaper Sudoku in place of the clues and time both.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
