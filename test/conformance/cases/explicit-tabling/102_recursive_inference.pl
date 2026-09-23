% Reference 11.1: recursive predicates are tabled only when declared explicitly.
%% ?- reach(X0, X1).

:- table reach_any/2.


edge(a, b).
edge(b, c).
edge(c, d).

reach(X, Y) :- reach_any(X, Y).
reach_any(X, Y) :- edge(X, Y).
reach_any(X, Z) :- edge(X, Y), reach_any(Y, Z).
