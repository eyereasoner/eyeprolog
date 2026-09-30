condition('C1', resolution, ok, 59).
condition('C2', well_founded, ok, 206).
condition('C3', justification, ok, 206).
condition('C4', coverage, ok, 291).
condition('C5', re_decision, ok, 145).
obligation(builtin, theory_scoped, sumall(Expression, (between(0, 8, K), Rk is 8 - K, choose(12, K, A), choose(10, Rk, B), Expression is A * B), 319770.0)).
obligation(builtin, theory_scoped, sumall(Expression, (between(0, 12, K), choose(12, K, Expression)), 4096.0)).
steps(206).
verified(59).
recomputed(145).
composed(0).
trusted(2).
claims(4).
verdict(checked_with_obligations).
