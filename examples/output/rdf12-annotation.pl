result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph).
result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph).
