holds_result(test, holds_result(joe, good(cobbler))).
why(
  holds_result(test, holds_result(joe, good(cobbler))),
  step(
    holds_result(test, holds_result(joe, good(cobbler))),
    rule("good-cobbler.pl", clause(2)),
    ['X' = joe, 'Y' = cobbler],
    [
      step(assertedIs(joe, good(cobbler)), fact("good-cobbler.pl", clause(1)), [], [])
    ]
  )
).

