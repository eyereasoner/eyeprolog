report(div_mod, quotient_remainder(-3, 2)).
why(
  report(div_mod, quotient_remainder(-3, 2)),
  step(
    report(div_mod, quotient_remainder(-3, 2)),
    rule("iso-integer-arithmetic.pl", clause(1)),
    ['Q' = -3, 'R' = 2],
    [
      step(is(-3, div(-7, 3)), builtin(is, 2), [], []),
      step(is(2, mod(-7, 3)), builtin(is, 2), [], [])
    ]
  )
).

report(quotient_rem, quotient_remainder(-2, -1)).
why(
  report(quotient_rem, quotient_remainder(-2, -1)),
  step(
    report(quotient_rem, quotient_remainder(-2, -1)),
    rule("iso-integer-arithmetic.pl", clause(2)),
    ['Q' = -2, 'R' = -1],
    [
      step(is(-2, //(-7, 3)), builtin(is, 2), [], []),
      step(is(-1, rem(-7, 3)), builtin(is, 2), [], [])
    ]
  )
).

report(bit_mask, 4).
why(
  report(bit_mask, 4),
  step(
    report(bit_mask, 4),
    rule("iso-integer-arithmetic.pl", clause(3)),
    ['Masked' = 4],
    [
      step(is(4, /\(13, 6)), builtin(is, 2), [], [])
    ]
  )
).

report(bit_union, 11).
why(
  report(bit_union, 11),
  step(
    report(bit_union, 11),
    rule("iso-integer-arithmetic.pl", clause(4)),
    ['Union' = 11],
    [
      step(is(11, \/(8, 3)), builtin(is, 2), [], [])
    ]
  )
).

report(left_shift, 12).
why(
  report(left_shift, 12),
  step(
    report(left_shift, 12),
    rule("iso-integer-arithmetic.pl", clause(5)),
    ['Shifted' = 12],
    [
      step(is(12, <<(3, 2)), builtin(is, 2), [], [])
    ]
  )
).

