condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 6).
condition('C3', justification, ok, 6).
condition('C4', coverage, ok, 7).
condition('C5', re_decision, ok, 0).
obligation(builtin, theory_scoped, aggregate_min(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)], feasible_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), 9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])).
obligation(builtin, theory_scoped, countall(feasible_schedule(_makespan, _schedule), 35)).
steps(6).
verified(4).
recomputed(0).
composed(0).
trusted(2).
claims(3).
verdict(checked_with_obligations).
