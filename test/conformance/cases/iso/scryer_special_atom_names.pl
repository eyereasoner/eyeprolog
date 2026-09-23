% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 308 and 324. See test/conformance/THIRD_PARTY.md.

%% ?- special_atom_names(A, B).

special_atom_names(A, B) :-
    A = '.+',
    atom(A),
    B = '%',
    atom(B).
