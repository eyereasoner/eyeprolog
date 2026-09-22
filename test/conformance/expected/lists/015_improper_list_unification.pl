% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = list, 'X1' = [head | tail]]).
answer(1, ['X0' = head, 'X1' = head]).
answer(1, ['X0' = tail, 'X1' = tail]).
