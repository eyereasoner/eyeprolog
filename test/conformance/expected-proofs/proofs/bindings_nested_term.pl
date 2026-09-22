answer(pair(a, "bc")).
why(
  answer(pair(a, "bc")),
  step(
    answer(pair(a, "bc")),
    rule("<stdin>", clause(2)),
    ['Term' = pair(a, "bc")],
    [
      step(source(pair(a, "bc")), fact("<stdin>", clause(1)), [], [])
    ]
  )
).

