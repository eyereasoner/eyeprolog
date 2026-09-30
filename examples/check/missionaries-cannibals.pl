condition('C1', resolution, ok, 53).
condition('C2', well_founded, ok, 97).
condition('C3', justification, ok, 97).
condition('C4', coverage, ok, 166).
condition('C5', re_decision, ok, 32).
obligation(absent, theory_scoped, \+ member(state(3, 1, right), [state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(3, 2, left), [state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(3, 0, right), [state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(3, 1, left), [state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(1, 1, right), [state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(2, 2, left), [state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(0, 2, right), [state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(0, 3, left), [state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(0, 1, right), [state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(1, 1, left), [state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(absent, theory_scoped, \+ member(state(0, 0, right), [state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])).
obligation(builtin, theory_scoped, countall(state_safe(state(_m, _c, _boat)), 10)).
steps(97).
verified(53).
recomputed(31).
composed(1).
trusted(12).
claims(3).
verdict(checked_with_obligations).
