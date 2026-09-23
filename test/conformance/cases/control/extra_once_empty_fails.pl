:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

answer(once_empty_fails) :- once(missing).
