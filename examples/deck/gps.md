# GPS route choice

## Which route should we take from Gent to Oostende?

A small road map lists four drives, each with a duration, a cost, a
reliability, and a comfort score. EyeProlog finds the two routes, totals their
scores, and recommends the direct route only because it is better on every
count.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=gps) ·
[Source](../gps.pl)

---

# The question

A traveller in Gent wants to reach Oostende. One route goes straight through
Brugge; the other detours through Kortrijk. Which route should the GPS
recommend, and can it justify the choice?

---

# The map

```prolog
map_graph(mapBE, (
  gps_description(mapBE, description(location(S, gent), true, location(S, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)),
  gps_description(mapBE, description(location(S, gent), true, location(S, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)),
  gps_description(mapBE, description(location(S, kortrijk), true, location(S, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)),
  gps_description(mapBE, description(location(S, brugge), true, location(S, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))
)).
```

Each drive has a duration in seconds, a cost, a belief (how likely the drive
goes as planned), and a comfort score. The map is one term, read with ordinary
term traversal rather than asserted as separate facts.

---

# Composing a route

```prolog
path(From, To, Actions, Duration, Cost, Belief, Comfort) :-
  map_description(From, Mid, Action, D1, C1, B1, F1),
  path(Mid, To, Restactions, D2, C2, B2, F2),
  append([Action], Restactions, Actions),
  (Duration is D1 + D2),
  (Cost is C1 + C2),
  (Belief is B1 * B2),
  (Comfort is F1 * F2).
```

Durations and costs add up; beliefs and comfort multiply, as probabilities of
independent drives going well do.

---

# The recommendation

```prolog
recommended_route(routeDirect) :-
  route_metrics(routeDirect, Directduration, Directcost, Directbelief, Directcomfort),
  route_metrics(routeViaKortrijk, Viaduration, Viacost, Viabelief, Viacomfort),
  (Directduration < Viaduration),
  (Directcost < Viacost),
  (Directbelief > Viabelief),
  (Directcomfort > Viacomfort).
```

The direct route is recommended only if it **dominates**: shorter, cheaper,
more reliable, and more comfortable. No weights are needed when one option wins
on every criterion.

---

# The answer

```sh
eyeprolog examples/gps.pl
```

```text
outcome(decision, "Take the direct route via Brugge.").
recommendedRoute(decision, routeDirect).
durationSeconds(routeDirect, 2400.0).
durationSeconds(routeViaKortrijk, 4100.0).
cost(routeDirect, 0.01).
cost(routeViaKortrijk, 0.018).
belief(routeDirect, 0.9408).
belief(routeViaKortrijk, 0.903168).
```

21 facts in all, including the five passed checks `c1`–`c5` and a `comparison`
report stating that the direct route dominates.

---

# The reason

```sh
eyeprolog --proof examples/gps.pl
```

```text
step(route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99),
     rule(13),
     ['Duration' = 2400.0, 'Cost' = 0.01, 'Belief' = 0.9408, 'Comfort' = 0.99],
     [traveller_path(i1, [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99)]).
```

The direct route's 2400 seconds come from a concrete path of two drives,
1500 + 900. The recommendation step cites these metrics and the four
comparisons that made it dominate.

---

# The check

```text
condition('C1', resolution, ok, 69).
condition('C5', re_decision, ok, 25).
steps(94).
verified(69).
recomputed(25).
trusted(0).
claims(21).
verdict(checked).
```

All 94 steps hold: 69 replayed against the program and 25 sums, products and
comparisons recomputed by the checker. The recommendation rests on nothing
unchecked.

---

# Try it

- Make the Kortrijk drives 100 seconds each. The detour becomes faster
  (1100 s), check `c3` disappears, and no route is recommended: neither
  dominates any more.
- Add a third route and a rule that recommends a route when it dominates
  every other one.
- When neither route dominates, what extra information would a principled
  recommendation need?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
