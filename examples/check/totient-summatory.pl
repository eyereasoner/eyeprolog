condition('C1', resolution, ok, 8).
condition('C2', well_founded, ok, 15).
condition('C3', justification, ok, 15).
condition('C4', coverage, ok, 15).
condition('C5', re_decision, ok, 3).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 19).
obligation(builtin, theory_scoped, countall(coprime_upto(36, A), 12)).
obligation(builtin, theory_scoped, countall(coprime_upto(97, A), 96)).
obligation(builtin, theory_scoped, countall(coprime_upto(84, A), 24)).
obligation(builtin, theory_scoped, sumall(A, (between(1, 30, B), totient(B, A)), 278)).
steps(15).
verified(8).
recomputed(3).
composed(0).
trusted(4).
claims(4).
verdict(checked_with_obligations).
