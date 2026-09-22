answer(ok).
why(
  answer(ok),
  step(
    answer(ok),
    rule("<stdin>", clause(2)),
    ['X' = ok],
    [
      step(seed(ok), fact("<stdin>", clause(1)), [], [])
    ]
  )
).

