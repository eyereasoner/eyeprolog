% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = matches, 'X1' = true]).
answer(1, ['X0' = not_matches, 'X1' = true]).
answer(1, ['X0' = lex_lt, 'X1' = true]).
answer(1, ['X0' = lex_gt, 'X1' = true]).
answer(1, ['X0' = numeric_le, 'X1' = true]).
