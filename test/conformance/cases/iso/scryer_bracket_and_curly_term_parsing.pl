% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 291, 307, and 309. See test/conformance/THIRD_PARTY.md.

%% goal: bracket_and_curly_term_parsing(A, B, C)

bracket_and_curly_term_parsing(A, B, C) :-
    A = [(a,b)],
    A = [','(a,b)],
    B = [/**/],
    B == [],
    C = {a,b},
    C = '{}'(','(a,b)).
