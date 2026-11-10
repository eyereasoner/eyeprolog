# Language

## How do quoted names and tabled recursion work together?

Prolog atoms can contain spaces when quoted, as in `'node a'`. This example
builds a small graph of such names and computes every path through it, with
a tabled recursive rule.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=language) ·
[Source](../language.pl)

---

# The question

Which nodes can reach which other nodes in a chain of linked identifiers?

The example also shows the basic surface of the language: ISO Prolog syntax
with uppercase variables, a `%% ?-` comment that declares the question, and an
explicit `table/1` declaration for the recursive predicate.

---

# The edges

```prolog
edge('node a', 'node b').
edge('node b', 'node c').
edge('node c', 'node d').
```

Quoting makes `'node a'` one atom. The space is part of its name,
so the quotes are needed wherever the atom appears.

---

# The rules

```prolog
:- table path/2.

path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
```

A path is an edge, or an edge followed by a path. The `table` declaration
makes EyeProlog remember the answers of each `path/2` call and reuse them, so
the relation stays finite even if the graph later gains a cycle.

---

# The answer

```sh
eyeprolog examples/language.pl
```

```text
path('node a', 'node b').
path('node b', 'node c').
path('node c', 'node d').
path('node a', 'node c').
path('node a', 'node d').
path('node b', 'node d').
```

Three direct paths and three longer ones: every pair of nodes in order along
the chain.

---

# The reason

```sh
eyeprolog --proof examples/language.pl
```

```text
step(path('node a', 'node d'),
     rule(6),
     ['X' = 'node a', 'Z' = 'node d', 'Y' = 'node b'],
     [edge('node a', 'node b'), path('node b', 'node d')]).
```

The longest path holds by the recursive rule with `Y` bound to `'node b'`: there is
an edge from `'node a'` to `'node b'`, and a path from `'node b'` to `'node d'`. That path has its own step
further down the proof.

---

# The check

```text
condition('C1', resolution, ok, 9).
condition('C4', coverage, ok, 15).
condition('C7', relevance, ok, 15).
verdict(checked).
```

All nine steps replay against the clauses they cite, every claim is covered,
and nothing is trusted. Tabling changes how answers are found, not what a
proof must show.

---

# Try it

- Add `edge('node d', 'node a')` to close the cycle. With the
  table, every node now reaches every node, including itself.
- Remove `:- table path/2.` and keep the cycle. The search prints a few
  answers and never finishes.
- Ask only for the nodes `'node a'` can reach: `--goal "path('node a', X)"`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 4.
