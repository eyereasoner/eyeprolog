% Adapted from Scryer Prolog tests-pl/issue831-call0.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: call_zero_arity(X0)

call_zero_arity(E) :-
    catch(call, error(E, _), true).
