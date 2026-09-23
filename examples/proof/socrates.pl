type(socrates, mortal).
holds_result(test, true).

clause(1, type(socrates, man), true).
clause(2, type(var('X'), mortal), type(var('X'), man)).
clause(3, holds_result(test, true), type(socrates, mortal)).

step(type(socrates, mortal), rule(2), ['X' = socrates], [type(socrates, man)]).
step(type(socrates, man), fact(1), [], []).
step(holds_result(test, true), rule(3), [], [type(socrates, mortal)]).
