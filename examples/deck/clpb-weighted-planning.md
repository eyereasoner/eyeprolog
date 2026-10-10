# Weighted release planning

## Which features give the most value within the rules?

A release can ship at most two of four features, some features depend on
others, and each has a business value. Boolean constraints describe what is
allowed, and one call finds the most valuable allowed plan.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpb-weighted-planning) ·
[Source](../clpb-weighted-planning.pl)

---

# The question

The candidate features are an API, a cache, audit logging, and search. At most
two can ship. Search needs the API, and the cache needs audit logging. The
values are 7 for the API, 4 for the cache, 3 for audit logging, and 6 for
search. Which plan maximizes the total value?

---

# The model

```prolog
best_release_plan(plan(
    api(Api), cache(Cache), audit(Audit), search(Search)), Score) :-
  sat(card([0,1,2], [Api, Cache, Audit, Search]) *
      (Search =< Api) *
      (Cache =< Audit)),
  weighted_maximum([7, 4, 3, 6], [Api, Cache, Audit, Search], Score).
```

Each feature is a 0/1 variable. `card([0,1,2], Vars)` says that zero, one, or
two of them are 1. `Search =< Api` reads "if search, then API". The constraint
solver of `library(clpb)` keeps all three rules together, and
`weighted_maximum/3` picks the admissible assignment with the highest weighted
sum and binds the variables to it.

---

# The answer

```sh
eyeprolog examples/clpb-weighted-planning.pl
```

```text
best_release_plan(plan(api(1), cache(0), audit(0), search(1)), 13).
```

Ship the API and search for a value of 13. The cache and audit pair would give
only 7, and any single feature at most 7.

---

# The reason

```text
step(best_release_plan(plan(api(1), cache(0), audit(0), search(1)), 13),
     rule(1),
     ['Api' = 1, 'Cache' = 0, 'Audit' = 0, 'Search' = 1, 'Score' = 13],
     [sat(card([0, 1, 2], [1, 0, 0, 1]) * (1 =< 1) * (0 =< 0)),
      weighted_maximum([7, 4, 3, 6], [1, 0, 0, 1], 13)]).
```

The plan follows from the one rule with the chosen values. With those values
substituted, the constraint reads: two features chosen, search implies API
(`1 =< 1`), cache implies audit (`0 =< 0`).

---

# The check

```text
condition('C1', resolution, ok, 1).
obligation(builtin, stateful, sat(card([0, 1, 2], [1, 0, 0, 1]) * (1 =< 1) * (0 =< 0))).
obligation(builtin, stateful, weighted_maximum([7, 4, 3, 6], [1, 0, 0, 1], 13)).
trusted(2).
verdict(checked_with_obligations).
```

The rule step is verified. The constraint and optimization steps depend on the
solver state of the run, so they become **obligations**. In particular, the
proof shows that this plan is admissible and scores 13; that 13 is the
*maximum* rests on `weighted_maximum/3`.

---

# Try it

- Raise the cache's value from 4 to 11. The best plan becomes cache plus audit,
  with a value of 14.
- Allow three features with `card([0,1,2,3], …)`. Now API, audit, and search
  together score 16.
- Add a rule that search and cache cannot both ship, and predict whether the
  answer changes.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
