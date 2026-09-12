% Adapted from Trealla Prolog tests/tests/test0092.pl (main2, main3).
% See test/conformance/THIRD_PARTY.md.
%% goal: occurs_check_rational_tree_subtleties(ok)

occurs_check_rational_tree_subtleties(ok) :-
    \+ (A4 = [A4 | A4], A4 = [_B4, A4]),
    \+ (A5 = B5, A5 = [A5 | A5], A5 = [B5, A5]),
    \+ unify_with_occurs_check(A, [[[A]] | A]).
