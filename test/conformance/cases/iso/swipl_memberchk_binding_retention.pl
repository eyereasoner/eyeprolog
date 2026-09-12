% Adapted from SWI-Prolog tests/core_lang/test_list.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: memberchk_binding_retention(X0)

memberchk_binding_retention(X) :-
    memberchk(f(X, a), [f(x, b), f(y, a)]).
