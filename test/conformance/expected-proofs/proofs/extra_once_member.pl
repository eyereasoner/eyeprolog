% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = once_member, 'X1' = a]).
why(1, ['X0' = once_member, 'X1' = a], [answer(once_member, a)]).

clause(1, answer(once_member, var('X')), once(member(var('X'), "abc"))).

step(answer(once_member, a), rule(1), ['X' = a], [once(member(a, "abc"))]).
step(once(member(a, "abc")), builtin, [], [member(a, "abc")]).
step(member(a, "abc"), builtin, [], []).
