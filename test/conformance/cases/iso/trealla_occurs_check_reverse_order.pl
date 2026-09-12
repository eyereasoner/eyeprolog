% Adapted from Trealla Prolog tests/issues/test0805.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: occurs_check_reverse_order(ok)

occurs_check_reverse_order(ok) :-
    \+ unify_with_occurs_check(L, [_ | L]),
    \+ unify_with_occurs_check([_ | L], L).
