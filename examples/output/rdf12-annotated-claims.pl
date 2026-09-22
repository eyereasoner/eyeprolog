% Prolog result format 4
query(1,
      result_rdf(_0, _1, _2, _3),
      ['__anon0' = _0, '__anon1' = _1, '__anon2' = _2, '__anon3' = _3]).
result(1, complete, 9).
answer(1,
       ['__anon0' = iri('https://example.org/bridge'),
        '__anon1' = iri('https://example.org/decision'),
        '__anon2' = iri('https://example.org/avoid_bridge'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/bridge'),
        '__anon1' = iri('https://example.org/trustedSource'),
        '__anon2' = iri('https://example.org/transportAuthority'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/bridge'),
        '__anon1' = iri('https://example.org/score'),
        '__anon2' = literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/closed'),
        '__anon1' = iri('https://example.org/rank'),
        '__anon2' = literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/open'),
        '__anon1' = iri('https://example.org/rank'),
        '__anon2' = literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/closed'),
        '__anon1' = iri('https://example.org/assertedBy'),
        '__anon2' = iri('https://example.org/transportAuthority'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/open'),
        '__anon1' = iri('https://example.org/assertedBy'),
        '__anon2' = iri('https://example.org/anonymousPost'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/closed'),
        '__anon1' = iri('https://example.org/score'),
        '__anon2' = literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/open'),
        '__anon1' = iri('https://example.org/score'),
        '__anon2' = literal('700', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
