% Prolog result format 4
query(1, value(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 13).
answer(1, ['X0' = atom, 'X1' = pat]).
answer(1, ['X0' = quoted_atom, 'X1' = 'atom with spaces']).
answer(1, ['X0' = quoted_quote, 'X1' = 'needs''quote']).
answer(1, ['X0' = empty_atom, 'X1' = '']).
answer(1, ['X0' = char_list, 'X1' = "line\nquote: \"ok\""]).
answer(1, ['X0' = integer, 'X1' = -42]).
answer(1, ['X0' = decimal, 'X1' = 0.25]).
answer(1, ['X0' = scientific, 'X1' = 1.25e-3]).
answer(1, ['X0' = compound, 'X1' = pair(3, nested(atom, "xy"))]).
answer(1, ['X0' = arity_zero_atom, 'X1' = nil]).
answer(1, ['X0' = empty_list, 'X1' = []]).
answer(1, ['X0' = proper_list, 'X1' = "abc"]).
answer(1, ['X0' = improper_list, 'X1' = "ab"||tail]).
