condition('C1', resolution, ok, 21).
condition('C2', well_founded, ok, 38).
condition('C3', justification, ok, 38).
condition('C4', coverage, ok, 45).
condition('C5', re_decision, ok, 10).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 42).
obligation(builtin, theory_scoped, aggregate_min(A, B, (between(1, 6, B), B < 6, cost(1, B, C), D is B + 1, cost(D, 6, E), F is 1 - 1, dim(F, G), dim(B, H), dim(6, I), J is G * H, K is J * I, L is C + E, A is L + K), 15125, 3)).
obligation(builtin, theory_scoped, aggregate_min(A, 3, (between(1, 6, 3), 3 < 6, cost(1, 3, B), C is 3 + 1, cost(C, 6, D), E is 1 - 1, dim(E, F), dim(3, G), dim(6, H), I is F * G, J is I * H, K is B + D, A is K + J), 15125, 3)).
obligation(builtin, theory_scoped, aggregate_min(A, 1, (between(1, 3, 1), 1 < 3, cost(1, 1, B), C is 1 + 1, cost(C, 3, D), E is 1 - 1, dim(E, F), dim(1, G), dim(3, H), I is F * G, J is I * H, K is B + D, A is K + J), 7875, 1)).
obligation(builtin, theory_scoped, aggregate_min(A, 2, (between(2, 3, 2), 2 < 3, cost(2, 2, B), C is 2 + 1, cost(C, 3, D), E is 2 - 1, dim(E, F), dim(2, G), dim(3, H), I is F * G, J is I * H, K is B + D, A is K + J), 2625, 2)).
obligation(builtin, theory_scoped, aggregate_min(A, 5, (between(4, 6, 5), 5 < 6, cost(4, 5, B), C is 5 + 1, cost(C, 6, D), E is 4 - 1, dim(E, F), dim(5, G), dim(6, H), I is F * G, J is I * H, K is B + D, A is K + J), 3500, 5)).
obligation(builtin, theory_scoped, aggregate_min(A, 4, (between(4, 5, 4), 4 < 5, cost(4, 4, B), C is 4 + 1, cost(C, 5, D), E is 4 - 1, dim(E, F), dim(4, G), dim(5, H), I is F * G, J is I * H, K is B + D, A is K + J), 1000, 4)).
obligation(builtin, theory_scoped, countall(subproblem(A, B, C), 21)).
steps(38).
verified(21).
recomputed(10).
composed(0).
trusted(7).
claims(4).
verdict(checked_with_obligations).
