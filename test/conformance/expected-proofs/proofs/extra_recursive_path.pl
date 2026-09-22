% Prolog result format 4
query(1, path(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = a, 'X1' = b]).
why(1, ['X0' = a, 'X1' = b], [path(a, b)]).
answer(1, ['X0' = b, 'X1' = c]).
why(1, ['X0' = b, 'X1' = c], [path(b, c)]).
answer(1, ['X0' = a, 'X1' = c]).
why(1, ['X0' = a, 'X1' = c], [path(a, c)]).

clause(1, edge(a, b), true).
clause(2, edge(b, c), true).
clause(3, path(var('X'), var('Y')), edge(var('X'), var('Y'))).
clause(4, path(var('X'), var('Z')), (edge(var('X'), var('Y')), path(var('Y'), var('Z')))).

step(path(a, b), rule(3), ['X' = a, 'Y' = b], [edge(a, b)]).
step(edge(a, b), fact(1), [], []).
step(path(b, c), rule(3), ['X' = b, 'Y' = c], [edge(b, c)]).
step(edge(b, c), fact(2), [], []).
step(path(a, c), rule(4), ['X' = a, 'Z' = c, 'Y' = b], [edge(a, b), path(b, c)]).
