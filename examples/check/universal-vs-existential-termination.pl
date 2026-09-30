condition('C1', resolution, ok, 1).
condition('C2', well_founded, ok, 7).
condition('C3', justification, ok, 7).
condition('C4', coverage, ok, 7).
condition('C5', re_decision, ok, 5).
obligation(collected, theory_scoped, findall(X - Y, append(X, Y, "abc"), [[] - "abc", "a" - "bc", "ab" - "c", "abc" - []])).
steps(7).
verified(1).
recomputed(5).
composed(0).
trusted(1).
claims(1).
verdict(checked_with_obligations).
