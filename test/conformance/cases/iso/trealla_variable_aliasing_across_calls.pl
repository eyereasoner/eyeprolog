% Adapted from Trealla Prolog tests/tests/test0059.pl (test14).
% See test/conformance/THIRD_PARTY.md.
%% goal: variable_aliasing_across_calls(ok)

bar_alias([A], B) :- A = B.
foo_alias(A, B) :- bar_alias(A, B).

variable_aliasing_across_calls(ok) :-
    A = a, foo_alias([A], B), A = B.
