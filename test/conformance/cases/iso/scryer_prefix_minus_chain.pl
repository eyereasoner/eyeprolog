% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, test
% 236. See test/conformance/THIRD_PARTY.md.

%% goal: prefix_minus_chain(X)

prefix_minus_chain(X) :-
    X = (a- - -b),
    X = -(a, -(-(b))).
