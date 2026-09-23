:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

answer(not_unbound_unknown_goal_succeeds) :- \+ missing(X).
