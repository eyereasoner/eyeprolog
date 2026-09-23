answer(b).

clause(1, answer(var('X')), (member(var('X'), "ab"), var('X') = b)).

step(answer(b), rule(1), ['X' = b], [member(b, "ab"), b = b]).
step(member(b, "ab"), builtin, [], []).
step(b = b, builtin, [], []).
