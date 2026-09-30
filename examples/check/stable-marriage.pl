condition('C1', resolution, ok, 9).
condition('C2', well_founded, ok, 16).
condition('C3', justification, ok, 16).
condition('C4', coverage, ok, 16).
condition('C5', re_decision, ok, 5).
obligation(absent, theory_scoped, \+ blocking_pair([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)], _man, _woman)).
obligation(builtin, theory_scoped, countall(stable_matching(_matching), 1)).
steps(16).
verified(9).
recomputed(4).
composed(1).
trusted(2).
claims(2).
verdict(checked_with_obligations).
