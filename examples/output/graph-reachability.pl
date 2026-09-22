% Prolog result format 4
query(1, reachable(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = reachability_case, 'X1' = path(a, f)]).
answer(1, ['X0' = reachability_case, 'X1' = path(c, g)]).
query(2, not_reachable(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = reachability_case, 'X1' = path(b, e)]).
