% Prolog result format 4
query(1,
      result_rdf(_0, _1, _2, _3),
      ['__anon0' = _0, '__anon1' = _1, '__anon2' = _2, '__anon3' = _3]).
result(1, complete, 15).
answer(1,
       ['__anon0' = iri('https://example.org/consent-risk'),
        '__anon1' = iri('https://example.org/rank'),
        '__anon2' = literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/sharing-risk'),
        '__anon1' = iri('https://example.org/rank'),
        '__anon2' = literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/retention-risk'),
        '__anon1' = iri('https://example.org/rank'),
        '__anon2' = literal('3', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/consent-risk'),
        '__anon1' = iri('https://example.org/score'),
        '__anon2' = literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/sharing-risk'),
        '__anon1' = iri('https://example.org/score'),
        '__anon2' = literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/retention-risk'),
        '__anon1' = iri('https://example.org/score'),
        '__anon2' = literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/consent-risk'),
        '__anon1' = iri('https://example.org/level'),
        '__anon2' = iri('https://example.org/high'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/sharing-risk'),
        '__anon1' = iri('https://example.org/level'),
        '__anon2' = iri('https://example.org/high'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/retention-risk'),
        '__anon1' = iri('https://example.org/level'),
        '__anon2' = iri('https://example.org/moderate'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/consent-risk'),
        '__anon1' = iri('https://example.org/clause'),
        '__anon2' = literal(h1, datatype('http://www.w3.org/2001/XMLSchema#string')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/sharing-risk'),
        '__anon1' = iri('https://example.org/clause'),
        '__anon2' = literal(h2, datatype('http://www.w3.org/2001/XMLSchema#string')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/retention-risk'),
        '__anon1' = iri('https://example.org/clause'),
        '__anon2' = literal(h4, datatype('http://www.w3.org/2001/XMLSchema#string')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/consent-risk'),
        '__anon1' = iri('https://example.org/mitigation'),
        '__anon2' = iri('https://example.org/require-explicit-consent'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/sharing-risk'),
        '__anon1' = iri('https://example.org/mitigation'),
        '__anon2' = iri('https://example.org/require-deidentification'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/retention-risk'),
        '__anon1' = iri('https://example.org/mitigation'),
        '__anon2' = iri('https://example.org/limit-retention-to-1095-days'),
        '__anon3' = default_graph]).
