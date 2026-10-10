# Dijkstra with findall and sort

## What is the cheapest route, found the way Dijkstra would?

Dijkstra's algorithm always expands the cheapest route found so far. This
example writes that idea in a few lines of standard Prolog: `findall/3`
collects the next candidates and `sort/2` keeps the frontier in cost order.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dijkstra-findall-sort) ·
[Source](../dijkstra-findall-sort.pl)

---

# The question

In a network of six places and nine two-way roads, what is the cheapest route
from `a` to `f`, and what does it cost? Unlike plain enumeration, the search
should stop as soon as the cheapest route is certain.

---

# The network

```prolog
:- table edge/3.

edge(a, b, 4).
edge(a, c, 2).
edge(b, c, 1).
edge(b, d, 5).
edge(c, d, 8).
edge(c, e, 10).
edge(d, e, 2).
edge(d, f, 6).
edge(e, f, 3).
edge(A, B, Cost) :- edge(B, A, Cost).
```

The last clause makes every road two-way. It calls `edge/3` again, so the
table declaration keeps that symmetric rule from looping.

---

# The rules

```prolog
dijkstra_queue([[Cost, Goal | Path] | _queue], Goal, _visited, [Goal | Path], Cost).
dijkstra_queue([[Cost, Node | Path] | Queue], Goal, Visited, Resultpath, Resultcost) :-
  findall([Newcost, Neighbor, Node | Path],
    (edge(Node, Neighbor, Weight), \+ member(Neighbor, Visited), (Newcost is Cost + Weight)),
    Neighbors),
  append(Queue, Neighbors, Newqueue),
  sort(Newqueue, Sortedqueue),
  dijkstra_queue(Sortedqueue, Goal, [Node | Visited], Resultpath, Resultcost).
```

The **frontier** is a list of entries `[Cost, Node | ReversedPath]`. Because
the cost comes first, `sort/2` puts the cheapest entry at the front. When the
front entry reaches the goal, its cost is the minimum: everything else in the
queue already costs at least as much.

---

# The answer

```sh
eyeprolog examples/dijkstra-findall-sort.pl
```

```text
shortestPath(dijkstra_findall_sort, "acbdef").
cost(dijkstra_findall_sort, 13).
```

The route is a → c → b → d → e → f, cost 13. (Lists of one-letter atoms print
in double-quote notation.)

---

# The reason

```sh
eyeprolog --proof examples/dijkstra-findall-sort.pl
```

```text
step(shortestPath(dijkstra_findall_sort, "acbdef"),
     rule(15),
     ['Path' = "acbdef"],
     [once(dijkstra(a, f, "acbdef", 13))]).
step(once(dijkstra(a, f, "acbdef", 13)), control, [], [dijkstra(a, f, "acbdef", 13)]).
```

The answer comes from the first solution of `dijkstra/4`, and the proof goes on
to record every queue expansion that led there.

---

# The check

```sh
eyeprolog --proof examples/dijkstra-findall-sort.pl > dijkstra-findall-sort.why.pl
eyeprolog --check-proof dijkstra-findall-sort.why.pl examples/dijkstra-findall-sort.pl
```

```text
condition('C1', resolution, ok, 15).
condition('C4', coverage, ok, 51).
condition('C7', relevance, ok, 52).
obligation(collected, theory_scoped, findall([A, B, a], (edge(a, B, C), \+ member(B, []), A is 0 + C), [[4|"ba"], [2|"ca"]])).
trusted(11).
verdict(checked_with_obligations).
```

Rule steps replay and 23 built-in steps are recomputed. The 11 `findall/3`
collections are **obligations**: the checker can confirm each listed neighbor,
but "these are *all* the neighbors" is a completeness claim it takes on trust
and names explicitly.

---

# Try it

- Make `edge(b, c, 1)` cost 10. Which route wins now?
- Ask for the route from `f` back to `a`. Is it the same route reversed?
- Compare with [dijkstra](dijkstra.md), which enumerates every route within a
  budget instead of stopping at the cheapest.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8 (collecting and choosing answers).
