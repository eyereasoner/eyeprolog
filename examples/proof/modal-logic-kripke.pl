modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))).
why(
  modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))),
  step(
    modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))),
    rule("modal-logic-kripke.pl", clause(21)),
    [],
    [
      step(
        mforces(w0, box(atom(clear))),
        rule("modal-logic-kripke.pl", clause(19)),
        ['World' = w0, 'Formula' = atom(clear)],
        [
          step(world(w0), fact("modal-logic-kripke.pl", clause(1)), [], []),
          step('\\+'(box_counterexample(w0, atom(clear))), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

modal_truth(repair_is_possible, w0, diamond(atom(repaired))).
why(
  modal_truth(repair_is_possible, w0, diamond(atom(repaired))),
  step(
    modal_truth(repair_is_possible, w0, diamond(atom(repaired))),
    rule("modal-logic-kripke.pl", clause(22)),
    [],
    [
      step(
        mforces(w0, diamond(atom(repaired))),
        rule("modal-logic-kripke.pl", clause(18)),
        ['World' = w0, 'Formula' = atom(repaired), 'Next' = w2],
        [
          step(accessible(w0, w2), fact("modal-logic-kripke.pl", clause(6)), [], []),
          step(
            mforces(w2, atom(repaired)),
            rule("modal-logic-kripke.pl", clause(16)),
            ['World' = w2, 'Prop' = repaired],
            [
              step(true_at(w2, repaired), fact("modal-logic-kripke.pl", clause(14)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))).
why(
  modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))),
  step(
    modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))),
    rule("modal-logic-kripke.pl", clause(23)),
    [],
    [
      step(
        mforces(w1, diamond(and(atom(clear), atom(clear)))),
        rule("modal-logic-kripke.pl", clause(18)),
        ['World' = w1, 'Formula' = and(atom(clear), atom(clear)), 'Next' = w1],
        [
          step(accessible(w1, w1), fact("modal-logic-kripke.pl", clause(7)), [], []),
          step(
            mforces(w1, and(atom(clear), atom(clear))),
            rule("modal-logic-kripke.pl", clause(17)),
            ['World' = w1, 'Left' = atom(clear), 'Right' = atom(clear)],
            [
              step(
                mforces(w1, atom(clear)),
                rule("modal-logic-kripke.pl", clause(16)),
                ['World' = w1, 'Prop' = clear],
                [
                  step(true_at(w1, clear), fact("modal-logic-kripke.pl", clause(11)), [], [])
                ]
              ),
              step(
                mforces(w1, atom(clear)),
                rule("modal-logic-kripke.pl", clause(16)),
                ['World' = w1, 'Prop' = clear],
                [
                  step(true_at(w1, clear), fact("modal-logic-kripke.pl", clause(11)), [], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

modal_countermodel(repair_not_necessary, w0).
why(
  modal_countermodel(repair_not_necessary, w0),
  step(
    modal_countermodel(repair_not_necessary, w0),
    rule("modal-logic-kripke.pl", clause(24)),
    [],
    [
      step('\\+'(mforces(w0, box(atom(repaired)))), builtin('\\+', 1), [], [])
    ]
  )
).

