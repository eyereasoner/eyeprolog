answer(5).

clause(1, answer(var('X')), var('X') is 2 + 3).

step(answer(5), rule(1), ['X' = 5], [5 is 2 + 3]).
step(5 is 2 + 3, builtin, [], []).
