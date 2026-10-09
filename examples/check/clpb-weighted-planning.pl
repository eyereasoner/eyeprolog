condition('C1', resolution, ok, 0).
condition('C2', well_founded, ok, 1).
condition('C3', justification, failed(1), 1).
condition('C4', coverage, ok, 1).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 2).
failure('C3', best_release_plan(plan(api(1), cache(0), audit(0), search(1)), 13), 'recorded as unproven').
steps(1).
verified(0).
recomputed(0).
composed(0).
trusted(0).
claims(1).
verdict(failed(1)).
