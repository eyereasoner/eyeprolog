condition('C1', resolution, ok, 19).
condition('C2', well_founded, ok, 26).
condition('C3', justification, ok, 26).
condition('C4', coverage, ok, 33).
condition('C5', re_decision, ok, 4).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 31).
obligation(absent, theory_scoped, \+ collision(g, A, B)).
obligation(absent, theory_scoped, \+ collision(f, A, B)).
obligation(absent, theory_scoped, \+ collision(h, A, B)).
steps(26).
verified(19).
recomputed(4).
composed(0).
trusted(3).
claims(5).
verdict(checked_with_obligations).
