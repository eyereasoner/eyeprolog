% Adapted from Trealla Prolog tests/tests/test0059.pl (test5a, test5b).
% See test/conformance/THIRD_PARTY.md.
%% goal: disjunction_commit_and_fallthrough(ok)

name_d(john).
name_d(mary).
name_d(tom).

disjunction_commit_and_fallthrough(ok) :-
    ( name_d(john) ; write('ERROR') ), !,
    ( name_d(fred) ; name_d(mary) ), !.
