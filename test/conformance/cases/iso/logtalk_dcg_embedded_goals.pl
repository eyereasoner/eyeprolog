% Adapted from Logtalk dcgs_bypass_01 and 03-10.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.

checked(X) --> [X], {atom(X)}.
bind(X) --> {X = bound}.
embedded_sequence(X) --> {X = a, atom(X)}, [X].
embedded_if --> ({true} -> [yes] ; [no]).

%% ?- phrase(checked(token), [token]).
%% ?- phrase(bind(X), []).
%% ?- phrase(embedded_sequence(X), Tokens).
%% ?- phrase(embedded_if, Tokens).
