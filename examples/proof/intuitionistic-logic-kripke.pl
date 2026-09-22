intuitionistic_truth(monotone_p_reaches_both, both, atom(p)).
why(
  intuitionistic_truth(monotone_p_reaches_both, both, atom(p)),
  step(
    intuitionistic_truth(monotone_p_reaches_both, both, atom(p)),
    rule("intuitionistic-logic-kripke.pl", clause(20)),
    [],
    [
      step(
        forces(both, atom(p)),
        rule("intuitionistic-logic-kripke.pl", clause(13)),
        ['World' = both, 'Prop' = p, 'Someworld' = left],
        [
          step(
            leq(left, both),
            rule("intuitionistic-logic-kripke.pl", clause(12)),
            ['From' = left, 'To' = both, 'Mid' = both],
            [
              step(step(left, both), fact("intuitionistic-logic-kripke.pl", clause(7)), [], []),
              step(
                leq(both, both),
                rule("intuitionistic-logic-kripke.pl", clause(11)),
                ['World' = both],
                [
                  step(world(both), fact("intuitionistic-logic-kripke.pl", clause(4)), [], [])
                ]
              )
            ]
          ),
          step(base(left, p), fact("intuitionistic-logic-kripke.pl", clause(9)), [], [])
        ]
      )
    ]
  )
).

intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))).
why(
  intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))),
  step(
    intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))),
    rule("intuitionistic-logic-kripke.pl", clause(21)),
    [],
    [
      step(
        forces(root, implies(atom(p), or(atom(p), atom(q)))),
        rule("intuitionistic-logic-kripke.pl", clause(17)),
        ['World' = root, 'Left' = atom(p), 'Right' = or(atom(p), atom(q))],
        [
          step(world(root), fact("intuitionistic-logic-kripke.pl", clause(1)), [], []),
          step('\\+'(bad_implication(root, atom(p), or(atom(p), atom(q)))), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))).
why(
  intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))),
  step(
    intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))),
    rule("intuitionistic-logic-kripke.pl", clause(22)),
    [],
    [
      step(
        forces(root, neg(neg(or(atom(p), atom(q))))),
        rule("intuitionistic-logic-kripke.pl", clause(18)),
        ['World' = root, 'Formula' = neg(or(atom(p), atom(q)))],
        [
          step(
            forces(root, implies(neg(or(atom(p), atom(q))), bottom)),
            rule("intuitionistic-logic-kripke.pl", clause(17)),
            ['World' = root, 'Left' = neg(or(atom(p), atom(q))), 'Right' = bottom],
            [
              step(world(root), fact("intuitionistic-logic-kripke.pl", clause(1)), [], []),
              step('\\+'(bad_implication(root, neg(or(atom(p), atom(q))), bottom)), builtin('\\+', 1), [], [])
            ]
          )
        ]
      )
    ]
  )
).

intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))).
why(
  intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))),
  step(
    intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))),
    rule("intuitionistic-logic-kripke.pl", clause(23)),
    [],
    [
      step('\\+'(forces(root, or(atom(p), atom(q)))), builtin('\\+', 1), [], [])
    ]
  )
).

intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))).
why(
  intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))),
  step(
    intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))),
    rule("intuitionistic-logic-kripke.pl", clause(24)),
    [],
    [
      step('\\+'(forces(root, or(atom(p), neg(atom(p))))), builtin('\\+', 1), [], [])
    ]
  )
).

