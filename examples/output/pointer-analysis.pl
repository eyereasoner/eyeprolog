% Prolog result format 4
query(1, pointsTo(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = x, 'X1' = object_a]).
answer(1, ['X0' = z, 'X1' = object_b]).
answer(1, ['X0' = y, 'X1' = object_a]).
answer(1, ['X0' = r, 'X1' = object_b]).
answer(1, ['X0' = q, 'X1' = object_b]).
query(2, heapField(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = object_a, 'X1' = object_b]).
query(3, pointerFlow(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = load_q_from_x, 'X1' = object_b]).
query(4, pointerConclusion(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4,
       ['X0' = case,
        'X1' = "the load q = *x recovers object_b through the store *y = z and y = x"]).
