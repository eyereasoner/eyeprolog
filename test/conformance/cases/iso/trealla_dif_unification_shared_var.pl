% Adapted from Trealla Prolog tests/tests/test0090.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: dif_unification_shared_var(ok)

dif_unification_shared_var(ok) :-
    [A, 1] \= [A, 2].
