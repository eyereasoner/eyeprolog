% From The Art of EyeProlog, Chapter 11.
type(socrates, mortal).

clause(1, type(socrates, man), true).
clause(2, type(var('X'), mortal), type(var('X'), man)).

step(type(socrates, mortal), rule(2), ['X' = socrates], [type(socrates, man)]).
step(type(socrates, man), fact(1), [], []).
