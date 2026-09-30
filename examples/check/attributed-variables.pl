condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 10).
condition('C3', justification, ok, 10).
condition('C4', coverage, ok, 10).
condition('C5', re_decision, ok, 3).
obligation(builtin, stateful, put_atts(Variable, required(7))).
obligation(builtin, stateful, put_atts(Variable, required(ready))).
obligation(builtin, stateful, get_atts(Y, required(ready))).
steps(10).
verified(4).
recomputed(3).
composed(0).
trusted(3).
claims(2).
verdict(checked_with_obligations).
