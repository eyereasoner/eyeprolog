condition('C1', resolution, ok, 1).
condition('C2', well_founded, ok, 14).
condition('C3', justification, ok, 14).
condition('C4', coverage, ok, 14).
condition('C5', re_decision, ok, 9).
condition('C6', boundary_consistency, ok, 1).
condition('C7', relevance, ok, 15).
obligation(builtin, stateful, sat(1 * ~ 0)).
obligation(builtin, stateful, reset_gensym(shared)).
obligation(builtin, stateful, gensym(shared, shared1)).
obligation(collected, theory_scoped, findall(A, path(a, A), "bc")).
steps(14).
verified(1).
recomputed(9).
composed(0).
trusted(4).
claims(1).
verdict(checked_with_obligations).
