xor_row(row(0, 0, 0)).
why(
  xor_row(row(0, 0, 0)),
  proof(
    goal(xor_row(row(0, 0, 0))),
    by(rule("clpb-boolean-circuit.pl", clause(2))),
    bindings([binding("X", 0), binding("Y", 0), binding("Z", 0)]),
    uses([
      proof(
        goal(xor_circuit(0, 0, 0)),
        by(rule("clpb-boolean-circuit.pl", clause(1))),
        bindings([binding("X", 0), binding("Y", 0), binding("Z", 0)]),
        uses([
          proof(
            goal(sat('=:='(0, '+'(*(0, ~(0)), *(~(0), 0))))),
            by(library(sat, 1))
          )
        ])
      ),
      proof(
        goal(labeling([0, 0, 0])),
        by(library(labeling, 1))
      )
    ])
  )
).

xor_row(row(1, 1, 0)).
why(
  xor_row(row(1, 1, 0)),
  proof(
    goal(xor_row(row(1, 1, 0))),
    by(rule("clpb-boolean-circuit.pl", clause(2))),
    bindings([binding("X", 1), binding("Y", 1), binding("Z", 0)]),
    uses([
      proof(
        goal(xor_circuit(1, 1, 0)),
        by(rule("clpb-boolean-circuit.pl", clause(1))),
        bindings([binding("X", 1), binding("Y", 1), binding("Z", 0)]),
        uses([
          proof(
            goal(sat('=:='(0, '+'(*(1, ~(1)), *(~(1), 1))))),
            by(library(sat, 1))
          )
        ])
      ),
      proof(
        goal(labeling([1, 1, 0])),
        by(library(labeling, 1))
      )
    ])
  )
).

xor_row(row(0, 1, 1)).
why(
  xor_row(row(0, 1, 1)),
  proof(
    goal(xor_row(row(0, 1, 1))),
    by(rule("clpb-boolean-circuit.pl", clause(2))),
    bindings([binding("X", 0), binding("Y", 1), binding("Z", 1)]),
    uses([
      proof(
        goal(xor_circuit(0, 1, 1)),
        by(rule("clpb-boolean-circuit.pl", clause(1))),
        bindings([binding("X", 0), binding("Y", 1), binding("Z", 1)]),
        uses([
          proof(
            goal(sat('=:='(1, '+'(*(0, ~(1)), *(~(0), 1))))),
            by(library(sat, 1))
          )
        ])
      ),
      proof(
        goal(labeling([0, 1, 1])),
        by(library(labeling, 1))
      )
    ])
  )
).

xor_row(row(1, 0, 1)).
why(
  xor_row(row(1, 0, 1)),
  proof(
    goal(xor_row(row(1, 0, 1))),
    by(rule("clpb-boolean-circuit.pl", clause(2))),
    bindings([binding("X", 1), binding("Y", 0), binding("Z", 1)]),
    uses([
      proof(
        goal(xor_circuit(1, 0, 1)),
        by(rule("clpb-boolean-circuit.pl", clause(1))),
        bindings([binding("X", 1), binding("Y", 0), binding("Z", 1)]),
        uses([
          proof(
            goal(sat('=:='(1, '+'(*(1, ~(0)), *(~(1), 0))))),
            by(library(sat, 1))
          )
        ])
      ),
      proof(
        goal(labeling([1, 0, 1])),
        by(library(labeling, 1))
      )
    ])
  )
).

xor_circuit_verified(1).
why(
  xor_circuit_verified(1),
  no_proof
).

