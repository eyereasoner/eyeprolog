hates(alice, nobody).
why(
  hates(alice, nobody),
  step(
    hates(alice, nobody),
    rule("snaf.pl", clause(3)),
    ['X' = bob],
    [
      step(person(bob), fact("snaf.pl", clause(2)), [], []),
      step('\\+'(hates(alice, bob)), builtin('\\+', 1), [], [])
    ]
  )
).

