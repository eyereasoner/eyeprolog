type_answer(id, fun(t0, t0)).
type_answer(const, fun(t0, fun(t1, t0))).
type_answer(apply_id, int).
type_answer(compose, fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2)))).
type_answer(branch, int).
type_answer(first_of_pair, bool).
type_reason(compose, "application unifies f with t1 -> t2 and g with t0 -> t1").
type_reason(apply_id, "the identity function's parameter type is unified with int").
