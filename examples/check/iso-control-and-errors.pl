condition('C1', resolution, ok, 11).
condition('C2', well_founded, ok, 20).
condition('C3', justification, ok, 20).
condition('C4', coverage, ok, 22).
condition('C5', re_decision, ok, 7).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 25).
obligation(absent, theory_scoped, \+ call(route(antwerp, paris))).
obligation(builtin, theory_scoped, catch((require_route(antwerp, paris), rejected = accepted), no_route(antwerp, paris), rejected = rejected)).
steps(20).
verified(11).
recomputed(3).
composed(4).
trusted(2).
claims(5).
verdict(checked_with_obligations).
