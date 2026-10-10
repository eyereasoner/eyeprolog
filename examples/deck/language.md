# Language

## How does an EyeProlog program look when its names are web identifiers?

Identifiers on the web often look like `<urn:example:a>`. In EyeProlog they
are simply quoted atoms. This example builds a small graph of such identifiers
and computes every path through it, with a tabled recursive rule.

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
edge('<urn:example:a>', '<urn:example:b>').
edge('<urn:example:b>', '<urn:example:c>').
edge('<urn:example:c>', '<urn:example:d>').
```

Quoting makes `'<urn:example:a>'` one atom. The angle brackets and colons are
just characters of its name, so no special syntax for identifiers is needed.

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
path('<urn:example:a>', '<urn:example:b>').
path('<urn:example:b>', '<urn:example:c>').
path('<urn:example:c>', '<urn:example:d>').
path('<urn:example:a>', '<urn:example:c>').
path('<urn:example:a>', '<urn:example:d>').
path('<urn:example:b>', '<urn:example:d>').
```

Three direct paths and three longer ones: every pair of nodes in order along
the chain.

---

# The reason

```sh
eyeprolog --proof examples/language.pl
```

```text
step(path('<urn:example:a>', '<urn:example:d>'),
     rule(6),
     ['X' = '<urn:example:a>', 'Z' = '<urn:example:d>', 'Y' = '<urn:example:b>'],
     [edge('<urn:example:a>', '<urn:example:b>'), path('<urn:example:b>', '<urn:example:d>')]).
```

The longest path holds by the recursive rule with `Y` bound to `b`: there is
an edge from `a` to `b`, and a path from `b` to `d`. That path has its own step
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

- Add `edge('<urn:example:d>', '<urn:example:a>')` to close the cycle. With the
  table, every node now reaches every node, including itself.
- Remove `:- table path/2.` and keep the cycle. The search prints a few
  answers and never finishes.
- Ask only for the nodes `a` can reach: `--goal "path('<urn:example:a>', X)"`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 4.
