condition('C1', resolution, ok, 57).
condition('C2', well_founded, ok, 71).
condition('C3', justification, ok, 71).
condition('C4', coverage, ok, 92).
condition('C5', re_decision, ok, 10).
obligation(builtin, theory_scoped, countall(span(command, s, 0, 5), 1)).
obligation(builtin, theory_scoped, countall(span(ambiguous_pp, s, 0, 8), 1)).
obligation(builtin, theory_scoped, countall(span(command, np, _start, _end), 2)).
obligation(builtin, theory_scoped, countall(span(ambiguous_pp, np, _start, _end), 4)).
steps(71).
verified(57).
recomputed(10).
composed(0).
trusted(4).
claims(6).
verdict(checked_with_obligations).
