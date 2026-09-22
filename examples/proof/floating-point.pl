value(sum, 3.75).
why(
  value(sum, 3.75),
  step(
    value(sum, 3.75),
    rule("floating-point.pl", clause(3)),
    ['X' = 3.75],
    [
      step(is(3.75, '+'(1.5, 2.25)), builtin(is, 2), [], [])
    ]
  )
).

value(difference, 6.875).
why(
  value(difference, 6.875),
  step(
    value(difference, 6.875),
    rule("floating-point.pl", clause(4)),
    ['X' = 6.875],
    [
      step(is(6.875, '-'(10.0, 3.125)), builtin(is, 2), [], [])
    ]
  )
).

value(product, 10.0).
why(
  value(product, 10.0),
  step(
    value(product, 10.0),
    rule("floating-point.pl", clause(5)),
    ['X' = 10.0],
    [
      step(is(10.0, *(2.5, 4.0)), builtin(is, 2), [], [])
    ]
  )
).

value(quotient, 3.75).
why(
  value(quotient, 3.75),
  step(
    value(quotient, 3.75),
    rule("floating-point.pl", clause(6)),
    ['X' = 3.75],
    [
      step(is(3.75, /(7.5, 2)), builtin(is, 2), [], [])
    ]
  )
).

value(sqrtByPower, 3.0).
why(
  value(sqrtByPower, 3.0),
  step(
    value(sqrtByPower, 3.0),
    rule("floating-point.pl", clause(7)),
    ['X' = 3.0],
    [
      step(is(3.0, **(9.0, 0.5)), builtin(is, 2), [], [])
    ]
  )
).

value(mathSum, 1.0).
why(
  value(mathSum, 1.0),
  step(
    value(mathSum, 1.0),
    rule("floating-point.pl", clause(8)),
    ['X' = 1.0],
    [
      step(is(1.0, '+'(0.125, 0.875)), builtin(is, 2), [], [])
    ]
  )
).

value(mathProduct, 3.0).
why(
  value(mathProduct, 3.0),
  step(
    value(mathProduct, 3.0),
    rule("floating-point.pl", clause(9)),
    ['X' = 3.0],
    [
      step(is(3.0, *(6.0, 0.5)), builtin(is, 2), [], [])
    ]
  )
).

value(comfortable, true).
why(
  value(comfortable, true),
  step(
    value(comfortable, true),
    rule("floating-point.pl", clause(11)),
    ['R' = 21.5],
    [
      step(sample(roomC, 21.5), fact("floating-point.pl", clause(1)), [], []),
      step(>=(21.5, 21.0), builtin(>=, 2), [], []),
      step(=<(21.5, 22.0), builtin(=<, 2), [], [])
    ]
  )
).

than(warmer, targetC).
why(
  than(warmer, targetC),
  step(
    than(warmer, targetC),
    rule("floating-point.pl", clause(10)),
    ['R' = 21.5, 'T' = 19.25],
    [
      step(sample(roomC, 21.5), fact("floating-point.pl", clause(1)), [], []),
      step(sample(targetC, 19.25), fact("floating-point.pl", clause(2)), [], []),
      step(>(21.5, 19.25), builtin(>, 2), [], [])
    ]
  )
).

