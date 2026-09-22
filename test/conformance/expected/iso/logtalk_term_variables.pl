% Prolog result format 4
query(1, ground_variables(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = []]).
query(2, ordered_variables(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = [first, second, third, fourth]]).
query(3, shared_variables_first(_0), ['X0' = _0]).
result(3, complete, 1).
answer(3, ['X0' = [first, second]]).
query(4, shared_variables_second(_0), ['X0' = _0]).
result(4, complete, 1).
answer(4, ['X0' = [first, second]]).
query(5, prefilled_variables, []).
result(5, complete, 1).
answer(5, []).
