xor_row(row(0, 0, 0)).
why(
  xor_row(row(0, 0, 0)),
  step(
    xor_row(row(0, 0, 0)),
    rule("clpb-boolean-circuit.pl", clause(2)),
    ['X' = 0, 'Y' = 0, 'Z' = 0],
    [
      step(
        xor_circuit(0, 0, 0),
        rule("clpb-boolean-circuit.pl", clause(1)),
        ['X' = 0, 'Y' = 0, 'Z' = 0],
        [
          step(sat('=:='(0, '+'(*(0, ~(0)), *(~(0), 0)))), library(sat, 1), [], [])
        ]
      ),
      step(labeling([0, 0, 0]), library(labeling, 1), [], [])
    ]
  )
).

xor_row(row(1, 1, 0)).
why(
  xor_row(row(1, 1, 0)),
  step(
    xor_row(row(1, 1, 0)),
    rule("clpb-boolean-circuit.pl", clause(2)),
    ['X' = 1, 'Y' = 1, 'Z' = 0],
    [
      step(
        xor_circuit(1, 1, 0),
        rule("clpb-boolean-circuit.pl", clause(1)),
        ['X' = 1, 'Y' = 1, 'Z' = 0],
        [
          step(sat('=:='(0, '+'(*(1, ~(1)), *(~(1), 1)))), library(sat, 1), [], [])
        ]
      ),
      step(labeling([1, 1, 0]), library(labeling, 1), [], [])
    ]
  )
).

xor_row(row(0, 1, 1)).
why(
  xor_row(row(0, 1, 1)),
  step(
    xor_row(row(0, 1, 1)),
    rule("clpb-boolean-circuit.pl", clause(2)),
    ['X' = 0, 'Y' = 1, 'Z' = 1],
    [
      step(
        xor_circuit(0, 1, 1),
        rule("clpb-boolean-circuit.pl", clause(1)),
        ['X' = 0, 'Y' = 1, 'Z' = 1],
        [
          step(sat('=:='(1, '+'(*(0, ~(1)), *(~(0), 1)))), library(sat, 1), [], [])
        ]
      ),
      step(labeling([0, 1, 1]), library(labeling, 1), [], [])
    ]
  )
).

xor_row(row(1, 0, 1)).
why(
  xor_row(row(1, 0, 1)),
  step(
    xor_row(row(1, 0, 1)),
    rule("clpb-boolean-circuit.pl", clause(2)),
    ['X' = 1, 'Y' = 0, 'Z' = 1],
    [
      step(
        xor_circuit(1, 0, 1),
        rule("clpb-boolean-circuit.pl", clause(1)),
        ['X' = 1, 'Y' = 0, 'Z' = 1],
        [
          step(sat('=:='(1, '+'(*(1, ~(0)), *(~(1), 0)))), library(sat, 1), [], [])
        ]
      ),
      step(labeling([1, 0, 1]), library(labeling, 1), [], [])
    ]
  )
).

xor_circuit_verified(1).
why(
  xor_circuit_verified(1),
  no_proof
).

