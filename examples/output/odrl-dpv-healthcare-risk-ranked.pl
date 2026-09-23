result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/rank'), literal('3', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/score'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/level'), iri('https://example.org/moderate'), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/clause'), literal(h1, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/clause'), literal(h2, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/clause'), literal(h4, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-explicit-consent'), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-deidentification'), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/mitigation'), iri('https://example.org/limit-retention-to-1095-days'), default_graph).
