condition('C1', resolution, ok, 1).
condition('C2', well_founded, ok, 2).
condition('C3', justification, ok, 2).
condition('C4', coverage, ok, 2).
condition('C5', re_decision, ok, 0).
obligation(builtin, theory_scoped, aggregate_max(Key, board(M, Perm), square(8, M, Key, __anon0, Perm), 544, board([[1, 1, 2, 3, 4, 5, 6, 7], [1, 1, 3, 2, 5, 4, 7, 6], [3, 2, 8, 8, 9, 10, 11, 12], [2, 3, 8, 8, 10, 9, 12, 11], [5, 4, 10, 9, 13, 13, 14, 15], [4, 5, 9, 10, 13, 13, 15, 14], [7, 6, 12, 11, 15, 14, 16, 16], [6, 7, 11, 12, 14, 15, 16, 16]], [2, 1, 4, 3, 6, 5, 8, 7]))).
steps(2).
verified(1).
recomputed(0).
composed(0).
trusted(1).
claims(1).
verdict(checked_with_obligations).
