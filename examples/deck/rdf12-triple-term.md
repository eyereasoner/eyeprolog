# RDF 1.2 triple terms

## Can a statement be talked about without being asserted?

Alice claims that Bob knows Carol. RDF 1.2 can record that claim as a
*triple term*: a triple used as a value inside another triple. EyeProlog reads
it as an ordinary nested Prolog term and lifts the quoted relationship out
into a result of its own.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=rdf12-triple-term) ·
[Source](../rdf12-triple-term.pl)

---

# The question

What relationship is inside Alice's claim?

This is one of a family of RDF 1.2 examples. RDF data arrives as
`rdf(Subject, Predicate, Object, Graph)` facts, as produced by
[rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange);
ordinary rules derive new results in the same shape, and `write_results/0`
prints them as `rdf/4` facts that convert straight back to RDF.

---

# The data

```prolog
rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), default_graph).
```

A **triple term** is a whole statement used as the object of another
statement. Here the object of `claims` is `triple(bob, knows, carol)`. The
data does *not* say that Bob knows Carol; it says that Alice claims so.

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

Unification looks inside the triple term: the pattern
`triple(S, knows, O)` matches the quoted statement and binds its subject and
object. Projecting a claim into a plain relationship is a decision this rule
makes explicitly; nothing in RDF does it for you.

---

# The answer

```sh
eyeprolog examples/rdf12-triple-term.pl
```

```text
result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph).
```

One relationship, recovered from inside the claim.

---

# The reason

```sh
eyeprolog --proof examples/rdf12-triple-term.pl
```

```text
step(result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph),
     rule(2),
     ['S' = iri('https://example.org/bob'),
      'O' = iri('https://example.org/carol'),
      'G' = default_graph],
     [rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), default_graph)]).
```

The result rests on exactly one source triple: Alice's claim. An auditor can
see that the asserted relationship came from a claim, and whose claim it was.

---

# The check

```text
condition('C1', resolution, ok, 2).
condition('C4', coverage, ok, 2).
condition('C7', relevance, ok, 3).
trusted(0).
verdict(checked).
```

Both steps replay against the program and nothing is taken on trust.

---

# Try it

- Change `knows` to `likes` inside the triple term. The run prints nothing:
  the rule only projects `knows` claims.
- Add a second claim by another person and require that two different people
  claim the same relationship before it is projected.
- Compare with the related decks:
  [nested triple terms](rdf12-nested-triple-term.md),
  [annotations](rdf12-annotation.md), and
  [triple terms in a named graph](rdf12-trig-triple-term.md).

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 9.
