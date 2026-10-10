# Abstract interpretation

## Can this program divide by zero?

Instead of running a three-line program for every possible input, this example
tracks only the *sign* of each variable: negative, zero, or positive. A handful
of rules propagate signs through both branches of an `if`, merge them, and
raise a warning because one path can reach the division with `y` equal to zero.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=abstract-interpretation) ·
[Source](../abstract-interpretation.pl)

---

# The question

The program under analysis is:

```text
x := input();
if x < 0 then y := -x else y := x;
z := 10 / y;
```

Is `10 / y` safe for every input? Testing integers one by one never finishes.
**Abstract interpretation** replaces each value by a coarse description, here
its sign, so that a finite computation covers every concrete run.

---

# The abstract domain

```prolog
input_sign(neg).
input_sign(zero).
input_sign(pos).

abs_state(input, x, Sign) :- input_sign(Sign).
```

`abs_state(Point, Var, Sign)` says that at program point `Point`, variable
`Var` may have sign `Sign`. The input statement allows all three signs.

---

# Transfer rules

```prolog
abs_state(negative_branch, x, neg) :- abs_state(input, x, neg).
abs_state(nonnegative_branch, x, zero) :- abs_state(input, x, zero).
abs_state(nonnegative_branch, x, pos) :- abs_state(input, x, pos).

abs_state(negative_branch, y, pos) :- abs_state(negative_branch, x, neg).
abs_state(nonnegative_branch, y, Sign) :- abs_state(nonnegative_branch, x, Sign).

abs_state(join, Var, Sign) :- abs_state(negative_branch, Var, Sign).
abs_state(join, Var, Sign) :- abs_state(nonnegative_branch, Var, Sign).

possible_division_by_zero(join) :- abs_state(join, y, zero).
```

The branch test refines `x`. Each assignment maps signs to signs: `y := -x`
turns a negative `x` into a positive `y`. At the join point the analysis keeps
everything either branch allows, which makes it **conservative**: it may warn
about a run that cannot happen, but never misses one that can.

---

# The answer

```sh
eyeprolog examples/abstract-interpretation.pl
```

```text
absState(join, x, sign(neg)).
absState(join, y, sign(pos)).
absState(join, x, sign(zero)).
absState(join, x, sign(pos)).
absState(join, y, sign(zero)).
absWarning(division_by_zero, join).
absConclusion(case, "abstract interpretation keeps all feasible signs and warns because y may be zero").
```

These are the last 7 of 16 answers; the first 9 list the signs at the input
and in each branch. At the join, `y` may be positive or zero, so the division is
flagged. The warning is real: input `0` takes the non-negative branch and sets
`y := 0`.

---

# The reason

```sh
eyeprolog --proof examples/abstract-interpretation.pl
```

```text
step(abs_state(input, x, zero), rule(4), ['Sign' = zero], [input_sign(zero)]).
step(abs_state(nonnegative_branch, x, zero), rule(6), [], [abs_state(input, x, zero)]).
```

The proof of the warning walks the zero path: the input may be zero (rule 4,
from the fact `input_sign(zero)`), that zero enters the non-negative branch
(rule 6), is copied into `y`, and reaches the join. The proof is a witness path
through the program.

---

# The check

```text
condition('C1', resolution, ok, 34).
condition('C4', coverage, ok, 47).
condition('C7', relevance, ok, 50).
trusted(0).
claims(16).
verdict(checked).
```

All 34 steps resolve against the clauses they cite, all 16 claims are covered,
and nothing is trusted. The analysis is pure Horn clauses, so the checker can
verify it completely.

---

# Try it

- Change the else branch to `y := x + 1`: replace the zero/pos rule for `y` in
  `nonnegative_branch` with rules that map `zero` to `pos`. Does the warning
  disappear?
- Add a fourth abstract value, `nonneg`, and explain where precision is lost at
  the join.
- Which answers would a concrete test with input `5` cover, and which would it
  miss?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 43, Laboratory 8 (a static analyzer).
