% Adapted from Logtalk dcgs_negation_01-02.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.
%% ?- negation_result(X0, X1).

not_b --> \+ [b], [_].
middle_not_x --> [a], \+ [x], [_].

negation_result(prefix_success, a) :- phrase(not_b, [a]).
negation_result(prefix_failure, preserved) :- \+ phrase(not_b, [b]).
negation_result(middle_success, [a, b]) :- phrase(middle_not_x, [a, b]).
negation_result(middle_failure, preserved) :- \+ phrase(middle_not_x, [a, x]).
