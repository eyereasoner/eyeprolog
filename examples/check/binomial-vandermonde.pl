condition('C1', resolution, ok, 59).
condition('C2', well_founded, ok, 206).
condition('C3', justification, ok, 206).
condition('C4', coverage, ok, 291).
condition('C5', re_decision, ok, 145).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 210).
obligation(builtin, theory_scoped, sumall(A, (between(0, 8, B), C is 8 - B, choose(12, B, D), choose(10, C, E), A is D * E), 319770.0)).
obligation(builtin, theory_scoped, sumall(A, (between(0, 12, B), choose(12, B, A)), 4096.0)).
steps(206).
verified(59).
recomputed(145).
composed(0).
trusted(2).
claims(4).
verdict(checked_with_obligations).
