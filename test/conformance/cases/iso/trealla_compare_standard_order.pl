% Adapted from Trealla Prolog tests/tests/test0059.pl (test15d).
% See test/conformance/THIRD_PARTY.md.
%% goal: compare_standard_order(ok)

compare_standard_order(ok) :-
    compare(<, 1, 2),
    compare(=, 2, 2),
    compare(>, 3, 2).
