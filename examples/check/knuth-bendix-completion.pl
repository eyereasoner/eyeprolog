condition('C1', resolution, ok, 47).
condition('C2', well_founded, ok, 61).
condition('C3', justification, ok, 61).
condition('C4', coverage, ok, 66).
condition('C5', re_decision, ok, 9).
condition('C6', boundary_consistency, ok, 3).
condition('C7', relevance, ok, 68).
obligation(absent, theory_scoped, \+ rewrite_once(append(a, append(b, c)), A, B)).
obligation(absent, theory_scoped, \+ rewrite_once(append(a, b), A, B)).
obligation(absent, theory_scoped, \+ rewrite_once(append(a, append(b, append(c, d))), A, B)).
obligation(builtin, theory_scoped, countall(oriented_rule(A, B, C), 3)).
obligation(builtin, theory_scoped, countall(joined_pair(A), 3)).
steps(61).
verified(47).
recomputed(0).
composed(9).
trusted(5).
claims(7).
verdict(checked_with_obligations).
