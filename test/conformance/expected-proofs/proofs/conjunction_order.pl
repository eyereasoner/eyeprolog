answer(ok).

clause(1, left(ok), true).
clause(2, right(ok), true).
clause(3, answer(ok), (left(ok), right(ok))).

step(answer(ok), rule(3), [], [left(ok), right(ok)]).
step(left(ok), fact(1), [], []).
step(right(ok), fact(2), [], []).
