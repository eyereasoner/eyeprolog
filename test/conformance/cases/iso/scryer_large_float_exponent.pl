% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, test
% 53. See test/conformance/THIRD_PARTY.md.

%% goal: large_float_exponent(X)

large_float_exponent(X) :-
    X = 1.0e100,
    float(X),
    X > 1.0e99,
    Y is X / 10.0,
    Y =:= 1.0e99.
