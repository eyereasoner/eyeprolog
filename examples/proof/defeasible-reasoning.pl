reimbursementQuestion(plain, taxi_receipt, true).
why(
  reimbursementQuestion(plain, taxi_receipt, true),
  proof(
    goal(reimbursementQuestion(plain, taxi_receipt, true)),
    by(rule("defeasible-reasoning.pl", clause(15))),
    bindings([binding("Verdict", true)]),
    uses([
      proof(
        goal(wfs_truth(reimbursable(taxi_receipt), true)),
        by(builtin(wfs_truth, 2))
      )
    ])
  )
).

reimbursementQuestion(alcohol_excluded, client_dinner_wine, false).
why(
  reimbursementQuestion(alcohol_excluded, client_dinner_wine, false),
  proof(
    goal(reimbursementQuestion(alcohol_excluded, client_dinner_wine, false)),
    by(rule("defeasible-reasoning.pl", clause(16))),
    bindings([binding("Verdict", false)]),
    uses([
      proof(
        goal(wfs_truth(reimbursable(client_dinner_wine), false)),
        by(builtin(wfs_truth, 2))
      )
    ])
  )
).

reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true).
why(
  reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true),
  proof(
    goal(reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true)),
    by(rule("defeasible-reasoning.pl", clause(17))),
    bindings([binding("Verdict", true)]),
    uses([
      proof(
        goal(wfs_truth(reimbursable(client_dinner_wine_preapproved), true)),
        by(builtin(wfs_truth, 2))
      )
    ])
  )
).

conflictQuestion(blanket_allowance, team_offsite_hotel, undefined).
why(
  conflictQuestion(blanket_allowance, team_offsite_hotel, undefined),
  proof(
    goal(conflictQuestion(blanket_allowance, team_offsite_hotel, undefined)),
    by(rule("defeasible-reasoning.pl", clause(18))),
    bindings([binding("Verdict", undefined)]),
    uses([
      proof(
        goal(wfs_truth(covered_by_blanket(team_offsite_hotel), undefined)),
        by(builtin(wfs_truth, 2))
      )
    ])
  )
).

conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined).
why(
  conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined),
  proof(
    goal(conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined)),
    by(rule("defeasible-reasoning.pl", clause(19))),
    bindings([binding("Verdict", undefined)]),
    uses([
      proof(
        goal(wfs_truth(itemized(team_offsite_hotel), undefined)),
        by(builtin(wfs_truth, 2))
      )
    ])
  )
).

explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement).
why(
  explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement),
  proof(
    goal(explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement)),
    by(rule("defeasible-reasoning.pl", clause(20))),
    uses([
      proof(
        goal(policy_conflict(team_offsite_hotel, blanket_allowance, itemized_reimbursement)),
        by(rule("defeasible-reasoning.pl", clause(14))),
        bindings([binding("Expense", team_offsite_hotel)]),
        uses([
          proof(
            goal(blanket_eligible(team_offsite_hotel)),
            by(fact("defeasible-reasoning.pl", clause(10)))
          ),
          proof(
            goal(itemizable(team_offsite_hotel)),
            by(fact("defeasible-reasoning.pl", clause(11)))
          )
        ])
      )
    ])
  )
).

