% Adapted from Logtalk dcgs_terminal_list_05-06.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.

capture(X) --> [X].
duplicate(X) --> [X, X].

%% ?- phrase(capture(X), [term(a)]).
%% ?- phrase(capture(value), Tokens).
%% ?- phrase(duplicate(same), Tokens).
