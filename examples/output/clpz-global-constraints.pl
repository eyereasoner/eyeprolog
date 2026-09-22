% Prolog result format 4
query(1, advanced_clpz(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = (table), 'X1' = compatible(4, 0, 2)]).
answer(1, ['X0' = (table), 'X1' = compatible(4, 3, 2)]).
answer(1, ['X0' = schedule, 'X1' = starts([0, 1, 3])]).
answer(1, ['X0' = cardinality, 'X1' = assignment([1, 1, 3], 13, >)]).
answer(1, ['X0' = cardinality, 'X1' = assignment([1, 3, 1], 12, >)]).
answer(1, ['X0' = cardinality, 'X1' = assignment([3, 1, 1], 6, <)]).
answer(1, ['X0' = circuit, 'X1' = successors([2, 3, 4, 1])]).
