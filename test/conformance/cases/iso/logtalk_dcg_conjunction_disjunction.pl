% Adapted from Logtalk dcgs_conjunction_01-04 and dcgs_disjunction_01-03.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.

a --> [a].
b --> [b].
sequence --> a, b.
optional_b --> a, (b; []).
bar_choice --> [x] | [y] | [z].
nested_choice --> ([a], [b]; [a], [c]).

%% ?- phrase(sequence, X).
%% ?- phrase(optional_b, X).
%% ?- phrase(bar_choice, X).
%% ?- phrase(nested_choice, X).
