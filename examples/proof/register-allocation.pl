registerAnswer(best_allocation, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]).
registerAnswer(spill_cost, 1).
registerAnswer(place(a), r1).
registerAnswer(place(b), spill).
registerAnswer(place(c), r2).
registerAnswer(place(d), r1).
registerAnswer(valid_allocation_count, 33).
registerAnswer(note, "the cheapest solution spills b to color the a-b-c triangle with two registers").

clause(15,
       assigned(var('Var'), [bind(var('Var'), var('Place')) | anonymous(1)], var('Place')),
       true).
clause(16,
       assigned(var('Var'), [bind(anonymous(1), anonymous(2)) | var('Rest')], var('Place')),
       assigned(var('Var'), var('Rest'), var('Place'))).
clause(22,
       best_allocation(var('Allocation'), var('Cost')),
       aggregate_min([var('Candidate_cost'), var('Candidate')], var('Candidate'), (valid_allocation(var('Candidate')), allocation_cost(var('Candidate'), var('Candidate_cost'))), [var('Cost'), var('Allocation')], var('Allocation'))).
clause(23,
       registerAnswer(best_allocation, var('Allocation')),
       best_allocation(var('Allocation'), anonymous(1))).
clause(24, registerAnswer(spill_cost, var('Cost')), best_allocation(anonymous(1), var('Cost'))).
clause(25,
       registerAnswer(place(var('Var')), var('Place')),
       (best_allocation(var('Allocation'), anonymous(1)),
        assigned(var('Var'), var('Allocation'), var('Place')))).
clause(26,
       registerAnswer(valid_allocation_count, var('Count')),
       countall(valid_allocation(anonymous(1)), var('Count'))).
clause(27,
       registerAnswer(note, "the cheapest solution spills b to color the a-b-c triangle with two registers"),
       best_allocation(anonymous(1), anonymous(2))).

step(registerAnswer(best_allocation, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]),
     rule(23),
     ['Allocation' = [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]],
     [best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1)]).
step(best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1),
     rule(22),
     ['Allocation' = [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 'Cost' = 1],
     [aggregate_min([Candidate_cost, Value], Value, (valid_allocation(Value), allocation_cost(Value, Candidate_cost)), [1, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]], [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)])]).
step(aggregate_min([Candidate_cost, Value], Value, (valid_allocation(Value), allocation_cost(Value, Candidate_cost)), [1, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]], [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]),
     builtin,
     [],
     []).
step(registerAnswer(spill_cost, 1),
     rule(24),
     ['Cost' = 1],
     [best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1)]).
step(registerAnswer(place(a), r1),
     rule(25),
     ['Var' = a,
      'Place' = r1,
      'Allocation' = [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]],
     [best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1),
      assigned(a, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], r1)]).
step(assigned(a, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], r1),
     fact(15),
     ['Var' = a, 'Place' = r1],
     []).
step(registerAnswer(place(b), spill),
     rule(25),
     ['Var' = b,
      'Place' = spill,
      'Allocation' = [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]],
     [best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1),
      assigned(b, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], spill)]).
step(assigned(b, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], spill),
     rule(16),
     ['Var' = b, 'Rest' = [bind(b, spill), bind(c, r2), bind(d, r1)], 'Place' = spill],
     [assigned(b, [bind(b, spill), bind(c, r2), bind(d, r1)], spill)]).
step(assigned(b, [bind(b, spill), bind(c, r2), bind(d, r1)], spill),
     fact(15),
     ['Var' = b, 'Place' = spill],
     []).
step(registerAnswer(place(c), r2),
     rule(25),
     ['Var' = c,
      'Place' = r2,
      'Allocation' = [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]],
     [best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1),
      assigned(c, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], r2)]).
step(assigned(c, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], r2),
     rule(16),
     ['Var' = c, 'Rest' = [bind(b, spill), bind(c, r2), bind(d, r1)], 'Place' = r2],
     [assigned(c, [bind(b, spill), bind(c, r2), bind(d, r1)], r2)]).
step(assigned(c, [bind(b, spill), bind(c, r2), bind(d, r1)], r2),
     rule(16),
     ['Var' = c, 'Rest' = [bind(c, r2), bind(d, r1)], 'Place' = r2],
     [assigned(c, [bind(c, r2), bind(d, r1)], r2)]).
step(assigned(c, [bind(c, r2), bind(d, r1)], r2), fact(15), ['Var' = c, 'Place' = r2], []).
step(registerAnswer(place(d), r1),
     rule(25),
     ['Var' = d,
      'Place' = r1,
      'Allocation' = [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]],
     [best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1),
      assigned(d, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], r1)]).
step(assigned(d, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], r1),
     rule(16),
     ['Var' = d, 'Rest' = [bind(b, spill), bind(c, r2), bind(d, r1)], 'Place' = r1],
     [assigned(d, [bind(b, spill), bind(c, r2), bind(d, r1)], r1)]).
step(assigned(d, [bind(b, spill), bind(c, r2), bind(d, r1)], r1),
     rule(16),
     ['Var' = d, 'Rest' = [bind(c, r2), bind(d, r1)], 'Place' = r1],
     [assigned(d, [bind(c, r2), bind(d, r1)], r1)]).
step(assigned(d, [bind(c, r2), bind(d, r1)], r1),
     rule(16),
     ['Var' = d, 'Rest' = [bind(d, r1)], 'Place' = r1],
     [assigned(d, [bind(d, r1)], r1)]).
step(assigned(d, [bind(d, r1)], r1), fact(15), ['Var' = d, 'Place' = r1], []).
step(registerAnswer(valid_allocation_count, 33),
     rule(26),
     ['Count' = 33],
     [countall(valid_allocation(__anon8), 33)]).
step(countall(valid_allocation(__anon8), 33), builtin, [], []).
step(registerAnswer(note, "the cheapest solution spills b to color the a-b-c triangle with two registers"),
     rule(27),
     [],
     [best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1)]).
