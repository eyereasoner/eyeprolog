report(div_mod, quotient_remainder(-3, 2)).
why(
  report(div_mod, quotient_remainder(-3, 2)),
  proof(
    goal(report(div_mod, quotient_remainder(-3, 2))),
    by(rule("iso-integer-arithmetic.pl", clause(1))),
    bindings([binding("Q", -3), binding("R", 2)]),
    uses([
      proof(
        goal(is(-3, div(-7, 3))),
        by(builtin(is, 2))
      ),
      proof(
        goal(is(2, mod(-7, 3))),
        by(builtin(is, 2))
      )
    ])
  )
).

report(quotient_rem, quotient_remainder(-2, -1)).
why(
  report(quotient_rem, quotient_remainder(-2, -1)),
  proof(
    goal(report(quotient_rem, quotient_remainder(-2, -1))),
    by(rule("iso-integer-arithmetic.pl", clause(2))),
    bindings([binding("Q", -2), binding("R", -1)]),
    uses([
      proof(
        goal(is(-2, //(-7, 3))),
        by(builtin(is, 2))
      ),
      proof(
        goal(is(-1, rem(-7, 3))),
        by(builtin(is, 2))
      )
    ])
  )
).

report(bit_mask, 4).
why(
  report(bit_mask, 4),
  proof(
    goal(report(bit_mask, 4)),
    by(rule("iso-integer-arithmetic.pl", clause(3))),
    bindings([binding("Masked", 4)]),
    uses([
      proof(
        goal(is(4, /\(13, 6))),
        by(builtin(is, 2))
      )
    ])
  )
).

report(bit_union, 11).
why(
  report(bit_union, 11),
  proof(
    goal(report(bit_union, 11)),
    by(rule("iso-integer-arithmetic.pl", clause(4))),
    bindings([binding("Union", 11)]),
    uses([
      proof(
        goal(is(11, \/(8, 3))),
        by(builtin(is, 2))
      )
    ])
  )
).

report(left_shift, 12).
why(
  report(left_shift, 12),
  proof(
    goal(report(left_shift, 12)),
    by(rule("iso-integer-arithmetic.pl", clause(5))),
    bindings([binding("Shifted", 12)]),
    uses([
      proof(
        goal(is(12, <<(3, 2))),
        by(builtin(is, 2))
      )
    ])
  )
).

