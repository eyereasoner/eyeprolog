% Reference 11.1: explicit tabling preserves recursive closure answers.
:- table reach_any/2.
%% ?- reach(X0, X1).

edge(a, b).
edge(b, c).
reach_any(X, Y) :- edge(X, Y).
reach_any(X, Z) :- edge(X, Y), reach_any(Y, Z).
reach(a, Y) :- reach_any(a, Y).
