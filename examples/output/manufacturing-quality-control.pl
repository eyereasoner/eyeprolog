% Prolog result format 4
query(1, cpk(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = line7_shift_a, 'X1' = 0.6666666666666673]).
answer(1, ['X0' = line8_shift_b, 'X1' = 1.6666666666666607]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = line8_shift_b, 'X1' = capable_process]).
answer(2, ['X0' = line7_shift_a, 'X1' = needs_process_adjustment]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 2).
answer(3, ['X0' = line8_shift_b, 'X1' = "Cpk meets the production capability threshold"]).
answer(3, ['X0' = line7_shift_a, 'X1' = "Cpk is below the production capability threshold"]).
