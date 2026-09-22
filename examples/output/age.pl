% Prolog result format 4
query(1, birthDay(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, duration(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 0).
query(3, ageAbove(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = patH, 'X1' = 'P80Y']).
query(4, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = test, 'X1' = true]).
