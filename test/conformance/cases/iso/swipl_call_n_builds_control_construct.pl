% Adapted from SWI-Prolog tests/core_lang/test_call.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: call_n_builds_control_construct(X0, X1, X2)

call_n_builds_control_construct(IfThenElse, Disj, Conj) :-
    findall(X, call(;((true -> X = a)), X = b), IfThenElse),
    findall(X, call(;(X = a), X = b), Disj),
    findall(X, call(','(X = a), X = b), Conj).
