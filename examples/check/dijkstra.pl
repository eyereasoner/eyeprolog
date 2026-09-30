condition('C1', resolution, ok, 121).
condition('C2', well_founded, ok, 167).
condition('C3', justification, ok, 167).
condition('C4', coverage, ok, 223).
condition('C5', re_decision, ok, 29).
obligation(absent, theory_scoped, \+ member(b, "a")).
obligation(absent, theory_scoped, \+ member(d, "ba")).
obligation(absent, theory_scoped, \+ member(e, "dba")).
obligation(absent, theory_scoped, \+ member(f, "edba")).
obligation(absent, theory_scoped, \+ member(f, "dba")).
obligation(absent, theory_scoped, \+ member(c, "a")).
obligation(absent, theory_scoped, \+ member(d, "ca")).
obligation(absent, theory_scoped, \+ member(e, "dca")).
obligation(absent, theory_scoped, \+ member(f, "edca")).
obligation(absent, theory_scoped, \+ member(f, "dca")).
obligation(absent, theory_scoped, \+ member(e, "ca")).
obligation(absent, theory_scoped, \+ member(f, "eca")).
obligation(absent, theory_scoped, \+ member(b, "ca")).
obligation(absent, theory_scoped, \+ member(d, "bca")).
obligation(absent, theory_scoped, \+ member(e, "dbca")).
obligation(absent, theory_scoped, \+ member(f, "edbca")).
obligation(absent, theory_scoped, \+ member(f, "dbca")).
steps(167).
verified(121).
recomputed(29).
composed(0).
trusted(17).
claims(16).
verdict(checked_with_obligations).
