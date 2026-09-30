condition('C1', resolution, ok, 5).
condition('C2', well_founded, ok, 7).
condition('C3', justification, ok, 7).
condition('C4', coverage, ok, 9).
condition('C5', re_decision, ok, 0).
obligation(builtin, theory_scoped, aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15))).
obligation(builtin, theory_scoped, countall(feasible_pack(_pack, _weight, _value), 113)).
steps(7).
verified(5).
recomputed(0).
composed(0).
trusted(2).
claims(4).
verdict(checked_with_obligations).
