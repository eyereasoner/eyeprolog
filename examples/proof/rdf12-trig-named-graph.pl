result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')).
why(
  result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')),
  step(
    result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')),
    rule("rdf12-trig-named-graph.pl", clause(3)),
    ['S' = iri('https://example.org/alice'), 'O' = iri('https://example.org/bob'), 'G' = iri('https://example.org/family')],
    [
      step(rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family')), fact("rdf12-trig-named-graph.pl", clause(1)), [], [])
    ]
  )
).

result_rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')).
why(
  result_rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')),
  step(
    result_rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')),
    rule("rdf12-trig-named-graph.pl", clause(3)),
    ['S' = iri('https://example.org/bob'), 'O' = iri('https://example.org/carol'), 'G' = iri('https://example.org/family')],
    [
      step(rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family')), fact("rdf12-trig-named-graph.pl", clause(2)), [], [])
    ]
  )
).

result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')).
why(
  result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')),
  step(
    result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')),
    rule("rdf12-trig-named-graph.pl", clause(4)),
    ['S' = iri('https://example.org/alice'), 'O' = iri('https://example.org/carol'), 'G' = iri('https://example.org/family'), 'M' = iri('https://example.org/bob')],
    [
      step(rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family')), fact("rdf12-trig-named-graph.pl", clause(1)), [], []),
      step(rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family')), fact("rdf12-trig-named-graph.pl", clause(2)), [], [])
    ]
  )
).

