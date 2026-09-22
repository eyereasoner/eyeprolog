% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 10).
answer(1, ['X0' = split, 'X1' = pair([], "xyz")]).
answer(1, ['X0' = split, 'X1' = pair("x", "yz")]).
answer(1, ['X0' = split, 'X1' = pair("xy", "z")]).
answer(1, ['X0' = split, 'X1' = pair("xyz", [])]).
answer(1, ['X0' = select_middle, 'X1' = "xz"]).
answer(1, ['X0' = select_duplicate, 'X1' = pair(a, "ba")]).
answer(1, ['X0' = select_duplicate, 'X1' = pair(b, "aa")]).
answer(1, ['X0' = select_duplicate, 'X1' = pair(a, "ab")]).
answer(1, ['X0' = rebuild, 'X1' = "abcd"]).
answer(1, ['X0' = no_select_rejected, 'X1' = ok]).
