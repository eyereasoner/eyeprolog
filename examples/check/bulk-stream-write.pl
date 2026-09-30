condition('C1', resolution, ok, 0).
condition('C2', well_founded, ok, 1).
condition('C3', justification, failed(1), 1).
condition('C4', coverage, ok, 1).
condition('C5', re_decision, ok, 0).
failure('C3', bulk_write_result(5000, 5000), 'recorded as unproven').
steps(1).
verified(0).
recomputed(0).
composed(0).
trusted(0).
claims(1).
verdict(failed(1)).
