% Prolog result format 4
query(1, cut_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = committed, 'X1' = "a"]).
answer(1, ['X0' = fallback_before_cut, 'X1' = "b"]).
answer(1, ['X0' = failure_after_cut, 'X1' = preserved]).
answer(1, ['X0' = nested, 'X1' = [start, a]]).
