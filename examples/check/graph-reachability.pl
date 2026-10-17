condition('C1', resolution, ok, 19).
condition('C2', well_founded, ok, 26).
condition('C3', justification, ok, 26).
condition('C4', coverage, ok, 26).
condition('C5', re_decision, ok, 6).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 29).
obligation(absent, theory_scoped, \+ is_reachable(b, e)).
steps(26).
verified(19).
recomputed(6).
composed(0).
trusted(1).
claims(3).
verdict(checked_with_obligations).
