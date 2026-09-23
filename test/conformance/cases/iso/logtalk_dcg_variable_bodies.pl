% Adapted from Logtalk dcgs_metacall_01-02.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.

delegate(Body) --> Body.
surrounded(Body) --> [left], Body, [right].
body_or_fallback(Body) --> Body | [fallback].

%% ?- phrase(delegate([a, b]), Tokens).
%% ?- phrase(surrounded([center]), Tokens).
%% ?- phrase(body_or_fallback([chosen]), Tokens).
