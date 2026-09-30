condition('C1', resolution, ok, 10).
condition('C2', well_founded, ok, 12).
condition('C3', justification, ok, 12).
condition('C4', coverage, ok, 17).
condition('C5', re_decision, ok, 0).
obligation(absent, theory_scoped, \+ (allOf(policy_x, Claim), \+ has(test1, Claim))).
obligation(absent, theory_scoped, \+ (noneOf(policy_x, Claim), has(test1, Claim))).
steps(12).
verified(10).
recomputed(0).
composed(0).
trusted(2).
claims(2).
verdict(checked_with_obligations).
