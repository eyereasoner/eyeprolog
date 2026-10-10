# Eulerian path

## Can you walk every street exactly once?

Euler's 1736 question about the bridges of Königsberg founded graph theory.
This example asks it of an eleven-edge graph: it checks the degree condition,
then searches for a trail that uses every edge exactly once.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=eulerian-path) ·
[Source](../eulerian-path.pl)

---

# The question

An **Eulerian path** traverses every edge of a graph exactly once; vertices may
be revisited. Euler showed that a connected graph has one only if zero or two
vertices have odd degree (an odd number of incident edges). With zero odd
vertices, the path can start anywhere and return to its start, forming an
Eulerian cycle.

---

# The graph

```prolog
edge(e12, v1, v2).
edge(e13, v1, v3).
edge(e15, v1, v5).
edge(e16, v1, v6).
edge(e23, v2, v3).
edge(e24, v2, v4).
edge(e26, v2, v6).
edge(e34, v3, v4).
edge(e36, v3, v6).
edge(e45, v4, v5).
edge(e46, v4, v6).
```

Edges carry identifiers, so the search can consume each physical edge once even
when it passes the same vertex several times.

---

# The rules

```prolog
odd_degree(V) :-
  findall(E, incident(V, E), Edges),
  length(Edges, Degree),
  (1 is Degree mod 2).

dfs_euler(_current, Path, [], Path).
dfs_euler(Current, Visited, Remaining, Path) :-
  adjacent_by_edge(Current, Next, Edge),
  select_item(Edge, Remaining, Newremaining),
  dfs_euler(Next, [Next | Visited], Newremaining, Path).
```

`findall/3` collects the edges at a vertex to compute its degree. The
depth-first search carries the list of unused edge ids as its state; it
succeeds when that list is empty.

---

# The answer

```sh
eyeprolog examples/eulerian-path.pl
```

```text
oddVertices(eulerian_path_case, []).
path(eulerian_path_case, [v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1]).
edgeCount(eulerian_path_case, 11).
```

No vertex has odd degree, so the trail is a cycle: it starts and ends at `v1`,
visits 12 positions, and so crosses all 11 edges.

---

# The reason

```text
step(odd_vertices([]),
     rule(21),
     ['Odds' = [], 'Raw' = []],
     [findall(V, odd_degree(V), []), sort([], [])]).
step(findall(V, odd_degree(V), []), collected, [], []).
```

"No odd vertices" rests on a completed `findall/3` that came back empty. The
proof marks it `collected`: the search finished and found nothing.

---

# The check

```text
condition('C1', resolution, ok, 75).
condition('C5', re_decision, ok, 6).
condition('C6', boundary_consistency, ok, 2).
obligation(collected, theory_scoped, findall(A, odd_degree(A), [])).
verdict(checked_with_obligations).
```

The checker replays 75 rule steps. It cannot prove that a collection is
complete without searching, so each `findall/3` result becomes an
**obligation**. For two of them it does compare the list against the
program's facts (C6) and finds nothing that contradicts it.

---

# Try it

- Remove `edge(e46, v4, v6).` Which two vertices become odd, and where must
  the path now start?
- Add an edge so that four vertices have odd degree. What does the program
  answer, and why does Euler's theorem predict it?
- Why does the search remove edge ids rather than vertex pairs from its state?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
