# The Pell equation

## Which whole numbers satisfy x² − 2y² = 1?

The Pell equation x² − 2y² = 1 has infinitely many whole-number solutions, and
they all grow from the smallest one, (3, 2), by a fixed recurrence. This
example generates the solutions with a tabled recurrence and then checks the
equation independently.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=pell-equation) ·
[Source](../pell-equation.pl)

---

# The question

Solutions of x² − 2y² = 1 give ever-better fractions x/y close to √2: 3/2,
17/12, 99/70, and so on. Mathematicians in India and Greece studied them long
before Pell.

The question is concrete: what are the 5th and 8th solutions? Do they really
satisfy the equation? And what is the sum of the first eight y-values?

---

# The recurrence

```prolog
:- table pell/3.

pell(0, 1, 0).
pell(N, X, Y) :-
  (N > 0),
  (N1 is N - 1),
  pell(N1, X0, Y0),
  (Ax is 3 * X0),
  (By is 4 * Y0),
  (X is Ax + By),
  (Cx is 2 * X0),
  (Dy is 3 * Y0),
  (Y is Cx + Dy).
```

From one solution (x, y), the next is (3x + 4y, 2x + 3y). Algebraically this
multiplies by 3 + 2√2. Tabling stores each `pell(N, X, Y)` answer, so the
eight-step sum does not recompute the chain from zero each time.

---

# An independent check

```prolog
pell_holds(N, true) :-
  pell(N, X, Y),
  (X2 is X * X),
  (Y2 is Y * Y),
  (Twicey2 is 2 * Y2),
  (1 is X2 - Twicey2).
```

The recurrence could be wrong. `pell_holds/2` does not trust it: it plugs the
generated numbers back into x² − 2y² and demands exactly 1.

---

# The answer

```sh
eyeprolog examples/pell-equation.pl
```

```text
pell_answer(solution_5, solution(3363, 2378)).
pell_answer(solution_8, solution(665857, 470832)).
pell_answer(check_8, true).
pell_answer(y_sum_1_to_8, 568344).
```

The 8th solution is (665857, 470832), and it satisfies the equation.

---

# The reason

```text
step(pell_holds(8, true),
     rule(4),
     ['N' = 8,
      'X' = 665857,
      'Y' = 470832,
      'X2' = 443365544449,
      'Y2' = 221682772224,
      'Twicey2' = 443365544448],
     [pell(8, 665857, 470832),
      443365544449 is 665857 * 665857,
      221682772224 is 470832 * 470832,
      443365544448 is 2 * 221682772224,
      1 is 443365544449 - 443365544448]).
```

The check is visible in full: 665857² = 443365544449, 2 × 470832² =
443365544448, and their difference is 1.

---

# The check

```text
condition('C1', resolution, ok, 14).
condition('C5', re_decision, ok, 68).
obligation(builtin, theory_scoped, sumall(A, (between(1, 8, B), pell(B, C, A)), 568344)).
trusted(1).
claims(4).
verdict(checked_with_obligations).
```

All 68 arithmetic steps are recomputed and agree. One step cannot be replayed
on its own: the `sumall/3` total calls the program's own `pell/3`, so the
checker cannot recompute it with built-ins alone. It is reported as an
obligation. The three other claims need no trust at all.

---

# Try it

- Ask for `pell(12, X, Y)` and confirm it with `pell_holds/2`.
- Compute x/y as a float for N = 1 to 8 and watch it approach √2.
- Change the equation to x² − 3y² = 1 with fundamental solution (2, 1). What
  is the new recurrence?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13.
