condition('C1', resolution, ok, 48).
condition('C2', well_founded, ok, 62).
condition('C3', justification, ok, 62).
condition('C4', coverage, ok, 94).
condition('C5', re_decision, ok, 2).
condition('C6', boundary_consistency, ok, 12).
condition('C7', relevance, ok, 65).
obligation(absent, theory_scoped, \+ member("ewew", ["wwww"])).
obligation(absent, theory_scoped, \+ member("wwew", ["ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("eeew", ["wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("weww", ["eeew", "wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("eewe", ["weww", "eeew", "wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("wewe", ["eewe", "weww", "eeew", "wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("eeee", ["wewe", "eewe", "weww", "eeew", "wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("ewee", ["wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("wwwe", ["ewee", "wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("eewe", ["wwwe", "ewee", "wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("wewe", ["eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"])).
obligation(absent, theory_scoped, \+ member("eeee", ["wewe", "eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"])).
steps(62).
verified(48).
recomputed(2).
composed(0).
trusted(12).
claims(3).
verdict(checked_with_obligations).
