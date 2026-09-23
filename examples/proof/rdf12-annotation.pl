result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph).

clause(1,
       rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
       true).
clause(2,
       rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph),
       true).
clause(3,
       rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph),
       true).
clause(4,
       rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph),
       true).
clause(5,
       annotated_claim(var('S'), var('P'), var('O'), var('Reifier'), var('Source'), var('Date')),
       (rdf(var('S'), var('P'), var('O'), default_graph),
        rdf(var('Reifier'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(var('S'), var('P'), var('O')), default_graph),
        rdf(var('Reifier'), iri('https://example.org/statedBy'), var('Source'), default_graph),
        rdf(var('Reifier'), iri('https://example.org/recorded'), var('Date'), default_graph))).
clause(6,
       result_rdf(var('S'), var('P'), var('O'), default_graph),
       annotated_claim(var('S'), var('P'), var('O'), anonymous(1), anonymous(2), anonymous(3))).
clause(7,
       result_rdf(var('Reifier'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(var('S'), var('P'), var('O')), default_graph),
       annotated_claim(var('S'), var('P'), var('O'), var('Reifier'), anonymous(1), anonymous(2))).
clause(8,
       result_rdf(var('Reifier'), iri('https://example.org/statedBy'), var('Source'), default_graph),
       annotated_claim(anonymous(1), anonymous(2), anonymous(3), var('Reifier'), var('Source'), anonymous(4))).
clause(9,
       result_rdf(var('Reifier'), iri('https://example.org/recorded'), var('Date'), default_graph),
       annotated_claim(anonymous(1), anonymous(2), anonymous(3), var('Reifier'), anonymous(4), var('Date'))).

step(result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(6),
     ['S' = iri('https://example.org/alice'),
      'P' = iri('https://example.org/name'),
      'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))],
     [annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]).
step(annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))),
     rule(5),
     ['S' = iri('https://example.org/alice'),
      'P' = iri('https://example.org/name'),
      'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')),
      'Reifier' = iri('https://example.org/claim1'),
      'Source' = iri('https://example.org/carol'),
      'Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
     [rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
      rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph),
      rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph),
      rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph)]).
step(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     fact(1),
     [],
     []).
step(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph),
     fact(2),
     [],
     []).
step(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph),
     fact(3),
     [],
     []).
step(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph),
     fact(4),
     [],
     []).
step(result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph),
     rule(7),
     ['Reifier' = iri('https://example.org/claim1'),
      'S' = iri('https://example.org/alice'),
      'P' = iri('https://example.org/name'),
      'O' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))],
     [annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]).
step(result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph),
     rule(8),
     ['Reifier' = iri('https://example.org/claim1'),
      'Source' = iri('https://example.org/carol')],
     [annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]).
step(result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph),
     rule(9),
     ['Reifier' = iri('https://example.org/claim1'),
      'Date' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))],
     [annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]).
