% Prolog result format 4
query(1,
      result_rdf(_0, _1, _2, _3),
      ['__anon0' = _0, '__anon1' = _1, '__anon2' = _2, '__anon3' = _3]).
result(1, complete, 4).
answer(1,
       ['__anon0' = iri('https://example.org/alice'),
        '__anon1' = iri('https://example.org/name'),
        '__anon2' = literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/claim1'),
        '__anon1' = iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'),
        '__anon2' = triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/claim1'),
        '__anon1' = iri('https://example.org/statedBy'),
        '__anon2' = iri('https://example.org/carol'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/claim1'),
        '__anon1' = iri('https://example.org/recorded'),
        '__anon2' = literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')),
        '__anon3' = default_graph]).
