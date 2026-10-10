# RDF 1.2 annotations

## Who said this, and when?

Alice's name is recorded as "Alice", and the same statement is annotated with
who stated it and when it was recorded. EyeProlog recovers the statement
together with its annotations, as one auditable claim.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=rdf12-annotation) ·
[Source](../rdf12-annotation.pl)

---

# The question

Which asserted statements carry provenance, and what is it?

This is one of a family of RDF 1.2 examples. RDF data arrives as
`rdf(Subject, Predicate, Object, Graph)` facts, as produced by
[rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange),
and results are printed in the same shape.

---

# The data

```prolog
rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph).
rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph).
rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph).
```

An RDF 1.2 **annotation** asserts a triple and also describes it. A
*reifier* (`claim1`) stands for the statement through `rdf:reifies`, and
ordinary triples about the reifier carry the metadata: Carol stated it, on
15 January 2025.

---

# The rule

```prolog
annotated_claim(S, P, O, Reifier, Source, Date) :-
  rdf(S, P, O, default_graph),
  rdf(
    Reifier,
    iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'),
    triple(S, P, O),
    default_graph
  ),
  rdf(
    Reifier,
    iri('https://example.org/statedBy'),
    Source,
    default_graph
  ),
  rdf(
    Reifier,
    iri('https://example.org/recorded'),
    Date,
    default_graph
  ).
```

An annotated claim needs four things to line up: the asserted triple, a
reifier that points to that very triple, a source, and a date. The shared
variables `S`, `P`, `O` and `Reifier` do the joining.

---

# The answer

```sh
eyeprolog examples/rdf12-annotation.pl
```

```text
result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph).
```

Four results: the statement and its three annotation triples, written back as
RDF.

---

# The reason

```text
step(result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(6),
     ['S' = iri('https://example.org/alice'),
      'P' = iri('https://example.org/name'),
      'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))],
     [annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]).
```

The statement is re-emitted only because a complete annotated claim was found;
the `annotated_claim/6` step below it cites all four source triples.

---

# The check

```text
condition('C1', resolution, ok, 9).
condition('C4', coverage, ok, 12).
condition('C7', relevance, ok, 13).
trusted(0).
verdict(checked).
```

All nine steps replay against the program.

---

# Try it

- Delete the `recorded` triple and predict the output. Is it right that an
  unannotated statement disappears entirely?
- Add a second reifier for the same statement, stated by someone else, and
  count the results.
- See [ranking annotated claims](rdf12-annotated-claims.md) for annotations
  that drive a decision, and the [scientific evidence graph](scientific-evidence-graph.md)
  for a larger case.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
