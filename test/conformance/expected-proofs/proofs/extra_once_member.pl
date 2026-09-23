answer(once_member, a).

clause(1, answer(once_member, var('X')), once(member(var('X'), "abc"))).

step(answer(once_member, a), rule(1), ['X' = a], [once(member(a, "abc"))]).
step(once(member(a, "abc")), builtin, [], [member(a, "abc")]).
step(member(a, "abc"), builtin, [], []).
