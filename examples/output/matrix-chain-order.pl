% Prolog result format 4
query(1, matrix_chain_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = min_cost, 'X1' = 15125]).
answer(1, ['X0' = best_split_1_6, 'X1' = 3]).
answer(1,
       ['X0' = best_order,
        'X1' = product(product(matrix(1), product(matrix(2), matrix(3))), product(product(matrix(4), matrix(5)), matrix(6)))]).
answer(1, ['X0' = subproblem_count, 'X1' = 21]).
