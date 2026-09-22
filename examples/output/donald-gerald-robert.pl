% Prolog result format 4
query(1, pandigital_cryptarithm_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = naive_search_space, 'X1' = permutations(10, 3628800)]).
answer(1, ['X0' = assignments, 'X1' = solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0)]).
answer(1, ['X0' = equation, 'X1' = equation(526485, 197485, 723970)]).
answer(1, ['X0' = digit_usage, 'X1' = [5, 2, 6, 4, 8, 1, 9, 7, 3, 0]]).
answer(1, ['X0' = solution_count, 'X1' = 1]).
