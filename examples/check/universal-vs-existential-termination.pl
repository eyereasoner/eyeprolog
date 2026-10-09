condition('C1', resolution, ok, 1).
condition('C2', well_founded, ok, 7).
condition('C3', justification, ok, 7).
condition('C4', coverage, ok, 7).
condition('C5', re_decision, ok, 5).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 8).
obligation(collected, theory_scoped, findall(A - B, append(A, B, "abc"), [[] - "abc", "a" - "bc", "ab" - "c", "abc" - []])).
steps(7).
verified(1).
recomputed(4).
composed(1).
trusted(1).
claims(1).
verdict(checked_with_obligations).
