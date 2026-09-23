% Adapted from Logtalk dcgs_terminal_list_01-06 and
% dcgs_terminal_string_01-03. Modified for EyeProlog's harness.
% See test/conformance/THIRD_PARTY.md.

empty --> [].
one(X) --> [X].
mixed --> [[], {}, 3, 3.2, a(b)].
letters --> "abc".
letters_or_q --> "abc" | "q".

%% ?- phrase(empty, []).
%% ?- phrase(one(value), [value]).
%% ?- phrase(mixed, [[], {}, 3, 3.2, a(b)]).
%% ?- phrase(letters, X).
%% ?- phrase(letters_or_q, X).
