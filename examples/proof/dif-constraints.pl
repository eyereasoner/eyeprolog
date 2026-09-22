allowed_pair(left, right).
why(
  allowed_pair(left, right),
  step(
    allowed_pair(left, right),
    rule("dif-constraints.pl", clause(1)),
    ['X' = left, 'Y' = right],
    [
      step(dif(left, right), builtin(dif, 2), [], []),
      step(=(left, left), builtin(=, 2), [], []),
      step(=(right, right), builtin(=, 2), [], [])
    ]
  )
).

specialization(1, 1).
why(
  specialization(1, 1),
  step(
    specialization(1, 1),
    rule("dif-constraints.pl", clause(2)),
    ['X' = 1, 'Y' = 1],
    [
      step(dif('-'(1, 1), '-'(1, 2)), builtin(dif, 2), [], []),
      step(=(1, 1), builtin(=, 2), [], []),
      step(=(1, 1), builtin(=, 2), [], [])
    ]
  )
).

