% Prolog result format 4
query(1,
      result_rdf(_0, _1, _2, _3),
      ['__anon0' = _0, '__anon1' = _1, '__anon2' = _2, '__anon3' = _3]).
result(1, complete, 9).
answer(1,
       ['__anon0' = iri('https://example.org/flow-care'),
        '__anon1' = iri('https://example.org/decision'),
        '__anon2' = iri('https://example.org/permit'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/flow-clinic'),
        '__anon1' = iri('https://example.org/decision'),
        '__anon2' = iri('https://example.org/review'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/flow-ads'),
        '__anon1' = iri('https://example.org/decision'),
        '__anon2' = iri('https://example.org/deny'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/flow-care'),
        '__anon1' = iri('https://example.org/confidence'),
        '__anon2' = literal('0.92', datatype('http://www.w3.org/2001/XMLSchema#decimal')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/flow-clinic'),
        '__anon1' = iri('https://example.org/confidence'),
        '__anon2' = literal('0.63', datatype('http://www.w3.org/2001/XMLSchema#decimal')),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/flow-care'),
        '__anon1' = iri('https://example.org/status'),
        '__anon2' = iri('https://example.org/executable_flow'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/flow-ads'),
        '__anon1' = iri('https://example.org/status'),
        '__anon2' = iri('https://example.org/blocked_flow'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/flow-clinic'),
        '__anon1' = iri('https://example.org/risk'),
        '__anon2' = iri('https://example.org/trustworthiness_risk'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/flow-ads'),
        '__anon1' = iri('https://example.org/risk'),
        '__anon2' = iri('https://example.org/unwanted_disclosure'),
        '__anon3' = default_graph]).
