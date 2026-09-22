% Prolog result format 4
query(1, answer(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = b]).
why(1, ['X0' = b], [answer(b)]).

clause(1, answer(var('X')), (member(var('X'), "ab"), var('X') = b)).

step(answer(b), rule(1), ['X' = b], [member(b, "ab"), b = b]).
step(member(b, "ab"), builtin, [], []).
step(b = b, builtin, [], []).
