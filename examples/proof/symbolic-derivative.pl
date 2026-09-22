derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1)))).
why(
  derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1)))),
  step(
    derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1)))),
    rule("symbolic-derivative.pl", clause(14)),
    ['Name' = square, 'Derivative' = add(mul(const(1), var(x)), mul(var(x), const(1))), 'Expr' = mul(var(x), var(x))],
    [
      step(expr(square, mul(var(x), var(x))), fact("symbolic-derivative.pl", clause(1)), [], []),
      step(
        d(mul(var(x), var(x)), x, add(mul(const(1), var(x)), mul(var(x), const(1)))),
        rule("symbolic-derivative.pl", clause(10)),
        ['U' = var(x), 'V' = var(x), 'X' = x, 'Du' = const(1), 'Dv' = const(1)],
        [
          step(d(var(x), x, const(1)), fact("symbolic-derivative.pl", clause(6)), ['X' = x], []),
          step(d(var(x), x, const(1)), fact("symbolic-derivative.pl", clause(6)), ['X' = x], [])
        ]
      )
    ]
  )
).

derivative_result(linear_plus_const, add(const(1), const(0))).
why(
  derivative_result(linear_plus_const, add(const(1), const(0))),
  step(
    derivative_result(linear_plus_const, add(const(1), const(0))),
    rule("symbolic-derivative.pl", clause(14)),
    ['Name' = linear_plus_const, 'Derivative' = add(const(1), const(0)), 'Expr' = add(var(x), const(3))],
    [
      step(expr(linear_plus_const, add(var(x), const(3))), fact("symbolic-derivative.pl", clause(2)), [], []),
      step(
        d(add(var(x), const(3)), x, add(const(1), const(0))),
        rule("symbolic-derivative.pl", clause(8)),
        ['U' = var(x), 'V' = const(3), 'X' = x, 'Du' = const(1), 'Dv' = const(0)],
        [
          step(d(var(x), x, const(1)), fact("symbolic-derivative.pl", clause(6)), ['X' = x], []),
          step(d(const(3), x, const(0)), fact("symbolic-derivative.pl", clause(5)), ['_c' = 3, '_x' = x], [])
        ]
      )
    ]
  )
).

derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))).
why(
  derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))),
  step(
    derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))),
    rule("symbolic-derivative.pl", clause(14)),
    ['Name' = product, 'Derivative' = add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))), 'Expr' = mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))))],
    [
      step(expr(product, mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))))), fact("symbolic-derivative.pl", clause(3)), [], []),
      step(
        d(mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), x, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))),
        rule("symbolic-derivative.pl", clause(10)),
        ['U' = add(var(x), const(1)), 'V' = mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))), 'X' = x, 'Du' = add(const(1), const(0)), 'Dv' = add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))],
        [
          step(
            d(add(var(x), const(1)), x, add(const(1), const(0))),
            rule("symbolic-derivative.pl", clause(8)),
            ['U' = var(x), 'V' = const(1), 'X' = x, 'Du' = const(1), 'Dv' = const(0)],
            [
              step(d(var(x), x, const(1)), fact("symbolic-derivative.pl", clause(6)), ['X' = x], []),
              step(d(const(1), x, const(0)), fact("symbolic-derivative.pl", clause(5)), ['_c' = 1, '_x' = x], [])
            ]
          ),
          step(
            d(mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))), x, add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))),
            rule("symbolic-derivative.pl", clause(10)),
            ['U' = add(pow(var(x), 2), const(2)), 'V' = add(pow(var(x), 3), const(3)), 'X' = x, 'Du' = add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), 'Dv' = add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))],
            [
              step(
                d(add(pow(var(x), 2), const(2)), x, add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0))),
                rule("symbolic-derivative.pl", clause(8)),
                ['U' = pow(var(x), 2), 'V' = const(2), 'X' = x, 'Du' = mul(mul(const(2), pow(var(x), 1)), const(1)), 'Dv' = const(0)],
                [
                  step(
                    d(pow(var(x), 2), x, mul(mul(const(2), pow(var(x), 1)), const(1))),
                    rule("symbolic-derivative.pl", clause(12)),
                    ['U' = var(x), 'N' = 2, 'X' = x, 'N1' = 1, 'Du' = const(1)],
                    [
                      step(is(1, '-'(2, 1)), builtin(is, 2), [], []),
                      step(d(var(x), x, const(1)), fact("symbolic-derivative.pl", clause(6)), ['X' = x], [])
                    ]
                  ),
                  step(d(const(2), x, const(0)), fact("symbolic-derivative.pl", clause(5)), ['_c' = 2, '_x' = x], [])
                ]
              ),
              step(
                d(add(pow(var(x), 3), const(3)), x, add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))),
                rule("symbolic-derivative.pl", clause(8)),
                ['U' = pow(var(x), 3), 'V' = const(3), 'X' = x, 'Du' = mul(mul(const(3), pow(var(x), 2)), const(1)), 'Dv' = const(0)],
                [
                  step(
                    d(pow(var(x), 3), x, mul(mul(const(3), pow(var(x), 2)), const(1))),
                    rule("symbolic-derivative.pl", clause(12)),
                    ['U' = var(x), 'N' = 3, 'X' = x, 'N1' = 2, 'Du' = const(1)],
                    [
                      step(is(2, '-'(3, 1)), builtin(is, 2), [], []),
                      step(d(var(x), x, const(1)), fact("symbolic-derivative.pl", clause(6)), ['X' = x], [])
                    ]
                  ),
                  step(d(const(3), x, const(0)), fact("symbolic-derivative.pl", clause(5)), ['_c' = 3, '_x' = x], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x)))).
why(
  derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x)))),
  step(
    derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x)))),
    rule("symbolic-derivative.pl", clause(14)),
    ['Name' = nested_log, 'Derivative' = divide(divide(const(1), var(x)), log(var(x))), 'Expr' = log(log(var(x)))],
    [
      step(expr(nested_log, log(log(var(x)))), fact("symbolic-derivative.pl", clause(4)), [], []),
      step(
        d(log(log(var(x))), x, divide(divide(const(1), var(x)), log(var(x)))),
        rule("symbolic-derivative.pl", clause(13)),
        ['U' = log(var(x)), 'X' = x, 'Du' = divide(const(1), var(x))],
        [
          step(
            d(log(var(x)), x, divide(const(1), var(x))),
            rule("symbolic-derivative.pl", clause(13)),
            ['U' = var(x), 'X' = x, 'Du' = const(1)],
            [
              step(d(var(x), x, const(1)), fact("symbolic-derivative.pl", clause(6)), ['X' = x], [])
            ]
          )
        ]
      )
    ]
  )
).

