% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = findall_builtin, 'X1' = "ab"]).
why(1, ['X0' = findall_builtin, 'X1' = "ab"], [answer(findall_builtin, "ab")]).

clause(3, answer(findall_builtin, var('Bag')), findall(var('X'), item(var('X')), var('Bag'))).

step(answer(findall_builtin, "ab"), rule(3), ['Bag' = "ab"], [findall(X, item(X), "ab")]).
step(findall(X, item(X), "ab"), collected, [], []).
