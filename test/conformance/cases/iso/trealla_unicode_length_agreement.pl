% Adapted from Trealla Prolog tests/tests/test0013.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: unicode_length_agreement(X0)

unicode_length_agreement(L) :-
    atom_length('一二三', L1),
    length("一二三", L2),
    L1 = L2, L1 = 3,
    L = L1.
