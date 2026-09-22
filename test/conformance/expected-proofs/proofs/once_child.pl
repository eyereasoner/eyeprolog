answer(a).
why(
  answer(a),
  step(
    answer(a),
    rule("<stdin>", clause(3)),
    ['X' = a],
    [
      step(
        once(choice(a)),
        builtin(once, 1),
        [],
        [
          step(choice(a), fact("<stdin>", clause(1)), [], [])
        ]
      )
    ]
  )
).

