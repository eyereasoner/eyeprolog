% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, test
% 49. See test/conformance/THIRD_PARTY.md.

:- op(9, xf, e9).

%% goal: bare_exponent_lexing(X)

bare_exponent_lexing(X) :-
    X = (1e9),
    X = e9(1).
