% Prolog result format 4
query(1, metric(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 2).
answer(1, ['X0' = bp1, 'X1' = thermal_margin_c, 'X2' = -18.0]).
answer(1, ['X0' = bp1, 'X1' = resistive_heating_w, 'X2' = 16.0]).
query(2, diagnosis(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = bp1, 'X1' = thermal_runaway_precursor]).
query(3, action(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = bp1, 'X1' = isolate_and_cool]).
