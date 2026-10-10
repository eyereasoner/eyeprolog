# New Scientist Enigma 1225

## Which symmetric 8 × 8 grid scores highest?

This puzzle from New Scientist's Enigma series is solved here with the program
from a published study of logic-programming solutions to it. The program
searches over grids whose rows, rearranged, give back the columns, numbers the
cells, and keeps the arrangement with the highest score in a single pass.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=enigma1225) ·
[Source](../enigma1225.pl)

---

# The question

In the program's formulation: take an 8 × 8 grid of cells. Rearranging its
rows by some permutation must give its transpose (rows become columns), and
all rows must differ. Cells that the symmetry forces to be equal share a
number. Numbers are handed out so that more frequent cells get larger numbers.
Which permutation and grid give the largest total, the sum over all cells?

---

# The search space

```prolog
square(Size, M, Total, Frequencies, Permutation) :-
    var_matrix(Size, M),
    ad_partition(Size, Partition),
    rep_perm(Size, Partition, Permutation),
    list_permute(Permutation, M, P),
    transpose_matrix(P, M),
    distinct(M),
    eval_matrix(M, Frequencies),
    total(Frequencies, Total).
```

The grid starts as 64 unbound variables. Instead of trying all 8! row
permutations, the program tries one representative for each **cycle type**,
enumerated as integer partitions of 8. Unifying the permuted rows with the
transpose then forces cells to share variables.

---

# Keeping the best

```prolog
:- table generator/2.

enigma1225(Size, [Permutation, Board, Max]) :-
    aggregate_max(Total, board(M, Perm),
                  square(Size, M, Total, _, Perm),
                  Max, board(Board, Permutation)).
```

`aggregate_max/5` keeps only the best candidate as the search runs.
`generator/2`, which enumerates the partitions, is tabled.

---

# The answer

```sh
eyeprolog examples/enigma1225.pl
```

```text
enigma1225(8, [[2, 1, 4, 3, 6, 5, 8, 7], [[1, 1, 2, 3, 4, 5, 6, 7], [1, 1, 3, 2, 5, 4, 7, 6], [3, 2, 8, 8, 9, 10, 11, 12], [2, 3, 8, 8, 10, 9, 12, 11], [5, 4, 10, 9, 13, 13, 14, 15], [4, 5, 9, 10, 13, 13, 15, 14], [7, 6, 12, 11, 15, 14, 16, 16], [6, 7, 11, 12, 14, 15, 16, 16]], 544]).
```

The best permutation swaps rows in pairs: 2, 1, 4, 3, 6, 5, 8, 7. The grid
then uses the numbers 1 to 16, each in exactly four cells, for a total of
4 × (1 + 2 + … + 16) = 544.

---

# The reason

```sh
eyeprolog --proof examples/enigma1225.pl
```

```text
step(enigma1225(8, [[2, 1, 4, 3, 6, 5, 8, 7], [[1, 1, 2, 3, 4, 5, 6, 7], [1, 1, 3, 2, 5, 4, 7, 6], [3, 2, 8, 8, 9, 10, 11, 12], [2, 3, 8, 8, 10, 9, 12, 11], [5, 4, 10, 9, 13, 13, 14, 15], [4, 5, 9, 10, 13, 13, 15, 14], [7, 6, 12, 11, 15, 14, 16, 16], [6, 7, 11, 12, 14, 15, 16, 16]], 544]),
     rule(2),
```

The proof is short: the answer rests on clause 2 and a single
`aggregate_max/5` step that chose this board as the maximum.

---

# The check

```sh
eyeprolog --proof examples/enigma1225.pl > enigma1225.why.pl
eyeprolog --check-proof enigma1225.why.pl examples/enigma1225.pl
```

```text
condition('C1', resolution, ok, 1).
condition('C4', coverage, ok, 2).
condition('C7', relevance, ok, 3).
obligation(builtin, theory_scoped, aggregate_max(A, board(B, C), square(8, B, A, D, C), 544, board([[1, 1, 2, 3, 4, 5, 6, 7], [1, 1, 3, 2, 5, 4, 7, 6], [3, 2, 8, 8, 9, 10, 11, 12], [2, 3, 8, 8, 10, 9, 12, 11], [5, 4, 10, 9, 13, 13, 14, 15], [4, 5, 9, 10, 13, 13, 15, 14], [7, 6, 12, 11, 15, 14, 16, 16], [6, 7, 11, 12, 14, 15, 16, 16]], [2, 1, 4, 3, 6, 5, 8, 7]))).
verdict(checked_with_obligations).
```

The rule step replays, but "544 is the **maximum**" is a claim about the whole
search, so it is an obligation: the checker records it as assumed rather than
proved. Here, the arithmetic above gives an independent sanity check.

---

# Try it

- Run `--goal 'enigma1225(4, R)'` for a 4 × 4 grid and predict the total
  first.
- Ask `--goal 'square(8, M, T, _, [2, 1, 4, 3, 6, 5, 8, 7])'` to see the
  winning permutation on its own.
- Why does trying one permutation per cycle type lose no solutions?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 28 (symmetry reduces search).
