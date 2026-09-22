% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = number_to_string, 'X1' = '42']).
answer(1, ['X0' = decimal_string_to_number, 'X1' = -12.75]).
answer(1, ['X0' = scientific_string_to_number, 'X1' = 1000.0]).
answer(1, ['X0' = atom_to_string, 'X1' = 'hello-world']).
answer(1, ['X0' = string_to_atom_needs_quotes, 'X1' = 'hello-world']).
answer(1, ['X0' = term_to_string, 'X1' = 'result([a, b], score(10))']).
answer(1, ['X0' = unbound_term_rejected, 'X1' = ok]).
