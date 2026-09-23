answer(a).

clause(1, choice(a), true).
clause(3, answer(var('X')), once(choice(var('X')))).

step(answer(a), rule(3), ['X' = a], [once(choice(a))]).
step(once(choice(a)), builtin, [], [choice(a)]).
step(choice(a), fact(1), [], []).
