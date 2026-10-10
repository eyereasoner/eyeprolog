condition('C1', resolution, ok, 181).
condition('C2', well_founded, ok, 188).
condition('C3', justification, ok, 188).
condition('C4', coverage, ok, 287).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 6).
condition('C7', relevance, ok, 305).
obligation(absent, theory_scoped, \+ prohibition_match(scenarioA)).
obligation(absent, theory_scoped, \+ prohibition_match(scenarioE)).
obligation(absent, theory_scoped, \+ prohibition_match(scenarioB)).
obligation(absent, theory_scoped, \+ subject_opt_out(scenarioF)).
obligation(absent, theory_scoped, \+ prohibition_match(scenarioF)).
obligation(absent, theory_scoped, \+ permission_match(scenarioC)).
obligation(absent, theory_scoped, \+ prohibition_match(scenarioC)).
steps(188).
verified(181).
recomputed(0).
composed(0).
trusted(7).
claims(117).
verdict(checked_with_obligations).
