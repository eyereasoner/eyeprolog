# Hamiltonian paths

## Which routes visit every vertex of this graph exactly once?

A Hamiltonian path passes through each vertex of a graph once and only once.
Finding one is a classic hard search problem. For a six-vertex graph,
EyeProlog lists every such path, and the proof shows why each candidate is
valid.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=hamiltonian-path) ·
[Source](../hamiltonian-path.pl)

---

# The question

Six vertices, eleven undirected edges. Is there a path that visits all six
vertices without repeating one, and if so, which paths are there?

Unlike the shortest-path problem, no efficient algorithm is known for this in
general, so the program searches. On six vertices the search is small enough
to be exhaustive.

---

# The graph

```prolog
edge(v1, v2).
edge(v1, v3).
edge(v1, v5).
edge(v1, v6).
edge(v2, v3).
edge(v2, v4).
edge(v2, v6).
edge(v3, v4).
edge(v3, v6).
edge(v4, v5).
edge(v4, v6).

adjacent(V, U) :- edge(V, U).
adjacent(V, U) :- edge(U, V).
```

Edges are stored once; `adjacent/2` reads them in both directions.

---

# The search

```prolog
hamiltonian_path([A, B, C, D, E, F]) :-
  vertex(A),
  vertex(B), adjacent(A, B), \+ member(B, [A]),
  vertex(C), adjacent(B, C), \+ member(C, [A, B]),
  vertex(D), adjacent(C, D), \+ member(D, [A, B, C]),
  vertex(E), adjacent(D, E), \+ member(E, [A, B, C, D]),
  vertex(F), adjacent(E, F), \+ member(F, [A, B, C, D, E]).
```

Choose a vertex, then repeatedly choose a neighbour that is not yet on the
path. Each test runs as soon as its inputs are bound, so dead ends are pruned
early.

---

# The answer

```sh
eyeprolog examples/hamiltonian-path.pl
```

```text
hasHamiltonianPath(graph, true).
hamiltonianPath(graph, [v1, v2, v3, v6, v4, v5]).
hamiltonianPath(graph, [v1, v2, v6, v3, v4, v5]).
hamiltonianPath(graph, [v1, v3, v2, v6, v4, v5]).
hamiltonianPath(graph, [v1, v3, v6, v2, v4, v5]).
...
```

Yes, the graph has a Hamiltonian path; in fact it has 120 when both directions
of each path are counted.

---

# The reason

```sh
eyeprolog --proof examples/hamiltonian-path.pl
```

```text
step(hasHamiltonianPath(graph, true),
     rule(21),
     [],
     [hamiltonian_path([v1, v2, v3, v6, v4, v5])]).
step(\+ member(v2, [v1]), absent, [], []).
```

One witness path is enough to prove existence. The step for that path cites
each vertex, each adjacency, and each "not visited yet" test. A test like
`\+ member(v2, [v1])` is recorded as `absent`: a completed search that found
nothing.

---

# The check

```text
condition('C5', re_decision, ok, 408).
steps(688).
verified(280).
recomputed(408).
trusted(0).
claims(121).
verdict(checked).
```

280 steps are replayed against the program. The 408 "not on the path yet"
tests, such as `\+ member(v2, [v1])`, are not resolution steps, but each one
is about a list that is right there in the step. The checker decides every one
of them again itself (C5), so nothing is left to take on trust: the verdict is
plainly `checked`.

---

# Try it

- Delete `edge(v4, v5).` Vertex `v5` then touches only `v1`, so every path
  must start or end at `v5`. The run finds 36 paths.
- Add a rule for a Hamiltonian *cycle*: a path whose last vertex is adjacent to
  its first. How many of the 120 paths close into a cycle?
- Generalize `hamiltonian_path/1` to any number of vertices with a recursive
  helper that carries the visited list.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
