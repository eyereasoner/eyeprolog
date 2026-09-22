answer(table_path_bound, b).
why(
  answer(table_path_bound, b),
  step(
    answer(table_path_bound, b),
    rule("<stdin>", clause(5)),
    ['X' = b],
    [
      step(
        path(a, b),
        rule("<stdin>", clause(3)),
        ['X' = a, 'Y' = b],
        [
          step(edge(a, b), fact("<stdin>", clause(1)), [], [])
        ]
      )
    ]
  )
).

answer(table_path_bound, c).
why(
  answer(table_path_bound, c),
  step(
    answer(table_path_bound, c),
    rule("<stdin>", clause(5)),
    ['X' = c],
    [
      step(
        path(a, c),
        rule("<stdin>", clause(4)),
        ['X' = a, 'Z' = c, 'Y' = b],
        [
          step(edge(a, b), fact("<stdin>", clause(1)), [], []),
          step(
            path(b, c),
            rule("<stdin>", clause(3)),
            ['X' = b, 'Y' = c],
            [
              step(edge(b, c), fact("<stdin>", clause(2)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

