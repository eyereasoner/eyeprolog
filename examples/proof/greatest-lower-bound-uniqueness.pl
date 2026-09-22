sameGreatestLowerBound(a, b, g1, g2).
why(
  sameGreatestLowerBound(a, b, g1, g2),
  step(
    sameGreatestLowerBound(a, b, g1, g2),
    rule("greatest-lower-bound-uniqueness.pl", clause(6)),
    ['A' = a, 'B' = b, 'M' = g1, 'N' = g2],
    [
      step(glbOf(g1, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(1)), [], []),
      step(glbOf(g2, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(2)), [], []),
      step(
        sameTerm(g1, g2),
        rule("greatest-lower-bound-uniqueness.pl", clause(5)),
        ['M' = g1, 'N' = g2],
        [
          step(
            leq(g1, g2),
            rule("greatest-lower-bound-uniqueness.pl", clause(4)),
            ['L' = g1, 'M' = g2, 'A' = a, 'B' = b],
            [
              step(glbOf(g2, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(2)), [], []),
              step(
                lowerBoundOf(g1, a, b),
                rule("greatest-lower-bound-uniqueness.pl", clause(3)),
                ['M' = g1, 'A' = a, 'B' = b],
                [
                  step(glbOf(g1, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(1)), [], [])
                ]
              )
            ]
          ),
          step(
            leq(g2, g1),
            rule("greatest-lower-bound-uniqueness.pl", clause(4)),
            ['L' = g2, 'M' = g1, 'A' = a, 'B' = b],
            [
              step(glbOf(g1, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(1)), [], []),
              step(
                lowerBoundOf(g2, a, b),
                rule("greatest-lower-bound-uniqueness.pl", clause(3)),
                ['M' = g2, 'A' = a, 'B' = b],
                [
                  step(glbOf(g2, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(2)), [], [])
                ]
              )
            ]
          )
        ]
      ),
      step(\=(g1, g2), builtin(\=, 2), [], [])
    ]
  )
).

sameGreatestLowerBound(a, b, g2, g1).
why(
  sameGreatestLowerBound(a, b, g2, g1),
  step(
    sameGreatestLowerBound(a, b, g2, g1),
    rule("greatest-lower-bound-uniqueness.pl", clause(6)),
    ['A' = a, 'B' = b, 'M' = g2, 'N' = g1],
    [
      step(glbOf(g2, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(2)), [], []),
      step(glbOf(g1, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(1)), [], []),
      step(
        sameTerm(g2, g1),
        rule("greatest-lower-bound-uniqueness.pl", clause(5)),
        ['M' = g2, 'N' = g1],
        [
          step(
            leq(g2, g1),
            rule("greatest-lower-bound-uniqueness.pl", clause(4)),
            ['L' = g2, 'M' = g1, 'A' = a, 'B' = b],
            [
              step(glbOf(g1, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(1)), [], []),
              step(
                lowerBoundOf(g2, a, b),
                rule("greatest-lower-bound-uniqueness.pl", clause(3)),
                ['M' = g2, 'A' = a, 'B' = b],
                [
                  step(glbOf(g2, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(2)), [], [])
                ]
              )
            ]
          ),
          step(
            leq(g1, g2),
            rule("greatest-lower-bound-uniqueness.pl", clause(4)),
            ['L' = g1, 'M' = g2, 'A' = a, 'B' = b],
            [
              step(glbOf(g2, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(2)), [], []),
              step(
                lowerBoundOf(g1, a, b),
                rule("greatest-lower-bound-uniqueness.pl", clause(3)),
                ['M' = g1, 'A' = a, 'B' = b],
                [
                  step(glbOf(g1, a, b), fact("greatest-lower-bound-uniqueness.pl", clause(1)), [], [])
                ]
              )
            ]
          )
        ]
      ),
      step(\=(g2, g1), builtin(\=, 2), [], [])
    ]
  )
).

