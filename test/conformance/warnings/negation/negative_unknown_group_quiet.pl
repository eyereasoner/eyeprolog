:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

answer(ok) :- \+ missing(ok).
