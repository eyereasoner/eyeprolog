% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1,
       ['X0' = all_pairs,
        'X1' = [result(alice, math, 9), result(alice, logic, 7), result(bob, math, 5), result(bob, logic, 8)]]).
answer(1, ['X0' = count_high, 'X1' = 2]).
answer(1, ['X0' = sum_alice, 'X1' = 16]).
answer(1, ['X0' = best_score, 'X1' = pair(9, result(alice, math))]).
answer(1, ['X0' = lowest_pair, 'X1' = pair([5, bob], math)]).
answer(1, ['X0' = max_tie_first, 'X1' = first]).
