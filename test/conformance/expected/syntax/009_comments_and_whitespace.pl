% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = quoted_percent, 'X1' = "% not a comment"]).
answer(1, ['X0' = quoted_atom, 'X1' = 'has % sign']).
