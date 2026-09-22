totient_answer(phi_36, 12).
why(
  totient_answer(phi_36, 12),
  step(
    totient_answer(phi_36, 12),
    rule("totient-summatory.pl", clause(7)),
    ['Phi' = 12],
    [
      step(
        totient(36, 12),
        rule("totient-summatory.pl", clause(5)),
        ['N' = 36, 'Count' = 12],
        [
          step(>(36, 0), builtin(>, 2), [], []),
          step(countall(coprime_upto(36, _k), 12), library(countall, 2), [], [])
        ]
      )
    ]
  )
).

totient_answer(phi_97, 96).
why(
  totient_answer(phi_97, 96),
  step(
    totient_answer(phi_97, 96),
    rule("totient-summatory.pl", clause(8)),
    ['Phi' = 96],
    [
      step(
        totient(97, 96),
        rule("totient-summatory.pl", clause(5)),
        ['N' = 97, 'Count' = 96],
        [
          step(>(97, 0), builtin(>, 2), [], []),
          step(countall(coprime_upto(97, _k), 96), library(countall, 2), [], [])
        ]
      )
    ]
  )
).

totient_answer(coprime_count_84, 24).
why(
  totient_answer(coprime_count_84, 24),
  step(
    totient_answer(coprime_count_84, 24),
    rule("totient-summatory.pl", clause(9)),
    ['Count' = 24],
    [
      step(
        totient(84, 24),
        rule("totient-summatory.pl", clause(5)),
        ['N' = 84, 'Count' = 24],
        [
          step(>(84, 0), builtin(>, 2), [], []),
          step(countall(coprime_upto(84, _k), 24), library(countall, 2), [], [])
        ]
      )
    ]
  )
).

totient_answer(summatory_phi_30, 278).
why(
  totient_answer(summatory_phi_30, 278),
  step(
    totient_answer(summatory_phi_30, 278),
    rule("totient-summatory.pl", clause(10)),
    ['Sum' = 278],
    [
      step(
        summatory_totient(30, 278),
        rule("totient-summatory.pl", clause(6)),
        ['Limit' = 30, 'Sum' = 278],
        [
          step(sumall(Expression, (between(1, 30, N), totient(N, Expression)), 278), library(sumall, 3), [], [])
        ]
      )
    ]
  )
).

