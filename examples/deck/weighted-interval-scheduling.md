# Weighted interval scheduling

## Which non-overlapping jobs earn the most?

You have eight jobs, each with a start time, a finish time, and a value, and
you can run only one at a time. Which jobs should you pick? This example solves
the classic problem with dynamic programming, using tabling to remember the
best value from each position.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=weighted-interval-scheduling) ·
[Source](../weighted-interval-scheduling.pl)

---

# The question

Choose a set of intervals that do not overlap and whose total value is as
large as possible.

Trying every subset of eight intervals means 256 candidates; with more jobs,
that grows exponentially. Dynamic programming reduces it to one decision per
interval: take it or skip it.

---

# The data

```prolog
interval(1, 1, 4, 5).
interval(2, 3, 5, 1).
interval(3, 0, 6, 8).
interval(4, 4, 7, 4).
interval(5, 3, 9, 6).
interval(6, 5, 9, 3).
interval(7, 6, 10, 2).
interval(8, 8, 11, 4).
```

Each fact is `interval(Id, Start, Finish, Value)`, ordered by finish time.

---

# The rule

```prolog
:- table best_from/2.

best_from(9, 0).
best_from(I, Best) :-
  last_interval(Last),
  (I =< Last),
  (Next is I + 1),
  best_from(Next, Skip),
  next_compatible(I, Compatible),
  best_from(Compatible, Tail),
  interval(I, _start, _finish, Value),
  (Take is Value + Tail),
  (Take >= Skip -> Best = Take ; Best = Skip).
```

From interval `I`, either skip it (best value from `I + 1`) or take it (its
value plus the best value from the next interval that starts after `I`
finishes). Tabling stores each `best_from/2` answer so it is computed once.

---

# The answer

```sh
eyeprolog examples/weighted-interval-scheduling.pl
```

```text
weighted_interval_answer(best_value, 13).
weighted_interval_answer(chosen_interval, interval(1, 1, 4, 5)).
weighted_interval_answer(chosen_interval, interval(4, 4, 7, 4)).
weighted_interval_answer(chosen_interval, interval(8, 8, 11, 4)).
weighted_interval_answer(candidate_count, 8).
```

The best schedule takes jobs 1, 4, and 8, for 5 + 4 + 4 = 13. The
single most valuable job (job 3, worth 8) is not part of it: it blocks too
much of the timeline.

---

# The reason

```text
step(weighted_interval_answer(best_value, 13), rule(19), ['Best' = 13], [best_from(1, 13)]).
step(1 =< 8, builtin, [], []).
step(2 is 1 + 1, builtin, [], []).
```

The best value 13 rests on `best_from(1, 13)`, whose step continues through
the skip and take branches and each arithmetic comparison, down to the
sentinel `best_from(9, 0)`.

---

# The check

```text
condition('C1', resolution, ok, 37).
condition('C5', re_decision, ok, 38).
obligation(absent, theory_scoped, \+ (interval(A, B, C, D), A > 8, B >= 11)).
obligation(builtin, theory_scoped, aggregate_min(A, A, (interval(A, B, C, D), A > 4, B >= 7), 8, 8)).
trusted(9).
verdict(checked_with_obligations).
```

Rule steps replay and arithmetic is recomputed. Finding the next compatible
interval uses `aggregate_min/5` or a negation over the program's own
`interval/4` facts. The checker cannot redo those searches without the
program, so it reports 9 **obligations**: the verdict holds provided those
minimums and absences are right.

---

# Try it

- Raise the value of job 3 to 14. Does the schedule change?
- Add a ninth interval, updating `last_interval/1` and `sentinel/1`, and predict
  the new best value.
- Remove `:- table best_from/2.` and compare `--stats`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
