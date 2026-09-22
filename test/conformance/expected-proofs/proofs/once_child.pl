% Prolog result format 4
query(1, answer(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = a]).
why(1, ['X0' = a], [answer(a)]).

clause(1, choice(a), true).
clause(3, answer(var('X')), once(choice(var('X')))).

step(answer(a), rule(3), ['X' = a], [once(choice(a))]).
step(once(choice(a)), builtin, [], [choice(a)]).
step(choice(a), fact(1), [], []).
