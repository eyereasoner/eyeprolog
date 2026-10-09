condition('C1', resolution, ok, 19).
condition('C2', well_founded, ok, 26).
condition('C3', justification, ok, 26).
condition('C4', coverage, ok, 26).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 6).
condition('C7', relevance, ok, 29).
obligation(absent, theory_scoped, \+ member(b, "a")).
obligation(absent, theory_scoped, \+ member(d, "ba")).
obligation(absent, theory_scoped, \+ member(f, "dba")).
obligation(absent, theory_scoped, \+ member(e, "c")).
obligation(absent, theory_scoped, \+ member(f, "ec")).
obligation(absent, theory_scoped, \+ member(g, "fec")).
obligation(absent, theory_scoped, \+ is_reachable(b, e)).
steps(26).
verified(19).
recomputed(0).
composed(0).
trusted(7).
claims(3).
verdict(checked_with_obligations).
