condition('C1', resolution, ok, 3).
condition('C2', well_founded, ok, 5).
condition('C3', justification, ok, 5).
condition('C4', coverage, ok, 5).
condition('C5', re_decision, ok, 1).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 6).
obligation(builtin, theory_scoped, countall(hasDog(alice, A), 5)).
steps(5).
verified(3).
recomputed(1).
composed(0).
trusted(1).
claims(1).
verdict(checked_with_obligations).
