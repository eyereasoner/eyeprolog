answer(once_member, a).
why(
  answer(once_member, a),
  step(
    answer(once_member, a),
    rule("<stdin>", clause(1)),
    ['X' = a],
    [
      step(
        once(member(a, "abc")),
        builtin(once, 1),
        [],
        [
          step(member(a, "abc"), library(member, 2), [], [])
        ]
      )
    ]
  )
).

