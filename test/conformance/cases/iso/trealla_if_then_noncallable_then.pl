% Adapted from Trealla Prolog tests/issues/test0898.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: if_then_noncallable_then(X0)

if_then_noncallable_then(E) :-
    catch(call((true -> false, 1)), error(E, _), true).
