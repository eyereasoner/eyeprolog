% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, test
% 164. See test/conformance/THIRD_PARTY.md.

:- op(7, fy, p).
:- op(9, yfx, p).

%% goal: lower_priority_prefix_with_infix(T)

lower_priority_prefix_with_infix(T) :-
    T = (1 p p p 2),
    T = p(1, p(p(2))).
