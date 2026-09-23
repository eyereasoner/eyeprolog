path(a, b).
path(b, c).
path(a, c).

clause(1, edge(a, b), true).
clause(2, edge(b, c), true).
clause(3, path(var('X'), var('Y')), edge(var('X'), var('Y'))).
clause(4, path(var('X'), var('Z')), (edge(var('X'), var('Y')), path(var('Y'), var('Z')))).

step(path(a, b), rule(3), ['X' = a, 'Y' = b], [edge(a, b)]).
step(edge(a, b), fact(1), [], []).
step(path(b, c), rule(3), ['X' = b, 'Y' = c], [edge(b, c)]).
step(edge(b, c), fact(2), [], []).
step(path(a, c), rule(4), ['X' = a, 'Z' = c, 'Y' = b], [edge(a, b), path(b, c)]).
