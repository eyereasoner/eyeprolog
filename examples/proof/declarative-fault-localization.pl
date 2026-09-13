answer(1, 3, 3, 5).
why(
  answer(1, 3, 3, 5),
  proof(
    goal(answer(1, 3, 3, 5)),
    by(rule("declarative-fault-localization.pl", clause(5))),
    bindings([binding("WholeListWrongAnswer", 1), binding("TwoElementSublistAlreadyWrong", 3), binding("BaseCaseIsCorrect", 3), binding("FixedAnswer", 5)]),
    uses([
      proof(
        goal(buggy_list_max([1, 5, 3], 1)),
        by(rule("declarative-fault-localization.pl", clause(2))),
        bindings([binding("X", 1), binding("Xs", [5, 3]), binding("Max", 1), binding("Max0", 3)]),
        uses([
          proof(
            goal(buggy_list_max([5, 3], 3)),
            by(rule("declarative-fault-localization.pl", clause(2))),
            bindings([binding("X", 5), binding("Xs", [3]), binding("Max", 3), binding("Max0", 3)]),
            uses([
              proof(
                goal(buggy_list_max([3], 3)),
                by(fact("declarative-fault-localization.pl", clause(1))),
                bindings([binding("X", 3)])
              ),
              proof(
                goal(';'(->(>(5, 3), =(3, 3)), =(3, 5))),
                by(builtin(';', 2))
              )
            ])
          ),
          proof(
            goal(';'(->(>(1, 3), =(1, 3)), =(1, 1))),
            by(builtin(';', 2))
          )
        ])
      ),
      proof(
        goal(buggy_list_max([5, 3], 3)),
        by(rule("declarative-fault-localization.pl", clause(2))),
        bindings([binding("X", 5), binding("Xs", [3]), binding("Max", 3), binding("Max0", 3)]),
        uses([
          proof(
            goal(buggy_list_max([3], 3)),
            by(fact("declarative-fault-localization.pl", clause(1))),
            bindings([binding("X", 3)])
          ),
          proof(
            goal(';'(->(>(5, 3), =(3, 3)), =(3, 5))),
            by(builtin(';', 2))
          )
        ])
      ),
      proof(
        goal(buggy_list_max([3], 3)),
        by(fact("declarative-fault-localization.pl", clause(1))),
        bindings([binding("X", 3)])
      ),
      proof(
        goal(fixed_list_max([1, 5, 3], 5)),
        by(rule("declarative-fault-localization.pl", clause(4))),
        bindings([binding("X", 1), binding("Xs", [5, 3]), binding("Max", 5), binding("Max0", 5)]),
        uses([
          proof(
            goal(fixed_list_max([5, 3], 5)),
            by(rule("declarative-fault-localization.pl", clause(4))),
            bindings([binding("X", 5), binding("Xs", [3]), binding("Max", 5), binding("Max0", 3)]),
            uses([
              proof(
                goal(fixed_list_max([3], 3)),
                by(fact("declarative-fault-localization.pl", clause(3))),
                bindings([binding("X", 3)])
              ),
              proof(
                goal(';'(->(>(5, 3), =(5, 5)), =(5, 3))),
                by(builtin(';', 2))
              )
            ])
          ),
          proof(
            goal(';'(->(>(1, 5), =(5, 1)), =(5, 5))),
            by(builtin(';', 2))
          )
        ])
      )
    ])
  )
).

