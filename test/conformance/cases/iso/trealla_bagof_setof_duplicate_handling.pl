% Adapted from Trealla Prolog tests/tests/test0049.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: bagof_setof_duplicate_handling(X0, X1)

foo_dup(a, b, c).
foo_dup(a, b, d).
foo_dup(a, b, a).
foo_dup(a, b, a).
foo_dup(b, c, f).
foo_dup(b, c, e).
foo_dup(c, c, g).

bagof_setof_duplicate_handling(Bag, Set) :-
    bagof(C, A^B^foo_dup(A, B, C), Bag),
    setof(C, A^B^foo_dup(A, B, C), Set).
