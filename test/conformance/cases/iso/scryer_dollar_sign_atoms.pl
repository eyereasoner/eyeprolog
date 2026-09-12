% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 198-199. See test/conformance/THIRD_PARTY.md.

%% goal: dollar_sign_atoms(A, B)

dollar_sign_atoms(A, B) :-
    atom($-),
    atom(-$),
    A = ($-),
    B = (-$).
