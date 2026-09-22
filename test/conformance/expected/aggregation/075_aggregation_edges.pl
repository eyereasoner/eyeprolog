% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = findall_empty, 'X1' = []]).
answer(1, ['X0' = count_filtered, 'X1' = 2]).
answer(1, ['X0' = sum_empty, 'X1' = 0]).
answer(1, ['X0' = sum_scores, 'X1' = 6]).
answer(1, ['X0' = best_min, 'X1' = pair(1, bob)]).
answer(1, ['X0' = best_max, 'X1' = pair(3, cara)]).
answer(1, ['X0' = best_empty_rejected, 'X1' = ok]).
