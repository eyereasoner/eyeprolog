% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 9).
answer(1, ['X0' = append_split, 'X1' = pair([], "ab")]).
answer(1, ['X0' = append_split, 'X1' = pair("a", "b")]).
answer(1, ['X0' = append_split, 'X1' = pair("ab", [])]).
answer(1, ['X0' = nth, 'X1' = pair(0, x)]).
answer(1, ['X0' = nth, 'X1' = pair(1, y)]).
answer(1, ['X0' = select, 'X1' = pair(a, "ba")]).
answer(1, ['X0' = select, 'X1' = pair(b, "aa")]).
answer(1, ['X0' = select, 'X1' = pair(a, "ab")]).
answer(1, ['X0' = absent_atom, 'X1' = ok]).
