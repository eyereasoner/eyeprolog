label('<urn:example:a>', "Alice").
why(
  label('<urn:example:a>', "Alice"),
  step(
    label('<urn:example:a>', "Alice"),
    rule("<stdin>", clause(2)),
    ['Iri' = '<urn:example:a>', 'Name' = "Alice"],
    [
      step(name('<urn:example:a>', "Alice"), fact("<stdin>", clause(1)), [], [])
    ]
  )
).

