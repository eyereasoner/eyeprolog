condition('C1', resolution, ok, 36).
condition('C2', well_founded, ok, 42).
condition('C3', justification, ok, 42).
condition('C4', coverage, ok, 57).
condition('C5', re_decision, ok, 5).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 53).
obligation(builtin, theory_scoped, aggregate_min(A, B, (satisfying_model(B), model_rank(B, A)), 7, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])).
steps(42).
verified(36).
recomputed(5).
composed(0).
trusted(1).
claims(11).
verdict(checked_with_obligations).
