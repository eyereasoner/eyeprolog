% Prolog result format 4
query(1, dynamic_body(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = sequence, 'X1' = "ab"]).
answer(1, ['X0' = choice, 'X1' = "a"]).
answer(1, ['X0' = choice, 'X1' = "b"]).
answer(1, ['X0' = embedded, 'X1' = [ok]]).
answer(1, ['X0' = conditional, 'X1' = [x, yes]]).
