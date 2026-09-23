knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor]).
knapsack_answer(total_weight, 15).
knapsack_answer(total_value, 40).
knapsack_answer(feasible_pack_count, 113).

clause(19,
       best_pack(var('Pack'), var('Weight'), var('Value')),
       aggregate_max(var('Value'), pack(var('Pack'), var('Weight')), feasible_pack(var('Pack'), var('Weight'), var('Value')), var('Value'), pack(var('Pack'), var('Weight')))).
clause(20,
       knapsack_answer(best_pack, var('Pack')),
       best_pack(var('Pack'), anonymous(1), anonymous(2))).
clause(21,
       knapsack_answer(total_weight, var('Weight')),
       best_pack(anonymous(1), var('Weight'), anonymous(2))).
clause(22,
       knapsack_answer(total_value, var('Value')),
       best_pack(anonymous(1), anonymous(2), var('Value'))).
clause(23,
       knapsack_answer(feasible_pack_count, var('Count')),
       countall(feasible_pack(anonymous(1), anonymous(2), anonymous(3)), var('Count'))).

step(knapsack_answer(best_pack, [atlas, battery, camera, medkit, sensor]),
     rule(20),
     ['Pack' = [atlas, battery, camera, medkit, sensor]],
     [best_pack([atlas, battery, camera, medkit, sensor], 15, 40)]).
step(best_pack([atlas, battery, camera, medkit, sensor], 15, 40),
     rule(19),
     ['Pack' = [atlas, battery, camera, medkit, sensor], 'Weight' = 15, 'Value' = 40],
     [aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15))]).
step(aggregate_max(40, pack([atlas, battery, camera, medkit, sensor], 15), feasible_pack([atlas, battery, camera, medkit, sensor], 15, 40), 40, pack([atlas, battery, camera, medkit, sensor], 15)),
     builtin,
     [],
     []).
step(knapsack_answer(total_weight, 15),
     rule(21),
     ['Weight' = 15],
     [best_pack([atlas, battery, camera, medkit, sensor], 15, 40)]).
step(knapsack_answer(total_value, 40),
     rule(22),
     ['Value' = 40],
     [best_pack([atlas, battery, camera, medkit, sensor], 15, 40)]).
step(knapsack_answer(feasible_pack_count, 113),
     rule(23),
     ['Count' = 113],
     [countall(feasible_pack(_pack, _weight, _value), 113)]).
step(countall(feasible_pack(_pack, _weight, _value), 113), builtin, [], []).
