condition('C1', resolution, ok, 11).
condition('C2', well_founded, ok, 16).
condition('C3', justification, ok, 16).
condition('C4', coverage, ok, 17).
condition('C5', re_decision, ok, 2).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 21).
obligation(builtin, theory_scoped, (call(route(antwerp, ghent)) -> connected = connected ; connected = disconnected)).
obligation(builtin, theory_scoped, (call(route(antwerp, paris)) -> disconnected = connected ; disconnected = disconnected)).
obligation(builtin, theory_scoped, catch((require_route(antwerp, paris), rejected = accepted), no_route(antwerp, paris), rejected = rejected)).
steps(16).
verified(11).
recomputed(1).
composed(1).
trusted(3).
claims(5).
verdict(checked_with_obligations).
