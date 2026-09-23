:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

answer(ok) :- \+ empty_counterexample.
empty_counterexample :- missing(X), \+ fail(X).
