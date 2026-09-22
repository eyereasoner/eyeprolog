stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]).
why(
  stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
  step(
    stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
    rule("stable-marriage.pl", clause(49)),
    ['Matching' = [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]],
    [
      step(
        once(stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])),
        builtin(once, 1),
        [],
        [
          step(
            stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
            rule("stable-marriage.pl", clause(48)),
            ['Matching' = [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]],
            [
              step(
                matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
                rule("stable-marriage.pl", clause(43)),
                ['W1' = bea, 'W2' = dana, 'W3' = amy, 'W4' = cora],
                [
                  step(
                    perm([amy, bea, cora, dana], [bea, dana, amy, cora]),
                    rule("stable-marriage.pl", clause(42)),
                    ['Items' = [amy, bea, cora, dana], 'X' = bea, 'Rest' = [dana, amy, cora], 'Remaining' = [amy, cora, dana]],
                    [
                      step(select(bea, [amy, bea, cora, dana], [amy, cora, dana]), library(select, 3), [], []),
                      step(
                        perm([amy, cora, dana], [dana, amy, cora]),
                        rule("stable-marriage.pl", clause(42)),
                        ['Items' = [amy, cora, dana], 'X' = dana, 'Rest' = [amy, cora], 'Remaining' = [amy, cora]],
                        [
                          step(select(dana, [amy, cora, dana], [amy, cora]), library(select, 3), [], []),
                          step(
                            perm([amy, cora], [amy, cora]),
                            rule("stable-marriage.pl", clause(42)),
                            ['Items' = [amy, cora], 'X' = amy, 'Rest' = [cora], 'Remaining' = [cora]],
                            [
                              step(select(amy, [amy, cora], [cora]), library(select, 3), [], []),
                              step(
                                perm([cora], [cora]),
                                rule("stable-marriage.pl", clause(42)),
                                ['Items' = [cora], 'X' = cora, 'Rest' = [], 'Remaining' = []],
                                [
                                  step(select(cora, [cora], []), library(select, 3), [], []),
                                  step(perm([], []), fact("stable-marriage.pl", clause(41)), [], [])
                                ]
                              )
                            ]
                          )
                        ]
                      )
                    ]
                  )
                ]
              ),
              step('\\+'(blocking_pair([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)], _man, _woman)), builtin('\\+', 1), [], [])
            ]
          )
        ]
      )
    ]
  )
).

stable_marriage_answer(stable_matching_count, 1).
why(
  stable_marriage_answer(stable_matching_count, 1),
  step(
    stable_marriage_answer(stable_matching_count, 1),
    rule("stable-marriage.pl", clause(50)),
    ['Count' = 1],
    [
      step(countall(stable_matching(_matching), 1), library(countall, 2), [], [])
    ]
  )
).

