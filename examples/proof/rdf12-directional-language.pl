% Prolog result format 4
query(1,
      result_rdf(_0, _1, _2, _3),
      ['__anon0' = _0, '__anon1' = _1, '__anon2' = _2, '__anon3' = _3]).
result(1, complete, 2).
answer(1,
       ['__anon0' = iri('https://example.org/welcome'),
        '__anon1' = iri('https://example.org/displayLabel'),
        '__anon2' = literal('مرحبا', lang(ar, rtl)),
        '__anon3' = default_graph]).
why(1,
    ['__anon0' = iri('https://example.org/welcome'),
     '__anon1' = iri('https://example.org/displayLabel'),
     '__anon2' = literal('مرحبا', lang(ar, rtl)),
     '__anon3' = default_graph],
    [result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph)]).
answer(1,
       ['__anon0' = iri('https://example.org/welcome'),
        '__anon1' = iri('https://example.org/displayLabel'),
        '__anon2' = literal('Welcome', lang(en, ltr)),
        '__anon3' = default_graph]).
why(1,
    ['__anon0' = iri('https://example.org/welcome'),
     '__anon1' = iri('https://example.org/displayLabel'),
     '__anon2' = literal('Welcome', lang(en, ltr)),
     '__anon3' = default_graph],
    [result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph)]).

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
