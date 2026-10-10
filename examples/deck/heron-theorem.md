# Heron's theorem

## What is the area of a triangle when you only know its sides?

Heron of Alexandria gave the answer about two thousand years ago:
`area = sqrt(s(s-a)(s-b)(s-c))`, where `s` is half the perimeter. This
example computes it for the classic 13-14-15 triangle, whose area is exactly
84, and every arithmetic step shows up in the proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=heron-theorem) ·
[Source](../heron-theorem.pl)

---

# The question

A surveyor measures the three sides of a field plot: 13, 14 and 15 metres.
What is its area, and is it a valid (non-degenerate) triangle?

The formula is theorem-shaped arithmetic: name the object, compute the
intermediate quantities, and report the result in domain vocabulary.

---

# The model

```prolog
triangle(field_plot, 13, 14, 15).

semiperimeter(Triangle, S) :-
  triangle(Triangle, A, B, C),
  (Ab is A + B),
  (Sum is Ab + C),
  (S is Sum / 2).
```

One fact names the triangle. The semiperimeter is the first reusable step:
half of `13 + 14 + 15`, which is 21.

---

# The rules

```prolog
heron_product(Triangle, Product) :-
  triangle(Triangle, A, B, C),
  semiperimeter(Triangle, S),
  (Sa is S - A),
  (Sb is S - B),
  (Sc is S - C),
  (T1 is S * Sa),
  (T2 is T1 * Sb),
  (Product is T2 * Sc).

area(Triangle, Area) :-
  heron_product(Triangle, Product),
  (Area is Product ** 0.5).

status(Triangle, valid_survey_triangle) :- area(Triangle, A), (A > 0).
```

Each multiplication is its own goal, so the proof can show every
intermediate value: `21 × 8 × 7 × 6 = 7056`, and the square root of 7056 is 84.

---

# The answer

```sh
eyeprolog examples/heron-theorem.pl
```

```text
semiperimeter(field_plot, 21.0).
area(field_plot, 84.0).
heronProduct(field_plot, 7056.0).
status(field_plot, valid_survey_triangle).
```

The results are floats because `/` and `**` always produce floats in ISO
Prolog, even when the value happens to be a whole number.

---

# The reason

```sh
eyeprolog --proof examples/heron-theorem.pl
```

```text
step(area(field_plot, 84.0),
     rule(4),
     ['Triangle' = field_plot, 'Area' = 84.0, 'Product' = 7056.0],
     [heron_product(field_plot, 7056.0), 84.0 is 7056.0 ** 0.5]).
step(7056.0 is 1176.0 * 6.0, builtin, [], []).
```

The area is 84.0 by rule 4, because the Heron product is 7056.0 and its
square root is 84.0. That product is itself justified step by step, down to
the last multiplication `1176.0 * 6.0`.

---

# The check

```text
condition('C1', resolution, ok, 6).
condition('C5', re_decision, ok, 11).
condition('C7', relevance, ok, 21).
verdict(checked).
```

Six rule and fact steps replay against their clauses, and the checker
recomputes all 11 arithmetic steps itself. Every number in the proof is
confirmed, not trusted.

---

# Try it

- Add `triangle(right_plot, 3, 4, 5).` The area of a 3-4-5 right triangle is
  `3 × 4 / 2 = 6`; check that Heron's formula agrees.
- Change the sides to `1, 2, 3`. The triangle is flat: the area is `0.0` and
  `status/2` no longer reports it as valid.
- Change them to `1, 1, 5`, which cannot form a triangle. The Heron product
  becomes negative, and the square root raises
  `evaluation_error(undefined)`. How would you add an integrity check that
  rejects such input before the arithmetic runs?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6.
