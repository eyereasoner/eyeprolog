condition('C1', resolution, ok, 6).
condition('C2', well_founded, ok, 12).
condition('C3', justification, ok, 12).
condition('C4', coverage, ok, 12).
condition('C5', re_decision, ok, 1).
obligation(builtin, theory_scoped, forall(color(Color), atom(Color))).
obligation(collected, theory_scoped, findall(N - S, (cfor(1, 3, N), succ(N, S)), [1 - 2, 2 - 3, 3 - 4])).
obligation(builtin, theory_scoped, findall(Template, color(Template), [red, green, blue, done], [done])).
obligation(absent, theory_scoped, \+ variant(tree(X, X), tree(__anon0, _Y))).
obligation(builtin, theory_scoped, countall(color(__anon1), 3)).
steps(12).
verified(6).
recomputed(1).
composed(0).
trusted(5).
claims(6).
verdict(checked_with_obligations).
