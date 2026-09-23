% Adapted from Logtalk dcgs_cut_01-06. Modified for EyeProlog's harness.
% See test/conformance/THIRD_PARTY.md.
%% ?- cut_result(X0, X1).

committed --> ([a], ! ; [b]).
cut_then_fail --> ([a], !, {fail} ; [b]).
cut_after_prefix --> [start], ([a], ! ; [b]).

cut_result(committed, Tokens) :- phrase(committed, Tokens).
cut_result(fallback_before_cut, [b]) :- phrase(cut_then_fail, [b]).
cut_result(failure_after_cut, preserved) :- \+ phrase(cut_then_fail, [a]).
cut_result(nested, Tokens) :- phrase(cut_after_prefix, Tokens).
