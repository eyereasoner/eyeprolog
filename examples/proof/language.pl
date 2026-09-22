path('<urn:example:a>', '<urn:example:b>').
why(
  path('<urn:example:a>', '<urn:example:b>'),
  step(
    path('<urn:example:a>', '<urn:example:b>'),
    rule("language.pl", clause(5)),
    ['X' = '<urn:example:a>', 'Y' = '<urn:example:b>'],
    [
      step(edge('<urn:example:a>', '<urn:example:b>'), fact("language.pl", clause(2)), [], [])
    ]
  )
).

path('<urn:example:b>', '<urn:example:c>').
why(
  path('<urn:example:b>', '<urn:example:c>'),
  step(
    path('<urn:example:b>', '<urn:example:c>'),
    rule("language.pl", clause(5)),
    ['X' = '<urn:example:b>', 'Y' = '<urn:example:c>'],
    [
      step(edge('<urn:example:b>', '<urn:example:c>'), fact("language.pl", clause(3)), [], [])
    ]
  )
).

path('<urn:example:c>', '<urn:example:d>').
why(
  path('<urn:example:c>', '<urn:example:d>'),
  step(
    path('<urn:example:c>', '<urn:example:d>'),
    rule("language.pl", clause(5)),
    ['X' = '<urn:example:c>', 'Y' = '<urn:example:d>'],
    [
      step(edge('<urn:example:c>', '<urn:example:d>'), fact("language.pl", clause(4)), [], [])
    ]
  )
).

path('<urn:example:a>', '<urn:example:c>').
why(
  path('<urn:example:a>', '<urn:example:c>'),
  step(
    path('<urn:example:a>', '<urn:example:c>'),
    rule("language.pl", clause(6)),
    ['X' = '<urn:example:a>', 'Z' = '<urn:example:c>', 'Y' = '<urn:example:b>'],
    [
      step(edge('<urn:example:a>', '<urn:example:b>'), fact("language.pl", clause(2)), [], []),
      step(
        path('<urn:example:b>', '<urn:example:c>'),
        rule("language.pl", clause(5)),
        ['X' = '<urn:example:b>', 'Y' = '<urn:example:c>'],
        [
          step(edge('<urn:example:b>', '<urn:example:c>'), fact("language.pl", clause(3)), [], [])
        ]
      )
    ]
  )
).

path('<urn:example:a>', '<urn:example:d>').
why(
  path('<urn:example:a>', '<urn:example:d>'),
  step(
    path('<urn:example:a>', '<urn:example:d>'),
    rule("language.pl", clause(6)),
    ['X' = '<urn:example:a>', 'Z' = '<urn:example:d>', 'Y' = '<urn:example:b>'],
    [
      step(edge('<urn:example:a>', '<urn:example:b>'), fact("language.pl", clause(2)), [], []),
      step(
        path('<urn:example:b>', '<urn:example:d>'),
        rule("language.pl", clause(6)),
        ['X' = '<urn:example:b>', 'Z' = '<urn:example:d>', 'Y' = '<urn:example:c>'],
        [
          step(edge('<urn:example:b>', '<urn:example:c>'), fact("language.pl", clause(3)), [], []),
          step(
            path('<urn:example:c>', '<urn:example:d>'),
            rule("language.pl", clause(5)),
            ['X' = '<urn:example:c>', 'Y' = '<urn:example:d>'],
            [
              step(edge('<urn:example:c>', '<urn:example:d>'), fact("language.pl", clause(4)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

path('<urn:example:b>', '<urn:example:d>').
why(
  path('<urn:example:b>', '<urn:example:d>'),
  step(
    path('<urn:example:b>', '<urn:example:d>'),
    rule("language.pl", clause(6)),
    ['X' = '<urn:example:b>', 'Z' = '<urn:example:d>', 'Y' = '<urn:example:c>'],
    [
      step(edge('<urn:example:b>', '<urn:example:c>'), fact("language.pl", clause(3)), [], []),
      step(
        path('<urn:example:c>', '<urn:example:d>'),
        rule("language.pl", clause(5)),
        ['X' = '<urn:example:c>', 'Y' = '<urn:example:d>'],
        [
          step(edge('<urn:example:c>', '<urn:example:d>'), fact("language.pl", clause(4)), [], [])
        ]
      )
    ]
  )
).

