result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), iri('https://example.org/claimsGraph')).

clause(1,
       rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), iri('https://example.org/claimsGraph')),
       true).
clause(2,
       result_rdf(var('S'), iri('https://example.org/knows'), var('O'), var('G')),
       rdf(anonymous(1), iri('https://example.org/claims'), triple(var('S'), iri('https://example.org/knows'), var('O')), var('G'))).

step(result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), iri('https://example.org/claimsGraph')),
     rule(2),
     ['S' = iri('https://example.org/bob'),
      'O' = iri('https://example.org/carol'),
      'G' = iri('https://example.org/claimsGraph')],
     [rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), iri('https://example.org/claimsGraph'))]).
step(rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), iri('https://example.org/claimsGraph')),
     fact(1),
     [],
     []).
