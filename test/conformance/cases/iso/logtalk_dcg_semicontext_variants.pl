% Adapted from Logtalk dcgs_push_back_list_02-06.
% Modified for EyeProlog's harness. See test/conformance/THIRD_PARTY.md.

push_two, [a, b] --> [].
consume_then_push, [tail] --> [head], [middle].
echo(X), [X] --> [X].
echo_pair(X, Y), [X, Y] --> [X, Y].

%% ?- phrase(push_two, [rest], Rest).
%% ?- phrase(consume_then_push, [head, middle, rest], Rest).
%% ?- phrase(echo(x), [x, rest], Rest).
%% ?- phrase(echo_pair(a, b), [a, b, rest], Rest).
