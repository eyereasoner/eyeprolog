result_rdf(iri('https://example.org/flow-care'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph).
result_rdf(iri('https://example.org/flow-clinic'), iri('https://example.org/decision'), iri('https://example.org/review'), default_graph).
result_rdf(iri('https://example.org/flow-ads'), iri('https://example.org/decision'), iri('https://example.org/deny'), default_graph).
result_rdf(iri('https://example.org/flow-care'), iri('https://example.org/confidence'), literal('0.92', datatype('http://www.w3.org/2001/XMLSchema#decimal')), default_graph).
result_rdf(iri('https://example.org/flow-clinic'), iri('https://example.org/confidence'), literal('0.63', datatype('http://www.w3.org/2001/XMLSchema#decimal')), default_graph).
result_rdf(iri('https://example.org/flow-care'), iri('https://example.org/status'), iri('https://example.org/executable_flow'), default_graph).
result_rdf(iri('https://example.org/flow-ads'), iri('https://example.org/status'), iri('https://example.org/blocked_flow'), default_graph).
result_rdf(iri('https://example.org/flow-clinic'), iri('https://example.org/risk'), iri('https://example.org/trustworthiness_risk'), default_graph).
result_rdf(iri('https://example.org/flow-ads'), iri('https://example.org/risk'), iri('https://example.org/unwanted_disclosure'), default_graph).
