% Part 3 alternatives, embedded goals, if-then-else, negation and cut.
token(X) --> [X], { atom(X) }.
choice --> [a] | [b].
guarded --> ([a] -> [b] ; [c]).
not_a --> \+ [a], [_].
committed --> ([a], ! ; [b]).

%% ?- phrase(token(a), [a]).
%% ?- phrase(choice, X).
%% ?- phrase(guarded, X).
%% ?- phrase(not_a, [b]).
%% ?- phrase(committed, X).
