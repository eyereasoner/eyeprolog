allowed_pair(left, right).
why(
  allowed_pair(left, right),
  proof(
    goal(allowed_pair(left, right)),
    by(rule("dif-constraints.pl", clause(1))),
    bindings([binding("X", left), binding("Y", right)]),
    uses([
      proof(
        goal(dif(left, right)),
        by(builtin(dif, 2))
      ),
      proof(
        goal(=(left, left)),
        by(builtin(=, 2))
      ),
      proof(
        goal(=(right, right)),
        by(builtin(=, 2))
      )
    ])
  )
).

specialization(1, 1).
why(
  specialization(1, 1),
  proof(
    goal(specialization(1, 1)),
    by(rule("dif-constraints.pl", clause(2))),
    bindings([binding("X", 1), binding("Y", 1)]),
    uses([
      proof(
        goal(dif('-'(1, 1), '-'(1, 2))),
        by(builtin(dif, 2))
      ),
      proof(
        goal(=(1, 1)),
        by(builtin(=, 2))
      ),
      proof(
        goal(=(1, 1)),
        by(builtin(=, 2))
      )
    ])
  )
).

