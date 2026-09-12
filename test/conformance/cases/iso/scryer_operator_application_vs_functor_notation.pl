% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 234-235. See test/conformance/THIRD_PARTY.md.

:- op(400, fx, f).

%% goal: space_before_paren_is_operator_application(T)

space_before_paren_is_operator_application(T) :-
    T = (f (1,2)),
    T = f(','(1,2)).
