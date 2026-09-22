% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 8).
answer(1, ['X0' = take_zero, 'X1' = []]).
answer(1, ['X0' = drop_all, 'X1' = []]).
answer(1, ['X0' = slice_empty, 'X1' = []]).
answer(1, ['X0' = last_single, 'X1' = only]).
answer(1, ['X0' = first_tail, 'X1' = pair(a, "bc")]).
answer(1, ['X0' = take_too_many_rejected, 'X1' = ok]).
answer(1, ['X0' = drop_too_many_rejected, 'X1' = ok]).
answer(1, ['X0' = last_empty_rejected, 'X1' = ok]).
