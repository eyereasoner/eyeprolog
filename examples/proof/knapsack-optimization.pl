knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor]).
why(
  knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor]),
  step(
    knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor]),
    rule("knapsack-optimization.pl", clause(20)),
    ['Pack' = [atlas, battery, camera, medkit, sensor], '_weight' = 15, '_value' = 40],
    [
      step(
        best_pack([atlas, battery, camera, medkit, sensor], 15, 40),
        rule("knapsack-optimization.pl", clause(19)),
        ['Pack' = [atlas, battery, camera, medkit, sensor], 'Weight' = 15, 'Value' = 40],
        [
          step(aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15)), library(aggregate_max, 5), [], [])
        ]
      )
    ]
  )
).

knapsack_answer(total_weight, 15).
why(
  knapsack_answer(total_weight, 15),
  step(
    knapsack_answer(total_weight, 15),
    rule("knapsack-optimization.pl", clause(21)),
    ['Weight' = 15, '_pack' = [atlas, battery, camera, medkit, sensor], '_value' = 40],
    [
      step(
        best_pack([atlas, battery, camera, medkit, sensor], 15, 40),
        rule("knapsack-optimization.pl", clause(19)),
        ['Pack' = [atlas, battery, camera, medkit, sensor], 'Weight' = 15, 'Value' = 40],
        [
          step(aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15)), library(aggregate_max, 5), [], [])
        ]
      )
    ]
  )
).

knapsack_answer(total_value, 40).
why(
  knapsack_answer(total_value, 40),
  step(
    knapsack_answer(total_value, 40),
    rule("knapsack-optimization.pl", clause(22)),
    ['Value' = 40, '_pack' = [atlas, battery, camera, medkit, sensor], '_weight' = 15],
    [
      step(
        best_pack([atlas, battery, camera, medkit, sensor], 15, 40),
        rule("knapsack-optimization.pl", clause(19)),
        ['Pack' = [atlas, battery, camera, medkit, sensor], 'Weight' = 15, 'Value' = 40],
        [
          step(aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15)), library(aggregate_max, 5), [], [])
        ]
      )
    ]
  )
).

knapsack_answer(feasible_pack_count, 113).
why(
  knapsack_answer(feasible_pack_count, 113),
  step(
    knapsack_answer(feasible_pack_count, 113),
    rule("knapsack-optimization.pl", clause(23)),
    ['Count' = 113],
    [
      step(countall(feasible_pack(_pack, _weight, _value), 113), library(countall, 2), [], [])
    ]
  )
).

