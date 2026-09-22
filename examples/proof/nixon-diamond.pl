defaultSupports(nixon, pacifist).
why(
  defaultSupports(nixon, pacifist),
  step(
    defaultSupports(nixon, pacifist),
    rule("nixon-diamond.pl", clause(8)),
    ['Person' = nixon, 'Conclusion' = pacifist],
    [
      step(
        supports_default(nixon, pacifist),
        rule("nixon-diamond.pl", clause(3)),
        ['Person' = nixon],
        [
          step(kind(nixon, quaker), fact("nixon-diamond.pl", clause(1)), [], [])
        ]
      )
    ]
  )
).

defaultSupports(nixon, hawk).
why(
  defaultSupports(nixon, hawk),
  step(
    defaultSupports(nixon, hawk),
    rule("nixon-diamond.pl", clause(8)),
    ['Person' = nixon, 'Conclusion' = hawk],
    [
      step(
        supports_default(nixon, hawk),
        rule("nixon-diamond.pl", clause(4)),
        ['Person' = nixon],
        [
          step(kind(nixon, republican), fact("nixon-diamond.pl", clause(2)), [], [])
        ]
      )
    ]
  )
).

conflict(nixon, conflict(pacifist, hawk)).
why(
  conflict(nixon, conflict(pacifist, hawk)),
  step(
    conflict(nixon, conflict(pacifist, hawk)),
    rule("nixon-diamond.pl", clause(9)),
    ['Person' = nixon, 'A' = pacifist, 'B' = hawk],
    [
      step(
        conflicted(nixon, pacifist, hawk),
        rule("nixon-diamond.pl", clause(7)),
        ['Person' = nixon, 'A' = pacifist, 'B' = hawk],
        [
          step(
            supports_default(nixon, pacifist),
            rule("nixon-diamond.pl", clause(3)),
            ['Person' = nixon],
            [
              step(kind(nixon, quaker), fact("nixon-diamond.pl", clause(1)), [], [])
            ]
          ),
          step(
            supports_default(nixon, hawk),
            rule("nixon-diamond.pl", clause(4)),
            ['Person' = nixon],
            [
              step(kind(nixon, republican), fact("nixon-diamond.pl", clause(2)), [], [])
            ]
          ),
          step(contrary(pacifist, hawk), fact("nixon-diamond.pl", clause(5)), [], [])
        ]
      )
    ]
  )
).

conflict(nixon, conflict(hawk, pacifist)).
why(
  conflict(nixon, conflict(hawk, pacifist)),
  step(
    conflict(nixon, conflict(hawk, pacifist)),
    rule("nixon-diamond.pl", clause(9)),
    ['Person' = nixon, 'A' = hawk, 'B' = pacifist],
    [
      step(
        conflicted(nixon, hawk, pacifist),
        rule("nixon-diamond.pl", clause(7)),
        ['Person' = nixon, 'A' = hawk, 'B' = pacifist],
        [
          step(
            supports_default(nixon, hawk),
            rule("nixon-diamond.pl", clause(4)),
            ['Person' = nixon],
            [
              step(kind(nixon, republican), fact("nixon-diamond.pl", clause(2)), [], [])
            ]
          ),
          step(
            supports_default(nixon, pacifist),
            rule("nixon-diamond.pl", clause(3)),
            ['Person' = nixon],
            [
              step(kind(nixon, quaker), fact("nixon-diamond.pl", clause(1)), [], [])
            ]
          ),
          step(contrary(hawk, pacifist), fact("nixon-diamond.pl", clause(6)), [], [])
        ]
      )
    ]
  )
).

status(nixon, conflicted_default_case).
why(
  status(nixon, conflicted_default_case),
  step(
    status(nixon, conflicted_default_case),
    rule("nixon-diamond.pl", clause(10)),
    ['Person' = nixon, '_a' = pacifist, '_b' = hawk],
    [
      step(
        conflicted(nixon, pacifist, hawk),
        rule("nixon-diamond.pl", clause(7)),
        ['Person' = nixon, 'A' = pacifist, 'B' = hawk],
        [
          step(
            supports_default(nixon, pacifist),
            rule("nixon-diamond.pl", clause(3)),
            ['Person' = nixon],
            [
              step(kind(nixon, quaker), fact("nixon-diamond.pl", clause(1)), [], [])
            ]
          ),
          step(
            supports_default(nixon, hawk),
            rule("nixon-diamond.pl", clause(4)),
            ['Person' = nixon],
            [
              step(kind(nixon, republican), fact("nixon-diamond.pl", clause(2)), [], [])
            ]
          ),
          step(contrary(pacifist, hawk), fact("nixon-diamond.pl", clause(5)), [], [])
        ]
      )
    ]
  )
).

