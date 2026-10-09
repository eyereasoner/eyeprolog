condition('C1', resolution, ok, 37).
condition('C2', well_founded, ok, 84).
condition('C3', justification, ok, 84).
condition('C4', coverage, ok, 158).
condition('C5', re_decision, ok, 38).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 89).
obligation(absent, theory_scoped, \+ (interval(A, B, C, D), A > 8, B >= 11)).
obligation(absent, theory_scoped, \+ (interval(A, B, C, D), A > 7, B >= 10)).
obligation(absent, theory_scoped, \+ (interval(A, B, C, D), A > 6, B >= 9)).
obligation(absent, theory_scoped, \+ (interval(A, B, C, D), A > 5, B >= 9)).
obligation(builtin, theory_scoped, aggregate_min(A, A, (interval(A, B, C, D), A > 4, B >= 7), 8, 8)).
obligation(builtin, theory_scoped, aggregate_min(A, A, (interval(A, B, C, D), A > 3, B >= 6), 7, 7)).
obligation(builtin, theory_scoped, aggregate_min(A, A, (interval(A, B, C, D), A > 2, B >= 5), 6, 6)).
obligation(builtin, theory_scoped, aggregate_min(A, A, (interval(A, B, C, D), A > 1, B >= 4), 4, 4)).
obligation(builtin, theory_scoped, countall(interval(A, B, C, D), 8)).
steps(84).
verified(37).
recomputed(38).
composed(0).
trusted(9).
claims(5).
verdict(checked_with_obligations).
