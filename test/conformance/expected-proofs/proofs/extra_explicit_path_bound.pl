% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = table_path_bound, 'X1' = b]).
why(1, ['X0' = table_path_bound, 'X1' = b], [answer(table_path_bound, b)]).
answer(1, ['X0' = table_path_bound, 'X1' = c]).
why(1, ['X0' = table_path_bound, 'X1' = c], [answer(table_path_bound, c)]).

clause(1, edge(a, b), true).
clause(2, edge(b, c), true).
clause(3, path(var('X'), var('Y')), edge(var('X'), var('Y'))).
clause(4, path(var('X'), var('Z')), (edge(var('X'), var('Y')), path(var('Y'), var('Z')))).
clause(5, answer(table_path_bound, var('X')), path(a, var('X'))).

step(answer(table_path_bound, b), rule(5), ['X' = b], [path(a, b)]).
step(path(a, b), rule(3), ['X' = a, 'Y' = b], [edge(a, b)]).
step(edge(a, b), fact(1), [], []).
step(answer(table_path_bound, c), rule(5), ['X' = c], [path(a, c)]).
step(path(a, c), rule(4), ['X' = a, 'Z' = c, 'Y' = b], [edge(a, b), path(b, c)]).
step(path(b, c), rule(3), ['X' = b, 'Y' = c], [edge(b, c)]).
step(edge(b, c), fact(2), [], []).
