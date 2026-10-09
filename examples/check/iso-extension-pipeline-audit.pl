condition('C1', resolution, ok, 2).
condition('C2', well_founded, ok, 8).
condition('C3', justification, ok, 8).
condition('C4', coverage, ok, 8).
condition('C5', re_decision, ok, 1).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 9).
obligation(builtin, theory_scoped, countall(stage(A, B), 5)).
obligation(builtin, theory_scoped, countall(transition(A, B, C), 4)).
obligation(collected, theory_scoped, findall(stage(A, B, outgoing(C)), (cfor(0, 4, A), stage(A, B), countall(transition(A, D, E), C)), [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))])).
obligation(builtin, theory_scoped, findall(step(A, B, C), transition(A, B, C), [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete], [complete])).
obligation(builtin, theory_scoped, forall(transition(A, B, C), transition_is_well_formed(A, B, C))).
steps(8).
verified(2).
recomputed(1).
composed(0).
trusted(5).
claims(1).
verdict(checked_with_obligations).
