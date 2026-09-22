% Prolog result format 4
query(1, dcg_example(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = parsed, 'X1' = set(light(kitchen), on)]).
answer(1, ['X0' = generated, 'X1' = [set, hall, light, to, off]]).
answer(1, ['X0' = remainder, 'X1' = [then, wait]]).
answer(1, ['X0' = rejected, 'X1' = invalid_command]).
