condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 7).
condition('C3', justification, ok, 7).
condition('C4', coverage, ok, 7).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 10).
obligation(collected, theory_scoped, findall(A, prime(A), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29])).
obligation(builtin, theory_scoped, countall(prime(A), 10)).
obligation(builtin, theory_scoped, countall(coprime(271, A), 270)).
steps(7).
verified(4).
recomputed(0).
composed(0).
trusted(3).
claims(3).
verdict(checked_with_obligations).
