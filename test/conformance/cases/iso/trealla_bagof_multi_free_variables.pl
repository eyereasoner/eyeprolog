% Adapted from Trealla Prolog tests/tests/test0027.pl, test0030.pl, and test0031.pl.
% See test/conformance/THIRD_PARTY.md.
foo(a, b, cc).
foo(a, b, dd).
foo(b, c, ee).
foo(b, c, ff).
foo(c, c, gg).
foo(d, e, gg).

%% goal: bagof_grouped_by_two_free_variables(X0)

bagof_grouped_by_two_free_variables(Cs) :-
    bagof(C, foo(_, _, C), Cs).

%% goal: bagof_two_free_variables_quantified(X0)

bagof_two_free_variables_quantified(Cs) :-
    bagof(C, A^B^foo(A, B, C), Cs).

%% goal: setof_two_free_variables_quantified(X0)

setof_two_free_variables_quantified(Cs) :-
    setof(C, A^B^foo(A, B, C), Cs).
