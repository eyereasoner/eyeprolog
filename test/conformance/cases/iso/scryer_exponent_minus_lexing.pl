% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 50-51, 204, and 220. See test/conformance/THIRD_PARTY.md.

:- op(9, xf, e).

%% goal: exponent_minus_lexing(X, Y)

exponent_minus_lexing(X, Y) :-
    X = (1e-9),
    X = -(e(1), 9),
    Y = (1.0e- 9),
    Y = -(e(1.0), 9).
