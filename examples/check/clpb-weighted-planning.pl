condition('C1', resolution, ok, 1).
condition('C2', well_founded, ok, 3).
condition('C3', justification, ok, 3).
condition('C4', coverage, ok, 3).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 4).
obligation(builtin, stateful, sat(card([0, 1, 2], [1, 0, 0, 1]) * (1 =< 1) * (0 =< 0))).
obligation(builtin, stateful, weighted_maximum([7, 4, 3, 6], [1, 0, 0, 1], 13)).
steps(3).
verified(1).
recomputed(0).
composed(0).
trusted(2).
claims(1).
verdict(checked_with_obligations).
