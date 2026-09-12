% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 172-173. See test/conformance/THIRD_PARTY.md.

%% goal: subnormal_float_underflow(X)

subnormal_float_underflow(X) :-
    X is 10.0** -323,
    X > 0.0,
    X =:= 1.0e-323.
