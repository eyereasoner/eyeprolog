answer(pair(a, "bc")).

clause(1, source(pair(a, "bc")), true).
clause(2, answer(var('Term')), source(var('Term'))).

step(answer(pair(a, "bc")), rule(2), ['Term' = pair(a, "bc")], [source(pair(a, "bc"))]).
step(source(pair(a, "bc")), fact(1), [], []).
