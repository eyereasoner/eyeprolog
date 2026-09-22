has_parent(alice, parent_of(alice)).
why(
  has_parent(alice, parent_of(alice)),
  step(
    has_parent(alice, parent_of(alice)),
    rule("<stdin>", clause(2)),
    ['Child' = alice],
    [
      step(person(alice), fact("<stdin>", clause(1)), [], [])
    ]
  )
).

