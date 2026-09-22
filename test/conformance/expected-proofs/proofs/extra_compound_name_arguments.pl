answer(compound_name_arguments, box, "ab").
why(
  answer(compound_name_arguments, box, "ab"),
  step(
    answer(compound_name_arguments, box, "ab"),
    rule("<stdin>", clause(1)),
    ['Name' = box, 'Args' = "ab"],
    [
      step('=..'(box(a, b), [box, a, b]), builtin('=..', 2), [], [])
    ]
  )
).

