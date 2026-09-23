answer(forall_builtin).

clause(1, answer(forall_builtin), \+ forall_counterexample).

step(answer(forall_builtin), rule(1), [], [\+ forall_counterexample]).
step(\+ forall_counterexample, absent, [], []).
