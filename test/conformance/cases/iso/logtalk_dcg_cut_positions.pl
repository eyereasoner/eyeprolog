% Adapted from Logtalk dcgs_cut_01-04 and 06.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.
%% ?- cut_position(X0, X1).

cut_first --> !, [a].
cut_middle --> [a], !, [b].
cut_choice --> ([a], !, [b] ; [a], [c]).
cut_embedded_failure --> [a], !, {fail}.

cut_position(first, Tokens) :- phrase(cut_first, Tokens).
cut_position(middle, Tokens) :- phrase(cut_middle, Tokens).
cut_position(choice, Tokens) :- phrase(cut_choice, Tokens).
cut_position(failure, preserved) :- \+ phrase(cut_embedded_failure, [a]).
