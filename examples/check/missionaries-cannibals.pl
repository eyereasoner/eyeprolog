condition('C1', resolution, ok, 53).
condition('C2', well_founded, ok, 97).
condition('C3', justification, ok, 97).
condition('C4', coverage, ok, 166).
condition('C5', re_decision, ok, 43).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 100).
obligation(builtin, theory_scoped, countall(state_safe(state(A, B, C)), 10)).
steps(97).
verified(53).
recomputed(42).
composed(1).
trusted(1).
claims(3).
verdict(checked_with_obligations).
