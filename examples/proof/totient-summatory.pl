totient_answer(phi_36, 12).
why(
  totient_answer(phi_36, 12),
  proof(
    goal(totient_answer(phi_36, 12)),
    by(rule("totient-summatory.pl", clause(7))),
    bindings([binding("Phi", 12)]),
    uses([
      proof(
        goal(totient(36, 12)),
        by(rule("totient-summatory.pl", clause(5))),
        bindings([binding("N", 36), binding("Count", 12)]),
        uses([
          proof(
            goal(>(36, 0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(countall(coprime_upto(36, _k), 12)),
            by(library(countall, 2))
          )
        ])
      )
    ])
  )
).

totient_answer(phi_97, 96).
why(
  totient_answer(phi_97, 96),
  proof(
    goal(totient_answer(phi_97, 96)),
    by(rule("totient-summatory.pl", clause(8))),
    bindings([binding("Phi", 96)]),
    uses([
      proof(
        goal(totient(97, 96)),
        by(rule("totient-summatory.pl", clause(5))),
        bindings([binding("N", 97), binding("Count", 96)]),
        uses([
          proof(
            goal(>(97, 0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(countall(coprime_upto(97, _k), 96)),
            by(library(countall, 2))
          )
        ])
      )
    ])
  )
).

totient_answer(coprime_count_84, 24).
why(
  totient_answer(coprime_count_84, 24),
  proof(
    goal(totient_answer(coprime_count_84, 24)),
    by(rule("totient-summatory.pl", clause(9))),
    bindings([binding("Count", 24)]),
    uses([
      proof(
        goal(totient(84, 24)),
        by(rule("totient-summatory.pl", clause(5))),
        bindings([binding("N", 84), binding("Count", 24)]),
        uses([
          proof(
            goal(>(84, 0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(countall(coprime_upto(84, _k), 24)),
            by(library(countall, 2))
          )
        ])
      )
    ])
  )
).

totient_answer(summatory_phi_30, 278).
why(
  totient_answer(summatory_phi_30, 278),
  proof(
    goal(totient_answer(summatory_phi_30, 278)),
    by(rule("totient-summatory.pl", clause(10))),
    bindings([binding("Sum", 278)]),
    uses([
      proof(
        goal(summatory_totient(30, 278)),
        by(rule("totient-summatory.pl", clause(6))),
        bindings([binding("Limit", 30), binding("Sum", 278)]),
        uses([
          proof(
            goal(sumall(Expression, (between(1, 30, N), totient(N, Expression)), 278)),
            by(library(sumall, 3))
          )
        ])
      )
    ])
  )
).

