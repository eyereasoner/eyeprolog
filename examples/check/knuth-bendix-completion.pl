condition('C1', resolution, ok, 47).
condition('C2', well_founded, ok, 52).
condition('C3', justification, ok, 52).
condition('C4', coverage, ok, 57).
condition('C5', re_decision, ok, 0).
obligation(absent, theory_scoped, \+ rewrite_once(append(a, append(b, c)), __anon0, __anon1)).
obligation(absent, theory_scoped, \+ rewrite_once(append(a, b), __anon0, __anon1)).
obligation(absent, theory_scoped, \+ rewrite_once(append(a, append(b, append(c, d))), __anon0, __anon1)).
obligation(builtin, theory_scoped, countall(oriented_rule(__anon3, __anon4, __anon5), 3)).
obligation(builtin, theory_scoped, countall(joined_pair(__anon6), 3)).
steps(52).
verified(47).
recomputed(0).
composed(0).
trusted(5).
claims(7).
verdict(checked_with_obligations).
