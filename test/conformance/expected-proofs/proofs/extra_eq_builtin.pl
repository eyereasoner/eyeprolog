answer(eq_builtin, a).
why(
  answer(eq_builtin, a),
  step(
    answer(eq_builtin, a),
    rule("<stdin>", clause(1)),
    ['X' = a],
    [
      step(=(pair(a, b), pair(a, b)), builtin(=, 2), [], [])
    ]
  )
).

