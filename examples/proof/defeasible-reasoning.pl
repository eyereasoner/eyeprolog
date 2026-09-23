reimbursementQuestion(plain, taxi_receipt, true).
reimbursementQuestion(alcohol_excluded, client_dinner_wine, false).
reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true).
conflictQuestion(blanket_allowance, team_offsite_hotel, undefined).
conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined).
explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement).

clause(10, blanket_eligible(team_offsite_hotel), true).
clause(11, itemizable(team_offsite_hotel), true).
clause(14,
       policy_conflict(var('Expense'), blanket_allowance, itemized_reimbursement),
       (blanket_eligible(var('Expense')), itemizable(var('Expense')))).
clause(15,
       reimbursementQuestion(plain, taxi_receipt, var('Verdict')),
       wfs_truth(reimbursable(taxi_receipt), var('Verdict'))).
clause(16,
       reimbursementQuestion(alcohol_excluded, client_dinner_wine, var('Verdict')),
       wfs_truth(reimbursable(client_dinner_wine), var('Verdict'))).
clause(17,
       reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, var('Verdict')),
       wfs_truth(reimbursable(client_dinner_wine_preapproved), var('Verdict'))).
clause(18,
       conflictQuestion(blanket_allowance, team_offsite_hotel, var('Verdict')),
       wfs_truth(covered_by_blanket(team_offsite_hotel), var('Verdict'))).
clause(19,
       conflictQuestion(itemized_reimbursement, team_offsite_hotel, var('Verdict')),
       wfs_truth(itemized(team_offsite_hotel), var('Verdict'))).
clause(20,
       explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement),
       policy_conflict(team_offsite_hotel, blanket_allowance, itemized_reimbursement)).

step(reimbursementQuestion(plain, taxi_receipt, true),
     rule(15),
     ['Verdict' = true],
     [wfs_truth(reimbursable(taxi_receipt), true)]).
step(wfs_truth(reimbursable(taxi_receipt), true), builtin, [], []).
step(reimbursementQuestion(alcohol_excluded, client_dinner_wine, false),
     rule(16),
     ['Verdict' = false],
     [wfs_truth(reimbursable(client_dinner_wine), false)]).
step(wfs_truth(reimbursable(client_dinner_wine), false), builtin, [], []).
step(reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true),
     rule(17),
     ['Verdict' = true],
     [wfs_truth(reimbursable(client_dinner_wine_preapproved), true)]).
step(wfs_truth(reimbursable(client_dinner_wine_preapproved), true), builtin, [], []).
step(conflictQuestion(blanket_allowance, team_offsite_hotel, undefined),
     rule(18),
     ['Verdict' = undefined],
     [wfs_truth(covered_by_blanket(team_offsite_hotel), undefined)]).
step(wfs_truth(covered_by_blanket(team_offsite_hotel), undefined), builtin, [], []).
step(conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined),
     rule(19),
     ['Verdict' = undefined],
     [wfs_truth(itemized(team_offsite_hotel), undefined)]).
step(wfs_truth(itemized(team_offsite_hotel), undefined), builtin, [], []).
step(explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement),
     rule(20),
     [],
     [policy_conflict(team_offsite_hotel, blanket_allowance, itemized_reimbursement)]).
step(policy_conflict(team_offsite_hotel, blanket_allowance, itemized_reimbursement),
     rule(14),
     ['Expense' = team_offsite_hotel],
     [blanket_eligible(team_offsite_hotel), itemizable(team_offsite_hotel)]).
step(blanket_eligible(team_offsite_hotel), fact(10), [], []).
step(itemizable(team_offsite_hotel), fact(11), [], []).
