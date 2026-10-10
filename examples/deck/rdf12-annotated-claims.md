# Ranking RDF 1.2 annotated claims

## Is the bridge open or closed?

The transport authority says the bridge is closed. An anonymous post says it
is open. Both statements arrive as RDF 1.2 annotated claims with a confidence
and a source. EyeProlog ranks them by confidence times source trust and
derives one auditable decision.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=rdf12-annotated-claims) ·
[Source](../rdf12-annotated-claims.pl)

---

# The question

Should a traveller cross the bridge, avoid it, or check manually?

This is one of a family of RDF 1.2 examples. RDF data arrives as
`rdf(Subject, Predicate, Object, Graph)` facts, as produced by
[rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange),
and the decision is written back in the same shape.

---

# The data

```prolog
rdf(iri('https://example.org/bridge'), iri('https://example.org/status'), iri('https://example.org/closed'), default_graph).
rdf(iri('https://example.org/authorityClaim'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/bridge'), iri('https://example.org/status'), iri('https://example.org/closed')), default_graph).
rdf(iri('https://example.org/authorityClaim'), iri('https://example.org/assertedBy'), iri('https://example.org/transportAuthority'), default_graph).
rdf(iri('https://example.org/authorityClaim'), iri('https://example.org/confidence'), literal('98', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
```

Each status statement is **annotated**: a reifier points at the statement and
carries who asserted it and with what confidence. A separate `trustScore`
rates each source (95 for the authority, 20 for the anonymous post).

---

# Scoring a claim

```prolog
  rdf_number(Reifier, 'https://example.org/confidence', Confidence),
  rdf_number(iri(SourceIri), 'https://example.org/trustScore', Trust),
  Score is Confidence * Trust.
```

This is the last part of `annotated_status_claim/3`, which first finds the
statement, its reifier, and its source. The score is confidence times trust:
98 × 95 = 9310 for "closed", 35 × 20 = 700 for "open".

---

# Deciding

```prolog
bridge_decision(
  [claim(Status, Source, score(Score))|_],
  Action,
  Source,
  Score
) :-
  Score >= 8000,
  status_action(Status, Action).
bridge_decision(
  [claim(_Status, _Source, score(Score))|_],
  verify_manually,
  no_trusted_source,
  Score
) :-
  Score < 8000.
```

Only the top-ranked claim counts, and only if its score reaches 8000.
Otherwise the decision is `verify_manually`: weak evidence does not become a
confident answer.

---

# The answer

```sh
eyeprolog examples/rdf12-annotated-claims.pl
```

```text
result_rdf(iri('https://example.org/bridge'), iri('https://example.org/decision'), iri('https://example.org/avoid_bridge'), default_graph).
result_rdf(iri('https://example.org/bridge'), iri('https://example.org/trustedSource'), iri('https://example.org/transportAuthority'), default_graph).
result_rdf(iri('https://example.org/bridge'), iri('https://example.org/score'), literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
```

These are the first 3 of 9 results; the rest give each claim's rank, source,
and score. Avoid the bridge, on the authority's word.

---

# The reason

```text
step(bridge_decision([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))], avoid_bridge, transport_authority, 9310),
     rule(14),
     ['Status' = closed,
      'Source' = transport_authority,
      'Score' = 9310,
      'Action' = avoid_bridge],
     [9310 >= 8000, status_action(closed, avoid_bridge)]).
```

The decision rests on the ranked list, the threshold test `9310 >= 8000`, and
the mapping from `closed` to `avoid_bridge`.

---

# The check

```text
condition('C1', resolution, ok, 30).
condition('C5', re_decision, ok, 12).
condition('C6', boundary_consistency, ok, 0).
obligation(collected, theory_scoped, findall(key(A, B) - claim(B, C, score(D)), (annotated_status_claim(B, C, D), A is - D), [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))])).
trusted(1).
verdict(checked_with_obligations).
```

30 steps replay against their clauses and 12 arithmetic or built-in steps are
recomputed. One step is an **obligation**: the claim that `findall/3` found
*all* annotated claims. A checker cannot prove that nothing was missed without
re-running the search, so it reports this completeness assumption instead of
hiding it.

---

# Try it

- Lower the authority's `trustScore` from 95 to 50. The top score drops to
  4900 and the decision becomes `verify_manually` with `noTrustedSource`.
- Add a third, highly trusted claim that the bridge is open, and predict the
  new ranking.
- Compare with the simpler [annotations](rdf12-annotation.md) deck and the
  [scientific evidence graph](scientific-evidence-graph.md).

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8.
