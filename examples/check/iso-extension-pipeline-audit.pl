condition('C1', resolution, ok, 2).
condition('C2', well_founded, ok, 8).
condition('C3', justification, ok, 8).
condition('C4', coverage, ok, 8).
condition('C5', re_decision, ok, 1).
obligation(builtin, theory_scoped, countall(stage(__anon0, __anon1), 5)).
obligation(builtin, theory_scoped, countall(transition(__anon2, __anon3, __anon4), 4)).
obligation(collected, theory_scoped, findall(stage(Index, Name, outgoing(Outgoing)), (cfor(0, 4, Index), stage(Index, Name), countall(transition(Index, __anon5, __anon6), Outgoing)), [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))])).
obligation(builtin, theory_scoped, findall(step(Index, From, To), transition(Index, From, To), [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete], [complete])).
obligation(builtin, theory_scoped, forall(transition(Index, From, To), transition_is_well_formed(Index, From, To))).
steps(8).
verified(2).
recomputed(1).
composed(0).
trusted(5).
claims(1).
verdict(checked_with_obligations).
