result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph).
why(
  result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph),
  step(
    result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph),
    rule("rdf12-nested-triple-term.pl", clause(2)),
    ['S' = iri('https://example.org/bob'), 'O' = iri('https://example.org/carol'), 'G' = default_graph, '__anon0' = iri('https://example.org/auditor'), '__anon1' = iri('https://example.org/alice')],
    [
      step(rdf(iri('https://example.org/auditor'), iri('https://example.org/reviews'), triple(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'))), default_graph), fact("rdf12-nested-triple-term.pl", clause(1)), [], [])
    ]
  )
).

