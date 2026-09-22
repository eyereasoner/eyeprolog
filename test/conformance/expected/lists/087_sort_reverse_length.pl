% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = length_empty, 'X1' = 0]).
answer(1, ['X0' = length_nested, 'X1' = 3]).
answer(1, ['X0' = reverse_atoms, 'X1' = "cba"]).
answer(1, ['X0' = sort_numbers, 'X1' = [1, 2, 3]]).
answer(1, ['X0' = sort_mixed_terms, 'X1' = [1, 2, a, b, pair(a), "s"]]).
answer(1, ['X0' = reverse_empty, 'X1' = []]).
