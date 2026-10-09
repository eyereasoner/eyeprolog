condition('C1', resolution, ok, 9).
condition('C2', well_founded, ok, 18).
condition('C3', justification, ok, 18).
condition('C4', coverage, ok, 18).
condition('C5', re_decision, ok, 4).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 23).
obligation(builtin, stateful, sat(0 =:= 0 * ~ 0 + ~ 0 * 0)).
obligation(builtin, stateful, sat(0 =:= 1 * ~ 1 + ~ 1 * 1)).
obligation(builtin, stateful, sat(1 =:= 0 * ~ 1 + ~ 0 * 1)).
obligation(builtin, stateful, sat(1 =:= 1 * ~ 0 + ~ 1 * 0)).
obligation(builtin, stateful, taut(x # y =:= x * ~ y + ~ x * y, 1)).
steps(18).
verified(9).
recomputed(4).
composed(0).
trusted(5).
claims(5).
verdict(checked_with_obligations).
