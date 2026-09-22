% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = atom, 'X1' = pair(alpha, 0)]).
answer(1, ['X0' = quoted_atom, 'X1' = pair('hello-world', 0)]).
answer(1, ['X0' = char_list, 'X1' = pair('.', 2)]).
answer(1, ['X0' = number, 'X1' = pair(123, 0)]).
answer(1, ['X0' = list_functor, 'X1' = pair('.', 2)]).
