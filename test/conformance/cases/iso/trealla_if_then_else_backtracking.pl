% Adapted from Trealla Prolog tests/tests/test0045.pl.
% See test/conformance/THIRD_PARTY.md.
cond(1).
cond(2).

ok(a).
ok(b).

%% ?- then_branch_backtracks(X0).

then_branch_backtracks(X) :-
    (true -> ok(X) ; fail).

%% ?- else_branch_backtracks(X0).

else_branch_backtracks(X) :-
    (fail -> fail ; ok(X)).

%% ?- cond_commits_to_first_solution(X0).

cond_commits_to_first_solution(X) :-
    (cond(X) -> true ; true).
