% Recursive grammar rules support both recognition and generation.

tokens([]) --> [].
tokens([X|Xs]) --> [X], tokens(Xs).

%% ?- phrase(tokens([a, b, c]), Generated).
%% ?- phrase(tokens(Parsed), [x, y]).
%% ?- phrase(tokens([a, b]), [a, b, rest], Rest).
