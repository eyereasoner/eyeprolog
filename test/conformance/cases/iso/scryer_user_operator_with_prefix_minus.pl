% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 215, 248, and 249. See test/conformance/THIRD_PARTY.md.

:- op(100, yfx, ~).

%% goal: user_operator_with_prefix_minus(A, B, C)

user_operator_with_prefix_minus(A, B, C) :-
    A = (- (1~2~3)),
    A = -(~(~(1,2),3)),
    B = (- (1~2)),
    B = -(~(1,2)),
    C = (1~2),
    C = ~(1,2).
