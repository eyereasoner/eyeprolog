egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))).
why(
  egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))),
  proof(
    goal(egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2))))),
    by(rule("equality-saturation.pl", clause(28))),
    bindings([binding("Expr", add(mul(add(x, 0), 1), mul(2, add(1, 2))))]),
    uses([
      proof(
        goal(expr(start, add(mul(add(x, 0), 1), mul(2, add(1, 2))))),
        by(fact("equality-saturation.pl", clause(4)))
      )
    ])
  )
).

egraphAnswer(best, add(x, 6)).
why(
  egraphAnswer(best, add(x, 6)),
  proof(
    goal(egraphAnswer(best, add(x, 6))),
    by(rule("equality-saturation.pl", clause(29))),
    bindings([binding("Expr", add(x, 6)), binding("__anon0", 3)]),
    uses([
      proof(
        goal(best_expression(add(x, 6), 3)),
        by(rule("equality-saturation.pl", clause(27))),
        bindings([binding("Expr", add(x, 6)), binding("Cost", 3)]),
        uses([
          proof(
            goal(aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6))),
            by(library(aggregate_min, 5))
          )
        ])
      )
    ])
  )
).

egraphAnswer(cost, 3).
why(
  egraphAnswer(cost, 3),
  proof(
    goal(egraphAnswer(cost, 3)),
    by(rule("equality-saturation.pl", clause(30))),
    bindings([binding("Cost", 3), binding("__anon1", add(x, 6))]),
    uses([
      proof(
        goal(best_expression(add(x, 6), 3)),
        by(rule("equality-saturation.pl", clause(27))),
        bindings([binding("Expr", add(x, 6)), binding("Cost", 3)]),
        uses([
          proof(
            goal(aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6))),
            by(library(aggregate_min, 5))
          )
        ])
      )
    ])
  )
).

egraphAnswer(candidate_count, 32).
why(
  egraphAnswer(candidate_count, 32),
  proof(
    goal(egraphAnswer(candidate_count, 32)),
    by(rule("equality-saturation.pl", clause(31))),
    bindings([binding("Count", 32)]),
    uses([
      proof(
        goal(countall(candidate_expression(__anon2), 32)),
        by(library(countall, 2))
      )
    ])
  )
).

egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph").
why(
  egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph"),
  proof(
    goal(egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph")),
    by(rule("equality-saturation.pl", clause(32))),
    bindings([binding("__anon3", add(x, 6)), binding("__anon4", 3)]),
    uses([
      proof(
        goal(best_expression(add(x, 6), 3)),
        by(rule("equality-saturation.pl", clause(27))),
        bindings([binding("Expr", add(x, 6)), binding("Cost", 3)]),
        uses([
          proof(
            goal(aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6))),
            by(library(aggregate_min, 5))
          )
        ])
      )
    ])
  )
).

