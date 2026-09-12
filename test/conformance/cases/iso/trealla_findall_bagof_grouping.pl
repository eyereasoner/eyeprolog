% Adapted from Trealla Prolog tests/tests/test0028.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: findall_bagof_grouping(X0)

foo_groups(a, b, c).
foo_groups(a, b, d).
foo_groups(b, c, e).
foo_groups(b, c, f).
foo_groups(c, c, g).
foo_groups(d, e, g).

findall_bagof_grouping(L) :-
    findall(Cs, bagof(C, foo_groups(_, _, C), Cs), L).
