% Adapted from Trealla Prolog tests/tests/test0059.pl (test1, test3).
% See test/conformance/THIRD_PARTY.md.
%% ?- functor_arg_partial_term(ok).

functor_arg_partial_term(ok) :-
    F = f(a, _, c),
    functor(F, f, 3),
    arg(2, F, b),
    F = f(a, b, c).

%% ?- copy_term_then_reunify_propagates(ok).

copy_term_then_reunify_propagates(ok) :-
    F = f(A, B, C),
    copy_term(F, X),
    F = X,
    A = a, B = b, C = c,
    arg(2, X, b).
