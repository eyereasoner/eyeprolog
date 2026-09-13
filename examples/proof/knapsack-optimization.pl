knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor]).
why(
  knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor]),
  proof(
    goal(knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor])),
    by(rule("knapsack-optimization.pl", clause(20))),
    bindings([binding("Pack", [atlas, battery, camera, medkit, sensor]), binding("_weight", 15), binding("_value", 40)]),
    uses([
      proof(
        goal(best_pack([atlas, battery, camera, medkit, sensor], 15, 40)),
        by(rule("knapsack-optimization.pl", clause(19))),
        bindings([binding("Pack", [atlas, battery, camera, medkit, sensor]), binding("Weight", 15), binding("Value", 40)]),
        uses([
          proof(
            goal(aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15))),
            by(library(aggregate_max, 5))
          )
        ])
      )
    ])
  )
).

knapsack_answer(total_weight, 15).
why(
  knapsack_answer(total_weight, 15),
  proof(
    goal(knapsack_answer(total_weight, 15)),
    by(rule("knapsack-optimization.pl", clause(21))),
    bindings([binding("Weight", 15), binding("_pack", [atlas, battery, camera, medkit, sensor]), binding("_value", 40)]),
    uses([
      proof(
        goal(best_pack([atlas, battery, camera, medkit, sensor], 15, 40)),
        by(rule("knapsack-optimization.pl", clause(19))),
        bindings([binding("Pack", [atlas, battery, camera, medkit, sensor]), binding("Weight", 15), binding("Value", 40)]),
        uses([
          proof(
            goal(aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15))),
            by(library(aggregate_max, 5))
          )
        ])
      )
    ])
  )
).

knapsack_answer(total_value, 40).
why(
  knapsack_answer(total_value, 40),
  proof(
    goal(knapsack_answer(total_value, 40)),
    by(rule("knapsack-optimization.pl", clause(22))),
    bindings([binding("Value", 40), binding("_pack", [atlas, battery, camera, medkit, sensor]), binding("_weight", 15)]),
    uses([
      proof(
        goal(best_pack([atlas, battery, camera, medkit, sensor], 15, 40)),
        by(rule("knapsack-optimization.pl", clause(19))),
        bindings([binding("Pack", [atlas, battery, camera, medkit, sensor]), binding("Weight", 15), binding("Value", 40)]),
        uses([
          proof(
            goal(aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15))),
            by(library(aggregate_max, 5))
          )
        ])
      )
    ])
  )
).

knapsack_answer(feasible_pack_count, 113).
why(
  knapsack_answer(feasible_pack_count, 113),
  proof(
    goal(knapsack_answer(feasible_pack_count, 113)),
    by(rule("knapsack-optimization.pl", clause(23))),
    bindings([binding("Count", 113)]),
    uses([
      proof(
        goal(countall(feasible_pack(_pack, _weight, _value), 113)),
        by(library(countall, 2))
      )
    ])
  )
).

