:- set_prolog_flag(unknown, fail).

% Negation succeeds when its inner goal has no solution.
%% ?- answer(X0).

answer(ok) :- \+ missing(fact).
