% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = split, 'X1' = split([], "ab")]).
answer(1, ['X0' = split, 'X1' = split("a", "b")]).
answer(1, ['X0' = split, 'X1' = split("ab", [])]).
