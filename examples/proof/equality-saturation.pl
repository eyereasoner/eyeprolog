egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))).
why(
  egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))),
  step(
    egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))),
    rule("equality-saturation.pl", clause(28)),
    ['Expr' = add(mul(add(x, 0), 1), mul(2, add(1, 2)))],
    [
      step(expr(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))), fact("equality-saturation.pl", clause(4)), [], [])
    ]
  )
).

egraphAnswer(best, add(x, 6)).
why(
  egraphAnswer(best, add(x, 6)),
  step(
    egraphAnswer(best, add(x, 6)),
    rule("equality-saturation.pl", clause(29)),
    ['Expr' = add(x, 6), '__anon0' = 3],
    [
      step(
        best_expression(add(x, 6), 3),
        rule("equality-saturation.pl", clause(27)),
        ['Expr' = add(x, 6), 'Cost' = 3],
        [
          step(aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6)), library(aggregate_min, 5), [], [])
        ]
      )
    ]
  )
).

egraphAnswer(cost, 3).
why(
  egraphAnswer(cost, 3),
  step(
    egraphAnswer(cost, 3),
    rule("equality-saturation.pl", clause(30)),
    ['Cost' = 3, '__anon1' = add(x, 6)],
    [
      step(
        best_expression(add(x, 6), 3),
        rule("equality-saturation.pl", clause(27)),
        ['Expr' = add(x, 6), 'Cost' = 3],
        [
          step(aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6)), library(aggregate_min, 5), [], [])
        ]
      )
    ]
  )
).

egraphAnswer(candidate_count, 32).
why(
  egraphAnswer(candidate_count, 32),
  step(
    egraphAnswer(candidate_count, 32),
    rule("equality-saturation.pl", clause(31)),
    ['Count' = 32],
    [
      step(countall(candidate_expression(__anon2), 32), library(countall, 2), [], [])
    ]
  )
).

egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph").
why(
  egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph"),
  step(
    egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph"),
    rule("equality-saturation.pl", clause(32)),
    ['__anon3' = add(x, 6), '__anon4' = 3],
    [
      step(
        best_expression(add(x, 6), 3),
        rule("equality-saturation.pl", clause(27)),
        ['Expr' = add(x, 6), 'Cost' = 3],
        [
          step(aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6)), library(aggregate_min, 5), [], [])
        ]
      )
    ]
  )
).

