cdclAnswer(conflict_clause, c2).
why(
  cdclAnswer(conflict_clause, c2),
  step(
    cdclAnswer(conflict_clause, c2),
    rule("cdcl-sat-solver.pl", clause(22)),
    ['Clause' = c2],
    [
      step(
        conflict(initial, c2),
        rule("cdcl-sat-solver.pl", clause(12)),
        ['Trail' = initial, 'Clause' = c2, 'Literals' = [neg(c)]],
        [
          step(sat_clause(c2, [neg(c)]), fact("cdcl-sat-solver.pl", clause(2)), [], []),
          step('\\+'(nonfalse_literal(initial, [neg(c)])), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

cdclAnswer(learned_clause, [neg(a)]).
why(
  cdclAnswer(learned_clause, [neg(a)]),
  step(
    cdclAnswer(learned_clause, [neg(a)]),
    rule("cdcl-sat-solver.pl", clause(23)),
    ['Literals' = [neg(a)]],
    [
      step(learned_clause(l1, [neg(a)]), fact("cdcl-sat-solver.pl", clause(14)), [], [])
    ]
  )
).

cdclAnswer(learned_from, resolve(c2, c1, pivot(c))).
why(
  cdclAnswer(learned_from, resolve(c2, c1, pivot(c))),
  step(
    cdclAnswer(learned_from, resolve(c2, c1, pivot(c))),
    rule("cdcl-sat-solver.pl", clause(24)),
    ['Reason' = resolve(c2, c1, pivot(c))],
    [
      step(learned_from(l1, resolve(c2, c1, pivot(c))), fact("cdcl-sat-solver.pl", clause(15)), [], [])
    ]
  )
).

cdclAnswer(final_value(a), false).
why(
  cdclAnswer(final_value(a), false),
  step(
    cdclAnswer(final_value(a), false),
    rule("cdcl-sat-solver.pl", clause(25)),
    ['Var' = a, 'Value' = false, '__anon5' = learned(l1)],
    [
      step(
        final_model_ok(ok),
        rule("cdcl-sat-solver.pl", clause(20)),
        [],
        [
          step('\\+'(unsatisfied_final_clause), builtin('\\+', 1), [], [])
        ]
      ),
      step(final_value(a, false, learned(l1)), fact("cdcl-sat-solver.pl", clause(16)), [], [])
    ]
  )
).

cdclAnswer(final_value(c), false).
why(
  cdclAnswer(final_value(c), false),
  step(
    cdclAnswer(final_value(c), false),
    rule("cdcl-sat-solver.pl", clause(25)),
    ['Var' = c, 'Value' = false, '__anon5' = unit(c2)],
    [
      step(
        final_model_ok(ok),
        rule("cdcl-sat-solver.pl", clause(20)),
        [],
        [
          step('\\+'(unsatisfied_final_clause), builtin('\\+', 1), [], [])
        ]
      ),
      step(final_value(c, false, unit(c2)), fact("cdcl-sat-solver.pl", clause(17)), [], [])
    ]
  )
).

cdclAnswer(final_value(b), true).
why(
  cdclAnswer(final_value(b), true),
  step(
    cdclAnswer(final_value(b), true),
    rule("cdcl-sat-solver.pl", clause(25)),
    ['Var' = b, 'Value' = true, '__anon5' = unit(c3)],
    [
      step(
        final_model_ok(ok),
        rule("cdcl-sat-solver.pl", clause(20)),
        [],
        [
          step('\\+'(unsatisfied_final_clause), builtin('\\+', 1), [], [])
        ]
      ),
      step(final_value(b, true, unit(c3)), fact("cdcl-sat-solver.pl", clause(18)), [], [])
    ]
  )
).

cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses").
why(
  cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses"),
  step(
    cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses"),
    rule("cdcl-sat-solver.pl", clause(26)),
    [],
    [
      step(
        final_model_ok(ok),
        rule("cdcl-sat-solver.pl", clause(20)),
        [],
        [
          step('\\+'(unsatisfied_final_clause), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

