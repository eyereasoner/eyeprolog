condition('C1', resolution, ok, 3).
condition('C2', well_founded, ok, 6).
condition('C3', justification, ok, 6).
condition('C4', coverage, ok, 7).
condition('C5', re_decision, ok, 2).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 8).
obligation(collected, theory_scoped, findall(A, combination(3, [1, 2, 3, 4, 5], A), [[1, 2, 3], [1, 2, 4], [1, 2, 5], [1, 2, 3], [1, 3, 4], [1, 3, 5], [1, 2, 4], [1, 3, 4], [1, 4, 5], [1, 2, 5], [1, 3, 5], [1, 4, 5], [1, 2, 3], [1, 2, 4], [1, 2, 5], [1, 2, 3], [2, 3, 4], [2, 3, 5], [1, 2, 4], [2, 3, 4], [2, 4, 5], [1, 2, 5], [2, 3, 5], [2, 4, 5], [1, 2, 3], [1, 3, 4], [1, 3, 5], [1, 2, 3], [2, 3, 4], [2, 3, 5], [1, 3, 4], [2, 3, 4], [3, 4, 5], [1, 3, 5], [2, 3, 5], [3, 4, 5], [1, 2, 4], [1, 3, 4], [1, 4, 5], [1, 2, 4], [2, 3, 4], [2, 4, 5], [1, 3, 4], [2, 3, 4], [3, 4, 5], [1, 4, 5], [2, 4, 5], [3, 4, 5], [1, 2, 5], [1, 3, 5], [1, 4, 5], [1, 2, 5], [2, 3, 5], [2, 4, 5], [1, 3, 5], [2, 3, 5], [3, 4, 5], [1, 4, 5], [2, 4, 5], [3, 4, 5]])).
steps(6).
verified(3).
recomputed(2).
composed(0).
trusted(1).
claims(2).
verdict(checked_with_obligations).
