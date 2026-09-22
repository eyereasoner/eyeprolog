% Prolog result format 4
query(1, cdclAnswer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = conflict_clause, 'X1' = c2]).
why(1, ['X0' = conflict_clause, 'X1' = c2], [cdclAnswer(conflict_clause, c2)]).
answer(1, ['X0' = learned_clause, 'X1' = [neg(a)]]).
why(1, ['X0' = learned_clause, 'X1' = [neg(a)]], [cdclAnswer(learned_clause, [neg(a)])]).
answer(1, ['X0' = learned_from, 'X1' = resolve(c2, c1, pivot(c))]).
why(1,
    ['X0' = learned_from, 'X1' = resolve(c2, c1, pivot(c))],
    [cdclAnswer(learned_from, resolve(c2, c1, pivot(c)))]).
answer(1, ['X0' = final_value(a), 'X1' = false]).
why(1, ['X0' = final_value(a), 'X1' = false], [cdclAnswer(final_value(a), false)]).
answer(1, ['X0' = final_value(c), 'X1' = false]).
why(1, ['X0' = final_value(c), 'X1' = false], [cdclAnswer(final_value(c), false)]).
answer(1, ['X0' = final_value(b), 'X1' = true]).
why(1, ['X0' = final_value(b), 'X1' = true], [cdclAnswer(final_value(b), true)]).
answer(1,
       ['X0' = note,
        'X1' = "one learned clause makes the final model satisfy all original clauses"]).
why(1,
    ['X0' = note,
     'X1' = "one learned clause makes the final model satisfy all original clauses"],
    [cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses")]).

clause(2, sat_clause(c2, [neg(c)]), true).
clause(12,
       conflict(var('Trail'), var('Clause')),
       (sat_clause(var('Clause'), var('Literals')),
        \+ nonfalse_literal(var('Trail'), var('Literals')))).
clause(14, learned_clause(l1, [neg(a)]), true).
clause(15, learned_from(l1, resolve(c2, c1, pivot(c))), true).
clause(16, final_value(a, false, learned(l1)), true).
clause(17, final_value(c, false, unit(c2)), true).
clause(18, final_value(b, true, unit(c3)), true).
clause(20, final_model_ok(ok), \+ unsatisfied_final_clause).
clause(22, cdclAnswer(conflict_clause, var('Clause')), conflict(initial, var('Clause'))).
clause(23, cdclAnswer(learned_clause, var('Literals')), learned_clause(l1, var('Literals'))).
clause(24, cdclAnswer(learned_from, var('Reason')), learned_from(l1, var('Reason'))).
clause(25,
       cdclAnswer(final_value(var('Var')), var('Value')),
       (final_model_ok(ok), final_value(var('Var'), var('Value'), anonymous(1)))).
clause(26,
       cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses"),
       final_model_ok(ok)).

step(cdclAnswer(conflict_clause, c2), rule(22), ['Clause' = c2], [conflict(initial, c2)]).
step(conflict(initial, c2),
     rule(12),
     ['Trail' = initial, 'Clause' = c2, 'Literals' = [neg(c)]],
     [sat_clause(c2, [neg(c)]), \+ nonfalse_literal(initial, [neg(c)])]).
step(sat_clause(c2, [neg(c)]), fact(2), [], []).
step(\+ nonfalse_literal(initial, [neg(c)]), absent, [], []).
step(cdclAnswer(learned_clause, [neg(a)]),
     rule(23),
     ['Literals' = [neg(a)]],
     [learned_clause(l1, [neg(a)])]).
step(learned_clause(l1, [neg(a)]), fact(14), [], []).
step(cdclAnswer(learned_from, resolve(c2, c1, pivot(c))),
     rule(24),
     ['Reason' = resolve(c2, c1, pivot(c))],
     [learned_from(l1, resolve(c2, c1, pivot(c)))]).
step(learned_from(l1, resolve(c2, c1, pivot(c))), fact(15), [], []).
step(cdclAnswer(final_value(a), false),
     rule(25),
     ['Var' = a, 'Value' = false],
     [final_model_ok(ok), final_value(a, false, learned(l1))]).
step(final_model_ok(ok), rule(20), [], [\+ unsatisfied_final_clause]).
step(\+ unsatisfied_final_clause, absent, [], []).
step(final_value(a, false, learned(l1)), fact(16), [], []).
step(cdclAnswer(final_value(c), false),
     rule(25),
     ['Var' = c, 'Value' = false],
     [final_model_ok(ok), final_value(c, false, unit(c2))]).
step(final_value(c, false, unit(c2)), fact(17), [], []).
step(cdclAnswer(final_value(b), true),
     rule(25),
     ['Var' = b, 'Value' = true],
     [final_model_ok(ok), final_value(b, true, unit(c3))]).
step(final_value(b, true, unit(c3)), fact(18), [], []).
step(cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses"),
     rule(26),
     [],
     [final_model_ok(ok)]).
