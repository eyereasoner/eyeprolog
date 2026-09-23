:- set_prolog_flag(unknown, fail).

item(a).
item(b).
answer(counts, counts(C, Z)) :- countall(item(X), C), countall(missing(X), Z).
%% ?- answer(X0, X1).

