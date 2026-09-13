answer([ann, pat], [jim]).
why(
  answer([ann, pat], [jim]),
  proof(
    goal(answer([ann, pat], [jim])),
    by(rule("vanilla-meta-interpreter.pl", clause(13))),
    bindings([binding("Grandchildren", [ann, pat]), binding("GreatGrandchildren", [jim])]),
    uses([
      proof(
        goal(findall(X, solve(grandparent(tom, X)), [ann, pat])),
        by(builtin(findall, 3))
      ),
      proof(
        goal(findall(X, solve(great_grandparent(tom, X)), [jim])),
        by(builtin(findall, 3))
      )
    ])
  )
).

