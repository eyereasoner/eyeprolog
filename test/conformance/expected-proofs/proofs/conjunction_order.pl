answer(ok).
why(
  answer(ok),
  step(
    answer(ok),
    rule("<stdin>", clause(3)),
    [],
    [
      step(left(ok), fact("<stdin>", clause(1)), [], []),
      step(right(ok), fact("<stdin>", clause(2)), [], [])
    ]
  )
).

