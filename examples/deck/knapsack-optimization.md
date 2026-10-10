# Knapsack optimization

## Which gear gives an expedition the most value within its weight limit?

Eight items, each with a weight and a value, and a pack that holds 15 units.
The **0/1 knapsack problem** asks which subset of items to take, each item
taken whole or not at all, so that the total value is as large as possible.
EyeProlog enumerates every subset, filters by weight, and keeps the best one.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=knapsack-optimization) ·
[Source](../knapsack-optimization.pl)

---

# The question

What is the most valuable pack that weighs at most 15? What are its weight and
value, and how many packs fit at all?

---

# The data

```prolog
capacity(15).
items([atlas, battery, camera, drone, emergency_radio, field_laptop, medkit, sensor]).

item(atlas, 2, 6).
item(battery, 4, 10).
item(camera, 3, 8).
item(drone, 6, 13).
```

`item(Name, Weight, Value)` facts form the item table, kept apart from the
rules so the problem can be retuned without touching the logic.

---

# Every subset, once

```prolog
subset([], []).
subset([Item|Rest], [Item|Chosen]) :- subset(Rest, Chosen).
subset([_item|Rest], Chosen) :- subset(Rest, Chosen).
```

For each item there are two clauses: take it, or leave it. Backtracking
through both choices for all eight items produces all 2⁸ = 256 subsets.

```prolog
best_pack(Pack, Weight, Value) :-
  aggregate_max(Value, pack(Pack, Weight), feasible_pack(Pack, Weight, Value), Value, pack(Pack, Weight)).
```

`feasible_pack/3` keeps the subsets within capacity, and `aggregate_max/5`
picks the one with the highest value.

---

# The answer

```sh
eyeprolog examples/knapsack-optimization.pl
```

```text
knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor]).
knapsack_answer(total_weight, 15).
knapsack_answer(total_value, 40).
knapsack_answer(feasible_pack_count, 113).
```

113 of the 256 subsets fit, and the best uses the full capacity for a value of
40. It skips the single most valuable item, the field laptop (16), because
five lighter items give more value per unit of weight.

---

# The reason

```sh
eyeprolog --proof examples/knapsack-optimization.pl
```

```text
step(best_pack([atlas, battery, camera, medkit, sensor], 15, 40),
     rule(19),
     ['Pack' = [atlas, battery, camera, medkit, sensor], 'Weight' = 15, 'Value' = 40],
     [aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15))]).
```

The best pack holds by rule 19, whose single premise is the `aggregate_max/5`
call with the winning pack, weight and value filled in.

---

# The check

```text
condition('C1', resolution, ok, 5).
obligation(builtin, theory_scoped, countall(feasible_pack(A, B, C), 113)).
verdict(checked_with_obligations).
```

The five rule steps replay against the program. The maximum and the count each
summarize a search over all 256 subsets. The checker records them as
**theory-scoped** obligations, trusted premises that rest on the aggregate
library, rather than redoing the search.

---

# Try it

- Raise `capacity(15)` to `capacity(20)`. The best pack adds the emergency radio,
  for a value of 51 from 187 feasible packs.
- Add a heavy, very valuable item and predict whether it displaces the current
  winners.
- Exhaustive search doubles in cost with every item. Write a dynamic-programming
  version over capacities 0–15 and compare the answers.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
