% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, test
% 41. See test/conformance/THIRD_PARTY.md.

%% goal: backslash_atom(A)

backslash_atom(A) :-
    A = ('\\'),
    A = (\).
