condition('C1', resolution, ok, 3).
condition('C2', well_founded, ok, 31).
condition('C3', justification, ok, 31).
condition('C4', coverage, ok, 33).
condition('C5', re_decision, ok, 23).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 34).
obligation(builtin, stateful, fd_var(A)).
obligation(builtin, stateful, fd_inf(A, 2)).
obligation(builtin, stateful, fd_sup(A, 7)).
obligation(builtin, stateful, fd_size(A, 4)).
obligation(builtin, stateful, fd_dom(A, 2..4 \/ 7)).
steps(31).
verified(3).
recomputed(23).
composed(0).
trusted(5).
claims(3).
verdict(checked_with_obligations).
