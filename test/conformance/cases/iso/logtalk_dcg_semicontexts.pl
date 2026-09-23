% Adapted from Logtalk dcgs_push_back_list_01-08.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.

look_ahead(X), [X] --> [X].
replace, [a, b] --> [foo].
push_one(X), [X] --> [X].
push_pair(X, Y), [X, Y] --> [X, Y].

%% ?- phrase(look_ahead(a), [a], Rest).
%% ?- phrase(replace, [foo, tail], Rest).
%% ?- phrase(push_one(x), [x], Rest).
%% ?- phrase(push_pair(a, b), [a, b], Rest).
