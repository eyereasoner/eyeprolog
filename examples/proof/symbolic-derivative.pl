% Prolog result format 4
query(1, derivative_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = square, 'X1' = add(mul(const(1), var(x)), mul(var(x), const(1)))]).
why(1,
    ['X0' = square, 'X1' = add(mul(const(1), var(x)), mul(var(x), const(1)))],
    [derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1))))]).
answer(1, ['X0' = linear_plus_const, 'X1' = add(const(1), const(0))]).
why(1,
    ['X0' = linear_plus_const, 'X1' = add(const(1), const(0))],
    [derivative_result(linear_plus_const, add(const(1), const(0)))]).
answer(1,
       ['X0' = product,
        'X1' = add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))]).
why(1,
    ['X0' = product,
     'X1' = add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))],
    [derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))))]).
answer(1, ['X0' = nested_log, 'X1' = divide(divide(const(1), var(x)), log(var(x)))]).
why(1,
    ['X0' = nested_log, 'X1' = divide(divide(const(1), var(x)), log(var(x)))],
    [derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x))))]).

clause(1, expr(square, mul(var(x), var(x))), true).
clause(2, expr(linear_plus_const, add(var(x), const(3))), true).
clause(3,
       expr(product, mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))))),
       true).
clause(4, expr(nested_log, log(log(var(x)))), true).
clause(5, d(const(anonymous(1)), anonymous(2), const(0)), true).
clause(6, d(var(var('X')), var('X'), const(1)), true).
clause(8,
       d(add(var('U'), var('V')), var('X'), add(var('Du'), var('Dv'))),
       (d(var('U'), var('X'), var('Du')), d(var('V'), var('X'), var('Dv')))).
clause(10,
       d(mul(var('U'), var('V')), var('X'), add(mul(var('Du'), var('V')), mul(var('U'), var('Dv')))),
       (d(var('U'), var('X'), var('Du')), d(var('V'), var('X'), var('Dv')))).
clause(12,
       d(pow(var('U'), var('N')), var('X'), mul(mul(const(var('N')), pow(var('U'), var('N1'))), var('Du'))),
       (var('N1') is var('N') - 1, d(var('U'), var('X'), var('Du')))).
clause(13,
       d(log(var('U')), var('X'), divide(var('Du'), var('U'))),
       d(var('U'), var('X'), var('Du'))).
clause(14,
       derivative_result(var('Name'), var('Derivative')),
       (expr(var('Name'), var('Expr')), d(var('Expr'), x, var('Derivative')))).

step(derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1)))),
     rule(14),
     ['Name' = square,
      'Derivative' = add(mul(const(1), var(x)), mul(var(x), const(1))),
      'Expr' = mul(var(x), var(x))],
     [expr(square, mul(var(x), var(x))),
      d(mul(var(x), var(x)), x, add(mul(const(1), var(x)), mul(var(x), const(1))))]).
step(expr(square, mul(var(x), var(x))), fact(1), [], []).
step(d(mul(var(x), var(x)), x, add(mul(const(1), var(x)), mul(var(x), const(1)))),
     rule(10),
     ['U' = var(x), 'V' = var(x), 'X' = x, 'Du' = const(1), 'Dv' = const(1)],
     [d(var(x), x, const(1)), d(var(x), x, const(1))]).
step(d(var(x), x, const(1)), fact(6), ['X' = x], []).
step(derivative_result(linear_plus_const, add(const(1), const(0))),
     rule(14),
     ['Name' = linear_plus_const,
      'Derivative' = add(const(1), const(0)),
      'Expr' = add(var(x), const(3))],
     [expr(linear_plus_const, add(var(x), const(3))),
      d(add(var(x), const(3)), x, add(const(1), const(0)))]).
step(expr(linear_plus_const, add(var(x), const(3))), fact(2), [], []).
step(d(add(var(x), const(3)), x, add(const(1), const(0))),
     rule(8),
     ['U' = var(x), 'V' = const(3), 'X' = x, 'Du' = const(1), 'Dv' = const(0)],
     [d(var(x), x, const(1)), d(const(3), x, const(0))]).
