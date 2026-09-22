% Prolog result format 4
query(1, input(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = case1, 'X1' = [1, 0, 1, 0, 0, 1]]).
answer(1, ['X0' = case2, 'X1' = [1, 0, 1, 1, 1, 1]]).
answer(1, ['X0' = case3, 'X1' = [1, 1, 1, 1, 1, 1]]).
answer(1, ['X0' = case4, 'X1' = []]).
query(2, output(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = case1, 'X1' = [1, 0, 1, 0, 1, 0, #]]).
answer(2, ['X0' = case2, 'X1' = [1, 1, 0, 0, 0, 0, #]]).
answer(2, ['X0' = case3, 'X1' = [1, 0, 0, 0, 0, 0, 0, #]]).
answer(2, ['X0' = case4, 'X1' = [1, #]]).
query(3, addsOne(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = case1, 'X1' = true]).
answer(3, ['X0' = case2, 'X1' = true]).
answer(3, ['X0' = case3, 'X1' = true]).
answer(3, ['X0' = case4, 'X1' = true]).
