answer(ok).

clause(2, answer(ok), \+ known(b)).

step(answer(ok), rule(2), [], [\+ known(b)]).
step(\+ known(b), absent, [], []).
