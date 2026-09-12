% Adapted from Trealla Prolog tests/tests/test0047.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: shared_argument_aliasing(ok)

foo_shared(A, B) :- A = 1, write(B), nl.

shared_argument_aliasing(ok) :-
    foo_shared(X, X).
