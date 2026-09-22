% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 10).
answer(1, ['X0' = trim, 'X1' = 'Hello EyeProlog']).
answer(1, ['X0' = lower, 'X1' = 'hello eyeprolog']).
answer(1, ['X0' = upper, 'X1' = 'HELLO EYEPROLOG']).
answer(1, ['X0' = split, 'X1' = [red, green, blue]]).
answer(1, ['X0' = join, 'X1' = 'red:green:blue']).
answer(1, ['X0' = substring, 'X1' = cde]).
answer(1, ['X0' = replace, 'X1' = 'blue-green-blue']).
answer(1, ['X0' = number_to_string, 'X1' = '42']).
answer(1, ['X0' = string_to_number, 'X1' = 3.5]).
answer(1, ['X0' = atom_string, 'X1' = eyeprolog]).
