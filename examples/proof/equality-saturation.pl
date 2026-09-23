egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))).
egraphAnswer(best, add(x, 6)).
egraphAnswer(cost, 3).
egraphAnswer(candidate_count, 32).
egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph").

clause(4, expr(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))), true).
clause(27,
       best_expression(var('Expr'), var('Cost')),
       aggregate_min([var('Candidate_cost'), var('Candidate')], var('Candidate'), (candidate_expression(var('Candidate')), expr_cost(var('Candidate'), var('Candidate_cost'))), [var('Cost'), var('Expr')], var('Expr'))).
clause(28, egraphAnswer(start, var('Expr')), expr(start, var('Expr'))).
clause(29, egraphAnswer(best, var('Expr')), best_expression(var('Expr'), anonymous(1))).
clause(30, egraphAnswer(cost, var('Cost')), best_expression(anonymous(1), var('Cost'))).
clause(31,
       egraphAnswer(candidate_count, var('Count')),
       countall(candidate_expression(anonymous(1)), var('Count'))).
clause(32,
       egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph"),
       best_expression(anonymous(1), anonymous(2))).

step(egraphAnswer(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))),
     rule(28),
     ['Expr' = add(mul(add(x, 0), 1), mul(2, add(1, 2)))],
     [expr(start, add(mul(add(x, 0), 1), mul(2, add(1, 2))))]).
step(expr(start, add(mul(add(x, 0), 1), mul(2, add(1, 2)))), fact(4), [], []).
step(egraphAnswer(best, add(x, 6)),
     rule(29),
     ['Expr' = add(x, 6)],
     [best_expression(add(x, 6), 3)]).
step(best_expression(add(x, 6), 3),
     rule(27),
     ['Expr' = add(x, 6), 'Cost' = 3],
     [aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6))]).
step(aggregate_min([Candidate_cost, Value], Value, (candidate_expression(Value), expr_cost(Value, Candidate_cost)), [3, add(x, 6)], add(x, 6)),
     builtin,
     [],
     []).
step(egraphAnswer(cost, 3), rule(30), ['Cost' = 3], [best_expression(add(x, 6), 3)]).
step(egraphAnswer(candidate_count, 32),
     rule(31),
     ['Count' = 32],
     [countall(candidate_expression(__anon2), 32)]).
step(countall(candidate_expression(__anon2), 32), builtin, [], []).
step(egraphAnswer(note, "bounded equality saturation extracts the cheapest term without a real e-graph"),
     rule(32),
     [],
     [best_expression(add(x, 6), 3)]).
