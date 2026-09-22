% Prolog result format 4
query(1, grouped(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = two, 'X1' = [2, 3]]).
answer(1, ['X0' = one, 'X1' = [1, 1, 2]]).
query(2, grouped_set(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = two, 'X1' = [2, 3]]).
answer(2, ['X0' = one, 'X1' = [1, 2]]).
query(3, existential(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = [2, 1, 1, 3, 2], 'X1' = [1, 2, 3]]).
query(4, no_solutions, []).
result(4, complete, 1).
answer(4, []).
query(5, retrieved(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 2).
answer(5, ['X0' = bob, 'X1' = true]).
answer(5, ['X0' = carol, 'X1' = true]).
query(6, shared_clause(_0), ['X0' = _0]).
result(6, complete, 1).
answer(6, ['X0' = pair(ok, ok)]).
query(7, shared_set_variables(_0), ['X0' = _0]).
result(7, complete, 1).
answer(7, ['X0' = ok]).
