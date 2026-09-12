% Adapted from Trealla Prolog tests/tests/test0073.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: curly_and_colon_syntax_equivalence(X0, X1, X2, X3, X4)

curly_and_colon_syntax_equivalence(X, Y, Z, A, B) :-
    X = {a:b},
    Y = {}(a:b),
    Z = :(a, b),
    A = a:b,
    B = (a:b).
