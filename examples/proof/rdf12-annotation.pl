result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
why(
  result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
  step(
    result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
    rule("rdf12-annotation.pl", clause(6)),
    ['S' = iri('https://example.org/alice'), 'P' = iri('https://example.org/name'), 'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), '_Reifier' = iri('https://example.org/claim1'), '_Source' = iri('https://example.org/carol'), '_Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
    [
      step(
        annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))),
        rule("rdf12-annotation.pl", clause(5)),
        ['S' = iri('https://example.org/alice'), 'P' = iri('https://example.org/name'), 'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), 'Reifier' = iri('https://example.org/claim1'), 'Source' = iri('https://example.org/carol'), 'Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
        [
          step(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph), fact("rdf12-annotation.pl", clause(1)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph), fact("rdf12-annotation.pl", clause(2)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph), fact("rdf12-annotation.pl", clause(3)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph), fact("rdf12-annotation.pl", clause(4)), [], [])
        ]
      )
    ]
  )
).

result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph).
why(
  result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph),
  step(
    result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph),
    rule("rdf12-annotation.pl", clause(7)),
    ['Reifier' = iri('https://example.org/claim1'), 'S' = iri('https://example.org/alice'), 'P' = iri('https://example.org/name'), 'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), '_Source' = iri('https://example.org/carol'), '_Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
    [
      step(
        annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))),
        rule("rdf12-annotation.pl", clause(5)),
        ['S' = iri('https://example.org/alice'), 'P' = iri('https://example.org/name'), 'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), 'Reifier' = iri('https://example.org/claim1'), 'Source' = iri('https://example.org/carol'), 'Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
        [
          step(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph), fact("rdf12-annotation.pl", clause(1)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph), fact("rdf12-annotation.pl", clause(2)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph), fact("rdf12-annotation.pl", clause(3)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph), fact("rdf12-annotation.pl", clause(4)), [], [])
        ]
      )
    ]
  )
).

result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph).
why(
  result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph),
  step(
    result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph),
    rule("rdf12-annotation.pl", clause(8)),
    ['Reifier' = iri('https://example.org/claim1'), 'Source' = iri('https://example.org/carol'), '_S' = iri('https://example.org/alice'), '_P' = iri('https://example.org/name'), '_O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), '_Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
    [
      step(
        annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))),
        rule("rdf12-annotation.pl", clause(5)),
        ['S' = iri('https://example.org/alice'), 'P' = iri('https://example.org/name'), 'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), 'Reifier' = iri('https://example.org/claim1'), 'Source' = iri('https://example.org/carol'), 'Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
        [
          step(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph), fact("rdf12-annotation.pl", clause(1)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph), fact("rdf12-annotation.pl", clause(2)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph), fact("rdf12-annotation.pl", clause(3)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph), fact("rdf12-annotation.pl", clause(4)), [], [])
        ]
      )
    ]
  )
).

result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph).
why(
  result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph),
  step(
    result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph),
    rule("rdf12-annotation.pl", clause(9)),
    ['Reifier' = iri('https://example.org/claim1'), 'Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), '_S' = iri('https://example.org/alice'), '_P' = iri('https://example.org/name'), '_O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), '_Source' = iri('https://example.org/carol')],
    [
      step(
        annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))),
        rule("rdf12-annotation.pl", clause(5)),
        ['S' = iri('https://example.org/alice'), 'P' = iri('https://example.org/name'), 'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), 'Reifier' = iri('https://example.org/claim1'), 'Source' = iri('https://example.org/carol'), 'Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
        [
          step(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph), fact("rdf12-annotation.pl", clause(1)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph), fact("rdf12-annotation.pl", clause(2)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph), fact("rdf12-annotation.pl", clause(3)), [], []),
          step(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph), fact("rdf12-annotation.pl", clause(4)), [], [])
        ]
      )
    ]
  )
).

