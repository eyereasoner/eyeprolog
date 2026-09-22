% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = filter1, 'X1' = first_order_low_pass]).
query(2, timeConstant_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = filter1, 'X1' = 0.01]).
query(3, cutoffFrequency_Hz(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = filter1, 'X1' = 15.915494309189533]).
