condition('C1', resolution, ok, 8).
condition('C2', well_founded, ok, 15).
condition('C3', justification, ok, 15).
condition('C4', coverage, ok, 15).
condition('C5', re_decision, ok, 3).
obligation(builtin, theory_scoped, countall(coprime_upto(36, _k), 12)).
obligation(builtin, theory_scoped, countall(coprime_upto(97, _k), 96)).
obligation(builtin, theory_scoped, countall(coprime_upto(84, _k), 24)).
obligation(builtin, theory_scoped, sumall(Expression, (between(1, 30, N), totient(N, Expression)), 278)).
steps(15).
verified(8).
recomputed(3).
composed(0).
trusted(4).
claims(4).
verdict(checked_with_obligations).
