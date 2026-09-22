% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = eq_builtin, 'X1' = a]).
why(1, ['X0' = eq_builtin, 'X1' = a], [answer(eq_builtin, a)]).

clause(1, answer(eq_builtin, var('X')), pair(var('X'), b) = pair(a, b)).

step(answer(eq_builtin, a), rule(1), ['X' = a], [pair(a, b) = pair(a, b)]).
step(pair(a, b) = pair(a, b), builtin, [], []).
