person(alice).
has_parent(Child, parent_of(Child)) :- person(Child).
%% ?- has_parent(X0, X1).

