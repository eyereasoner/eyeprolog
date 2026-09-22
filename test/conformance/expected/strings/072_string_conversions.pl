% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 8).
answer(1, ['X0' = number_to_string, 'X1' = '-7']).
answer(1, ['X0' = string_to_integer, 'X1' = 123]).
answer(1, ['X0' = string_to_decimal, 'X1' = -3.5]).
answer(1, ['X0' = non_numeric_rejected, 'X1' = ok]).
answer(1, ['X0' = atom_to_string, 'X1' = hello_world]).
answer(1, ['X0' = string_to_atom, 'X1' = hello_world]).
answer(1, ['X0' = number_to_atom, 'X1' = '123']).
answer(1, ['X0' = trim_to_empty, 'X1' = '']).
