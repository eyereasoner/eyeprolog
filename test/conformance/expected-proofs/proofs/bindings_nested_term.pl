% Prolog result format 4
query(1, answer(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = pair(a, "bc")]).
why(1, ['X0' = pair(a, "bc")], [answer(pair(a, "bc"))]).

clause(1, source(pair(a, "bc")), true).
clause(2, answer(var('Term')), source(var('Term'))).

step(answer(pair(a, "bc")), rule(2), ['Term' = pair(a, "bc")], [source(pair(a, "bc"))]).
step(source(pair(a, "bc")), fact(1), [], []).
