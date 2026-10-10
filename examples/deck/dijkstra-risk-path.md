# Risk-adjusted route selection

## Is the cheapest route the best one when routes carry risk?

A delivery can take one of five routes. Each road segment has a cost and a
risk. The example scores every route as cost plus ten times total risk and
shows that the route with the lowest raw cost is not the one selected.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dijkstra-risk-path) ·
[Source](../dijkstra-risk-path.pl)

---

# The question

From `depotA` to `labD`, which candidate route has the best risk-adjusted
score, and can a route with a lower raw cost lose because it is riskier?

---

# The network and candidates

```prolog
route_network(riskNetwork, (
  segment(depotA, segment(depotB, 4.0, 0.2)),
  segment(depotB, segment(labD, 4.0, 0.3)),
  segment(depotA, segment(depotC, 3.0, 0.9)),
  segment(depotC, segment(labD, 6.0, 0.3)),
  segment(depotC, segment(depotB, 0.5, 0.5)),
  ...
)).

candidate(pathB, [depotA, depotB, labD]).
candidate(pathViaC, [depotA, depotC, depotB, labD]).
```

Each segment carries a raw cost and a risk. Five candidate routes are given as
lists of places.

---

# The rules

```prolog
route_cost([_], 0.0, 0.0, 0).
route_cost([From, To|Rest], Raw, Risk, Edges) :-
  route_segment(From, To, Stepraw, Steprisk),
  route_cost([To|Rest], Restraw, Restrisk, Restedges),
  (Raw is Stepraw + Restraw),
  (Risk is Steprisk + Restrisk),
  (Edges is 1 + Restedges).

score(Raw, Risk, Score) :-
  (Penalty is Risk * 10.0),
  (Score is Raw + Penalty).
```

`route_cost/4` folds a route into its total cost, risk, and number of
segments. `score/3` turns cost and risk into one number. `best_path/1` then
compares the scores of all five candidates explicitly.

---

# The answer

```sh
eyeprolog examples/dijkstra-risk-path.pl
```

```text
rawCost(pathB, 8.0).
rawCost(pathViaC, 7.5).
score(pathB, 13.0).
score(pathViaC, 24.5).
selectedPath(case, pathB).
notes(case, riskCanOutweighRawCost).
selects(dijkstraRiskPath, pathB).
```

`pathViaC` is cheapest in raw cost (7.5), but its risk of 1.7 adds 17 to its
score. `pathB` wins with a score of 13.0. These are 7 of the 29 answers, which
also list each route's path, risk, and number of segments.

---

# The reason

```sh
eyeprolog --proof examples/dijkstra-risk-path.pl
```

```text
step(13.0 < 21.0, builtin, [], []).
step(13.0 < 14.0, builtin, [], []).
step(13.0 < 14.5, builtin, [], []).
step(13.0 < 24.5, builtin, [], []).
```

`best_path(pathB)` rests on the metrics of all five routes and on these four
comparisons: `pathB`'s score of 13.0 is lower than every other candidate's.

---

# The check

```sh
eyeprolog --proof examples/dijkstra-risk-path.pl > dijkstra-risk-path.why.pl
eyeprolog --check-proof dijkstra-risk-path.why.pl examples/dijkstra-risk-path.pl
```

```text
condition('C1', resolution, ok, 111).
condition('C4', coverage, ok, 204).
condition('C7', relevance, ok, 183).
verdict(checked).
```

All 111 rule steps replay, and the 43 arithmetic steps, including the four
comparisons above, are recomputed independently. Nothing is taken on trust.

---

# Try it

- Change the penalty from `10.0` to `1.0`. Which route is selected now, and
  does `best_path(pathB)` still succeed?
- Add a sixth candidate through `relay` and `depotB`. Does it need a new
  comparison in `best_path/1`?
- Rewrite `best_path/1` with `aggregate_min/5` so it no longer names the
  winner in advance.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24 (designing finite search).
