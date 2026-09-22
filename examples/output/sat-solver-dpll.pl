% Prolog result format 4
query(1, satModel(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]]).
query(2, satValue(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = d, 'X1' = true]).
answer(2, ['X0' = c, 'X1' = true]).
answer(2, ['X0' = b, 'X1' = true]).
answer(2, ['X0' = a, 'X1' = false]).
query(3, satClauseStatus(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 5).
answer(3, ['X0' = c1, 'X1' = satisfied]).
answer(3, ['X0' = c2, 'X1' = satisfied]).
answer(3, ['X0' = c3, 'X1' = satisfied]).
answer(3, ['X0' = c4, 'X1' = satisfied]).
answer(3, ['X0' = c5, 'X1' = satisfied]).
query(4, satConclusion(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4,
       ['X0' = case,
        'X1' = "DPLL finds a satisfying assignment after pruning clauses that become impossible"]).
