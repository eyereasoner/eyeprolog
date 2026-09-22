% Prolog result format 4
query(1, types(_0, _1, _2, _3), ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(1, complete, 1).
answer(1, ['X0' = was_variable, 'X1' = 7, 'X2' = 2.5, 'X3' = pair(a, 1)]).
query(2, ordering(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 1).
answer(2, ['X0' = (<), 'X1' = (=), 'X2' = (>)]).
query(3, functors(_0, _1, _2, _3), ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(3, complete, 1).
answer(3, ['X0' = node(left, right), 'X1' = node, 'X2' = 2, 'X3' = right]).
query(4, copied(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = pair(source, source), 'X1' = pair(copy, copy)]).
