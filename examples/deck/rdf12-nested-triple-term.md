# RDF 1.2 nested triple terms

## What is buried inside a claim about a claim?

An auditor reviews Alice's claim that Bob knows Carol. In RDF 1.2 that is a
triple term inside a triple term. EyeProlog matches the whole nesting with one
pattern and recovers the innermost relationship.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=rdf12-nested-triple-term) ·
[Source](../rdf12-nested-triple-term.pl)

---

# The question

Which relationship sits at the bottom of a review of a claim?

This is one of a family of RDF 1.2 examples. RDF data arrives as
`rdf(Subject, Predicate, Object, Graph)` facts, as produced by
[rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange),
and results are printed in the same shape.

---

# The data

```prolog
rdf(iri('https://example.org/auditor'), iri('https://example.org/reviews'), triple(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'))), default_graph).
```

Triple terms nest: the auditor reviews a statement whose object is itself a
statement. Each level is a statement *about* the one below it, and none of
them is asserted as plain fact.

---

# The rule

```prolog
result_rdf(S, iri('https://example.org/knows'), O, G) :-
  rdf(
    _,
    iri('https://example.org/reviews'),
    triple(
      _,
      iri('https://example.org/claims'),
      triple(S, iri('https://example.org/knows'), O)
    ),
    G
  ).
```

The pattern has the same shape as the data. Nesting needs no special query
language: a nested term is matched by a nested pattern.

---

# The answer

```sh
eyeprolog examples/rdf12-nested-triple-term.pl
```

```text
result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph).
```

---

# The reason

```text
step(result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph),
     rule(2),
     ['S' = iri('https://example.org/bob'),
      'O' = iri('https://example.org/carol'),
      'G' = default_graph],
     [rdf(iri('https://example.org/auditor'), iri('https://example.org/reviews'), triple(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'))), default_graph)]).
```

The proof cites the single reviewed triple. Who reviewed, who claimed, and
what was claimed all stay visible in that one premise.

---

# The check

```text
condition('C1', resolution, ok, 2).
condition('C4', coverage, ok, 2).
condition('C7', relevance, ok, 3).
trusted(0).
verdict(checked).
```

---

# Try it

- Also return who made the inner claim, as a second result relation.
- Add a review of a different claim and predict which of the two the rule
  picks up.
- Compare with the single-level [triple term](rdf12-triple-term.md) deck.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 9.
