result_rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph).
why(
  result_rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
  step(
    result_rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
    rule("rdf12-trig-graph-join.pl", clause(3)),
    ['S' = iri('https://example.org/sensor1'), 'Station' = iri('https://example.org/station7'), '__anon0' = literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string'))],
    [
      step(rdf(iri('https://example.org/sensorGraph'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph), fact("rdf12-trig-graph-join.pl", clause(1)), [], []),
      step(rdf(iri('https://example.org/sensor1'), iri('https://example.org/temperature'), literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/sensorGraph')), fact("rdf12-trig-graph-join.pl", clause(2)), [], [])
    ]
  )
).

