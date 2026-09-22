answer(iri_join, '<urn:example:alice>').
why(
  answer(iri_join, '<urn:example:alice>'),
  step(
    answer(iri_join, '<urn:example:alice>'),
    rule("<stdin>", clause(1)),
    ['Who' = '<urn:example:alice>'],
    [
      step(=('<urn:example:alice>', '<urn:example:alice>'), builtin(=, 2), [], [])
    ]
  )
).

