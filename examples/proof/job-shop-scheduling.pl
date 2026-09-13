job_shop_answer(best_makespan, 9).
why(
  job_shop_answer(best_makespan, 9),
  proof(
    goal(job_shop_answer(best_makespan, 9)),
    by(rule("job-shop-scheduling.pl", clause(5))),
    bindings([binding("Makespan", 9), binding("_schedule", [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])]),
    uses([
      proof(
        goal(best_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])),
        by(rule("job-shop-scheduling.pl", clause(4))),
        bindings([binding("Makespan", 9), binding("Schedule", [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])]),
        uses([
          proof(
            goal(aggregate_min(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)], feasible_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), 9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])),
            by(library(aggregate_min, 5))
          )
        ])
      )
    ])
  )
).

job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]).
why(
  job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]),
  proof(
    goal(job_shop_answer(best_schedule, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])),
    by(rule("job-shop-scheduling.pl", clause(6))),
    bindings([binding("Schedule", [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), binding("_makespan", 9)]),
    uses([
      proof(
        goal(best_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])),
        by(rule("job-shop-scheduling.pl", clause(4))),
        bindings([binding("Makespan", 9), binding("Schedule", [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])]),
        uses([
          proof(
            goal(aggregate_min(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)], feasible_schedule(9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)]), 9, [op(j1_mill, 0, 3), op(j1_lathe, 3, 5), op(j2_lathe, 0, 2), op(j2_mill, 5, 9), op(j3_mill, 3, 5), op(j3_lathe, 5, 8)])),
            by(library(aggregate_min, 5))
          )
        ])
      )
    ])
  )
).

job_shop_answer(feasible_schedule_count, 35).
why(
  job_shop_answer(feasible_schedule_count, 35),
  proof(
    goal(job_shop_answer(feasible_schedule_count, 35)),
    by(rule("job-shop-scheduling.pl", clause(7))),
    bindings([binding("Count", 35)]),
    uses([
      proof(
        goal(countall(feasible_schedule(_makespan, _schedule), 35)),
        by(library(countall, 2))
      )
    ])
  )
).

