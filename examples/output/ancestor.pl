% Prolog result format 4
query(1, parent(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, ancestor(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 6).
answer(2, ['X0' = pat, 'X1' = jan]).
answer(2, ['X0' = jan, 'X1' = lies]).
answer(2, ['X0' = lies, 'X1' = emma]).
answer(2, ['X0' = pat, 'X1' = lies]).
answer(2, ['X0' = pat, 'X1' = emma]).
answer(2, ['X0' = jan, 'X1' = emma]).
