:- table path/2.

% Quoted atoms, variables, and tabled recursion.
% Atom names may contain spaces when quoted.
% The explicit table/1 declaration is a normal-mode extension.

%% ?- path(X0, X1).

edge('node a', 'node b').
edge('node b', 'node c').
edge('node c', 'node d').

path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
