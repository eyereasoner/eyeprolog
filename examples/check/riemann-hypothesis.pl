condition('C1', resolution, ok, 34).
condition('C2', well_founded, ok, 40).
condition('C3', justification, ok, 40).
condition('C4', coverage, ok, 57).
condition('C5', re_decision, ok, 2).
condition('C6', boundary_consistency, ok, 3).
condition('C7', relevance, ok, 52).
obligation(absent, theory_scoped, \+ trivial_zero(z1)).
obligation(absent, theory_scoped, \+ counterexample_found(yes)).
obligation(absent, theory_scoped, \+ trivial_zero(z2)).
obligation(absent, theory_scoped, \+ trivial_zero(z3)).
steps(40).
verified(34).
recomputed(2).
composed(0).
trusted(4).
claims(12).
verdict(checked_with_obligations).
