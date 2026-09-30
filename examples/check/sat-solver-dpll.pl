condition('C1', resolution, ok, 36).
condition('C2', well_founded, ok, 42).
condition('C3', justification, ok, 42).
condition('C4', coverage, ok, 57).
condition('C5', re_decision, ok, 5).
obligation(builtin, theory_scoped, aggregate_min(Key, Value, (satisfying_model(Value), model_rank(Value, Key)), 7, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])).
steps(42).
verified(36).
recomputed(5).
composed(0).
trusted(1).
claims(11).
verdict(checked_with_obligations).
