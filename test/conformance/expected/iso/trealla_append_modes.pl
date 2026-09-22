% Prolog result format 4
query(1, append_concat(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = "abcd"]).
query(2, append_split(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 5).
answer(2, ['X0' = [], 'X1' = "abcd"]).
answer(2, ['X0' = "a", 'X1' = "bcd"]).
answer(2, ['X0' = "ab", 'X1' = "cd"]).
answer(2, ['X0' = "abc", 'X1' = "d"]).
answer(2, ['X0' = "abcd", 'X1' = []]).
