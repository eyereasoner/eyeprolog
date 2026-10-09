condition('C1', resolution, ok, 12).
condition('C2', well_founded, ok, 21).
condition('C3', justification, ok, 21).
condition('C4', coverage, ok, 22).
condition('C5', re_decision, ok, 4).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 26).
obligation(collected, theory_scoped, findall(A, sale(B, C, A), [7, 7, 5, 9])).
obligation(builtin, theory_scoped, bagof(A, B ^ sale(north, B, A), [7, 7, 5])).
obligation(builtin, theory_scoped, bagof(A, B ^ sale(south, B, A), [9])).
obligation(builtin, theory_scoped, setof(A, B ^ C ^ sale(A, B, C), [north, south])).
obligation(builtin, reflective, clause(sale(north, ada, 7), true)).
steps(21).
verified(12).
recomputed(4).
composed(0).
trusted(5).
claims(5).
verdict(checked_with_obligations).
