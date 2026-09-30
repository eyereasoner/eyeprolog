condition('C1', resolution, ok, 18).
condition('C2', well_founded, ok, 28).
condition('C3', justification, ok, 28).
condition('C4', coverage, ok, 28).
condition('C5', re_decision, ok, 4).
obligation(builtin, theory_scoped, phrase(expression(add(lit(2), mul(lit(3), sub(lit(4), lit(1))))), [2, +, 3, *, '(', 4, -, 1, ')'])).
obligation(builtin, theory_scoped, phrase(expression(sub(mul(var(x), add(var(y), lit(2))), var(z))), [x, *, '(', y, +, 2|")-z"])).
obligation(builtin, theory_scoped, phrase(emit_expression(sub(lit(20), sub(lit(5), lit(3)))), [20, -, '(', 5, -, 3, ')'])).
obligation(builtin, theory_scoped, phrase(expression(sub(lit(20), sub(lit(5), lit(3)))), [20, -, '(', 5, -, 3, ')'])).
obligation(builtin, theory_scoped, phrase(expression(mul(var(x), lit(2))), [x, *, 2, then, stop], [then, stop])).
obligation(absent, theory_scoped, \+ phrase(expression(__anon14), [2, *, '(', 3, +, 4])).
steps(28).
verified(18).
recomputed(4).
composed(0).
trusted(6).
claims(5).
verdict(checked_with_obligations).
