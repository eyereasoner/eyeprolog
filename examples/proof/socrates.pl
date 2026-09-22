type(socrates, mortal).
why(
  type(socrates, mortal),
  step(
    type(socrates, mortal),
    rule("socrates.pl", clause(2)),
    ['X' = socrates],
    [
      step(type(socrates, man), fact("socrates.pl", clause(1)), [], [])
    ]
  )
).

holds_result(test, true).
why(
  holds_result(test, true),
  step(
    holds_result(test, true),
    rule("socrates.pl", clause(3)),
    [],
    [
      step(
        type(socrates, mortal),
        rule("socrates.pl", clause(2)),
        ['X' = socrates],
        [
          step(type(socrates, man), fact("socrates.pl", clause(1)), [], [])
        ]
      )
    ]
  )
).

