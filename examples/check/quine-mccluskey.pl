condition('C1', resolution, ok, 145).
condition('C2', well_founded, ok, 242).
condition('C3', justification, ok, 242).
condition('C4', coverage, ok, 307).
condition('C5', re_decision, ok, 76).
obligation(asserted, theory_scoped, solution_cache(["00xx", "0xx1", "xx11"], ["00xx", "xx11"])).
obligation(collected, theory_scoped, findall(Part, (member(Pat, ["00xx", "xx11"]), term_sop(Pat, Part)), ['~A~B', 'CD'])).
obligation(collected, theory_scoped, findall(M, minterm(M), [1, 3, 7, 11, 15])).
obligation(collected, theory_scoped, findall(Z, is_true_zero(Z), [4, 6, 8, 9, 10, 12, 13, 14])).
obligation(absent, theory_scoped, \+ covers_int("00xx", 4)).
obligation(absent, theory_scoped, \+ covers_int("xx11", 4)).
obligation(absent, theory_scoped, \+ covers_int("00xx", 6)).
obligation(absent, theory_scoped, \+ covers_int("xx11", 6)).
obligation(absent, theory_scoped, \+ covers_int("00xx", 8)).
obligation(absent, theory_scoped, \+ covers_int("xx11", 8)).
obligation(absent, theory_scoped, \+ covers_int("00xx", 9)).
obligation(absent, theory_scoped, \+ covers_int("xx11", 9)).
obligation(absent, theory_scoped, \+ covers_int("00xx", 10)).
obligation(absent, theory_scoped, \+ covers_int("xx11", 10)).
obligation(absent, theory_scoped, \+ covers_int("00xx", 12)).
obligation(absent, theory_scoped, \+ covers_int("xx11", 12)).
obligation(absent, theory_scoped, \+ covers_int("00xx", 13)).
obligation(absent, theory_scoped, \+ covers_int("xx11", 13)).
obligation(absent, theory_scoped, \+ covers_int("00xx", 14)).
obligation(absent, theory_scoped, \+ covers_int("xx11", 14)).
obligation(collected, theory_scoped, findall(C, (find_combination(2, ["00xx", "0xx1", "xx11"], C), covers_all(C, [1, 3, 7, 11, 15])), [["00xx", "xx11"], ["00xx", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"]])).
steps(242).
verified(145).
recomputed(76).
composed(0).
trusted(21).
claims(7).
verdict(checked_with_obligations).
