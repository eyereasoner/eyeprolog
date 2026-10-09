condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 8).
condition('C3', justification, ok, 8).
condition('C4', coverage, ok, 8).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 12).
obligation(builtin, theory_scoped, phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on])).
obligation(builtin, theory_scoped, phrase(command(set(light(hall), off)), [set, hall, light, to, off])).
obligation(builtin, theory_scoped, phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on, then, wait], [then, wait])).
obligation(absent, theory_scoped, \+ phrase(command(A), [set, garage, light, to, blinking])).
steps(8).
verified(4).
recomputed(0).
composed(0).
trusted(4).
claims(4).
verdict(checked_with_obligations).
