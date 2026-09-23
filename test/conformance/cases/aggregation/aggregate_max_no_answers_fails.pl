:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

answer(ok) :- \+ aggregate_max(Key, Value, missing(Value), BestKey, BestValue).
