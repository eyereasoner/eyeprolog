# Route planning

## How do I get to Nantes, and which way exactly?

One-way road links between French cities, and two rules that find not only
*whether* a city reaches Nantes but the route itself, as a term you can read,
store, or hand to another rule.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=route-planning) ·
[Source](../route-planning.pl)

---

# The question

Reachability answers yes or no. A traveller wants more: the sequence of roads
to take. The program has to carry that plan along while it searches.

---

# The road map

```prolog
oneway(paris, orleans).
oneway(paris, chartres).
oneway(paris, amiens).
oneway(chartres, lemans).
oneway(lemans, angers).
oneway(lemans, tours).
oneway(angers, nantes).
```

Ten one-way links in all. Only one city, Angers, has a direct road to Nantes.

---

# The rules

```prolog
path([A, B], go(A, B, goal)) :-
  oneway(A, B).

path([A, C], go(A, B, Rest)) :-
  oneway(A, B),
  path([B, C], Rest).

route_to_nantes(From, Plan) :-
  path([From, nantes], Plan).
```

A direct road is a one-step plan, `go(A, B, goal)`. A longer trip takes one
road and nests the rest of the plan inside: `go(A, B, Rest)`. The plan is
built as the search goes, so the answer *is* the witness.

---

# The answer

```sh
eyeprolog examples/route-planning.pl
```

```text
route_to_nantes(angers, go(angers, nantes, goal)).
route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))).
route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))).
route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal))).
```

Four cities reach Nantes. Paris goes via Chartres, Le Mans, and Angers; the
roads through Orléans and Amiens lead nowhere near it.

---

# The reason

```text
step(path([paris, nantes], go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
     rule(12),
     ['A' = paris,
      'C' = nantes,
      'B' = chartres,
      'Rest' = go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))],
     [oneway(paris, chartres),
      path([chartres, nantes], go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))]).
step(oneway(paris, chartres), fact(2), [], []).
```

The Paris route holds by the recursive rule (clause 12): take the road to
Chartres (fact 2), and Chartres already has a route to Nantes. The proof
mirrors the plan, one step per road.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C4', coverage, ok, 15).
verdict(checked).
```

All 12 steps replay against the clauses they cite, every claim is covered, and
nothing is trusted.

---

# Try it

- Add `oneway(tours, nantes).` The answer grows from 4 to 11 routes. Which
  cities now have two different routes?
- Ask only for routes from Paris: `--goal 'route_to_nantes(paris, Plan)'`.
- The map has no cycles. Add `oneway(nantes, paris).` and think about what the
  search would do before you run it.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 4 and 24.
