witch(girl).
why(
  witch(girl),
  step(
    witch(girl),
    rule("witch.pl", clause(1)),
    ['X' = girl],
    [
      step(
        burns(girl),
        rule("witch.pl", clause(3)),
        ['X' = girl],
        [
          step(
            madeOfWood(girl),
            rule("witch.pl", clause(4)),
            ['X' = girl],
            [
              step(
                floats(girl),
                rule("witch.pl", clause(6)),
                ['Y' = girl, 'X' = duck],
                [
                  step(sameWeight(duck, girl), fact("witch.pl", clause(7)), [], []),
                  step(floats(duck), fact("witch.pl", clause(5)), [], [])
                ]
              )
            ]
          )
        ]
      ),
      step(woman(girl), fact("witch.pl", clause(2)), [], [])
    ]
  )
).

burns(duck).
why(
  burns(duck),
  step(
    burns(duck),
    rule("witch.pl", clause(3)),
    ['X' = duck],
    [
      step(
        madeOfWood(duck),
        rule("witch.pl", clause(4)),
        ['X' = duck],
        [
          step(floats(duck), fact("witch.pl", clause(5)), [], [])
        ]
      )
    ]
  )
).

burns(girl).
why(
  burns(girl),
  step(
    burns(girl),
    rule("witch.pl", clause(3)),
    ['X' = girl],
    [
      step(
        madeOfWood(girl),
        rule("witch.pl", clause(4)),
        ['X' = girl],
        [
          step(
            floats(girl),
            rule("witch.pl", clause(6)),
            ['Y' = girl, 'X' = duck],
            [
              step(sameWeight(duck, girl), fact("witch.pl", clause(7)), [], []),
              step(floats(duck), fact("witch.pl", clause(5)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

madeOfWood(duck).
why(
  madeOfWood(duck),
  step(
    madeOfWood(duck),
    rule("witch.pl", clause(4)),
    ['X' = duck],
    [
      step(floats(duck), fact("witch.pl", clause(5)), [], [])
    ]
  )
).

madeOfWood(girl).
why(
  madeOfWood(girl),
  step(
    madeOfWood(girl),
    rule("witch.pl", clause(4)),
    ['X' = girl],
    [
      step(
        floats(girl),
        rule("witch.pl", clause(6)),
        ['Y' = girl, 'X' = duck],
        [
          step(sameWeight(duck, girl), fact("witch.pl", clause(7)), [], []),
          step(floats(duck), fact("witch.pl", clause(5)), [], [])
        ]
      )
    ]
  )
).

floats(girl).
why(
  floats(girl),
  step(
    floats(girl),
    rule("witch.pl", clause(6)),
    ['Y' = girl, 'X' = duck],
    [
      step(sameWeight(duck, girl), fact("witch.pl", clause(7)), [], []),
      step(floats(duck), fact("witch.pl", clause(5)), [], [])
    ]
  )
).

holds_result(witchExample, true).
why(
  holds_result(witchExample, true),
  step(
    holds_result(witchExample, true),
    rule("witch.pl", clause(8)),
    [],
    [
      step(
        witch(girl),
        rule("witch.pl", clause(1)),
        ['X' = girl],
        [
          step(
            burns(girl),
            rule("witch.pl", clause(3)),
            ['X' = girl],
            [
              step(
                madeOfWood(girl),
                rule("witch.pl", clause(4)),
                ['X' = girl],
                [
                  step(
                    floats(girl),
                    rule("witch.pl", clause(6)),
                    ['Y' = girl, 'X' = duck],
                    [
                      step(sameWeight(duck, girl), fact("witch.pl", clause(7)), [], []),
                      step(floats(duck), fact("witch.pl", clause(5)), [], [])
                    ]
                  )
                ]
              )
            ]
          ),
          step(woman(girl), fact("witch.pl", clause(2)), [], [])
        ]
      )
    ]
  )
).

