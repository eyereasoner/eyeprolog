refutes(proof1, raining).
why(
  refutes(proof1, raining),
  step(
    refutes(proof1, raining),
    rule("proof-contrapositive.pl", clause(4)),
    [],
    [
      step(
        false(raining),
        rule("proof-contrapositive.pl", clause(3)),
        ['A' = raining, 'B' = wet_ground],
        [
          step(implies(raining, wet_ground), fact("proof-contrapositive.pl", clause(1)), [], []),
          step(false(wet_ground), fact("proof-contrapositive.pl", clause(2)), [], [])
        ]
      )
    ]
  )
).

method(proof1, contrapositive).
why(
  method(proof1, contrapositive),
  step(
    method(proof1, contrapositive),
    rule("proof-contrapositive.pl", clause(5)),
    [],
    [
      step(
        false(raining),
        rule("proof-contrapositive.pl", clause(3)),
        ['A' = raining, 'B' = wet_ground],
        [
          step(implies(raining, wet_ground), fact("proof-contrapositive.pl", clause(1)), [], []),
          step(false(wet_ground), fact("proof-contrapositive.pl", clause(2)), [], [])
        ]
      )
    ]
  )
).

reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining").
why(
  reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining"),
  step(
    reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining"),
    rule("proof-contrapositive.pl", clause(6)),
    [],
    [
      step(
        false(raining),
        rule("proof-contrapositive.pl", clause(3)),
        ['A' = raining, 'B' = wet_ground],
        [
          step(implies(raining, wet_ground), fact("proof-contrapositive.pl", clause(1)), [], []),
          step(false(wet_ground), fact("proof-contrapositive.pl", clause(2)), [], [])
        ]
      )
    ]
  )
).

