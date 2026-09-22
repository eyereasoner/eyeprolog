path(a, b).
why(
  path(a, b),
  step(
    path(a, b),
    rule("<stdin>", clause(4)),
    ['X' = a, 'Y' = b],
    [
      step(edge(a, b), fact("<stdin>", clause(2)), [], [])
    ]
  )
).

path(b, c).
why(
  path(b, c),
  step(
    path(b, c),
    rule("<stdin>", clause(4)),
    ['X' = b, 'Y' = c],
    [
      step(edge(b, c), fact("<stdin>", clause(3)), [], [])
    ]
  )
).

path(a, c).
why(
  path(a, c),
  step(
    path(a, c),
    rule("<stdin>", clause(5)),
    ['X' = a, 'Z' = c, 'Y' = b],
    [
      step(edge(a, b), fact("<stdin>", clause(2)), [], []),
      step(
        path(b, c),
        rule("<stdin>", clause(4)),
        ['X' = b, 'Y' = c],
        [
          step(edge(b, c), fact("<stdin>", clause(3)), [], [])
        ]
      )
    ]
  )
).

