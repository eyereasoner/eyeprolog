# Weighted routes from a to f

## Which routes through a small road network stay within a cost budget?

Before choosing the cheapest route, it helps to see all reasonable ones. This
example enumerates every simple route from `a` to `f` in a weighted network,
adds up the cost of each, and keeps those that cost at most 16.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dijkstra) ·
[Source](../dijkstra.pl)

---

# The question

Six places, nine roads, each with a cost. Roads can be travelled in both
directions. Which routes from `a` to `f` visit no place twice and cost 16 or
less, and what does each cost?

---

# The network

```prolog
weighted_graph(dijkstraGraph, (
  edge(a, arc(b, 4)),
  edge(a, arc(c, 2)),
  edge(b, arc(c, 1)),
  edge(b, arc(d, 5)),
  edge(c, arc(d, 8)),
  edge(c, arc(e, 10)),
  edge(d, arc(e, 2)),
  edge(d, arc(f, 6)),
  edge(e, arc(f, 3))
)).
```

The whole network is one term, a **context**, rather than nine separate facts.
A small relation, `context_member/2`, walks it, so the roads stay scoped to
this graph instead of becoming global `edge/2` facts.

---

# The rules

```prolog
link(A, B, Cost) :- base_link(A, B, Cost).
link(B, A, Cost) :- base_link(A, B, Cost).

path(Goal, Goal, _visited, [Goal], 0).
path(Node, Goal, Visited, [Node|Path], Cost) :-
  link(Node, Next, Stepcost),
  \+ member(Next, Visited),
  path(Next, Goal, [Next|Visited], Path, Restcost),
  (Cost is Stepcost + Restcost).
```

`link/3` makes every road two-way. `path/5` carries the places already
visited, so `\+ member(Next, Visited)` rules out cycles and the search is
finite. The cost is added on the way back out of the recursion.

---

# The answer

```sh
eyeprolog examples/dijkstra.pl
```

```text
path("af", ["abdef", 14]).
path("af", ["abdf", 15]).
path("af", ["acdef", 15]).
path("af", ["acdf", 16]).
path("af", ["acef", 15]).
path("af", ["acbdef", 13]).
path("af", ["acbdf", 14]).
```

Seven routes fit the budget. Lists of one-letter atoms are printed in
double-quote notation, so `"acbdef"` is the route a → c → b → d → e → f, the
cheapest at 13. The output also lists the 9 reversed roads, 16 answers in all.

---

# The reason

```sh
eyeprolog --proof examples/dijkstra.pl
```

```text
step(path("af", ["acbdef", 13]),
     rule(11),
     ['Path' = "acbdef", 'Cost' = 13],
     [path(a, f, "a", "acbdef", 13), 13 =< 16]).
```

The cheapest route qualifies because a path of cost 13 exists and 13 is within
the budget. Its sub-steps walk the route one road at a time: `a` to `c` costs
2, the rest costs 11, and `13 is 2 + 11`.

---

# The check

```sh
eyeprolog --proof examples/dijkstra.pl > dijkstra.why.pl
eyeprolog --check-proof dijkstra.why.pl examples/dijkstra.pl
```

```text
condition('C1', resolution, ok, 121).
condition('C4', coverage, ok, 223).
condition('C5', re_decision, ok, 46).
condition('C7', relevance, ok, 183).
trusted(0).
verdict(checked).
```

All 121 rule steps replay. The `\+ member(...)` tests, "this place was not
visited yet", are absences, but each one is about a list written out in the
step, so the checker decides it again itself instead of taking it on trust.
Together with the arithmetic, that makes 46 recomputed steps, nothing left as
an obligation, and a plain `checked` verdict.

---

# Try it

- Lower the budget from 16 to 14. Which routes remain?
- Remove the road `edge(b, arc(c, 1))`. What is the cheapest route now?
- Compare with [dijkstra-findall-sort](dijkstra-findall-sort.md), which finds
  the cheapest route without enumerating all the others.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24 (designing finite search).
