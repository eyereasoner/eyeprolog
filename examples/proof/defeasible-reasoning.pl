reimbursementQuestion(plain, taxi_receipt, true).
why(
  reimbursementQuestion(plain, taxi_receipt, true),
  step(
    reimbursementQuestion(plain, taxi_receipt, true),
    rule("defeasible-reasoning.pl", clause(15)),
    ['Verdict' = true],
    [
      step(wfs_truth(reimbursable(taxi_receipt), true), builtin(wfs_truth, 2), [], [])
    ]
  )
).

reimbursementQuestion(alcohol_excluded, client_dinner_wine, false).
why(
  reimbursementQuestion(alcohol_excluded, client_dinner_wine, false),
  step(
    reimbursementQuestion(alcohol_excluded, client_dinner_wine, false),
    rule("defeasible-reasoning.pl", clause(16)),
    ['Verdict' = false],
    [
      step(wfs_truth(reimbursable(client_dinner_wine), false), builtin(wfs_truth, 2), [], [])
    ]
  )
).

reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true).
why(
  reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true),
  step(
    reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true),
    rule("defeasible-reasoning.pl", clause(17)),
    ['Verdict' = true],
    [
      step(wfs_truth(reimbursable(client_dinner_wine_preapproved), true), builtin(wfs_truth, 2), [], [])
    ]
  )
).

conflictQuestion(blanket_allowance, team_offsite_hotel, undefined).
why(
  conflictQuestion(blanket_allowance, team_offsite_hotel, undefined),
  step(
    conflictQuestion(blanket_allowance, team_offsite_hotel, undefined),
    rule("defeasible-reasoning.pl", clause(18)),
    ['Verdict' = undefined],
    [
      step(wfs_truth(covered_by_blanket(team_offsite_hotel), undefined), builtin(wfs_truth, 2), [], [])
    ]
  )
).

conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined).
why(
  conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined),
  step(
    conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined),
    rule("defeasible-reasoning.pl", clause(19)),
    ['Verdict' = undefined],
    [
      step(wfs_truth(itemized(team_offsite_hotel), undefined), builtin(wfs_truth, 2), [], [])
    ]
  )
).

explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement).
why(
  explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement),
  step(
    explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement),
    rule("defeasible-reasoning.pl", clause(20)),
    [],
    [
      step(
        policy_conflict(team_offsite_hotel, blanket_allowance, itemized_reimbursement),
        rule("defeasible-reasoning.pl", clause(14)),
        ['Expense' = team_offsite_hotel],
        [
          step(blanket_eligible(team_offsite_hotel), fact("defeasible-reasoning.pl", clause(10)), [], []),
          step(itemizable(team_offsite_hotel), fact("defeasible-reasoning.pl", clause(11)), [], [])
        ]
      )
    ]
  )
).

