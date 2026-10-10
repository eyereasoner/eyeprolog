# The quadratic formula

## Where does a parabola cross zero?

For each equation a·x² + b·x + c = 0, the program computes the discriminant
and both roots, one algebraic step per rule. The proof then shows every
intermediate value, so the calculation can be audited line by line.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=quadratic-formula) ·
[Source](../quadratic-formula.pl)

---

# The question

What are the real roots of x² − 5x + 6 = 0 and 2x² − 4x − 6 = 0?

The quadratic formula gives x = (−b ± √(b² − 4ac)) / 2a. The quantity
b² − 4ac is the **discriminant**: positive means two real roots, zero means
one, negative means none.

---

# The equations

```prolog
equation(eq1, 1.0, -5.0, 6.0).
equation(eq2, 2.0, -4.0, -6.0).
```

Each fact stores the coefficients a, b, and c.

---

# The rules

```prolog
discriminant(Case, D) :-
  equation(Case, A, B, C),
  (B2 is B ** 2.0),
  (Foura is 4.0 * A),
  (Fourac is Foura * C),
  (D is B2 - Fourac).

sqrt_discriminant(Case, S) :-
  discriminant(Case, D),
  (D >= 0.0),
  (S is D ** 0.5).
```

The formula is split into small named steps: discriminant, its square root,
−b, the denominator 2a, and the two branches. The test `D >= 0.0` means an
equation with no real roots simply has no `root/2` answers.

---

# The answer

```sh
eyeprolog examples/quadratic-formula.pl
```

```text
discriminant(eq1, 1.0).
discriminant(eq2, 64.0).
root(eq1, 3.0).
root(eq2, 3.0).
root(eq1, 2.0).
root(eq2, -1.0).
```

x² − 5x + 6 has roots 3 and 2; 2x² − 4x − 6 has roots 3 and −1.

---

# The reason

```text
step(sqrt_discriminant(eq2, 8.0),
     rule(4),
     ['Case' = eq2, 'S' = 8.0, 'D' = 64.0],
     [discriminant(eq2, 64.0), 64.0 >= 0.0, 8.0 is 64.0 ** 0.5]).
step(root(eq2, -1.0), rule(10), ['Case' = eq2, 'Root' = -1.0], [root_minus(eq2, -1.0)]).
```

Each arithmetic goal appears with its actual values, such as
`8.0 is 64.0 ** 0.5`, so a reader can redo the calculation by hand.

---

# The check

```text
condition('C1', resolution, ok, 18).
condition('C5', re_decision, ok, 24).
condition('C7', relevance, ok, 48).
trusted(0).
verdict(checked).
```

18 rule and fact steps replay against their clauses, and the checker
**recomputes** all 24 arithmetic steps itself. Nothing is taken on trust.

---

# Try it

- Add `equation(eq3, 1.0, 0.0, 1.0).` Its discriminant is −4.0 and it gets no
  roots.
- Add `equation(eq4, 1.0, -2.0, 1.0).` The discriminant is 0.0, and the double
  root 1.0 is printed once, because duplicate answers are suppressed.
- Write a rule that reports `complex_roots(Case)` when the discriminant is
  negative.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6.
