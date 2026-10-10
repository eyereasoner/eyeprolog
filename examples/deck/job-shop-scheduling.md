# Job-shop scheduling

## What is the shortest way to run three jobs on two shared machines?

Three jobs each need a mill operation and a lathe operation, in a fixed order.
Two operations cannot share a machine at the same time. EyeProlog enumerates
every feasible timetable within a small time window and keeps the one that
finishes first.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=job-shop-scheduling) ·
[Source](../job-shop-scheduling.pl)

---

# The question

The **makespan** is the time at which the last operation finishes. Which
schedule has the smallest makespan, and how many feasible schedules are there
at all?

Job-shop scheduling is a classic hard combinatorial problem. This instance is
small enough to search exhaustively, which makes the answer easy to trust.

---

# Machines cannot overlap

```prolog
nonoverlap(_starta, Enda, Startb, _endb) :- (Enda =< Startb).
nonoverlap(Starta, _enda, _startb, Endb) :- (Endb =< Starta).
```

Two operations on the same machine are compatible when one finishes before
the other starts. The two clauses are the two possible orders, so the
relation itself encodes the scheduling choice.

---

# Generate, then constrain

```prolog
  between(0, 6, J1millstart), (J1millend is J1millstart + 3),
  between(0, 6, J1lathestart), (J1latheend is J1lathestart + 2),
  (J1millend =< J1lathestart),
```

For each job, `between/3` proposes start times, `is/2` computes end times, and
a comparison enforces the order within the job (mill before lathe for job 1).
Six `nonoverlap/4` calls then reject machine clashes.

```prolog
best_schedule(Makespan, Schedule) :-
  aggregate_min(Makespan, Schedule, feasible_schedule(Makespan, Schedule), Makespan, Schedule).
```

`aggregate_min/5` searches every feasible schedule and keeps the one with the
smallest makespan.

---

# The answer

```sh
eyeprolog examples/job-shop-scheduling.pl
```

```text
job_shop_answer(best_makespan, 9).
job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]).
job_shop_answer(feasible_schedule_count, 35).
```

Of 35 feasible schedules, the best finishes at time 9. On the mill, job 1 runs
first (0–3), then job 3 (3–5), then job 2 (5–9). Meanwhile the lathe serves
job 2 first, so job 2's mill operation can start as soon as the mill is free.

---

# The reason

```sh
eyeprolog --proof examples/job-shop-scheduling.pl
```

```text
step(job_shop_answer(best_makespan, 9),
     rule(5),
     ['Makespan' = 9],
     [best_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])]).
```

The makespan answer rests on `best_schedule/2`, which in turn rests on one
`aggregate_min/5` call recorded with the winning schedule filled in.

---

# The check

```text
condition('C1', resolution, ok, 4).
obligation(builtin, theory_scoped, countall(feasible_schedule(A, B), 35)).
verdict(checked_with_obligations).
```

The four rule steps replay against the program. The `aggregate_min/5` and
`countall/2` calls summarize an entire search, so the checker cannot confirm
them step by step without redoing the search. It lists them as
**theory-scoped** obligations: the optimum is correct provided those two
library aggregates are.

---

# Try it

- Narrow the start window from `between(0, 6, …)` to `between(0, 5, …)`. Does a
  makespan of 9 still fit?
- Make job 3's lathe operation take 4 time units instead of 3, and predict the
  new optimum before running it.
- Ask `feasible_schedule(8, S)` directly. Is there any schedule that finishes
  at time 8?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
