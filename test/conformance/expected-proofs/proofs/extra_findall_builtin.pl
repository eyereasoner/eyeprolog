answer(findall_builtin, "ab").
why(
  answer(findall_builtin, "ab"),
  step(
    answer(findall_builtin, "ab"),
    rule("<stdin>", clause(3)),
    ['Bag' = "ab"],
    [
      step(findall(X, item(X), "ab"), builtin(findall, 3), [], [])
    ]
  )
).

