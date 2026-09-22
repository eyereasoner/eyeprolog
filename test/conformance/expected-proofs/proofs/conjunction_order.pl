% Prolog result format 4
query(1, answer(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = ok]).
why(1, ['X0' = ok], [answer(ok)]).

clause(1, left(ok), true).
clause(2, right(ok), true).
clause(3, answer(ok), (left(ok), right(ok))).

step(answer(ok), rule(3), [], [left(ok), right(ok)]).
step(left(ok), fact(1), [], []).
step(right(ok), fact(2), [], []).
