answer(ok).
why(
  answer(ok),
  step(
    answer(ok),
    rule("<stdin>", clause(2)),
    [],
    [
      step('\\+'(known(b)), builtin('\\+', 1), [], [])
    ]
  )
).

