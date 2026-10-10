# Law of cosines

## How long is the third side of a triangle?

Given two sides of a triangle and the angle between them, the **law of
cosines** gives the third side: c² = a² + b² − 2ab·cos C. This example
computes it step by step, so the proof shows every intermediate number.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=law-of-cosines) ·
[Source](../law-of-cosines.pl)

---

# The question

A triangle has sides 7 and 9 with a 60° angle between them. How long is the
third side?

The example keeps trigonometry out of the program: it stores cos 60° = 0.5 as
data, and the rules do only the algebra.

---

# The data

```prolog
triangle(tri60, 7, 9, 0.5).
```

`triangle(Name, A, B, CosC)` records the two known sides and the cosine of the
angle between them.

---

# The formula, one step at a time

```prolog
side_c_squared(Triangle, C2) :-
  triangle(Triangle, A, B, Cosc),
  (A2 is A * A),
  (B2 is B * B),
  (Sum is A2 + B2),
  (Twoa is 2 * A),
  (Twoab is Twoa * B),
  (Projection is Twoab * Cosc),
  (C2 is Sum - Projection).

side_c(Triangle, C) :-
  side_c_squared(Triangle, C2),
  (C is C2 ** 0.5).
```

Each `is/2` goal computes one named quantity. That costs a few lines, but
every intermediate value then appears in the proof.

---

# The answer

```sh
eyeprolog examples/law-of-cosines.pl
```

```text
sideCSquared(tri60, 67.0).
sideC(tri60, 8.18535277187245).
status(tri60, acute_triangle).
```

c² = 49 + 81 − 63 = 67, so c ≈ 8.185.

---

# The reason

```sh
eyeprolog --proof examples/law-of-cosines.pl
```

```text
step(side_c_squared(tri60, 67.0),
     rule(2),
     ['Triangle' = tri60,
      'C2' = 67.0,
      'A' = 7,
      'B' = 9,
      'Cosc' = 0.5,
      'A2' = 49,
      'B2' = 81,
      'Sum' = 130,
      'Twoa' = 14,
      'Twoab' = 126,
      'Projection' = 63.0],
```

The step lists every binding of the rule, 49, 81, 130, 14, 126 and 63.0, which
is exactly the hand calculation. Each arithmetic goal is a separate premise.

---

# The check

```text
condition('C1', resolution, ok, 6).
condition('C5', re_decision, ok, 9).
condition('C7', relevance, ok, 18).
verdict(checked).
```

Six rule and fact steps replay against the program, and all nine arithmetic
steps are recomputed independently and agree. The derivation is fully checked,
under the floating-point arithmetic that produced it.

---

# Try it

- Add `triangle(tri90, 3, 4, 0).` A right angle has cosine 0, and the law
  reduces to Pythagoras: `sideC(tri90, 5.0)`.
- Add `triangle(tri120, 7, 9, -0.5).` It is reported as `acute_triangle`
  too, although 120° is obtuse. The status rule only tests `C2 > 0`, which
  holds for every triangle. Fix it so the label follows the sign of the
  cosine.
- Compute the angle back from three sides by solving the formula for cos C.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
