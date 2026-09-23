% The empty list is a first-class term.
%% ?- answer(X0).

seed([]).
answer(X) :- seed(X).
