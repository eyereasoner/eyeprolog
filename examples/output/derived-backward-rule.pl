% Prolog result format 4
query(1, log_impliedBy(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = childOf(var(x), var(y)), 'X1' = parentOf(var(y), var(x))]).
query(2, childOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = bob, 'X1' = alice]).
query(3, hasParent(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = bob, 'X1' = alice]).
