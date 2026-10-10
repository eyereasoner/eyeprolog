# Equality saturation

## What is the cheapest expression equal to this one?

An optimizer can rewrite `((x + 0) * 1) + 2 * (1 + 2)` in many ways. This
example explores every rewrite reachable within a small budget, scores each
candidate, and extracts the cheapest one, all as plain relations.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=equality-saturation) ·
[Source](../equality-saturation.pl)

---

# The question

Compilers and term-rewriting tools use **equality saturation**: apply every
known equality to an expression, keep all the equivalent forms, then pick the
best one. Real engines store the forms in an *e-graph*. EyeProlog has no
e-graph, so this example asks the same question relationally: which terms are
reachable from the start expression within six rewrite steps, and which of
them is cheapest?

---

# The rewrites

```prolog
expr(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))).
fuel(6).

rewrite(add(X, 0), X).
rewrite(mul(X, 1), X).
rewrite(add(A, B), C) :- number(A), number(B), (C is A + B).
rewrite(mul(A, B), C) :- number(A), number(B), (C is A * B).
rewrite(mul(X, add(Y, Z)), add(mul(X, Y), mul(X, Z))).
```

Each `rewrite/2` clause is one oriented equality: identity laws, constant
folding, and one distributive law. `rewrite_anywhere/2` applies a rule at the
root or inside any subterm.

---

# Bounded saturation and extraction

```prolog
equivalent_at_depth(0, Expr, Expr).
equivalent_at_depth(Depth, Expr, Out) :-
  (Depth > 0),
  (Previous_depth is Depth - 1),
  equivalent_at_depth(Previous_depth, Expr, Mid),
  rewrite_anywhere(Mid, Out).

best_expression(Expr, Cost) :-
  aggregate_min([Candidate_cost, Candidate], Candidate,
    (candidate_expression(Candidate), expr_cost(Candidate, Candidate_cost)),
    [Cost, Expr], Expr).
```

The fuel bound keeps the search finite. `expr_cost/2` counts nodes, and
`aggregate_min/5` keeps the candidate with the lowest cost, breaking ties by
term order so the result is deterministic.

---

# The answer

```sh
eyeprolog examples/equality-saturation.pl
```

```text
egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))).
egraphAnswer(best, add(x, 6)).
egraphAnswer(cost, 3).
egraphAnswer(candidate_count, 32).
egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph").
```

Out of 32 candidate derivations, the cheapest equivalent form is `x + 6`, with
three nodes.

---

# The reason

```text
step(egraphAnswer(best, add(x, 6)),
     rule(29),
     ['Expr' = add(x, 6)],
     [best_expression(add(x, 6), 3)]).
step(best_expression(add(x, 6), 3),
     rule(27),
     ['Expr' = add(x, 6), 'Cost' = 3],
     [aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6))]).
```

The answer rests on `best_expression/2`, which rests on one `aggregate_min/5`
call. That call ranges over the whole candidate set, so the proof records it
as a single built-in step rather than replaying all 32 candidates.

---

# The check

```text
condition('C1', resolution, ok, 7).
condition('C4', coverage, ok, 11).
condition('C7', relevance, ok, 14).
obligation(builtin, theory_scoped, aggregate_min([A, B], B, (candidate_expression(B), expr_cost(B, A)), [3, add(x, 6)], add(x, 6))).
obligation(builtin, theory_scoped, countall(candidate_expression(A), 32)).
verdict(checked_with_obligations).
```

Every rule step replays, but the two aggregates depend on the program's own
`candidate_expression/1`, so the checker cannot recompute them in isolation.
It reports them as **obligations**: the proof is valid *provided* those two
summaries over the candidate set are right.

---

# Try it

- Lower `fuel(6)` to `fuel(2)`. Is `x + 6` still reachable, and what does the
  best expression become?
- Add `rewrite(add(X, Y), add(Y, X)).` (commutativity). Why would that blow up
  the candidate count, and how does the fuel bound keep it finite?
- Change `expr_cost/2` so multiplication costs more than addition and see
  whether the extracted term changes.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 22 and 23.
