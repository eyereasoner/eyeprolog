% Prolog result format 4
query(1, pow(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = [2, 10], 'X1' = 1024.0]).
query(2, powSlow(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = [2, 10], 'X1' = 1024.0]).
query(3, powMod1e6(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 2).
answer(3, ['X0' = [2, 10000], 'X1' = 709376]).
answer(3, ['X0' = [3, 10000], 'X1' = 200001]).
query(4, tower(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = [2, 4], 'X1' = 65536]).
query(5, towerMod1e6(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = [2, 5], 'X1' = 156736]).
