% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 65-66 and 318. See test/conformance/THIRD_PARTY.md.

%% goal: unary_plus_compound(A, B)

unary_plus_compound(A, B) :-
    compound(+1),
    compound(+ 1),
    A = (+1),
    A = +(1),
    B = (+ (1*2)^3),
    B = +((1*2)^3).
