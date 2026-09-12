% Adapted from SWI-Prolog tests/core_lang/test_call.pl (catch, partial_unification).
% See test/conformance/THIRD_PARTY.md.
%% goal: catch_partial_unification_rethrow(X0)

t3_rethrow :- throw(f(_, 2)).
t2_rethrow(X) :- catch(t3_rethrow, f(2, 1), X = 2).
t1_rethrow(X) :- catch(t2_rethrow(X), f(1, 2), X = 1).

catch_partial_unification_rethrow(X) :- t1_rethrow(X).
