condition('C1', resolution, ok, 25).
condition('C2', well_founded, ok, 32).
condition('C3', justification, ok, 32).
condition('C4', coverage, ok, 38).
condition('C5', re_decision, ok, 4).
condition('C6', boundary_consistency, ok, 3).
condition('C7', relevance, ok, 41).
obligation(absent, theory_scoped, \+ exclusion_renal(p001)).
obligation(absent, theory_scoped, \+ exclusion_pregnancy(p001)).
obligation(absent, theory_scoped, \+ inclusion_hba1c(p004)).
steps(32).
verified(25).
recomputed(4).
composed(0).
trusted(3).
claims(9).
verdict(checked_with_obligations).
