condition('C1', resolution, ok, 21).
condition('C2', well_founded, ok, 38).
condition('C3', justification, ok, 38).
condition('C4', coverage, ok, 45).
condition('C5', re_decision, ok, 10).
obligation(builtin, theory_scoped, aggregate_min(Key, Value, (between(1, 6, Value), Value < 6, cost(1, Value, Left), K1 is Value + 1, cost(K1, 6, Right), I0 is 1 - 1, dim(I0, Rows), dim(Value, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 15125, 3)).
obligation(builtin, theory_scoped, aggregate_min(Key, 3, (between(1, 6, 3), 3 < 6, cost(1, 3, Left), K1 is 3 + 1, cost(K1, 6, Right), I0 is 1 - 1, dim(I0, Rows), dim(3, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 15125, 3)).
obligation(builtin, theory_scoped, aggregate_min(Key, 1, (between(1, 3, 1), 1 < 3, cost(1, 1, Left), K1 is 1 + 1, cost(K1, 3, Right), I0 is 1 - 1, dim(I0, Rows), dim(1, Shared), dim(3, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 7875, 1)).
obligation(builtin, theory_scoped, aggregate_min(Key, 2, (between(2, 3, 2), 2 < 3, cost(2, 2, Left), K1 is 2 + 1, cost(K1, 3, Right), I0 is 2 - 1, dim(I0, Rows), dim(2, Shared), dim(3, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 2625, 2)).
obligation(builtin, theory_scoped, aggregate_min(Key, 5, (between(4, 6, 5), 5 < 6, cost(4, 5, Left), K1 is 5 + 1, cost(K1, 6, Right), I0 is 4 - 1, dim(I0, Rows), dim(5, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 3500, 5)).
obligation(builtin, theory_scoped, aggregate_min(Key, 4, (between(4, 5, 4), 4 < 5, cost(4, 4, Left), K1 is 4 + 1, cost(K1, 5, Right), I0 is 4 - 1, dim(I0, Rows), dim(4, Shared), dim(5, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 1000, 4)).
obligation(builtin, theory_scoped, countall(subproblem(_i, _j, _cost), 21)).
steps(38).
verified(21).
recomputed(10).
composed(0).
trusted(7).
claims(4).
verdict(checked_with_obligations).
