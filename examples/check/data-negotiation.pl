condition('C1', resolution, ok, 8).
condition('C2', well_founded, ok, 12).
condition('C3', justification, ok, 12).
condition('C4', coverage, ok, 14).
condition('C5', re_decision, ok, 3).
obligation(absent, theory_scoped, \+ member(data4, [data1, data2, data3])).
steps(12).
verified(8).
recomputed(3).
composed(0).
trusted(1).
claims(1).
verdict(checked_with_obligations).
