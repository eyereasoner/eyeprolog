advanced_clpz(table, compatible(4, 0, 2)).
advanced_clpz(table, compatible(4, 3, 2)).
advanced_clpz(schedule, starts([0, 1, 3])).
advanced_clpz(cardinality, assignment([1, 1, 3], 13, >)).
advanced_clpz(cardinality, assignment([1, 3, 1], 12, >)).
advanced_clpz(cardinality, assignment([3, 1, 1], 6, <)).
advanced_clpz(circuit, successors([2, 3, 4, 1])).

clause(1,
       advanced_clpz(table, compatible(4, var('Y'), var('Distinct'))),
       (tuples_in([[var('X'), var('Y')]], [[1, 2], [1, 5], [4, 0], [4, 3]]),
        var('X') = 4,
        nvalue(var('Distinct'), [var('X'), var('Y')]),
        labeling([], [var('Y')]))).
clause(2,
       advanced_clpz(schedule, starts([var('A'), var('B'), var('C')])),
       ([var('A'), var('B'), var('C')] ins 0..3,
        lex_chain([[var('A'), var('B')], [var('B'), var('C')]]),
        serialized([var('A'), var('B'), var('C')], [1, 2, 1]),
        (integer(var('B')) -> (integer(var('A')) -> var('B') >= var('A') + 1 ; var('T#1') is var('B'), clpz:clpz_geq(var('T#1'), var('A') + 1)) ; integer(var('A')) -> var('T#1') is var('A') + 1, clpz:clpz_geq(var('B'), var('T#1')) ; clpz:clpz_geq(var('B'), var('A') + 1)),
        (integer(var('C')) -> (integer(var('B')) -> var('C') >= var('B') + 1 ; var('T#2') is var('C'), clpz:clpz_geq(var('T#2'), var('B') + 1)) ; integer(var('B')) -> var('T#2') is var('B') + 1, clpz:clpz_geq(var('C'), var('T#2')) ; clpz:clpz_geq(var('C'), var('B') + 1)),
        labeling([ff], [var('A'), var('B'), var('C')]))).
clause(3,
       advanced_clpz(cardinality, assignment(var('Values'), var('Cost'), var('Order'))),
       (var('Values') = [anonymous(1), anonymous(2), anonymous(3)],
        global_cardinality(var('Values'), [1 - 2, 3 - 1], [cost(var('Cost'), [[5, 1], [2, 4], [3, 6]])]),
        labeling([ff], var('Values')),
        zcompare(var('Order'), var('Cost'), 10))).
clause(4,
       advanced_clpz(circuit, successors(var('Values'))),
       (var('Values') = [var('A'), var('B'), anonymous(1), anonymous(2)],
        circuit(var('Values')),
        (integer(var('A')) -> var('A') =:= 2 ; true, var(var('A')) -> var('A') = 2 ; var('Var#3') = 2, clpz:clpz_equal(var('A'), var('Var#3'))),
        (integer(var('B')) -> var('B') =:= 3 ; true, var(var('B')) -> var('B') = 3 ; var('Var#4') = 3, clpz:clpz_equal(var('B'), var('Var#4'))),
        labeling([ff], var('Values')))).

step(advanced_clpz(table, compatible(4, 0, 2)),
     rule(1),
     ['Y' = 0, 'Distinct' = 2, 'X' = 4],
     [tuples_in([[4, 0]], [[1, 2], [1, 5], [4, 0], [4, 3]]),
      4 = 4,
      nvalue(2, [4, 0]),
      labeling([], [0])]).
step(tuples_in([[4, 0]], [[1, 2], [1, 5], [4, 0], [4, 3]]), builtin, [], []).
step(4 = 4, builtin, [], []).
step(nvalue(2, [4, 0]), builtin, [], []).
step(labeling([], [0]), builtin, [], []).
step(advanced_clpz(table, compatible(4, 3, 2)),
     rule(1),
     ['Y' = 3, 'Distinct' = 2, 'X' = 4],
     [tuples_in([[4, 3]], [[1, 2], [1, 5], [4, 0], [4, 3]]),
      4 = 4,
      nvalue(2, [4, 3]),
      labeling([], [3])]).
step(tuples_in([[4, 3]], [[1, 2], [1, 5], [4, 0], [4, 3]]), builtin, [], []).
step(nvalue(2, [4, 3]), builtin, [], []).
step(labeling([], [3]), builtin, [], []).
step(advanced_clpz(schedule, starts([0, 1, 3])),
     rule(2),
     ['A' = 0, 'B' = 1, 'C' = 3],
     [[0, 1, 3] ins 0..3,
      lex_chain([[0, 1], [1, 3]]),
      serialized([0, 1, 3], [1, 2, 1]),
      (integer(1) -> (integer(0) -> 1 >= 0 + 1 ; T_1 is 1, clpz:clpz_geq(T_1, 0 + 1)) ; integer(0) -> T_1 is 0 + 1, clpz:clpz_geq(1, T_1) ; clpz:clpz_geq(1, 0 + 1)),
      (integer(3) -> (integer(1) -> 3 >= 1 + 1 ; T_2 is 3, clpz:clpz_geq(T_2, 1 + 1)) ; integer(1) -> T_2 is 1 + 1, clpz:clpz_geq(3, T_2) ; clpz:clpz_geq(3, 1 + 1)),
      labeling([ff], [0, 1, 3])]).
