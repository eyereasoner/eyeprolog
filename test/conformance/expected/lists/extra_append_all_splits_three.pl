% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = append_split, 'X1' = pair([], "abc")]).
answer(1, ['X0' = append_split, 'X1' = pair("a", "bc")]).
answer(1, ['X0' = append_split, 'X1' = pair("ab", "c")]).
answer(1, ['X0' = append_split, 'X1' = pair("abc", [])]).
