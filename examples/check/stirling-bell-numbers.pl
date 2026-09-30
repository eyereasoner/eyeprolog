condition('C1', resolution, ok, 14).
condition('C2', well_founded, ok, 39).
condition('C3', justification, ok, 39).
condition('C4', coverage, ok, 44).
condition('C5', re_decision, ok, 21).
obligation(builtin, theory_scoped, sumall(Expression, (between(0, 4, I), signed_term(10, 4, I, Expression)), 818520.0)).
obligation(builtin, theory_scoped, sumall(Expression, (between(0, 5, I), signed_term(12, 5, I, Expression)), 165528000.0)).
obligation(builtin, theory_scoped, sumall(Expression, (between(0, 9, K), binomial(9, K, Choose), bell(K, Bell), Expression is Choose * Bell), 115975)).
obligation(builtin, theory_scoped, sumall(Expression, (between(0, 11, K), binomial(11, K, Choose), bell(K, Bell), Expression is Choose * Bell), 4213597)).
steps(39).
verified(14).
recomputed(21).
composed(0).
trusted(4).
claims(4).
verdict(checked_with_obligations).
