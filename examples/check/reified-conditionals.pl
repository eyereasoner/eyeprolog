condition('C1', resolution, ok, 1).
condition('C2', well_founded, ok, 5).
condition('C3', justification, ok, 5).
condition('C4', coverage, ok, 5).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 6).
obligation(builtin, theory_scoped, tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8])).
obligation(builtin, theory_scoped, tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8], [1, 3, 5, 7])).
obligation(builtin, theory_scoped, if_(even_t(4), even = even, even = odd)).
obligation(builtin, theory_scoped, if_(even_t(7), odd = even, odd = odd)).
steps(5).
verified(1).
recomputed(0).
composed(0).
trusted(4).
claims(1).
verdict(checked_with_obligations).
