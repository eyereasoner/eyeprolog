% Adapted from Trealla Prolog tests/issues/test0796.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: number_chars_skips_comments(X0, X1)

number_chars_skips_comments(N1, N2) :-
    number_chars(N1, "%$$$\n1"),
    number_chars(N2, "/*$$$*/-2").
