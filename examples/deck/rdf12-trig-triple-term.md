# RDF 1.2 triple terms in a named graph

## Does a claim keep its context when it is unpacked?

Alice's claim that Bob knows Carol is stored in a named graph of claims.
EyeProlog lifts the quoted relationship out of the triple term and keeps the
graph it came from, so the result never loses its context.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=rdf12-trig-triple-term) ·
[Source](../rdf12-trig-triple-term.pl)

---

# The question

Which relationship does the claim contain, and in which graph does the result
belong?

This is one of a family of RDF 1.2 examples. RDF data arrives as
`rdf(Subject, Predicate, Object, Graph)` facts, as produced by
[rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange).
The fourth argument is the graph: `default_graph`, or the name of a graph in a
TriG dataset.

---

# The data

```prolog
rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), iri('https://example.org/claimsGraph')).
```

**TriG** is the RDF syntax for datasets with several **named graphs**. A named
graph groups triples under a name, which is often used to record where they
came from or how much they are trusted.

---

# The rule

```prolog
result_rdf(S, iri('https://example.org/knows'), O, G) :-
  rdf(
    _,
    iri('https://example.org/claims'),
    triple(S, iri('https://example.org/knows'), O),
    G
  ).
```

The same variable `G` appears in the source pattern and in the result, so the
derived relationship lands in the graph that supplied the claim.

---

# The answer

```sh
eyeprolog examples/rdf12-trig-triple-term.pl
```

```text
result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), iri('https://example.org/claimsGraph')).
```

The result is in `claimsGraph`, not in the default graph.

---

# The reason

```text
step(result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), iri('https://example.org/claimsGraph')),
     rule(2),
     ['S' = iri('https://example.org/bob'),
      'O' = iri('https://example.org/carol'),
      'G' = iri('https://example.org/claimsGraph')],
     [rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), iri('https://example.org/claimsGraph'))]).
```

The binding `'G' = iri('https://example.org/claimsGraph')` shows where the
graph name was carried through.

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

- Replace `G` in the rule head with `default_graph` and decide whether that
  loses information a consumer might need.
- Add the same claim in a second graph and predict the number of results.
- Compare with the [default-graph version](rdf12-triple-term.md) and with
  [named-graph reasoning](rdf12-trig-named-graph.md).

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 15.
