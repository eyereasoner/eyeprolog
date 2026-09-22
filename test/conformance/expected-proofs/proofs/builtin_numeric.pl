% Prolog result format 4
query(1, answer(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = 5]).
why(1, ['X0' = 5], [answer(5)]).

clause(1, answer(var('X')), var('X') is 2 + 3).

step(answer(5), rule(1), ['X' = 5], [5 is 2 + 3]).
step(5 is 2 + 3, builtin, [], []).
