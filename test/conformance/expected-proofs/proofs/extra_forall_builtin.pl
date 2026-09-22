% Prolog result format 4
query(1, answer(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = forall_builtin]).
why(1, ['X0' = forall_builtin], [answer(forall_builtin)]).

clause(1, answer(forall_builtin), \+ forall_counterexample).

step(answer(forall_builtin), rule(1), [], [\+ forall_counterexample]).
step(\+ forall_counterexample, absent, [], []).
