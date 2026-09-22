% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = tail, 'X1' = "bc"]).
answer(1, ['X0' = select, 'X1' = selected(a, "b")]).
answer(1, ['X0' = select, 'X1' = selected(b, "a")]).
answer(1, ['X0' = absent, 'X1' = true]).
