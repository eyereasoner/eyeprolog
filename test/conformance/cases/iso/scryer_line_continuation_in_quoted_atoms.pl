% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 7-10. See test/conformance/THIRD_PARTY.md.

%% goal: line_continuation_in_quoted_atoms(A, B, C)

line_continuation_in_quoted_atoms(A, B, C) :-
    A = '\
',
    A == '',
    B = '\
a',
    B == a,
    C = 'a\
 b',
    C == 'a b'.
