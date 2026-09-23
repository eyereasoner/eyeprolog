answer(ok).

clause(1, seed(ok), true).
clause(2, answer(var('X')), seed(var('X'))).

step(answer(ok), rule(2), ['X' = ok], [seed(ok)]).
step(seed(ok), fact(1), [], []).
