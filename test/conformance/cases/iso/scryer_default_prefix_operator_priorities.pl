% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 79-80. See test/conformance/THIRD_PARTY.md.

%% goal: default_prefix_operator_priorities(A, B)

default_prefix_operator_priorities(A, B) :-
    current_op(A, fy, -),
    current_op(B, fy, +).
