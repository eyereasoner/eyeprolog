condition('C1', resolution, ok, 9).
condition('C2', well_founded, ok, 14).
condition('C3', justification, ok, 14).
condition('C4', coverage, ok, 14).
condition('C5', re_decision, ok, 0).
obligation(builtin, theory_scoped, wfs_truth(reimbursable(taxi_receipt), true)).
obligation(builtin, theory_scoped, wfs_truth(reimbursable(client_dinner_wine), false)).
obligation(builtin, theory_scoped, wfs_truth(reimbursable(client_dinner_wine_preapproved), true)).
obligation(builtin, theory_scoped, wfs_truth(covered_by_blanket(team_offsite_hotel), undefined)).
obligation(builtin, theory_scoped, wfs_truth(itemized(team_offsite_hotel), undefined)).
steps(14).
verified(9).
recomputed(0).
composed(0).
trusted(5).
claims(6).
verdict(checked_with_obligations).
