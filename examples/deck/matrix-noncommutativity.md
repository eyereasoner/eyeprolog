# Matrix multiplication is not commutative

## Does A·B always equal B·A?

For numbers, the order of multiplication never matters. For matrices it
does. This example multiplies two 2×2 matrices both ways and shows the
results differ: one concrete pair is enough to refute a universal claim.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=matrix-noncommutativity) ·
[Source](../matrix-noncommutativity.pl)

---

# The question

Is matrix multiplication commutative? A proof that it *is* would have to cover
every pair of matrices. A proof that it *is not* needs only one
counterexample.

---

# The facts

```prolog
matrix_a([[1, 2], [0, 1]]).
matrix_b([[1, 0], [3, 1]]).
```

A matrix is a list of rows. Both matrices are small enough to multiply by
hand.

---

# The rules

```prolog
dot2([X1, X2], [Y1, Y2], R) :-
  (P1 is X1 * Y1),
  (P2 is X2 * Y2),
  (R is P1 + P2).

row_times_matrix(Row, Matrix, [R1, R2]) :-
  transpose2(Matrix, [Col1, Col2]),
  dot2(Row, Col1, R1),
  dot2(Row, Col2, R2).

matrix_result(commutative, false) :-
  matrix_a(A),
  matrix_b(B),
  matrix_mul(A, B, Ab),
  matrix_mul(B, A, Ba),
  (Ab \= Ba).
```

Each entry of a product is the dot product of a row with a column.
`matrix_result(commutative, false)` holds only if the two products differ.

---

# The answer

```sh
eyeprolog examples/matrix-noncommutativity.pl
```

```text
matrix_result(ab, [[7, 2], [3, 1]]).
matrix_result(ba, [[1, 2], [3, 7]]).
matrix_result(commutative, false).
```

A·B and B·A contain the same numbers in different places, so they are
different matrices.

---

# The reason

```text
step(matrix_result(commutative, false),
     rule(9),
     ['A' = [[1, 2], [0, 1]],
      'B' = [[1, 0], [3, 1]],
      'Ab' = [[7, 2], [3, 1]],
      'Ba' = [[1, 2], [3, 7]]],
     [matrix_a([[1, 2], [0, 1]]),
      matrix_b([[1, 0], [3, 1]]),
      matrix_mul([[1, 2], [0, 1]], [[1, 0], [3, 1]], [[7, 2], [3, 1]]),
      matrix_mul([[1, 0], [3, 1]], [[1, 2], [0, 1]], [[1, 2], [3, 7]]),
      [[7, 2], [3, 1]] \= [[1, 2], [3, 7]]]).
```

The conclusion rests on the two products and the final test that they do not
unify. Each product has its own steps, down to the individual multiplications.

---

# The check

```text
condition('C1', resolution, ok, 21).
condition('C5', re_decision, ok, 19).
steps(40).
verified(21).
recomputed(19).
trusted(0).
verdict(checked).
```

All 21 rule steps replay, and the 19 arithmetic and comparison steps are
recomputed independently. The counterexample is fully checked, with nothing
taken on trust.

---

# Try it

- Replace `matrix_b` with the identity matrix `[[1, 0], [0, 1]]`. What does
  `matrix_result(commutative, X)` give now, and why is that not a proof of
  commutativity?
- Find two non-identity 2×2 matrices that do commute (try diagonal matrices).
- Extend `matrix_mul/3` to 3×3 matrices.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
