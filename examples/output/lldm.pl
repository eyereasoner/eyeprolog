% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = meas47, 'X1' = lld_alarm]).
query(2, lld_left_length_cm(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = meas47, 'X1' = 21.548900464617255]).
query(3, lld_right_length_cm(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = meas47, 'X1' = 23.45713444515475]).
query(4, lld_discrepancy_cm(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = meas47, 'X1' = -1.9082339805374957]).
query(5, lld_threshold_cm(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = meas47, 'X1' = 1.25]).
query(6, lld_reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = meas47, 'X1' = "discrepancy below negative threshold"]).
