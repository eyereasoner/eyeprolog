% Prolog result format 4
query(1, period_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = pendulum1, 'X1' = 2.0]).
query(2, periodError_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = pendulum1, 'X1' = 0.0]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = pendulum1, 'X1' = within_period_tolerance]).
query(4, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = pendulum1, 'X1' = "small-angle period matches the two-second target"]).
