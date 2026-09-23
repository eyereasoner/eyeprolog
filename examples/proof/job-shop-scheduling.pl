job_shop_answer(best_makespan, 9).
job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]).
job_shop_answer(feasible_schedule_count, 35).

clause(4,
       best_schedule(var('Makespan'), var('Schedule')),
       aggregate_min(var('Makespan'), var('Schedule'), feasible_schedule(var('Makespan'), var('Schedule')), var('Makespan'), var('Schedule'))).
clause(5,
       job_shop_answer(best_makespan, var('Makespan')),
       best_schedule(var('Makespan'), anonymous(1))).
clause(6,
       job_shop_answer(best_schedule, var('Schedule')),
       best_schedule(anonymous(1), var('Schedule'))).
clause(7,
       job_shop_answer(feasible_schedule_count, var('Count')),
       countall(feasible_schedule(anonymous(1), anonymous(2)), var('Count'))).

step(job_shop_answer(best_makespan, 9),
     rule(5),
     ['Makespan' = 9],
     [best_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])]).
step(best_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]),
     rule(4),
     ['Makespan' = 9,
      'Schedule' = [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]],
     [aggregate_min(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)], feasible_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), 9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])]).
step(aggregate_min(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)], feasible_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), 9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]),
     builtin,
     [],
     []).
step(job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]),
     rule(6),
     ['Schedule' = [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]],
     [best_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])]).
step(job_shop_answer(feasible_schedule_count, 35),
     rule(7),
     ['Count' = 35],
     [countall(feasible_schedule(_makespan, _schedule), 35)]).
step(countall(feasible_schedule(_makespan, _schedule), 35), builtin, [], []).
