condition('C1', resolution, ok, 7).
condition('C2', well_founded, ok, 15).
condition('C3', justification, ok, 15).
condition('C4', coverage, ok, 17).
condition('C5', re_decision, ok, 6).
obligation(builtin, theory_scoped, sumall(Expression, (between(0, 11, I), J is 11 - I, catalan(I, A), catalan(J, B), Expression is A * B), 208012)).
obligation(builtin, theory_scoped, sumall(Expression, (between(0, 9, N), catalan(N, Expression)), 6918)).
steps(15).
verified(7).
recomputed(6).
composed(0).
trusted(2).
claims(4).
verdict(checked_with_obligations).
