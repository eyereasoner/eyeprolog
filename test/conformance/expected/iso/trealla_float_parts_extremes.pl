% Prolog result format 4
query(1, float_parts_1e30(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = 1.0e+30, 'X1' = 0.0]).
query(2, float_parts_neg1e30(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = -1.0e+30, 'X1' = 0.0]).
query(3, float_parts_1e300(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = 1.0e+300, 'X1' = 0.0]).
query(4, float_parts_zero(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = 0.0, 'X1' = 0.0]).
