condition('C1', resolution, ok, 105).
condition('C2', well_founded, ok, 128).
condition('C3', justification, ok, 128).
condition('C4', coverage, ok, 186).
condition('C5', re_decision, ok, 11).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, finish_time(Value, Key), 23, launch)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(launch, Value), finish_time(Value, Key)), 22, security_review)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(security_review, Value), finish_time(Value, Key)), 19, integration)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(integration, Value), finish_time(Value, Key)), 15, backend)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(backend, Value), finish_time(Value, Key)), 9, database)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(database, Value), finish_time(Value, Key)), 5, architecture)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(architecture, Value), finish_time(Value, Key)), 2, requirements)).
obligation(absent, theory_scoped, \+ depends(requirements, _pred)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(api_design, Value), finish_time(Value, Key)), 2, requirements)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(frontend, Value), finish_time(Value, Key)), 4, api_design)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(auth, Value), finish_time(Value, Key)), 5, architecture)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, (depends(load_test, Value), finish_time(Value, Key)), 19, integration)).
steps(128).
verified(105).
recomputed(11).
composed(0).
trusted(12).
claims(19).
verdict(checked_with_obligations).
