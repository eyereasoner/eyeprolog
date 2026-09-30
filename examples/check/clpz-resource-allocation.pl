condition('C1', resolution, ok, 2).
condition('C2', well_founded, ok, 25).
condition('C3', justification, failed(1), 25).
condition('C4', coverage, ok, 27).
condition('C5', re_decision, ok, 22).
failure('C3', clpz_example(domain, domain(2, 7, 4, 2..4 \/ 7)), 'recorded as unproven').
steps(25).
verified(2).
recomputed(22).
composed(0).
trusted(0).
claims(3).
verdict(failed(1)).
