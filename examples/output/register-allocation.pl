% Prolog result format 4
query(1, registerAnswer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 8).
answer(1,
       ['X0' = best_allocation, 'X1' = [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]]).
answer(1, ['X0' = spill_cost, 'X1' = 1]).
answer(1, ['X0' = place(a), 'X1' = r1]).
answer(1, ['X0' = place(b), 'X1' = spill]).
answer(1, ['X0' = place(c), 'X1' = r2]).
answer(1, ['X0' = place(d), 'X1' = r1]).
answer(1, ['X0' = valid_allocation_count, 'X1' = 33]).
answer(1,
       ['X0' = note,
        'X1' = "the cheapest solution spills b to color the a-b-c triangle with two registers"]).
