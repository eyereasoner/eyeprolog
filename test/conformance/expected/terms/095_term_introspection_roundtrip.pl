% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = functor_compound, 'X1' = pair(edge, 2)]).
answer(1, ['X0' = arg_first, 'X1' = a]).
answer(1, ['X0' = arg_second, 'X1' = b]).
answer(1, ['X0' = decompose, 'X1' = pair(edge, "ab")]).
answer(1, ['X0' = recompose, 'X1' = edge(a, b)]).
answer(1, ['X0' = roundtrip, 'X1' = edge(a, b)]).
