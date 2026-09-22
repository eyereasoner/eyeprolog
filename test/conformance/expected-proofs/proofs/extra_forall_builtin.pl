answer(forall_builtin).
why(
  answer(forall_builtin),
  step(
    answer(forall_builtin),
    rule("<stdin>", clause(1)),
    [],
    [
      step('\\+'(forall_counterexample), builtin('\\+', 1), [], [])
    ]
  )
).

