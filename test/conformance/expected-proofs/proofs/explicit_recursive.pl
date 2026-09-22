% Prolog result format 4
query(1, path(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = a, 'X1' = b]).
why(1, ['X0' = a, 'X1' = b], [path(a, b)]).
answer(1, ['X0' = b, 'X1' = c]).
why(1, ['X0' = b, 'X1' = c], [path(b, c)]).
answer(1, ['X0' = a, 'X1' = c]).
why(1, ['X0' = a, 'X1' = c], [path(a, c)]).

clause(2, edge(a, b), true).
clause(3, edge(b, c), true).
clause(4, path(var('X'), var('Y')), edge(var('X'), var('Y'))).
clause(5, path(var('X'), var('Z')), (edge(var('X'), var('Y')), path(var('Y'), var('Z')))).

step(path(a, b), rule(4), ['X' = a, 'Y' = b], [edge(a, b)]).
step(edge(a, b), fact(2), [], []).
step(path(b, c), rule(4), ['X' = b, 'Y' = c], [edge(b, c)]).
step(edge(b, c), fact(3), [], []).
step(path(a, c), rule(5), ['X' = a, 'Z' = c, 'Y' = b], [edge(a, b), path(b, c)]).
