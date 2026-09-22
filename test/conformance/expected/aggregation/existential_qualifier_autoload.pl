% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = plain, 'X1' = "ab"]).
answer(1, ['X0' = qualified, 'X1' = "ab"]).
answer(1, ['X0' = qualified_bag, 'X1' = "bab"]).
answer(1, ['X0' = nested, 'X1' = [1, 2]]).
answer(1, ['X0' = witness_kept, 'X1' = [1 - a, 2 - b]]).
