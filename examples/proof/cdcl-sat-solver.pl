cdclAnswer(conflict_clause, c2).
why(
  cdclAnswer(conflict_clause, c2),
  proof(
    goal(cdclAnswer(conflict_clause, c2)),
    by(rule("cdcl-sat-solver.pl", clause(22))),
    bindings([binding("Clause", c2)]),
    uses([
      proof(
        goal(conflict(initial, c2)),
        by(rule("cdcl-sat-solver.pl", clause(12))),
        bindings([binding("Trail", initial), binding("Clause", c2), binding("Literals", [neg(c)])]),
        uses([
          proof(
            goal(sat_clause(c2, [neg(c)])),
            by(fact("cdcl-sat-solver.pl", clause(2)))
          ),
          proof(
            goal('\\+'(nonfalse_literal(initial, [neg(c)]))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

cdclAnswer(learned_clause, [neg(a)]).
why(
  cdclAnswer(learned_clause, [neg(a)]),
  proof(
    goal(cdclAnswer(learned_clause, [neg(a)])),
    by(rule("cdcl-sat-solver.pl", clause(23))),
    bindings([binding("Literals", [neg(a)])]),
    uses([
      proof(
        goal(learned_clause(l1, [neg(a)])),
        by(fact("cdcl-sat-solver.pl", clause(14)))
      )
    ])
  )
).

cdclAnswer(learned_from, resolve(c2, c1, pivot(c))).
why(
  cdclAnswer(learned_from, resolve(c2, c1, pivot(c))),
  proof(
    goal(cdclAnswer(learned_from, resolve(c2, c1, pivot(c)))),
    by(rule("cdcl-sat-solver.pl", clause(24))),
    bindings([binding("Reason", resolve(c2, c1, pivot(c)))]),
    uses([
      proof(
        goal(learned_from(l1, resolve(c2, c1, pivot(c)))),
        by(fact("cdcl-sat-solver.pl", clause(15)))
      )
    ])
  )
).

cdclAnswer(final_value(a), false).
why(
  cdclAnswer(final_value(a), false),
  proof(
    goal(cdclAnswer(final_value(a), false)),
    by(rule("cdcl-sat-solver.pl", clause(25))),
    bindings([binding("Var", a), binding("Value", false), binding("__anon5", learned(l1))]),
    uses([
      proof(
        goal(final_model_ok(ok)),
        by(rule("cdcl-sat-solver.pl", clause(20))),
        uses([
          proof(
            goal('\\+'(unsatisfied_final_clause)),
            by(builtin('\\+', 1))
          )
        ])
      ),
      proof(
        goal(final_value(a, false, learned(l1))),
        by(fact("cdcl-sat-solver.pl", clause(16)))
      )
    ])
  )
).

cdclAnswer(final_value(c), false).
why(
  cdclAnswer(final_value(c), false),
  proof(
    goal(cdclAnswer(final_value(c), false)),
    by(rule("cdcl-sat-solver.pl", clause(25))),
    bindings([binding("Var", c), binding("Value", false), binding("__anon5", unit(c2))]),
    uses([
      proof(
        goal(final_model_ok(ok)),
        by(rule("cdcl-sat-solver.pl", clause(20))),
        uses([
          proof(
            goal('\\+'(unsatisfied_final_clause)),
            by(builtin('\\+', 1))
          )
        ])
      ),
      proof(
        goal(final_value(c, false, unit(c2))),
        by(fact("cdcl-sat-solver.pl", clause(17)))
      )
    ])
  )
).

cdclAnswer(final_value(b), true).
why(
  cdclAnswer(final_value(b), true),
  proof(
    goal(cdclAnswer(final_value(b), true)),
    by(rule("cdcl-sat-solver.pl", clause(25))),
    bindings([binding("Var", b), binding("Value", true), binding("__anon5", unit(c3))]),
    uses([
      proof(
        goal(final_model_ok(ok)),
        by(rule("cdcl-sat-solver.pl", clause(20))),
        uses([
          proof(
            goal('\\+'(unsatisfied_final_clause)),
            by(builtin('\\+', 1))
          )
        ])
      ),
      proof(
        goal(final_value(b, true, unit(c3))),
        by(fact("cdcl-sat-solver.pl", clause(18)))
      )
    ])
  )
).

cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses").
why(
  cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses"),
  proof(
    goal(cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses")),
    by(rule("cdcl-sat-solver.pl", clause(26))),
    uses([
      proof(
        goal(final_model_ok(ok)),
        by(rule("cdcl-sat-solver.pl", clause(20))),
        uses([
          proof(
            goal('\\+'(unsatisfied_final_clause)),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

