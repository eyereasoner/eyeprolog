condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 9).
condition('C3', justification, ok, 9).
condition('C4', coverage, ok, 10).
condition('C5', re_decision, ok, 2).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 11).
obligation(builtin, stateful, put_atts(7, required(7))).
obligation(builtin, stateful, put_atts(ready, required(ready))).
obligation(builtin, stateful, get_atts(ready, required(ready))).
steps(9).
verified(4).
recomputed(2).
composed(0).
trusted(3).
claims(2).
verdict(checked_with_obligations).
