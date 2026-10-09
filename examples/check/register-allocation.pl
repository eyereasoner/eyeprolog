condition('C1', resolution, ok, 19).
condition('C2', well_founded, ok, 21).
condition('C3', justification, ok, 21).
condition('C4', coverage, ok, 27).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 29).
obligation(builtin, theory_scoped, aggregate_min([A, B], B, (valid_allocation(B), allocation_cost(B, A)), [1, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]], [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)])).
obligation(builtin, theory_scoped, countall(valid_allocation(A), 33)).
steps(21).
verified(19).
recomputed(0).
composed(0).
trusted(2).
claims(8).
verdict(checked_with_obligations).
