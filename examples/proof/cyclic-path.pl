path(a, b).
path(b, c).
path(c, d).
path(d, a).
path(a, c).
path(a, d).
path(a, a).
path(b, d).
path(b, a).
path(b, b).
path(c, a).
path(c, b).
path(c, c).
path(d, b).
path(d, c).
path(d, d).

clause(2, arc(a, b), true).
clause(3, arc(b, c), true).
clause(4, arc(c, d), true).
clause(5, arc(d, a), true).
clause(6, path(var('X'), var('Y')), arc(var('X'), var('Y'))).
clause(7, path(var('X'), var('Z')), (arc(var('X'), var('Y')), path(var('Y'), var('Z')))).

step(path(a, b), rule(6), ['X' = a, 'Y' = b], [arc(a, b)]).
step(arc(a, b), fact(2), [], []).
step(path(b, c), rule(6), ['X' = b, 'Y' = c], [arc(b, c)]).
step(arc(b, c), fact(3), [], []).
step(path(c, d), rule(6), ['X' = c, 'Y' = d], [arc(c, d)]).
step(arc(c, d), fact(4), [], []).
step(path(d, a), rule(6), ['X' = d, 'Y' = a], [arc(d, a)]).
step(arc(d, a), fact(5), [], []).
step(path(a, c), rule(7), ['X' = a, 'Z' = c, 'Y' = b], [arc(a, b), path(b, c)]).
step(path(a, d), rule(7), ['X' = a, 'Z' = d, 'Y' = b], [arc(a, b), path(b, d)]).
step(path(b, d), rule(7), ['X' = b, 'Z' = d, 'Y' = c], [arc(b, c), path(c, d)]).
step(path(a, a), rule(7), ['X' = a, 'Z' = a, 'Y' = b], [arc(a, b), path(b, a)]).
step(path(b, a), rule(7), ['X' = b, 'Z' = a, 'Y' = c], [arc(b, c), path(c, a)]).
step(path(c, a), rule(7), ['X' = c, 'Z' = a, 'Y' = d], [arc(c, d), path(d, a)]).
step(path(b, b), rule(7), ['X' = b, 'Z' = b, 'Y' = c], [arc(b, c), path(c, b)]).
step(path(c, b), rule(7), ['X' = c, 'Z' = b, 'Y' = d], [arc(c, d), path(d, b)]).
step(path(d, b), rule(7), ['X' = d, 'Z' = b, 'Y' = a], [arc(d, a), path(a, b)]).
step(path(c, c), rule(7), ['X' = c, 'Z' = c, 'Y' = d], [arc(c, d), path(d, c)]).
step(path(d, c), rule(7), ['X' = d, 'Z' = c, 'Y' = a], [arc(d, a), path(a, c)]).
step(path(d, d), rule(7), ['X' = d, 'Z' = d, 'Y' = a], [arc(d, a), path(a, d)]).
