result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), iri('https://example.org/claimsGraph')).
why(
  result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), iri('https://example.org/claimsGraph')),
  step(
    result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), iri('https://example.org/claimsGraph')),
    rule("rdf12-trig-triple-term.pl", clause(2)),
    ['S' = iri('https://example.org/bob'), 'O' = iri('https://example.org/carol'), 'G' = iri('https://example.org/claimsGraph'), '__anon0' = iri('https://example.org/alice')],
    [
      step(rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), iri('https://example.org/claimsGraph')), fact("rdf12-trig-triple-term.pl", clause(1)), [], [])
    ]
  )
).

