answer([ann, pat], [jim]).
why(
  answer([ann, pat], [jim]),
  step(
    answer([ann, pat], [jim]),
    rule("vanilla-meta-interpreter.pl", clause(13)),
    ['Grandchildren' = [ann, pat], 'GreatGrandchildren' = [jim]],
    [
      step(findall(X, solve(grandparent(tom, X)), [ann, pat]), builtin(findall, 3), [], []),
      step(findall(X, solve(great_grandparent(tom, X)), [jim]), builtin(findall, 3), [], [])
    ]
  )
).

