% Adapted from Trealla Prolog tests/issues/test0078.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: mod_sign_rules(X0, X1, X2, X3, X4, X5, X6, X7, X8)

mod_sign_rules(M1, M2, M3, M4, M5, M6, M7, Big, M8) :-
    M1 is 1 mod 3,
    M2 is -1 mod 3,
    M3 is -1 mod -3,
    M4 is 1 mod -3,
    M5 is -2 mod 3,
    M6 is -2 mod -3,
    M7 is 2 mod -3,
    Big is (1 << 150) mod (3 << 150),
    M8 is -5 mod -3.
