% Prolog result format 4
query(1, answer(_0), ['X0' = _0]).
result(1, complete, 2).
answer(1, ['X0' = a]).
answer(1, ['X0' = b]).
query(2, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = a, 'X1' = doubled]).
answer(2, ['X0' = b, 'X1' = doubled]).
