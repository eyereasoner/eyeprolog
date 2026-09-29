matrix_chain_answer(min_cost, 15125).
matrix_chain_answer(best_split_1_6, 3).
matrix_chain_answer(best_order, product(product(matrix(1), product(matrix(2), matrix(3))), product(product(matrix(4), matrix(5)), matrix(6)))).
matrix_chain_answer(subproblem_count, 21).

clause(11,
       cost(var('I'), var('J'), var('Cost')),
       (var('I') < var('J'),
        aggregate_min(var('Splitcost'), var('K'), (between(var('I'), var('J'), var('K')), var('K') < var('J'), cost(var('I'), var('K'), var('Left')), var('K1') is var('K') + 1, cost(var('K1'), var('J'), var('Right')), var('I0') is var('I') - 1, dim(var('I0'), var('Rows')), dim(var('K'), var('Shared')), dim(var('J'), var('Cols')), var('First') is var('Rows') * var('Shared'), var('Multcost') is var('First') * var('Cols'), var('Partial') is var('Left') + var('Right'), var('Splitcost') is var('Partial') + var('Multcost')), var('Cost'), anonymous(1)))).
clause(12,
       best_split(var('I'), var('J'), var('K')),
       (var('I') < var('J'),
        aggregate_min(var('Splitcost'), var('K'), (between(var('I'), var('J'), var('K')), var('K') < var('J'), cost(var('I'), var('K'), var('Left')), var('K1') is var('K') + 1, cost(var('K1'), var('J'), var('Right')), var('I0') is var('I') - 1, dim(var('I0'), var('Rows')), dim(var('K'), var('Shared')), dim(var('J'), var('Cols')), var('First') is var('Rows') * var('Shared'), var('Multcost') is var('First') * var('Cols'), var('Partial') is var('Left') + var('Right'), var('Splitcost') is var('Partial') + var('Multcost')), anonymous(1), var('K')))).
clause(13, parenthesization(var('I'), var('I'), matrix(var('I'))), true).
clause(14,
       parenthesization(var('I'), var('J'), product(var('Lefttree'), var('Righttree'))),
       (var('I') < var('J'),
        best_split(var('I'), var('J'), var('K')),
        var('K1') is var('K') + 1,
        parenthesization(var('I'), var('K'), var('Lefttree')),
        parenthesization(var('K1'), var('J'), var('Righttree')))).
clause(15, matrix_chain_answer(min_cost, var('Cost')), cost(1, 6, var('Cost'))).
clause(16, matrix_chain_answer(best_split_1_6, var('K')), best_split(1, 6, var('K'))).
clause(17, matrix_chain_answer(best_order, var('Tree')), parenthesization(1, 6, var('Tree'))).
clause(19,
       matrix_chain_answer(subproblem_count, var('Count')),
       countall(subproblem(anonymous(1), anonymous(2), anonymous(3)), var('Count'))).

