% Adapted from Logtalk dcgs_if_the_else_01-06 and dcgs_bypass_06-07.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.

select --> ([x] -> [then] ; [else]).
after_prefix --> [start], ([x] -> [yes] ; [no]).
condition_sequence --> ([a], [b] -> [c] ; [d]).
embedded_condition --> ({true} -> [yes] ; [no]).

%% ?- phrase(select, [x, then]).
%% ?- phrase(select, [else]).
%% ?- phrase(after_prefix, [start, x, yes]).
%% ?- phrase(after_prefix, [start, no]).
%% ?- phrase(condition_sequence, [a, b, c]).
%% ?- phrase(condition_sequence, [d]).
%% ?- phrase(embedded_condition, X).
