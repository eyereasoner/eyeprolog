condition('C1', resolution, ok, 28).
condition('C2', well_founded, ok, 37).
condition('C3', justification, ok, 37).
condition('C4', coverage, ok, 42).
condition('C5', re_decision, ok, 2).
obligation(absent, theory_scoped, \+ known_var([bind(x, const(10))], y, __anon3)).
obligation(absent, theory_scoped, \+ (const(10) = const(_A), var(y) = const(_B))).
obligation(absent, theory_scoped, \+ (mul(const(10), var(y)) = const(_A), const(13) = const(_B))).
obligation(absent, theory_scoped, \+ known_var([bind(x, const(10))], flag, __anon3)).
obligation(absent, theory_scoped, \+ var(flag) = bool(true)).
obligation(absent, theory_scoped, \+ var(flag) = bool(false)).
obligation(absent, theory_scoped, \+ (var(y) = const(_A), const(2) = const(_B))).
steps(37).
verified(28).
recomputed(2).
composed(0).
trusted(7).
claims(4).
verdict(checked_with_obligations).
