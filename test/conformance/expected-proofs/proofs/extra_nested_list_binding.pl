answer(nested_list_binding, "c").
why(
  answer(nested_list_binding, "c"),
  step(
    answer(nested_list_binding, "c"),
    rule("<stdin>", clause(1)),
    ['Tail' = "c"],
    [
      step(=("abc", "abc"), builtin(=, 2), [], [])
    ]
  )
).

