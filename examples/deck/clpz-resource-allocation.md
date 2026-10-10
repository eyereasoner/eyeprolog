# Resource allocation with integer constraints

## Which worker should do which job so the team finishes fast?

Three workers, three jobs, and a duration table per job. Integer constraints
from `library(clpz)` link who does what to how long it takes, and keep only
assignments that finish within 12 time units.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpz-resource-allocation) ·
[Source](../clpz-resource-allocation.pl)

---

# The question

Jobs A, B, and C each get a different worker numbered 1 to 3. Job A takes 5, 3,
or 4 time units depending on the worker, job B 4, 6, or 2, job C 7, 2, or 5.
A side condition ties the worker numbers together, job A may not be faster
than job B, and the total must be at most 12. Which assignments qualify? A
second clause shows how to read back what the solver knows about a variable's
**domain**, its set of possible values.

---

# The allocation model

```prolog
clpz_example(allocation, plan([A, B, C], durations([DA, DB, DC]), Total)) :-
  [A, B, C] ins 1..3,
  all_distinct([A, B, C]),
  scalar_product([1, 2, 3], [A, B, C], #=, 11),
  element(A, [5, 3, 4], DA),
  element(B, [4, 6, 2], DB),
  element(C, [7, 2, 5], DC),
  chain(#>=, [DA, DB]),
  sum([DA, DB, DC], #=, Total),
  Fast in 0..1,
  Fast #<==> Total #=< 12,
  Fast #= 1,
  labeling([ff, down], [A, B, C, Fast]).
```

`element(A, [5, 3, 4], DA)` makes `DA` the `A`-th entry of the table.
`scalar_product/4` requires A + 2B + 3C = 11. `Fast #<==> Total #=< 12`
**reifies** the deadline: `Fast` is 1 exactly when the total is at most 12.

---

# Domain reflection

```prolog
clpz_example(domain, domain(Infimum, Supremum, Size, Domain)) :-
  X in 2..4 \/ 7,
  fd_var(X),
  fd_inf(X, Infimum),
  fd_sup(X, Supremum),
  fd_size(X, Size),
  fd_dom(X, Domain).
```

`X` may be 2, 3, 4, or 7. The `fd_*` predicates report the smallest and
largest value, the number of values, and the domain itself.

---

# The answer

```sh
eyeprolog examples/clpz-resource-allocation.pl
```

```text
clpz_example(allocation, plan([2, 3, 1], durations([3, 2, 7]), 12)).
clpz_example(allocation, plan([3, 1, 2], durations([4, 4, 2]), 10)).
clpz_example(domain, domain(2, 7, 4, 2..4 \/ 7)).
```

Two assignments meet the deadline, with totals 12 and 10. The domain of `X`
runs from 2 to 7 and holds 4 values.

---

# The reason

```text
step(clpz_example(allocation, plan([2, 3, 1], durations([3, 2, 7]), 12)),
     rule(1),
     ['A' = 2, 'B' = 3, 'C' = 1, 'DA' = 3, 'DB' = 2, 'DC' = 7, 'Total' = 12, 'Fast' = 1],
     [[2, 3, 1] ins 1..3,
      …
      element(2, [5, 3, 4], 3),
      …
      1 #<==> 12 #=< 12,
      …]).
```

The first plan holds by the allocation rule with every value filled in:
worker 2 on job A takes 3 units (the second table entry), and the total of 12
meets the deadline, so `Fast` is 1.

---

# The check

```text
condition('C5', re_decision, ok, 23).
obligation(builtin, stateful, fd_inf(A, 2)).
obligation(builtin, stateful, fd_dom(A, 2..4 \/ 7)).
trusted(5).
verdict(checked_with_obligations).
```

All allocation steps are verified or recomputed. The five `fd_*` steps read
the solver's internal state for a variable that is never bound, so the checker
cannot recompute them. It keeps them as **obligations**: the domain answer is
as good as the constraint store that produced it.

---

# Try it

- Require a slow plan with `Fast #= 0`. There is no answer: both assignments
  that satisfy A + 2B + 3C = 11 finish within 12 units.
- Remove `chain(#>=, [DA, DB])` and predict whether new plans appear.
- Change `X in 2..4 \/ 7` to `X in 1..10, X #\= 5` and predict the four
  reflected values.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