step(d(const(3), x, const(0)), fact(5), [], []).
step(derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))),
     rule(14),
     ['Name' = product,
      'Derivative' = add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))),
      'Expr' = mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))))],
     [expr(product, mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))))),
      d(mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), x, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))))]).
step(expr(product, mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))))),
     fact(3),
     [],
     []).
step(d(mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), x, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))),
     rule(10),
     ['U' = add(var(x), const(1)),
      'V' = mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))),
      'X' = x,
      'Du' = add(const(1), const(0)),
      'Dv' = add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))],
     [d(add(var(x), const(1)), x, add(const(1), const(0))),
      d(mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))), x, add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))]).
step(d(add(var(x), const(1)), x, add(const(1), const(0))),
     rule(8),
     ['U' = var(x), 'V' = const(1), 'X' = x, 'Du' = const(1), 'Dv' = const(0)],
     [d(var(x), x, const(1)), d(const(1), x, const(0))]).
step(d(const(1), x, const(0)), fact(5), [], []).
step(d(mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))), x, add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))),
     rule(10),
     ['U' = add(pow(var(x), 2), const(2)),
      'V' = add(pow(var(x), 3), const(3)),
      'X' = x,
      'Du' = add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)),
      'Dv' = add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))],
     [d(add(pow(var(x), 2), const(2)), x, add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0))),
      d(add(pow(var(x), 3), const(3)), x, add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))]).
step(d(add(pow(var(x), 2), const(2)), x, add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0))),
     rule(8),
     ['U' = pow(var(x), 2),
      'V' = const(2),
      'X' = x,
      'Du' = mul(mul(const(2), pow(var(x), 1)), const(1)),
      'Dv' = const(0)],
     [d(pow(var(x), 2), x, mul(mul(const(2), pow(var(x), 1)), const(1))),
      d(const(2), x, const(0))]).
step(d(pow(var(x), 2), x, mul(mul(const(2), pow(var(x), 1)), const(1))),
     rule(12),
     ['U' = var(x), 'N' = 2, 'X' = x, 'N1' = 1, 'Du' = const(1)],
     [1 is 2 - 1, d(var(x), x, const(1))]).
step(1 is 2 - 1, builtin, [], []).
step(d(const(2), x, const(0)), fact(5), [], []).
step(d(add(pow(var(x), 3), const(3)), x, add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))),
     rule(8),
     ['U' = pow(var(x), 3),
      'V' = const(3),
      'X' = x,
      'Du' = mul(mul(const(3), pow(var(x), 2)), const(1)),
      'Dv' = const(0)],
     [d(pow(var(x), 3), x, mul(mul(const(3), pow(var(x), 2)), const(1))),
      d(const(3), x, const(0))]).
step(d(pow(var(x), 3), x, mul(mul(const(3), pow(var(x), 2)), const(1))),
     rule(12),
     ['U' = var(x), 'N' = 3, 'X' = x, 'N1' = 2, 'Du' = const(1)],
     [2 is 3 - 1, d(var(x), x, const(1))]).
step(2 is 3 - 1, builtin, [], []).
step(derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x)))),
     rule(14),
     ['Name' = nested_log,
      'Derivative' = divide(divide(const(1), var(x)), log(var(x))),
      'Expr' = log(log(var(x)))],
     [expr(nested_log, log(log(var(x)))),
      d(log(log(var(x))), x, divide(divide(const(1), var(x)), log(var(x))))]).
step(expr(nested_log, log(log(var(x)))), fact(4), [], []).
step(d(log(log(var(x))), x, divide(divide(const(1), var(x)), log(var(x)))),
     rule(13),
     ['U' = log(var(x)), 'X' = x, 'Du' = divide(const(1), var(x))],
     [d(log(var(x)), x, divide(const(1), var(x)))]).
step(d(log(var(x)), x, divide(const(1), var(x))),
     rule(13),
     ['U' = var(x), 'X' = x, 'Du' = const(1)],
     [d(var(x), x, const(1))]).
