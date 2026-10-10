# Path discovery

## How can you fly from Ostend to Prague with at most two stopovers?

The example loads a real air-routes graph of about 7,700 airports and 37,000
flights, then searches for every route between two airports that respects a
limit on stopovers and never visits an airport twice.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=path-discovery) ·
[Source](../path-discovery.pl)

---

# The question

Flight networks are graphs, and graphs have cycles: from Brussels you can fly
to Paris and back again. A naive search could circle forever or report
absurd routes.

The question is bounded on purpose: routes from Ostend-Bruges to Václav Havel
Airport Prague with **at most two stopovers**, as readable text.

---

# The data

```prolog
route_request('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2).
```

```prolog
airport(res_airport_310, 'Ostend-Bruges International Airport').
airport(res_airport_309, 'Liège Airport').
flight(res_airport_310, res_airport_309).
```

The program holds 7,698 `airport/2` facts and 37,274 `flight/2` facts. A
request names the airports by label and gives the stopover limit.

---

# The search

```prolog
simple_path(Node, Node, _Remaininglegs, Visited, Visited).
simple_path(Node, Goal, Remaininglegs, Visited, Path) :-
  (Remaininglegs > 0),
  flight(Node, Next),
  \+ member(Next, Visited),
  (Nextremaininglegs is Remaininglegs - 1),
  simple_path(Next, Goal, Nextremaininglegs, [Next|Visited], Path).
```

Two guards keep the search finite. `Remaininglegs` counts down from
stopovers + 1, and the visited list rejects any airport already on the path. A
two-stopover limit means at most three legs.

---

# The answer

```sh
eyeprolog examples/path-discovery.pl
```

```text
airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague').
airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague').
airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague').
```

Three routes, all via Liège and then a Mediterranean holiday airport.

---

# The reason

```text
step(simple_path(res_airport_310, res_airport_1587, 3, [res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_310,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 3,
      'Visited' = [res_airport_310],
      'Path' = [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310],
      'Next' = res_airport_309,
      'Nextremaininglegs' = 2],
     [3 > 0,
      flight(res_airport_310, res_airport_309),
      \+ member(res_airport_309, [res_airport_310]),
      2 is 3 - 1,
      simple_path(res_airport_309, res_airport_1587, 2, [res_airport_309, res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310])]).
```

The first leg, Ostend (310) to Liège (309), is justified by the flight fact, the
check that Liège was not yet visited, and the leg count dropping from 3 to 2.
The rest of the route is the same rule, one leg at a time.

---

# The check

```text
condition('C1', resolution, ok, 42).
condition('C5', re_decision, ok, 31).
condition('C6', boundary_consistency, ok, 7).
obligation(absent, theory_scoped, \+ member(res_airport_309, [res_airport_310])).
trusted(7).
claims(3).
verdict(checked_with_obligations).
```

42 steps replay and 31 arithmetic steps are recomputed. The seven "not yet
visited" tests are negations, so they are reported as obligations. The checker
tested all seven against the evidence it had, and none was contradicted.

---

# Try it

- Change the stopover limit to `1`. No route is found: there is no route
  with only one stopover in this data.
- Ask for routes in the other direction, from Prague to Ostend.
- Count the routes for a limit of `3` with `findall/3` and `length/2` before
  printing them. The search space grows quickly.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
