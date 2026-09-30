condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 9).
condition('C3', justification, ok, 9).
condition('C4', coverage, ok, 9).
condition('C5', re_decision, ok, 1).
obligation(asserted, theory_scoped, task(check_power, urgent)).
obligation(collected, theory_scoped, findall(task(Task, Priority), task(Task, Priority), [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)])).
obligation(absent, theory_scoped, \+ task(old_probe, obsolete)).
obligation(builtin, reflective, current_predicate(task / 2)).
steps(9).
verified(4).
recomputed(0).
composed(1).
trusted(4).
claims(4).
verdict(checked_with_obligations).
