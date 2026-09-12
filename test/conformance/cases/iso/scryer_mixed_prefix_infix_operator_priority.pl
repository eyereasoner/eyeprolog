% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, test
% 163. See test/conformance/THIRD_PARTY.md.

:- op(9, fy, p).
:- op(9, xfy, p).

%% goal: mixed_prefix_infix_priority(T)

mixed_prefix_infix_priority(T) :-
    T = (1 p p p 2),
    T = p(1, p(p(2))).
