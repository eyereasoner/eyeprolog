answer(1, 3, 3, 5).
why(
  answer(1, 3, 3, 5),
  step(
    answer(1, 3, 3, 5),
    rule("declarative-fault-localization.pl", clause(5)),
    ['WholeListWrongAnswer' = 1, 'TwoElementSublistAlreadyWrong' = 3, 'BaseCaseIsCorrect' = 3, 'FixedAnswer' = 5],
    [
      step(
        buggy_list_max([1, 5, 3], 1),
        rule("declarative-fault-localization.pl", clause(2)),
        ['X' = 1, 'Xs' = [5, 3], 'Max' = 1, 'Max0' = 3],
        [
          step(
            buggy_list_max([5, 3], 3),
            rule("declarative-fault-localization.pl", clause(2)),
            ['X' = 5, 'Xs' = [3], 'Max' = 3, 'Max0' = 3],
            [
              step(buggy_list_max([3], 3), fact("declarative-fault-localization.pl", clause(1)), ['X' = 3], []),
              step(';'(->(>(5, 3), =(3, 3)), =(3, 5)), builtin(';', 2), [], [])
            ]
          ),
          step(';'(->(>(1, 3), =(1, 3)), =(1, 1)), builtin(';', 2), [], [])
        ]
      ),
      step(
        buggy_list_max([5, 3], 3),
        rule("declarative-fault-localization.pl", clause(2)),
        ['X' = 5, 'Xs' = [3], 'Max' = 3, 'Max0' = 3],
        [
          step(buggy_list_max([3], 3), fact("declarative-fault-localization.pl", clause(1)), ['X' = 3], []),
          step(';'(->(>(5, 3), =(3, 3)), =(3, 5)), builtin(';', 2), [], [])
        ]
      ),
      step(buggy_list_max([3], 3), fact("declarative-fault-localization.pl", clause(1)), ['X' = 3], []),
      step(
        fixed_list_max([1, 5, 3], 5),
        rule("declarative-fault-localization.pl", clause(4)),
        ['X' = 1, 'Xs' = [5, 3], 'Max' = 5, 'Max0' = 5],
        [
          step(
            fixed_list_max([5, 3], 5),
            rule("declarative-fault-localization.pl", clause(4)),
            ['X' = 5, 'Xs' = [3], 'Max' = 5, 'Max0' = 3],
            [
              step(fixed_list_max([3], 3), fact("declarative-fault-localization.pl", clause(3)), ['X' = 3], []),
              step(';'(->(>(5, 3), =(5, 5)), =(5, 3)), builtin(';', 2), [], [])
            ]
          ),
          step(';'(->(>(1, 5), =(5, 1)), =(5, 5)), builtin(';', 2), [], [])
        ]
      )
    ]
  )
).

