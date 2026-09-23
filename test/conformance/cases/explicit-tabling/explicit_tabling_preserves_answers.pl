% Explicit tabling is a search-control strategy and does not change answers.
%% ?- path(X0, X1).

:- table path/2.

edge(a, b).
edge(b, c).
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
