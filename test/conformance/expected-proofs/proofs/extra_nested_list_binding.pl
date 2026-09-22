% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = nested_list_binding, 'X1' = "c"]).
why(1, ['X0' = nested_list_binding, 'X1' = "c"], [answer(nested_list_binding, "c")]).

clause(1, answer(nested_list_binding, var('Tail')), "ab"||var('Tail') = "abc").

step(answer(nested_list_binding, "c"), rule(1), ['Tail' = "c"], ["abc" = "abc"]).
step("abc" = "abc", builtin, [], []).
