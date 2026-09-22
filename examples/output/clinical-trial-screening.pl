% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = p001, 'X1' = trial_candidate]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = p001, 'X1' = eligible]).
answer(2, ['X0' = p002, 'X1' = screen_fail]).
answer(2, ['X0' = p003, 'X1' = screen_fail]).
answer(2, ['X0' = p004, 'X1' = screen_fail]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = p001, 'X1' = "meets inclusion criteria and no listed exclusion"]).
answer(3, ['X0' = p002, 'X1' = "eGFR below renal safety threshold"]).
answer(3, ['X0' = p003, 'X1' = "pregnancy exclusion applies"]).
answer(3, ['X0' = p004, 'X1' = "HbA1c is outside protocol range"]).
