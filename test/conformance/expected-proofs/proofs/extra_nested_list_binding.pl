answer(nested_list_binding, "c").

clause(1, answer(nested_list_binding, var('Tail')), "ab"||var('Tail') = "abc").

step(answer(nested_list_binding, "c"), rule(1), ['Tail' = "c"], ["abc" = "abc"]).
step("abc" = "abc", builtin, [], []).
