% Prolog result format 4
query(1, holdsFor(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = diamondProperty, 'X1' = r]).
answer(1, ['X0' = diamondProperty, 'X1' = re]).
query(2, commonSuccessor(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = diamondProperty, 'X1' = d]).
query(3, preservedUnderReflexiveClosure(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = diamondProperty, 'X1' = true]).
