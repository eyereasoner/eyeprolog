result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
why(
  result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
  proof(
    goal(result_rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph)),
    by(rule("rdf12-annotation.pl", clause(6))),
    bindings([binding("S", iri('https://example.org/alice')), binding("P", iri('https://example.org/name')), binding("O", literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), binding("_Reifier", iri('https://example.org/claim1')), binding("_Source", iri('https://example.org/carol')), binding("_Date", literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]),
    uses([
      proof(
        goal(annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))),
        by(rule("rdf12-annotation.pl", clause(5))),
        bindings([binding("S", iri('https://example.org/alice')), binding("P", iri('https://example.org/name')), binding("O", literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), binding("Reifier", iri('https://example.org/claim1')), binding("Source", iri('https://example.org/carol')), binding("Date", literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]),
        uses([
          proof(
            goal(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph)),
            by(fact("rdf12-annotation.pl", clause(1)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph)),
            by(fact("rdf12-annotation.pl", clause(2)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph)),
            by(fact("rdf12-annotation.pl", clause(3)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph)),
            by(fact("rdf12-annotation.pl", clause(4)))
          )
        ])
      )
    ])
  )
).

result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph).
why(
  result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph),
  proof(
    goal(result_rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph)),
    by(rule("rdf12-annotation.pl", clause(7))),
    bindings([binding("Reifier", iri('https://example.org/claim1')), binding("S", iri('https://example.org/alice')), binding("P", iri('https://example.org/name')), binding("O", literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), binding("_Source", iri('https://example.org/carol')), binding("_Date", literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]),
    uses([
      proof(
        goal(annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))),
        by(rule("rdf12-annotation.pl", clause(5))),
        bindings([binding("S", iri('https://example.org/alice')), binding("P", iri('https://example.org/name')), binding("O", literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), binding("Reifier", iri('https://example.org/claim1')), binding("Source", iri('https://example.org/carol')), binding("Date", literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]),
        uses([
          proof(
            goal(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph)),
            by(fact("rdf12-annotation.pl", clause(1)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph)),
            by(fact("rdf12-annotation.pl", clause(2)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph)),
            by(fact("rdf12-annotation.pl", clause(3)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph)),
            by(fact("rdf12-annotation.pl", clause(4)))
          )
        ])
      )
    ])
  )
).

result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph).
why(
  result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph),
  proof(
    goal(result_rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph)),
    by(rule("rdf12-annotation.pl", clause(8))),
    bindings([binding("Reifier", iri('https://example.org/claim1')), binding("Source", iri('https://example.org/carol')), binding("_S", iri('https://example.org/alice')), binding("_P", iri('https://example.org/name')), binding("_O", literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), binding("_Date", literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]),
    uses([
      proof(
        goal(annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))),
        by(rule("rdf12-annotation.pl", clause(5))),
        bindings([binding("S", iri('https://example.org/alice')), binding("P", iri('https://example.org/name')), binding("O", literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), binding("Reifier", iri('https://example.org/claim1')), binding("Source", iri('https://example.org/carol')), binding("Date", literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]),
        uses([
          proof(
            goal(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph)),
            by(fact("rdf12-annotation.pl", clause(1)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph)),
            by(fact("rdf12-annotation.pl", clause(2)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph)),
            by(fact("rdf12-annotation.pl", clause(3)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph)),
            by(fact("rdf12-annotation.pl", clause(4)))
          )
        ])
      )
    ])
  )
).

result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph).
why(
  result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph),
  proof(
    goal(result_rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph)),
    by(rule("rdf12-annotation.pl", clause(9))),
    bindings([binding("Reifier", iri('https://example.org/claim1')), binding("Date", literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date'))), binding("_S", iri('https://example.org/alice')), binding("_P", iri('https://example.org/name')), binding("_O", literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), binding("_Source", iri('https://example.org/carol'))]),
    uses([
      proof(
        goal(annotated_claim(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/claim1'), iri('https://example.org/carol'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))),
        by(rule("rdf12-annotation.pl", clause(5))),
        bindings([binding("S", iri('https://example.org/alice')), binding("P", iri('https://example.org/name')), binding("O", literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), binding("Reifier", iri('https://example.org/claim1')), binding("Source", iri('https://example.org/carol')), binding("Date", literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')))]),
        uses([
          proof(
            goal(rdf(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph)),
            by(fact("rdf12-annotation.pl", clause(1)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'), triple(iri('https://example.org/alice'), iri('https://example.org/name'), literal('Alice', datatype('http://www.w3.org/2001/XMLSchema#string'))), default_graph)),
            by(fact("rdf12-annotation.pl", clause(2)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('https://example.org/statedBy'), iri('https://example.org/carol'), default_graph)),
            by(fact("rdf12-annotation.pl", clause(3)))
          ),
          proof(
            goal(rdf(iri('https://example.org/claim1'), iri('https://example.org/recorded'), literal('2025-01-15', datatype('http://www.w3.org/2001/XMLSchema#date')), default_graph)),
            by(fact("rdf12-annotation.pl", clause(4)))
          )
        ])
      )
    ])
  )
).

