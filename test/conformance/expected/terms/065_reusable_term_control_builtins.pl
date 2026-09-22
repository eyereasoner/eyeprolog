% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = functor, 'X1' = pair(edge, 2)]).
answer(1, ['X0' = arg, 'X1' = b]).
answer(1, ['X0' = decompose, 'X1' = pair(edge, "ab")]).
answer(1, ['X0' = compose, 'X1' = edge(a, b)]).
answer(1, ['X0' = term_string, 'X1' = 'edge(a, [b, c])']).
answer(1, ['X0' = forall, 'X1' = ok]).
