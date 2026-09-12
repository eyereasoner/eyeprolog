% Adapted from Trealla Prolog tests/tests/test0102.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: number_codes_char_literal(X0)

number_codes_char_literal(N) :-
    number_codes(N, [48, 39, 92, 110]).
