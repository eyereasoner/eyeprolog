result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph).

clause(1,
       rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), default_graph),
       true).
clause(2,
       result_rdf(var('S'), iri('https://example.org/knows'), var('O'), var('G')),
       rdf(anonymous(1), iri('https://example.org/claims'), triple(var('S'), iri('https://example.org/knows'), var('O')), var('G'))).

step(result_rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph),
     rule(2),
     ['S' = iri('https://example.org/bob'),
      'O' = iri('https://example.org/carol'),
      'G' = default_graph],
     [rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), default_graph)]).
step(rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), default_graph),
     fact(1),
     [],
     []).
