result_rdf(iri('https://example.org/bridge'), iri('https://example.org/decision'), iri('https://example.org/avoid_bridge'), default_graph).
result_rdf(iri('https://example.org/bridge'), iri('https://example.org/trustedSource'), iri('https://example.org/transportAuthority'), default_graph).
result_rdf(iri('https://example.org/bridge'), iri('https://example.org/score'), literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/closed'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/open'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/closed'), iri('https://example.org/assertedBy'), iri('https://example.org/transportAuthority'), default_graph).
result_rdf(iri('https://example.org/open'), iri('https://example.org/assertedBy'), iri('https://example.org/anonymousPost'), default_graph).
result_rdf(iri('https://example.org/closed'), iri('https://example.org/score'), literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/open'), iri('https://example.org/score'), literal('700', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
