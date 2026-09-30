condition('C1', resolution, ok, 30).
condition('C2', well_founded, ok, 38).
condition('C3', justification, ok, 38).
condition('C4', coverage, ok, 50).
condition('C5', re_decision, ok, 0).
obligation(absent, theory_scoped, \+ duplicate_sdc_path(1, 1, path(false, false, true))).
obligation(absent, theory_scoped, \+ duplicate_sdc_path(3, 3, path(false, false, false))).
obligation(absent, theory_scoped, \+ duplicate_sdc_path(0, 0, path(true, true, true))).
obligation(absent, theory_scoped, \+ duplicate_sdc_path(2, 2, path(true, true, false))).
obligation(absent, theory_scoped, \+ sdcoding(0, 1)).
obligation(absent, theory_scoped, \+ sdcoding(1, 0)).
obligation(absent, theory_scoped, \+ sdcoding(2, 3)).
obligation(absent, theory_scoped, \+ sdcoding(3, 2)).
steps(38).
verified(30).
recomputed(0).
composed(0).
trusted(8).
claims(6).
verdict(checked_with_obligations).
