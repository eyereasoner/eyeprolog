condition('C1', resolution, ok, 15).
condition('C2', well_founded, ok, 17).
condition('C3', justification, ok, 17).
condition('C4', coverage, ok, 18).
condition('C5', re_decision, ok, 0).
obligation(absent, theory_scoped, \+ box_counterexample(w0, atom(clear))).
obligation(absent, theory_scoped, \+ mforces(w0, box(atom(repaired)))).
steps(17).
verified(15).
recomputed(0).
composed(0).
trusted(2).
claims(4).
verdict(checked_with_obligations).
