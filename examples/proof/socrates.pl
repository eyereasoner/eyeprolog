% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = socrates, 'X1' = mortal]).
why(1, ['X0' = socrates, 'X1' = mortal], [type(socrates, mortal)]).
query(2, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = test, 'X1' = true]).
why(2, ['X0' = test, 'X1' = true], [holds_result(test, true)]).

clause(1, type(socrates, man), true).
clause(2, type(var('X'), mortal), type(var('X'), man)).
clause(3, holds_result(test, true), type(socrates, mortal)).

step(type(socrates, mortal), rule(2), ['X' = socrates], [type(socrates, man)]).
step(type(socrates, man), fact(1), [], []).
step(holds_result(test, true), rule(3), [], [type(socrates, mortal)]).
