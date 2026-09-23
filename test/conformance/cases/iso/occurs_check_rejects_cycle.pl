% Isolated ISO mode-table success case.
%% ?- answer.

answer :- \+ unify_with_occurs_check(X, f(X)).
