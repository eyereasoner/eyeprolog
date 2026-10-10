# RDF 1.2 named graphs

## Can rules reason inside one graph without leaking into others?

A family graph says Alice is Bob's parent and Bob is Carol's. Rules derive
ancestors, and every derived triple stays in the named graph its evidence
came from.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=rdf12-trig-named-graph) ·
[Source](../rdf12-trig-named-graph.pl)

---

# The question

Who is an ancestor of whom, according to the `family` graph?

This is one of a family of RDF 1.2 examples. RDF data arrives as
`rdf(Subject, Predicate, Object, Graph)` facts, as produced by
[rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange).
In a TriG dataset, the fourth argument names the graph that holds each triple.

---

# The data

```prolog
rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family')).
rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family')).
```

Both triples live in the named graph `family`. A named graph is a labelled
set of triples, often one per source.

---

# The rules

```prolog
result_rdf(S, iri('https://example.org/ancestor'), O, G) :-
  rdf(S, iri('https://example.org/parent'), O, G).

result_rdf(S, iri('https://example.org/ancestor'), O, G) :-
  rdf(S, iri('https://example.org/parent'), M, G),
  rdf(M, iri('https://example.org/parent'), O, G).
```

A parent is an ancestor, and so is a parent's parent. Because both goals share
`G`, the two-step rule only joins parent links from the *same* graph.

---

# The answer

```sh
eyeprolog examples/rdf12-trig-named-graph.pl
```

```text
result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')).
result_rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')).
result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')).
```

Two direct ancestors and one grandparent, all in `family`.

---

# The reason

```text
step(result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')),
     rule(3),
     ['S' = iri('https://example.org/alice'),
      'O' = iri('https://example.org/bob'),
      'G' = iri('https://example.org/family')],
     [rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family'))]).
```

Alice is an ancestor of Bob by the first rule (clause 3), resting on one parent
triple from the `family` graph.

---

# The check

```text
condition('C1', resolution, ok, 5).
condition('C4', coverage, ok, 7).
condition('C7', relevance, ok, 8).
trusted(0).
verdict(checked).
```

All five steps replay; nothing is trusted.

---

# Try it

- Move Bob's parent triple to another graph. Predict which ancestor result
  disappears, and why.
- Make the second rule recursive so it handles chains of any length.
- Compare with the [ancestor](ancestor.md) deck, which does the same in plain
  Prolog, and with [joining across graphs](rdf12-trig-graph-join.md).

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 4.
