condition('C1', resolution, ok, 3).
condition('C2', well_founded, ok, 33).
condition('C3', justification, ok, 33).
condition('C4', coverage, ok, 35).
condition('C5', re_decision, ok, 25).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 36).
obligation(builtin, stateful, fd_var(A)).
obligation(builtin, stateful, fd_inf(A, 2)).
obligation(builtin, stateful, fd_sup(A, 7)).
obligation(builtin, stateful, fd_size(A, 4)).
obligation(builtin, stateful, fd_dom(A, 2..4 \/ 7)).
steps(33).
verified(3).
recomputed(24).
composed(1).
trusted(5).
claims(3).
verdict(checked_with_obligations).
