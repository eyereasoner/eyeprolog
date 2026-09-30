condition('C1', resolution, ok, 37).
condition('C2', well_founded, ok, 84).
condition('C3', justification, ok, 84).
condition('C4', coverage, ok, 158).
condition('C5', re_decision, ok, 38).
obligation(absent, theory_scoped, \+ (interval(K, Startk, _finishk, _valuek), K > 8, Startk >= 11)).
obligation(absent, theory_scoped, \+ (interval(K, Startk, _finishk, _valuek), K > 7, Startk >= 10)).
obligation(absent, theory_scoped, \+ (interval(K, Startk, _finishk, _valuek), K > 6, Startk >= 9)).
obligation(absent, theory_scoped, \+ (interval(K, Startk, _finishk, _valuek), K > 5, Startk >= 9)).
obligation(builtin, theory_scoped, aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 4, Startk >= 7), 8, 8)).
obligation(builtin, theory_scoped, aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 3, Startk >= 6), 7, 7)).
obligation(builtin, theory_scoped, aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 2, Startk >= 5), 6, 6)).
obligation(builtin, theory_scoped, aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 1, Startk >= 4), 4, 4)).
obligation(builtin, theory_scoped, countall(interval(_i, _start, _finish, _value), 8)).
steps(84).
verified(37).
recomputed(38).
composed(0).
trusted(9).
claims(5).
verdict(checked_with_obligations).
