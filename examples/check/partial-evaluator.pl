condition('C1', resolution, ok, 28).
condition('C2', well_founded, ok, 37).
condition('C3', justification, ok, 37).
condition('C4', coverage, ok, 42).
condition('C5', re_decision, ok, 2).
condition('C6', boundary_consistency, ok, 4).
condition('C7', relevance, ok, 41).
obligation(absent, theory_scoped, \+ known_var([bind(x, const(10))], y, A)).
obligation(absent, theory_scoped, \+ (const(10) = const(A), var(y) = const(B))).
obligation(absent, theory_scoped, \+ (mul(const(10), var(y)) = const(A), const(13) = const(B))).
obligation(absent, theory_scoped, \+ known_var([bind(x, const(10))], flag, A)).
obligation(absent, theory_scoped, \+ var(flag) = bool(true)).
obligation(absent, theory_scoped, \+ var(flag) = bool(false)).
obligation(absent, theory_scoped, \+ (var(y) = const(A), const(2) = const(B))).
steps(37).
verified(28).
recomputed(2).
composed(0).
trusted(7).
claims(4).
verdict(checked_with_obligations).
