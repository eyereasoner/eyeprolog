% Prolog result format 4
query(1, type_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = id, 'X1' = fun(t0, t0)]).
answer(1, ['X0' = const, 'X1' = fun(t0, fun(t1, t0))]).
answer(1, ['X0' = apply_id, 'X1' = int]).
answer(1, ['X0' = compose, 'X1' = fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2)))]).
answer(1, ['X0' = branch, 'X1' = int]).
answer(1, ['X0' = first_of_pair, 'X1' = bool]).
query(2, type_reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = compose, 'X1' = "application unifies f with t1 -> t2 and g with t0 -> t1"]).
answer(2,
       ['X0' = apply_id, 'X1' = "the identity function's parameter type is unified with int"]).
