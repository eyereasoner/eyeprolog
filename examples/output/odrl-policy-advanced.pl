% Prolog result format 4
query(1,
      result_rdf(_0, _1, _2, _3),
      ['__anon0' = _0, '__anon1' = _1, '__anon2' = _2, '__anon3' = _3]).
result(1, complete, 6).
answer(1,
       ['__anon0' = iri('https://example.org/result/research_use'),
        '__anon1' = iri('https://example.org/decision'),
        '__anon2' = iri('https://example.org/permit'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/result/commercial_use'),
        '__anon1' = iri('https://example.org/decision'),
        '__anon2' = iri('https://example.org/deny'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/result/dataset_transfer'),
        '__anon1' = iri('https://example.org/decision'),
        '__anon2' = iri('https://example.org/deny'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/result/research_use'),
        '__anon1' = iri('https://example.org/duty'),
        '__anon2' = iri('https://example.org/deidentify'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/result/commercial_use'),
        '__anon1' = iri('https://example.org/reason'),
        '__anon2' = iri('https://example.org/purpose_mismatch'),
        '__anon3' = default_graph]).
answer(1,
       ['__anon0' = iri('https://example.org/result/dataset_transfer'),
        '__anon1' = iri('https://example.org/reason'),
        '__anon2' = iri('https://example.org/prohibited'),
        '__anon3' = default_graph]).
