result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')).
result_rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')).
result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')).

clause(1,
       rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family')),
       true).
clause(2,
       rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family')),
       true).
clause(3,
       result_rdf(var('S'), iri('https://example.org/ancestor'), var('O'), var('G')),
       rdf(var('S'), iri('https://example.org/parent'), var('O'), var('G'))).
clause(4,
       result_rdf(var('S'), iri('https://example.org/ancestor'), var('O'), var('G')),
       (rdf(var('S'), iri('https://example.org/parent'), var('M'), var('G')),
        rdf(var('M'), iri('https://example.org/parent'), var('O'), var('G')))).

step(result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')),
     rule(3),
     ['S' = iri('https://example.org/alice'),
      'O' = iri('https://example.org/bob'),
      'G' = iri('https://example.org/family')],
     [rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family'))]).
step(rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family')),
     fact(1),
     [],
     []).
step(result_rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')),
     rule(3),
     ['S' = iri('https://example.org/bob'),
      'O' = iri('https://example.org/carol'),
      'G' = iri('https://example.org/family')],
     [rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family'))]).
step(rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family')),
     fact(2),
     [],
     []).
step(result_rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')),
     rule(4),
     ['S' = iri('https://example.org/alice'),
      'O' = iri('https://example.org/carol'),
      'G' = iri('https://example.org/family'),
      'M' = iri('https://example.org/bob')],
     [rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family')),
      rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family'))]).
