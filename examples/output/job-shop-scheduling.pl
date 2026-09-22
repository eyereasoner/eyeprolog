% Prolog result format 4
query(1, job_shop_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = best_makespan, 'X1' = 9]).
answer(1,
       ['X0' = best_schedule,
        'X1' = [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]]).
answer(1, ['X0' = feasible_schedule_count, 'X1' = 35]).
