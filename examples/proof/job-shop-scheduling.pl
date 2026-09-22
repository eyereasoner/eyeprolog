job_shop_answer(best_makespan, 9).
why(
  job_shop_answer(best_makespan, 9),
  step(
    job_shop_answer(best_makespan, 9),
    rule("job-shop-scheduling.pl", clause(5)),
    ['Makespan' = 9, '_schedule' = [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]],
    [
      step(
        best_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]),
        rule("job-shop-scheduling.pl", clause(4)),
        ['Makespan' = 9, 'Schedule' = [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]],
        [
          step(aggregate_min(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)], feasible_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), 9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), library(aggregate_min, 5), [], [])
        ]
      )
    ]
  )
).

job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]).
why(
  job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]),
  step(
    job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]),
    rule("job-shop-scheduling.pl", clause(6)),
    ['Schedule' = [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)], '_makespan' = 9],
    [
      step(
        best_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]),
        rule("job-shop-scheduling.pl", clause(4)),
        ['Makespan' = 9, 'Schedule' = [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]],
        [
          step(aggregate_min(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)], feasible_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), 9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), library(aggregate_min, 5), [], [])
        ]
      )
    ]
  )
).

job_shop_answer(feasible_schedule_count, 35).
why(
  job_shop_answer(feasible_schedule_count, 35),
  step(
    job_shop_answer(feasible_schedule_count, 35),
    rule("job-shop-scheduling.pl", clause(7)),
    ['Count' = 35],
    [
      step(countall(feasible_schedule(_makespan, _schedule), 35), library(countall, 2), [], [])
    ]
  )
).

