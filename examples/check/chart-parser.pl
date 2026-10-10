condition('C1', resolution, ok, 59).
condition('C2', well_founded, ok, 73).
condition('C3', justification, ok, 73).
condition('C4', coverage, ok, 94).
condition('C5', re_decision, ok, 10).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 79).
obligation(builtin, theory_scoped, sumall(A, tree_count(command, s, 0, 5, A), 1)).
obligation(builtin, theory_scoped, sumall(A, tree_count(ambiguous_pp, s, 0, 8, A), 2)).
obligation(builtin, theory_scoped, countall(span(command, np, A, B), 2)).
obligation(builtin, theory_scoped, countall(span(ambiguous_pp, np, A, B), 4)).
steps(73).
verified(59).
recomputed(10).
composed(0).
trusted(4).
claims(6).
verdict(checked_with_obligations).
