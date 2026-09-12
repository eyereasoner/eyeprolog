% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 100, 103, 114-116, and 165. See test/conformance/THIRD_PARTY.md.

%% goal: quote_and_char_code_literals(A, B, C, D)

quote_and_char_code_literals(A, B, C, D) :-
    '''' = '\'',
    A = '\141\141',
    A == a141,
    B = 0'\',
    integer(B),
    C = 0''',
    integer(C),
    C == B,
    D = '.''-''.',
    atom(D).
