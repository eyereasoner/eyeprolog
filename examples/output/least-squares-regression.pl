% Prolog result format 4
query(1, slope(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = regression1, 'X1' = 0.8]).
query(2, intercept(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = regression1, 'X1' = 1.5]).
query(3, rSquared(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = regression1, 'X1' = 0.64]).
query(4, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = regression1, 'X1' = accepted_linear_fit]).
query(5, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5,
       ['X0' = regression1, 'X1' = "R squared meets the minimum explanatory-power threshold"]).
