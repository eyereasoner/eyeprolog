% Adapted from Trealla Prolog tests/issues/test0159.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: call_extends_missing_arity(X0, X1)

call_extends_missing_arity(Error, Context) :-
    catch(call(true, false), error(Error, Context), true).
