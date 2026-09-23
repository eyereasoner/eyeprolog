answer(findall_builtin, "ab").

clause(3, answer(findall_builtin, var('Bag')), findall(var('X'), item(var('X')), var('Bag'))).

step(answer(findall_builtin, "ab"), rule(3), ['Bag' = "ab"], [findall(X, item(X), "ab")]).
step(findall(X, item(X), "ab"), collected, [], []).
