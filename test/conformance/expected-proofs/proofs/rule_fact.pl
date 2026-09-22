% Prolog result format 4
query(1, answer(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = ok]).
why(1, ['X0' = ok], [answer(ok)]).

clause(1, seed(ok), true).
clause(2, answer(var('X')), seed(var('X'))).

step(answer(ok), rule(2), ['X' = ok], [seed(ok)]).
step(seed(ok), fact(1), [], []).
