condition('C1', resolution, ok, 13).
condition('C2', well_founded, ok, 15).
condition('C3', justification, ok, 15).
condition('C4', coverage, ok, 15).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 2).
condition('C7', relevance, ok, 19).
obligation(absent, theory_scoped, \+ does(alice, work_related_task)).
obligation(absent, theory_scoped, \+ does(dave, log_off_at_end_of_shift)).
steps(15).
verified(13).
recomputed(0).
composed(0).
trusted(2).
claims(4).
verdict(checked_with_obligations).
