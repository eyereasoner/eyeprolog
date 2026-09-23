:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

answer(N) :- sumall(X, missing(X), N).
