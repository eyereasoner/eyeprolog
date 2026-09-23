result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph).
result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph).

clause(1,
       rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('مرحبا', lang(ar, rtl)), default_graph),
       true).
clause(2,
       rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('Welcome', lang(en, ltr)), default_graph),
       true).
clause(3,
       result_rdf(var('S'), iri('https://example.org/displayLabel'), var('Label'), var('G')),
       rdf(var('S'), iri('https://example.org/label'), var('Label'), var('G'))).

step(result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph),
     rule(3),
     ['S' = iri('https://example.org/welcome'),
      'Label' = literal('مرحبا', lang(ar, rtl)),
      'G' = default_graph],
     [rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('مرحبا', lang(ar, rtl)), default_graph)]).
step(rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('مرحبا', lang(ar, rtl)), default_graph),
     fact(1),
     [],
     []).
step(result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph),
     rule(3),
     ['S' = iri('https://example.org/welcome'),
      'Label' = literal('Welcome', lang(en, ltr)),
      'G' = default_graph],
     [rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('Welcome', lang(en, ltr)), default_graph)]).
step(rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('Welcome', lang(en, ltr)), default_graph),
     fact(2),
     [],
     []).
