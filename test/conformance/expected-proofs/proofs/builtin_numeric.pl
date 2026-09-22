answer(5).
why(
  answer(5),
  step(
    answer(5),
    rule("<stdin>", clause(1)),
    ['X' = 5],
    [
      step(is(5, '+'(2, 3)), builtin(is, 2), [], [])
    ]
  )
).

