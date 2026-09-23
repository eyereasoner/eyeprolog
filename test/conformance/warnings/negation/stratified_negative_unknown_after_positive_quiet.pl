:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

item(a).
answer(X) :- item(X), \+ missing(X).
