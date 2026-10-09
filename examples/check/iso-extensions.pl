condition('C1', resolution, ok, 6).
condition('C2', well_founded, ok, 12).
condition('C3', justification, ok, 12).
condition('C4', coverage, ok, 12).
condition('C5', re_decision, ok, 1).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 18).
obligation(builtin, theory_scoped, forall(color(A), atom(A))).
obligation(collected, theory_scoped, findall(A - B, (cfor(1, 3, A), succ(A, B)), [1 - 2, 2 - 3, 3 - 4])).
obligation(builtin, theory_scoped, findall(A, color(A), [red, green, blue, done], [done])).
obligation(absent, theory_scoped, \+ variant(tree(A, A), tree(B, C))).
obligation(builtin, theory_scoped, countall(color(A), 3)).
steps(12).
verified(6).
recomputed(1).
composed(0).
trusted(5).
claims(6).
verdict(checked_with_obligations).
