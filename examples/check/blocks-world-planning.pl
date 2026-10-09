condition('C1', resolution, ok, 37).
condition('C2', well_founded, ok, 90).
condition('C3', justification, ok, 90).
condition('C4', coverage, ok, 96).
condition('C5', re_decision, ok, 40).
condition('C6', boundary_consistency, ok, 6).
condition('C7', relevance, ok, 94).
obligation(absent, theory_scoped, \+ member(on(A, e), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)])).
obligation(absent, theory_scoped, \+ member([on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]])).
obligation(absent, theory_scoped, \+ member(on(A, d), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)])).
obligation(absent, theory_scoped, \+ member([on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]])).
obligation(absent, theory_scoped, \+ member(on(A, c), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)])).
obligation(absent, theory_scoped, \+ member([on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]])).
obligation(absent, theory_scoped, \+ member(on(A, d), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)])).
obligation(absent, theory_scoped, \+ member(on(A, c), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)])).
obligation(absent, theory_scoped, \+ member([on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [[on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]])).
obligation(absent, theory_scoped, \+ member(on(A, e), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)])).
obligation(absent, theory_scoped, \+ member(on(A, d), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)])).
obligation(absent, theory_scoped, \+ member([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]])).
obligation(collected, theory_scoped, findall(A, block(A), "abcde")).
steps(90).
verified(37).
recomputed(39).
composed(1).
trusted(13).
claims(4).
verdict(checked_with_obligations).
