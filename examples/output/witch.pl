% Prolog result format 4
query(1, witch(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = girl]).
query(2, burns(_0), ['X0' = _0]).
result(2, complete, 2).
answer(2, ['X0' = duck]).
answer(2, ['X0' = girl]).
query(3, madeOfWood(_0), ['X0' = _0]).
result(3, complete, 2).
answer(3, ['X0' = duck]).
answer(3, ['X0' = girl]).
query(4, floats(_0), ['X0' = _0]).
result(4, complete, 1).
answer(4, ['X0' = girl]).
query(5, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = witchExample, 'X1' = true]).
