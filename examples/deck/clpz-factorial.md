# Factorial with integer constraints

## What is 6!, computed with constraints instead of `is/2`?

The classic factorial program, written with integer constraints from
`library(clpz)`. Each recursive step states a relation between numbers instead
of an assignment, and the constraint solver works out the one unknown value.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpz-factorial) ·
[Source](../clpz-factorial.pl)

---

# The question

The factorial of 6 is 6 × 5 × 4 × 3 × 2 × 1. In ordinary Prolog, `F is N * PF`
works only when `N` and `PF` are already known. Constraints such as
`F #= N * PF` are equations: they hold whichever side is known. What does the
factorial program look like when written that way?

---

# The program

```prolog
factorial(0, 1).
factorial(N, F) :-
  N #> 0,
  Previous #= N - 1,
  factorial(Previous, PreviousFactorial),
  F #= N * PreviousFactorial.
```

The base case says 0! is 1. The recursive case says: for positive `N`, the
factorial is `N` times the factorial of `N - 1`. `#>` and `#=` are CLP(Z)
constraints over integers.

---

# The answer

```sh
eyeprolog examples/clpz-factorial.pl
```

```text
factorial(6, 720).
```

---

# The reason

```text
step(factorial(6, 720),
     rule(2),
     ['N' = 6, 'F' = 720, 'Previous' = 5, 'PreviousFactorial' = 120],
     [(integer(6) -> 6 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(6, Var_1)),
      …
      factorial(5, 120),
      …]).
```

6! is 720 by the recursive rule with `Previous = 5` and 5! = 120. The proof
also shows what the constraints became: when the program is loaded,
`library(clpz)` expands `N #> 0` into a test that uses plain arithmetic when
`N` is already an integer and falls back to the constraint solver otherwise.

---

# The check

```text
condition('C1', resolution, ok, 7).
condition('C5', re_decision, ok, 18).
steps(25).
recomputed(18).
trusted(0).
verdict(checked).
```

All seven factorial steps resolve against their clauses, and the checker
recomputes the 18 arithmetic steps itself. Nothing is left on trust.

---

# Try it

- Ask `factorial(10, F)` and compare with `is/2` arithmetic.
- Ask backwards: `--goal 'factorial(N, 720)'`. This version runs out of stack
  (`resource_error(stack)`). Why does the recursion not stop, and which
  reordering of the constraints would help?
- Replace `#=` and `#>` by `is` and `>`, and compare the two versions on
  `factorial(6, F)`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6.
