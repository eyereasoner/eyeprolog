invalid_state(stone, conflicting_colors).
why(
  invalid_state(stone, conflicting_colors),
  step(
    invalid_state(stone, conflicting_colors),
    rule("integrity-check.pl", clause(3)),
    ['X' = stone],
    [
      step(color(stone, black), fact("integrity-check.pl", clause(1)), [], []),
      step(color(stone, white), fact("integrity-check.pl", clause(2)), [], [])
    ]
  )
).

status(stone, invalid(conflicting_colors)).
why(
  status(stone, invalid(conflicting_colors)),
  step(
    status(stone, invalid(conflicting_colors)),
    rule("integrity-check.pl", clause(4)),
    ['X' = stone, 'Reason' = conflicting_colors],
    [
      step(
        invalid_state(stone, conflicting_colors),
        rule("integrity-check.pl", clause(3)),
        ['X' = stone],
        [
          step(color(stone, black), fact("integrity-check.pl", clause(1)), [], []),
          step(color(stone, white), fact("integrity-check.pl", clause(2)), [], [])
        ]
      )
    ]
  )
).

