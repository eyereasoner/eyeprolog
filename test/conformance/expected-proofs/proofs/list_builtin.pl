answer(b).
why(
  answer(b),
  step(
    answer(b),
    rule("<stdin>", clause(1)),
    ['X' = b],
    [
      step(member(b, "ab"), library(member, 2), [], []),
      step(=(b, b), builtin(=, 2), [], [])
    ]
  )
).

