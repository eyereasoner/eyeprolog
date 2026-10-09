condition('C1', resolution, ok, 14).
condition('C2', well_founded, ok, 39).
condition('C3', justification, ok, 39).
condition('C4', coverage, ok, 44).
condition('C5', re_decision, ok, 21).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 43).
obligation(builtin, theory_scoped, sumall(A, (between(0, 4, B), signed_term(10, 4, B, A)), 818520.0)).
obligation(builtin, theory_scoped, sumall(A, (between(0, 5, B), signed_term(12, 5, B, A)), 165528000.0)).
obligation(builtin, theory_scoped, sumall(A, (between(0, 9, B), binomial(9, B, C), bell(B, D), A is C * D), 115975)).
obligation(builtin, theory_scoped, sumall(A, (between(0, 11, B), binomial(11, B, C), bell(B, D), A is C * D), 4213597)).
steps(39).
verified(14).
recomputed(21).
composed(0).
trusted(4).
claims(4).
verdict(checked_with_obligations).
