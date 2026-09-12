% Adapted from Trealla Prolog tests/tests/test0040.pl, test0036.pl.
% See test/conformance/THIRD_PARTY.md.
:- op(500, xfy, plus).

%% goal: operator_terms_vs_precedence(X0, X1, X2, X3)

operator_terms_vs_precedence(A, B, C, D) :-
    A = (1 plus 2),
    B = ((1+2)*3),
    C = (1*(2+3)),
    D = (-(-)-(-)).

%% goal: canonical_ignores_custom_operator(ok)

canonical_ignores_custom_operator(ok) :-
    write_canonical(1 plus 2), nl,
    write(1 plus 2), nl.

%% goal: dot_functor_is_list_notation(X0, X1, X2)

dot_functor_is_list_notation(A, B, C) :-
    A = [a],
    B = '.'(a, []),
    C = .(a, []),
    A == B,
    B == C.
