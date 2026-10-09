condition('C1', resolution, ok, 5).
condition('C2', well_founded, ok, 10).
condition('C3', justification, ok, 10).
condition('C4', coverage, ok, 10).
condition('C5', re_decision, ok, 2).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 13).
obligation(builtin, stateful, sat(card([2], [0, 0, 1, 1]) * (0 =< 1) * (0 # 1))).
obligation(builtin, stateful, sat(card([2], [0, 1, 1, 0]) * (0 =< 1) * (1 # 0))).
obligation(builtin, stateful, sat_count(card([2], [A, B, C, D]) * (A =< C) * (B # D), 2)).
steps(10).
verified(5).
recomputed(2).
composed(0).
trusted(3).
claims(3).
verdict(checked_with_obligations).
