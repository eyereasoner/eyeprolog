% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = first, 'X1' = zero]).
answer(1, ['X0' = tail, 'X1' = [one, two, three, four]]).
answer(1, ['X0' = last, 'X1' = four]).
answer(1, ['X0' = take_three, 'X1' = [zero, one, two]]).
answer(1, ['X0' = drop_three, 'X1' = [three, four]]).
answer(1, ['X0' = slice_middle, 'X1' = [one, two, three]]).
answer(1, ['X0' = slice_tail_empty, 'X1' = []]).
