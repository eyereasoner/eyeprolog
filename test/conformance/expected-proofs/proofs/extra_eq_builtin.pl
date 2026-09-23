answer(eq_builtin, a).

clause(1, answer(eq_builtin, var('X')), pair(var('X'), b) = pair(a, b)).

step(answer(eq_builtin, a), rule(1), ['X' = a], [pair(a, b) = pair(a, b)]).
step(pair(a, b) = pair(a, b), builtin, [], []).
