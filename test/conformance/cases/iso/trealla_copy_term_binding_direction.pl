% Adapted from Trealla Prolog tests/issues/test1136.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: copy_term_binding_direction(ok)

copy_term_binding_direction(ok) :-
    copy_term(X, 3), var(X),
    copy_term(f(Y), f(3)), var(Y),
    copy_term(3, Z), Z == 3,
    \+ copy_term(f(_), 3).
