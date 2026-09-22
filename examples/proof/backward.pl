isIndeedMoreInterestingThan(5, 3).
why(
  isIndeedMoreInterestingThan(5, 3),
  step(
    isIndeedMoreInterestingThan(5, 3),
    rule("backward.pl", clause(2)),
    [],
    [
      step(
        moreInterestingThan(5, 3),
        rule("backward.pl", clause(1)),
        ['X' = 5, 'Y' = 3],
        [
          step(>(5, 3), builtin(>, 2), [], [])
        ]
      )
    ]
  )
).

