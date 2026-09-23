% Part 3 call//1, phrase//1, variable bodies, and semicontexts.
match(X, [X|S], S).

via_call(X) --> call(match(X)).
via_phrase --> phrase([x, y]).
look_ahead(X), [X] --> [X].
variable_body(Body) --> Body.

%% ?- phrase(via_call(a), [a]).
%% ?- phrase(via_phrase, X).
%% ?- phrase(look_ahead(a), [a], R).
%% ?- phrase(variable_body([z]), X).
