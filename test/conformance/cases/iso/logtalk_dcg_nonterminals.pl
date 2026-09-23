% Adapted from Logtalk dcgs_non_terminal_01-03 and dcgs_metacall_01-02.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.

token(X) --> [X].
pair(X, Y) --> token(X), token(Y).
delegate(Body) --> Body.
via_call(X) --> call(token(X)).

%% ?- phrase(pair(a, b), X).
%% ?- phrase(delegate([x, y]), X).
%% ?- phrase(via_call(z), X).
