# Continued fraction for √2

## How do the fractions 3/2, 7/5, 17/12, … close in on the square root of two?

√2 has the continued fraction [1; 2, 2, 2, …]. Cutting it off after more and
more terms gives better and better fractions, its *convergents*. A two-line
recurrence generates them, and a table keeps the recurrence fast.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=continued-fraction-sqrt2) ·
[Source](../continued-fraction-sqrt2.pl)

---

# The question

What is the 10th, and the 15th, convergent P/Q of √2? How good is it?

For these convergents there is a neat measure of quality: P² − 2Q² is always
+1 or −1. That is Pell's equation, and it says that P/Q squared is as close to
2 as a fraction with denominator Q can get.

---

# The recurrence

```prolog
:- table conv/3.

conv(0, 1, 1).
conv(1, 3, 2).
conv(N, P, Q) :-
  (N > 1),
  (N1 is N - 1),
  (N2 is N - 2),
  conv(N1, P1, Q1),
  conv(N2, P2, Q2),
  (Twicep1 is 2 * P1),
  (P is Twicep1 + P2),
  (Twiceq1 is 2 * Q1),
  (Q is Twiceq1 + Q2).
```

Each numerator is twice the previous one plus the one before that, and the
same holds for denominators. Like Fibonacci, the plain recurrence asks for the
same earlier convergents again and again. `:- table conv/3.` makes EyeProlog
remember each answer, so every convergent is computed once.

---

# The Pell error

```prolog
pell_error(N, Error) :-
  conv(N, P, Q),
  (P2 is P * P),
  (Q2 is Q * Q),
  (Twiceq2 is 2 * Q2),
  (Error is P2 - Twiceq2).
```

`pell_error/2` turns the claim "P² − 2Q² = ±1" into something you can compute
for any convergent.

---

# The answer

```sh
eyeprolog examples/continued-fraction-sqrt2.pl
```

```text
convergent_answer(convergent_10, fraction(8119, 5741)).
convergent_answer(convergent_15, fraction(665857, 470832)).
convergent_answer(pell_error_15, 1).
convergent_answer(numerator_sum_0_to_10, 13859).
```

665857/470832 agrees with √2 to about eleven decimal places, and its Pell error
is exactly 1. The last line adds up the numerators of convergents 0 to 10.

---

# The reason

```sh
eyeprolog --proof examples/continued-fraction-sqrt2.pl
```

```text
step(convergent_answer(pell_error_15, 1), rule(8), ['Error' = 1], [pell_error(15, 1)]).
step(sumall(Expression, (between(0, 10, N), conv(N, Expression, _q)), 13859), builtin, [], []).
```

The Pell error of 1 rests on `pell_error(15, 1)`, which in turn rests on the
15th convergent and four arithmetic steps. The sum is different: it is
recorded as a single `builtin` step over a whole nested search.

---

# The check

```sh
eyeprolog --proof examples/continued-fraction-sqrt2.pl > cf.why.pl
eyeprolog --check-proof cf.why.pl examples/continued-fraction-sqrt2.pl
```

```text
condition('C1', resolution, ok, 21).
condition('C5', re_decision, ok, 102).
obligation(builtin, theory_scoped, sumall(A, (between(0, 10, B), conv(B, A, C)), 13859)).
trusted(1).
verdict(checked_with_obligations).
```

The checker replays 21 clause steps and recomputes 102 arithmetic steps. The
`sumall/3` step cannot be recomputed on its own, because its inner goal calls
`conv/3`, a predicate of this program. So it stays an **obligation**: the
answer holds provided that sum was collected correctly.

---

# Try it

- Ask `--goal 'pell_error(14, E)'`. The error is −1: the sign alternates from
  one convergent to the next.
- Ask `--goal 'conv(20, P, Q)'` and compare P/Q with √2 on a calculator.
- Remove `:- table conv/3.` and ask for `conv(22, P, Q)`. The answer is the
  same, but it takes seconds instead of a fraction of a second. Why does the
  time grow so fast with N?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 13 and 27.
