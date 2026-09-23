:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

answer(Bag) :- findall(X, missing(X), Bag).
