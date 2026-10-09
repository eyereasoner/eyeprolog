condition('C1', resolution, ok, 105).
condition('C2', well_founded, ok, 128).
condition('C3', justification, ok, 128).
condition('C4', coverage, ok, 186).
condition('C5', re_decision, ok, 11).
condition('C6', boundary_consistency, ok, 1).
condition('C7', relevance, ok, 147).
obligation(builtin, theory_scoped, aggregate_max(A, B, finish_time(B, A), 23, launch)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(launch, B), finish_time(B, A)), 22, security_review)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(security_review, B), finish_time(B, A)), 19, integration)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(integration, B), finish_time(B, A)), 15, backend)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(backend, B), finish_time(B, A)), 9, database)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(database, B), finish_time(B, A)), 5, architecture)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(architecture, B), finish_time(B, A)), 2, requirements)).
obligation(absent, theory_scoped, \+ depends(requirements, A)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(api_design, B), finish_time(B, A)), 2, requirements)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(frontend, B), finish_time(B, A)), 4, api_design)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(auth, B), finish_time(B, A)), 5, architecture)).
obligation(builtin, theory_scoped, aggregate_max(A, B, (depends(load_test, B), finish_time(B, A)), 19, integration)).
steps(128).
verified(105).
recomputed(11).
composed(0).
trusted(12).
claims(19).
verdict(checked_with_obligations).