step(matrix_chain_answer(min_cost, 15125), rule(15), ['Cost' = 15125], [cost(1, 6, 15125)]).
step(cost(1, 6, 15125),
     rule(11),
     ['I' = 1, 'J' = 6, 'Cost' = 15125],
     [1 < 6,
      aggregate_min(Key, Value, (between(1, 6, Value), Value < 6, cost(1, Value, Left), K1 is Value + 1, cost(K1, 6, Right), I0 is 1 - 1, dim(I0, Rows), dim(Value, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 15125, 3)]).
step(1 < 6, builtin, [], []).
step(aggregate_min(Key, Value, (between(1, 6, Value), Value < 6, cost(1, Value, Left), K1 is Value + 1, cost(K1, 6, Right), I0 is 1 - 1, dim(I0, Rows), dim(Value, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 15125, 3),
     builtin,
     [],
     []).
step(matrix_chain_answer(best_split_1_6, 3), rule(16), ['K' = 3], [best_split(1, 6, 3)]).
step(best_split(1, 6, 3),
     rule(12),
     ['I' = 1, 'J' = 6, 'K' = 3],
     [1 < 6,
      aggregate_min(Key, 3, (between(1, 6, 3), 3 < 6, cost(1, 3, Left), K1 is 3 + 1, cost(K1, 6, Right), I0 is 1 - 1, dim(I0, Rows), dim(3, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 15125, 3)]).
step(aggregate_min(Key, 3, (between(1, 6, 3), 3 < 6, cost(1, 3, Left), K1 is 3 + 1, cost(K1, 6, Right), I0 is 1 - 1, dim(I0, Rows), dim(3, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 15125, 3),
     builtin,
     [],
     []).
step(matrix_chain_answer(best_order, product(product(matrix(1), product(matrix(2), matrix(3))), product(product(matrix(4), matrix(5)), matrix(6)))),
     rule(17),
     ['Tree' = product(product(matrix(1), product(matrix(2), matrix(3))), product(product(matrix(4), matrix(5)), matrix(6)))],
     [parenthesization(1, 6, product(product(matrix(1), product(matrix(2), matrix(3))), product(product(matrix(4), matrix(5)), matrix(6))))]).
step(parenthesization(1, 6, product(product(matrix(1), product(matrix(2), matrix(3))), product(product(matrix(4), matrix(5)), matrix(6)))),
     rule(14),
     ['I' = 1,
      'J' = 6,
      'Lefttree' = product(matrix(1), product(matrix(2), matrix(3))),
      'Righttree' = product(product(matrix(4), matrix(5)), matrix(6)),
      'K' = 3,
      'K1' = 4],
     [1 < 6,
      best_split(1, 6, 3),
      4 is 3 + 1,
      parenthesization(1, 3, product(matrix(1), product(matrix(2), matrix(3)))),
      parenthesization(4, 6, product(product(matrix(4), matrix(5)), matrix(6)))]).
step(4 is 3 + 1, builtin, [], []).
step(parenthesization(1, 3, product(matrix(1), product(matrix(2), matrix(3)))),
     rule(14),
     ['I' = 1,
      'J' = 3,
      'Lefttree' = matrix(1),
      'Righttree' = product(matrix(2), matrix(3)),
      'K' = 1,
      'K1' = 2],
     [1 < 3,
      best_split(1, 3, 1),
      2 is 1 + 1,
      parenthesization(1, 1, matrix(1)),
      parenthesization(2, 3, product(matrix(2), matrix(3)))]).
step(1 < 3, builtin, [], []).
step(best_split(1, 3, 1),
     rule(12),
     ['I' = 1, 'J' = 3, 'K' = 1],
     [1 < 3,
      aggregate_min(Key, 1, (between(1, 3, 1), 1 < 3, cost(1, 1, Left), K1 is 1 + 1, cost(K1, 3, Right), I0 is 1 - 1, dim(I0, Rows), dim(1, Shared), dim(3, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 7875, 1)]).
step(aggregate_min(Key, 1, (between(1, 3, 1), 1 < 3, cost(1, 1, Left), K1 is 1 + 1, cost(K1, 3, Right), I0 is 1 - 1, dim(I0, Rows), dim(1, Shared), dim(3, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 7875, 1),
     builtin,
     [],
     []).
step(2 is 1 + 1, builtin, [], []).
step(parenthesization(1, 1, matrix(1)), fact(13), ['I' = 1], []).
step(parenthesization(2, 3, product(matrix(2), matrix(3))),
     rule(14),
     ['I' = 2, 'J' = 3, 'Lefttree' = matrix(2), 'Righttree' = matrix(3), 'K' = 2, 'K1' = 3],
     [2 < 3,
      best_split(2, 3, 2),
      3 is 2 + 1,
      parenthesization(2, 2, matrix(2)),
      parenthesization(3, 3, matrix(3))]).
step(2 < 3, builtin, [], []).
step(best_split(2, 3, 2),
     rule(12),
     ['I' = 2, 'J' = 3, 'K' = 2],
     [2 < 3,
      aggregate_min(Key, 2, (between(2, 3, 2), 2 < 3, cost(2, 2, Left), K1 is 2 + 1, cost(K1, 3, Right), I0 is 2 - 1, dim(I0, Rows), dim(2, Shared), dim(3, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 2625, 2)]).
step(aggregate_min(Key, 2, (between(2, 3, 2), 2 < 3, cost(2, 2, Left), K1 is 2 + 1, cost(K1, 3, Right), I0 is 2 - 1, dim(I0, Rows), dim(2, Shared), dim(3, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 2625, 2),
     builtin,
     [],
     []).
step(3 is 2 + 1, builtin, [], []).
step(parenthesization(2, 2, matrix(2)), fact(13), ['I' = 2], []).
step(parenthesization(3, 3, matrix(3)), fact(13), ['I' = 3], []).
step(parenthesization(4, 6, product(product(matrix(4), matrix(5)), matrix(6))),
     rule(14),
     ['I' = 4,
      'J' = 6,
      'Lefttree' = product(matrix(4), matrix(5)),
      'Righttree' = matrix(6),
      'K' = 5,
      'K1' = 6],
     [4 < 6,
      best_split(4, 6, 5),
      6 is 5 + 1,
      parenthesization(4, 5, product(matrix(4), matrix(5))),
      parenthesization(6, 6, matrix(6))]).
step(4 < 6, builtin, [], []).
step(best_split(4, 6, 5),
     rule(12),
     ['I' = 4, 'J' = 6, 'K' = 5],
     [4 < 6,
      aggregate_min(Key, 5, (between(4, 6, 5), 5 < 6, cost(4, 5, Left), K1 is 5 + 1, cost(K1, 6, Right), I0 is 4 - 1, dim(I0, Rows), dim(5, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 3500, 5)]).
step(aggregate_min(Key, 5, (between(4, 6, 5), 5 < 6, cost(4, 5, Left), K1 is 5 + 1, cost(K1, 6, Right), I0 is 4 - 1, dim(I0, Rows), dim(5, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 3500, 5),
     builtin,
     [],
     []).
step(6 is 5 + 1, builtin, [], []).
step(parenthesization(4, 5, product(matrix(4), matrix(5))),
     rule(14),
     ['I' = 4, 'J' = 5, 'Lefttree' = matrix(4), 'Righttree' = matrix(5), 'K' = 4, 'K1' = 5],
     [4 < 5,
      best_split(4, 5, 4),
      5 is 4 + 1,
      parenthesization(4, 4, matrix(4)),
      parenthesization(5, 5, matrix(5))]).
step(4 < 5, builtin, [], []).
step(best_split(4, 5, 4),
     rule(12),
     ['I' = 4, 'J' = 5, 'K' = 4],
     [4 < 5,
      aggregate_min(Key, 4, (between(4, 5, 4), 4 < 5, cost(4, 4, Left), K1 is 4 + 1, cost(K1, 5, Right), I0 is 4 - 1, dim(I0, Rows), dim(4, Shared), dim(5, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 1000, 4)]).
step(aggregate_min(Key, 4, (between(4, 5, 4), 4 < 5, cost(4, 4, Left), K1 is 4 + 1, cost(K1, 5, Right), I0 is 4 - 1, dim(I0, Rows), dim(4, Shared), dim(5, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 1000, 4),
     builtin,
     [],
     []).
step(5 is 4 + 1, builtin, [], []).
step(parenthesization(4, 4, matrix(4)), fact(13), ['I' = 4], []).
step(parenthesization(5, 5, matrix(5)), fact(13), ['I' = 5], []).
step(parenthesization(6, 6, matrix(6)), fact(13), ['I' = 6], []).
step(matrix_chain_answer(subproblem_count, 21),
     rule(19),
     ['Count' = 21],
     [countall(subproblem(_i, _j, _cost), 21)]).
step(countall(subproblem(_i, _j, _cost), 21), builtin, [], []).
