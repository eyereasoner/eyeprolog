condition('C1', resolution, ok, 7).
condition('C2', well_founded, ok, 9).
condition('C3', justification, ok, 9).
condition('C4', coverage, ok, 11).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 14).
obligation(builtin, theory_scoped, aggregate_min([A, B], B, (candidate_expression(B), expr_cost(B, A)), [3, add(x, 6)], add(x, 6))).
obligation(builtin, theory_scoped, countall(candidate_expression(A), 32)).
steps(9).
verified(7).
recomputed(0).
composed(0).
trusted(2).
claims(5).
verdict(checked_with_obligations).
