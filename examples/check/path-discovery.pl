condition('C1', resolution, ok, 42).
condition('C2', well_founded, ok, 80).
condition('C3', justification, ok, 80).
condition('C4', coverage, ok, 118).
condition('C5', re_decision, ok, 31).
obligation(absent, theory_scoped, \+ member(res_airport_309, [res_airport_310])).
obligation(absent, theory_scoped, \+ member(res_airport_1452, [res_airport_309, res_airport_310])).
obligation(absent, theory_scoped, \+ member(res_airport_1587, [res_airport_1452, res_airport_309, res_airport_310])).
obligation(absent, theory_scoped, \+ member(res_airport_1472, [res_airport_309, res_airport_310])).
obligation(absent, theory_scoped, \+ member(res_airport_1587, [res_airport_1472, res_airport_309, res_airport_310])).
obligation(absent, theory_scoped, \+ member(res_airport_3998, [res_airport_309, res_airport_310])).
obligation(absent, theory_scoped, \+ member(res_airport_1587, [res_airport_3998, res_airport_309, res_airport_310])).
steps(80).
verified(42).
recomputed(31).
composed(0).
trusted(7).
claims(3).
verdict(checked_with_obligations).
