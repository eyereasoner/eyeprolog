stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]).
why(
  stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
  proof(
    goal(stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])),
    by(rule("stable-marriage.pl", clause(49))),
    bindings([binding("Matching", [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])]),
    uses([
      proof(
        goal(once(stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]))),
        by(builtin(once, 1)),
        uses([
          proof(
            goal(stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])),
            by(rule("stable-marriage.pl", clause(48))),
            bindings([binding("Matching", [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])]),
            uses([
              proof(
                goal(matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])),
                by(rule("stable-marriage.pl", clause(43))),
                bindings([binding("W1", bea), binding("W2", dana), binding("W3", amy), binding("W4", cora)]),
                uses([
                  proof(
                    goal(perm([amy, bea, cora, dana], [bea, dana, amy, cora])),
                    by(rule("stable-marriage.pl", clause(42))),
                    bindings([binding("Items", [amy, bea, cora, dana]), binding("X", bea), binding("Rest", [dana, amy, cora]), binding("Remaining", [amy, cora, dana])]),
                    uses([
                      proof(
                        goal(select(bea, [amy, bea, cora, dana], [amy, cora, dana])),
                        by(library(select, 3))
                      ),
                      proof(
                        goal(perm([amy, cora, dana], [dana, amy, cora])),
                        by(rule("stable-marriage.pl", clause(42))),
                        bindings([binding("Items", [amy, cora, dana]), binding("X", dana), binding("Rest", [amy, cora]), binding("Remaining", [amy, cora])]),
                        uses([
                          proof(
                            goal(select(dana, [amy, cora, dana], [amy, cora])),
                            by(library(select, 3))
                          ),
                          proof(
                            goal(perm([amy, cora], [amy, cora])),
                            by(rule("stable-marriage.pl", clause(42))),
                            bindings([binding("Items", [amy, cora]), binding("X", amy), binding("Rest", [cora]), binding("Remaining", [cora])]),
                            uses([
                              proof(
                                goal(select(amy, [amy, cora], [cora])),
                                by(library(select, 3))
                              ),
                              proof(
                                goal(perm([cora], [cora])),
                                by(rule("stable-marriage.pl", clause(42))),
                                bindings([binding("Items", [cora]), binding("X", cora), binding("Rest", []), binding("Remaining", [])]),
                                uses([
                                  proof(
                                    goal(select(cora, [cora], [])),
                                    by(library(select, 3))
                                  ),
                                  proof(
                                    goal(perm([], [])),
                                    by(fact("stable-marriage.pl", clause(41)))
                                  )
                                ])
                              )
                            ])
                          )
                        ])
                      )
                    ])
                  )
                ])
              ),
              proof(
                goal('\\+'(blocking_pair([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)], _man, _woman))),
                by(builtin('\\+', 1))
              )
            ])
          )
        ])
      )
    ])
  )
).

stable_marriage_answer(stable_matching_count, 1).
why(
  stable_marriage_answer(stable_matching_count, 1),
  proof(
    goal(stable_marriage_answer(stable_matching_count, 1)),
    by(rule("stable-marriage.pl", clause(50))),
    bindings([binding("Count", 1)]),
    uses([
      proof(
        goal(countall(stable_matching(_matching), 1)),
        by(library(countall, 2))
      )
    ])
  )
).

