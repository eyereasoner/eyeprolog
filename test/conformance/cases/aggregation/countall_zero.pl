:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

answer(N) :- countall(missing(X), N).
