% Prolog result format 4
query(1, reimbursementQuestion(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 3).
answer(1, ['X0' = plain, 'X1' = taxi_receipt, 'X2' = true]).
answer(1, ['X0' = alcohol_excluded, 'X1' = client_dinner_wine, 'X2' = false]).
answer(1, ['X0' = alcohol_preapproved, 'X1' = client_dinner_wine_preapproved, 'X2' = true]).
query(2, conflictQuestion(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 2).
answer(2, ['X0' = blanket_allowance, 'X1' = team_offsite_hotel, 'X2' = undefined]).
answer(2, ['X0' = itemized_reimbursement, 'X1' = team_offsite_hotel, 'X2' = undefined]).
query(3, explicitConflictQuestion(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(3, complete, 1).
answer(3, ['X0' = team_offsite_hotel, 'X1' = blanket_allowance, 'X2' = itemized_reimbursement]).