step([0, 1, 3] ins 0..3, builtin, [], []).
step(lex_chain([[0, 1], [1, 3]]), builtin, [], []).
step(serialized([0, 1, 3], [1, 2, 1]), builtin, [], []).
step((integer(1) -> (integer(0) -> 1 >= 0 + 1 ; T_1 is 1, clpz:clpz_geq(T_1, 0 + 1)) ; integer(0) -> T_1 is 0 + 1, clpz:clpz_geq(1, T_1) ; clpz:clpz_geq(1, 0 + 1)),
     builtin,
     [],
     []).
step((integer(3) -> (integer(1) -> 3 >= 1 + 1 ; T_2 is 3, clpz:clpz_geq(T_2, 1 + 1)) ; integer(1) -> T_2 is 1 + 1, clpz:clpz_geq(3, T_2) ; clpz:clpz_geq(3, 1 + 1)),
     builtin,
     [],
     []).
step(labeling([ff], [0, 1, 3]), builtin, [], []).
step(advanced_clpz(cardinality, assignment([1, 1, 3], 13, >)),
     rule(3),
     ['Values' = [1, 1, 3], 'Cost' = 13, 'Order' = (>)],
     [[1, 1, 3] = [1, 1, 3],
      global_cardinality([1, 1, 3], [1 - 2, 3 - 1], [cost(13, [[5, 1], [2, 4], [3, 6]])]),
      labeling([ff], [1, 1, 3]),
      zcompare(>, 13, 10)]).
step([1, 1, 3] = [1, 1, 3], builtin, [], []).
step(global_cardinality([1, 1, 3], [1 - 2, 3 - 1], [cost(13, [[5, 1], [2, 4], [3, 6]])]),
     builtin,
     [],
     []).
step(labeling([ff], [1, 1, 3]), builtin, [], []).
step(zcompare(>, 13, 10), builtin, [], []).
step(advanced_clpz(cardinality, assignment([1, 3, 1], 12, >)),
     rule(3),
     ['Values' = [1, 3, 1], 'Cost' = 12, 'Order' = (>)],
     [[1, 3, 1] = [1, 3, 1],
      global_cardinality([1, 3, 1], [1 - 2, 3 - 1], [cost(12, [[5, 1], [2, 4], [3, 6]])]),
      labeling([ff], [1, 3, 1]),
      zcompare(>, 12, 10)]).
step([1, 3, 1] = [1, 3, 1], builtin, [], []).
step(global_cardinality([1, 3, 1], [1 - 2, 3 - 1], [cost(12, [[5, 1], [2, 4], [3, 6]])]),
     builtin,
     [],
     []).
step(labeling([ff], [1, 3, 1]), builtin, [], []).
step(zcompare(>, 12, 10), builtin, [], []).
step(advanced_clpz(cardinality, assignment([3, 1, 1], 6, <)),
     rule(3),
     ['Values' = [3, 1, 1], 'Cost' = 6, 'Order' = (<)],
     [[3, 1, 1] = [3, 1, 1],
      global_cardinality([3, 1, 1], [1 - 2, 3 - 1], [cost(6, [[5, 1], [2, 4], [3, 6]])]),
      labeling([ff], [3, 1, 1]),
      zcompare(<, 6, 10)]).
step([3, 1, 1] = [3, 1, 1], builtin, [], []).
step(global_cardinality([3, 1, 1], [1 - 2, 3 - 1], [cost(6, [[5, 1], [2, 4], [3, 6]])]),
     builtin,
     [],
     []).
step(labeling([ff], [3, 1, 1]), builtin, [], []).
step(zcompare(<, 6, 10), builtin, [], []).
step(advanced_clpz(circuit, successors([2, 3, 4, 1])),
     rule(4),
     ['Values' = [2, 3, 4, 1], 'A' = 2, 'B' = 3],
     [[2, 3, 4, 1] = [2, 3, 4, 1],
      circuit([2, 3, 4, 1]),
      (integer(2) -> 2 =:= 2 ; true, var(2) -> 2 = 2 ; Var_3 = 2, clpz:clpz_equal(2, Var_3)),
      (integer(3) -> 3 =:= 3 ; true, var(3) -> 3 = 3 ; Var_4 = 3, clpz:clpz_equal(3, Var_4)),
      labeling([ff], [2, 3, 4, 1])]).
step([2, 3, 4, 1] = [2, 3, 4, 1], builtin, [], []).
step(circuit([2, 3, 4, 1]), builtin, [], []).
step((integer(2) -> 2 =:= 2 ; true, var(2) -> 2 = 2 ; Var_3 = 2, clpz:clpz_equal(2, Var_3)),
     builtin,
     [],
     []).
step((integer(3) -> 3 =:= 3 ; true, var(3) -> 3 = 3 ; Var_4 = 3, clpz:clpz_equal(3, Var_4)),
     builtin,
     [],
     []).
step(labeling([ff], [2, 3, 4, 1]), builtin, [], []).
