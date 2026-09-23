path(a, b).
path(b, c).
path(a, c).

clause(2, edge(a, b), true).
clause(3, edge(b, c), true).
clause(4, path(var('X'), var('Y')), edge(var('X'), var('Y'))).
clause(5, path(var('X'), var('Z')), (edge(var('X'), var('Y')), path(var('Y'), var('Z')))).

step(path(a, b), rule(4), ['X' = a, 'Y' = b], [edge(a, b)]).
step(edge(a, b), fact(2), [], []).
step(path(b, c), rule(4), ['X' = b, 'Y' = c], [edge(b, c)]).
step(edge(b, c), fact(3), [], []).
step(path(a, c), rule(5), ['X' = a, 'Z' = c, 'Y' = b], [edge(a, b), path(b, c)]).
