% Adapted from Trealla Prolog tests/tests/test0016.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: call_transparent_to_disjunction(ok)

call_transparent_to_disjunction(ok) :-
    call((true ; false)),
    call((false ; true)).
