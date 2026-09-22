% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 9).
answer(1, ['X0' = functor_atom, 'X1' = pair(alpha, 0)]).
answer(1, ['X0' = functor_number, 'X1' = pair(42, 0)]).
answer(1, ['X0' = functor_char_list, 'X1' = pair('.', 2)]).
answer(1, ['X0' = arg_nested, 'X1' = edge(a, b)]).
answer(1, ['X0' = compose_nested, 'X1' = outer(inner(a), "bc")]).
answer(1, ['X0' = compose_atom_empty_args, 'X1' = z]).
answer(1, ['X0' = decompose_atom_empty_args, 'X1' = pair(z, [])]).
answer(1, ['X0' = arg_zero_rejected, 'X1' = ok]).
answer(1, ['X0' = arg_too_large_rejected, 'X1' = ok]).
