# Catalan numbers

## How many ways can you cut a polygon into triangles?

A 14-sided polygon can be split into triangles by non-crossing diagonals in
208,012 ways. The same number counts the ways to bracket a product of 13
factors. Both are Catalan numbers, and EyeProlog computes them from one
recursive definition.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=catalan-convolution) ·
[Source](../catalan-convolution.pl)

---

# The question

The Catalan numbers 1, 1, 2, 5, 14, 42, … count many recursive shapes: binary
trees, bracketings, polygon triangulations. Each shape splits into a left part
and a right part, and the count is the sum over all splits:

C₀ = 1, Cₙ = Σᵢ Cᵢ · Cₙ₋₁₋ᵢ

---

# The definition

```prolog
:- table catalan/2.

catalan(0, 1).
catalan(N, C) :-
  (N > 0),
  (N1 is N - 1),
  sumall(Product,
    (between(0, N1, I),
     (J is N1 - I),
     catalan(I, A),
     catalan(J, B),
     (Product is A * B)),
    C).
```

The rule is the formula. Without tabling, the same smaller values would be
recomputed over and over; with `:- table catalan/2.` each one is computed once.

---

# Three readings of one number

```prolog
polygon_triangulations(Sides, Count) :-
  (Sides >= 3),
  (N is Sides - 2),
  catalan(N, Count).

parenthesizations(Factors, Count) :-
  (Factors >= 1),
  (N is Factors - 1),
  catalan(N, Count).
```

An *n*-gon has Cₙ₋₂ triangulations, and a product of *k* factors has Cₖ₋₁
bracketings. The wrappers only shift the index.

---

# The answer

```sh
eyeprolog examples/catalan-convolution.pl
```

```text
catalan_answer(catalan_12, 208012).
catalan_answer(triangulations_14_gon, 208012).
catalan_answer(parenthesizations_13_factors, 208012).
catalan_answer(first_ten_sum, 6918).
```

---

# The reason

```text
step(polygon_triangulations(14, 208012),
     rule(4),
     ['Sides' = 14, 'Count' = 208012, 'N' = 12],
     [14 >= 3, 12 is 14 - 2, catalan(12, 208012)]).
step(catalan(12, 208012),
     rule(3),
     ['N' = 12, 'C' = 208012, 'N1' = 11],
     [12 > 0,
      11 is 12 - 1,
      sumall(Expression, (between(0, 11, I), J is 11 - I, catalan(I, A), catalan(J, B), Expression is A * B), 208012)]).
```

The triangulation count is C₁₂, and C₁₂ is the sum of the twelve products
C₀·C₁₁, C₁·C₁₀, …, C₁₁·C₀.

---

# The check

```text
condition('C1', resolution, ok, 7).
condition('C5', re_decision, ok, 6).
obligation(builtin, theory_scoped, sumall(A, (between(0, 11, B), C is 11 - B, catalan(B, D), catalan(C, E), A is D * E), 208012)).
obligation(builtin, theory_scoped, sumall(A, (between(0, 9, B), catalan(B, A)), 6918)).
verdict(checked_with_obligations).
```

The rule steps and arithmetic are replayed. The two sums run a nested search
over the program's own `catalan/2`, which the checker cannot recompute without
the program, so it lists them as **obligations** rather than claiming them.

---

# Try it

- Ask `--goal 'catalan(15, C)'`. The answer is 9694845.
- Ask `--goal 'polygon_triangulations(6, T)'` and draw the 14 triangulations
  of a hexagon.
- Remove the `table` declaration and time `catalan(15, C)` again. Why does it
  get so much slower?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 8, 13 and 27.
