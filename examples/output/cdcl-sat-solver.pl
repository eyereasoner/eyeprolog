% Prolog result format 4
query(1, cdclAnswer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = conflict_clause, 'X1' = c2]).
answer(1, ['X0' = learned_clause, 'X1' = [neg(a)]]).
answer(1, ['X0' = learned_from, 'X1' = resolve(c2, c1, pivot(c))]).
answer(1, ['X0' = final_value(a), 'X1' = false]).
answer(1, ['X0' = final_value(c), 'X1' = false]).
answer(1, ['X0' = final_value(b), 'X1' = true]).
answer(1,
       ['X0' = note,
        'X1' = "one learned clause makes the final model satisfy all original clauses"]).
