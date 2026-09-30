condition('C1', resolution, ok, 75).
condition('C2', well_founded, ok, 84).
condition('C3', justification, ok, 84).
condition('C4', coverage, ok, 86).
condition('C5', re_decision, ok, 6).
obligation(collected, theory_scoped, findall(V, odd_degree(V), [])).
obligation(collected, theory_scoped, findall(V, vertex(V), [v1, v1, v1, v1, v2, v2, v2, v3, v3, v4, v4, v2, v3, v5, v6, v3, v4, v6, v4, v6, v5, v6])).
obligation(collected, theory_scoped, findall(E, edge(E, _a, _b), [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46])).
steps(84).
verified(75).
recomputed(5).
composed(1).
trusted(3).
claims(3).
verdict(checked_with_obligations).
