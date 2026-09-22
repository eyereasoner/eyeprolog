% Prolog result format 4
query(1, reimbursementQuestion(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 3).
answer(1, ['X0' = plain, 'X1' = taxi_receipt, 'X2' = true]).
why(1,
    ['X0' = plain, 'X1' = taxi_receipt, 'X2' = true],
    [reimbursementQuestion(plain, taxi_receipt, true)]).
answer(1, ['X0' = alcohol_excluded, 'X1' = client_dinner_wine, 'X2' = false]).
why(1,
    ['X0' = alcohol_excluded, 'X1' = client_dinner_wine, 'X2' = false],
    [reimbursementQuestion(alcohol_excluded, client_dinner_wine, false)]).
answer(1, ['X0' = alcohol_preapproved, 'X1' = client_dinner_wine_preapproved, 'X2' = true]).
why(1,
    ['X0' = alcohol_preapproved, 'X1' = client_dinner_wine_preapproved, 'X2' = true],
    [reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true)]).
query(2, conflictQuestion(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 2).
answer(2, ['X0' = blanket_allowance, 'X1' = team_offsite_hotel, 'X2' = undefined]).
why(2,
    ['X0' = blanket_allowance, 'X1' = team_offsite_hotel, 'X2' = undefined],
    [conflictQuestion(blanket_allowance, team_offsite_hotel, undefined)]).
answer(2, ['X0' = itemized_reimbursement, 'X1' = team_offsite_hotel, 'X2' = undefined]).
why(2,
    ['X0' = itemized_reimbursement, 'X1' = team_offsite_hotel, 'X2' = undefined],
    [conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined)]).
query(3, explicitConflictQuestion(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(3, complete, 1).
answer(3, ['X0' = team_offsite_hotel, 'X1' = blanket_allowance, 'X2' = itemized_reimbursement]).
why(3,
    ['X0' = team_offsite_hotel, 'X1' = blanket_allowance, 'X2' = itemized_reimbursement],
    [explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement)]).

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
