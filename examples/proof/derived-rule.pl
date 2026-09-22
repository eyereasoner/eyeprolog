log_implies(type(var(y), dog), holds_result(test, true)).
why(
  log_implies(type(var(y), dog), holds_result(test, true)),
  step(
    log_implies(type(var(y), dog), holds_result(test, true)),
    rule("derived-rule.pl", clause(3)),
    ['_x' = minka],
    [
      step(type(minka, cat), fact("derived-rule.pl", clause(1)), [], [])
    ]
  )
).

holds_result(test, true).
why(
  holds_result(test, true),
  step(
    holds_result(test, true),
    rule("derived-rule.pl", clause(4)),
    ['_y' = charly],
    [
      step(
        log_implies(type(var(y), dog), holds_result(test, true)),
        rule("derived-rule.pl", clause(3)),
        ['_x' = minka],
        [
          step(type(minka, cat), fact("derived-rule.pl", clause(1)), [], [])
        ]
      ),
      step(type(charly, dog), fact("derived-rule.pl", clause(2)), [], [])
    ]
  )
).

