registerAnswer(best_allocation, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]).
registerAnswer(spill_cost, 1).
registerAnswer(place(a), r1).
registerAnswer(place(b), spill).
registerAnswer(place(c), r2).
registerAnswer(place(d), r1).
registerAnswer(valid_allocation_count, 33).
registerAnswer(note, "the cheapest solution spills b to color the a-b-c triangle with two registers").
