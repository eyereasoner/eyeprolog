condition('C1', resolution, ok, 51).
condition('C2', well_founded, ok, 79).
condition('C3', justification, ok, 79).
condition('C4', coverage, ok, 93).
condition('C5', re_decision, ok, 26).
condition('C6', boundary_consistency, ok, 2).
condition('C7', relevance, ok, 91).
obligation(absent, theory_scoped, \+ allowed_shape(gps, 2)).
obligation(absent, theory_scoped, \+ allowed_shape(tampered, 1)).
steps(79).
verified(51).
recomputed(26).
composed(0).
trusted(2).
claims(12).
verdict(checked_with_obligations).
