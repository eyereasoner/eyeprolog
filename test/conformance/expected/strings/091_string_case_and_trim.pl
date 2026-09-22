% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = lower_mixed, 'X1' = 'hello world 123!']).
answer(1, ['X0' = upper_mixed, 'X1' = 'HELLO WORLD 123!']).
answer(1, ['X0' = trim_spaces, 'X1' = padded]).
answer(1, ['X0' = trim_tabs_newline, 'X1' = value]).
answer(1, ['X0' = trim_empty, 'X1' = '']).
