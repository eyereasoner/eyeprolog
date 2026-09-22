% Prolog result format 4
query(1, decodesAs(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = message(1), 'X1' = 1]).
answer(1, ['X0' = message(3), 'X1' = 3]).
answer(1, ['X0' = message(0), 'X1' = 0]).
answer(1, ['X0' = message(2), 'X1' = 2]).
query(2, preservesMessage(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = protocol, 'X1' = true]).
query(3, cancelsCrossTalk(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = protocol, 'X1' = true]).
