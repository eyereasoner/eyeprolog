holdsFor(diamondProperty, r).
why(
  holdsFor(diamondProperty, r),
  step(
    holdsFor(diamondProperty, r),
    rule("diamond-property.pl", clause(14)),
    ['Rel' = r],
    [
      step(
        diamond(r, a, b, c, d),
        rule("diamond-property.pl", clause(11)),
        ['Rel' = r, 'A' = a, 'B' = b, 'C' = c, 'D' = d],
        [
          step(
            step(r, a, b),
            rule("diamond-property.pl", clause(12)),
            ['X' = a, 'Y' = b],
            [
              step(r(a, b), fact("diamond-property.pl", clause(5)), [], [])
            ]
          ),
          step(
            step(r, a, c),
            rule("diamond-property.pl", clause(12)),
            ['X' = a, 'Y' = c],
            [
              step(r(a, c), fact("diamond-property.pl", clause(6)), [], [])
            ]
          ),
          step(
            step(r, b, d),
            rule("diamond-property.pl", clause(12)),
            ['X' = b, 'Y' = d],
            [
              step(r(b, d), fact("diamond-property.pl", clause(7)), [], [])
            ]
          ),
          step(
            step(r, c, d),
            rule("diamond-property.pl", clause(12)),
            ['X' = c, 'Y' = d],
            [
              step(r(c, d), fact("diamond-property.pl", clause(8)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

holdsFor(diamondProperty, re).
why(
  holdsFor(diamondProperty, re),
  step(
    holdsFor(diamondProperty, re),
    rule("diamond-property.pl", clause(14)),
    ['Rel' = re],
    [
      step(
        diamond(re, a, b, c, d),
        rule("diamond-property.pl", clause(11)),
        ['Rel' = re, 'A' = a, 'B' = b, 'C' = c, 'D' = d],
        [
          step(
            step(re, a, b),
            rule("diamond-property.pl", clause(13)),
            ['X' = a, 'Y' = b],
            [
              step(
                re(a, b),
                rule("diamond-property.pl", clause(10)),
                ['X' = a, 'Y' = b],
                [
                  step(r(a, b), fact("diamond-property.pl", clause(5)), [], [])
                ]
              )
            ]
          ),
          step(
            step(re, a, c),
            rule("diamond-property.pl", clause(13)),
            ['X' = a, 'Y' = c],
            [
              step(
                re(a, c),
                rule("diamond-property.pl", clause(10)),
                ['X' = a, 'Y' = c],
                [
                  step(r(a, c), fact("diamond-property.pl", clause(6)), [], [])
                ]
              )
            ]
          ),
          step(
            step(re, b, d),
            rule("diamond-property.pl", clause(13)),
            ['X' = b, 'Y' = d],
            [
              step(
                re(b, d),
                rule("diamond-property.pl", clause(10)),
                ['X' = b, 'Y' = d],
                [
                  step(r(b, d), fact("diamond-property.pl", clause(7)), [], [])
                ]
              )
            ]
          ),
          step(
            step(re, c, d),
            rule("diamond-property.pl", clause(13)),
            ['X' = c, 'Y' = d],
            [
              step(
                re(c, d),
                rule("diamond-property.pl", clause(10)),
                ['X' = c, 'Y' = d],
                [
                  step(r(c, d), fact("diamond-property.pl", clause(8)), [], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

commonSuccessor(diamondProperty, d).
why(
  commonSuccessor(diamondProperty, d),
  step(
    commonSuccessor(diamondProperty, d),
    rule("diamond-property.pl", clause(15)),
    ['D' = d],
    [
      step(
        diamond(r, a, b, c, d),
        rule("diamond-property.pl", clause(11)),
        ['Rel' = r, 'A' = a, 'B' = b, 'C' = c, 'D' = d],
        [
          step(
            step(r, a, b),
            rule("diamond-property.pl", clause(12)),
            ['X' = a, 'Y' = b],
            [
              step(r(a, b), fact("diamond-property.pl", clause(5)), [], [])
            ]
          ),
          step(
            step(r, a, c),
            rule("diamond-property.pl", clause(12)),
            ['X' = a, 'Y' = c],
            [
              step(r(a, c), fact("diamond-property.pl", clause(6)), [], [])
            ]
          ),
          step(
            step(r, b, d),
            rule("diamond-property.pl", clause(12)),
            ['X' = b, 'Y' = d],
            [
              step(r(b, d), fact("diamond-property.pl", clause(7)), [], [])
            ]
          ),
          step(
            step(r, c, d),
            rule("diamond-property.pl", clause(12)),
            ['X' = c, 'Y' = d],
            [
              step(r(c, d), fact("diamond-property.pl", clause(8)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

preservedUnderReflexiveClosure(diamondProperty, true).
why(
  preservedUnderReflexiveClosure(diamondProperty, true),
  step(
    preservedUnderReflexiveClosure(diamondProperty, true),
    rule("diamond-property.pl", clause(16)),
    [],
    [
      step(
        diamond(re, a, b, c, d),
        rule("diamond-property.pl", clause(11)),
        ['Rel' = re, 'A' = a, 'B' = b, 'C' = c, 'D' = d],
        [
          step(
            step(re, a, b),
            rule("diamond-property.pl", clause(13)),
            ['X' = a, 'Y' = b],
            [
              step(
                re(a, b),
                rule("diamond-property.pl", clause(10)),
                ['X' = a, 'Y' = b],
                [
                  step(r(a, b), fact("diamond-property.pl", clause(5)), [], [])
                ]
              )
            ]
          ),
          step(
            step(re, a, c),
            rule("diamond-property.pl", clause(13)),
            ['X' = a, 'Y' = c],
            [
              step(
                re(a, c),
                rule("diamond-property.pl", clause(10)),
                ['X' = a, 'Y' = c],
                [
                  step(r(a, c), fact("diamond-property.pl", clause(6)), [], [])
                ]
              )
            ]
          ),
          step(
            step(re, b, d),
            rule("diamond-property.pl", clause(13)),
            ['X' = b, 'Y' = d],
            [
              step(
                re(b, d),
                rule("diamond-property.pl", clause(10)),
                ['X' = b, 'Y' = d],
                [
                  step(r(b, d), fact("diamond-property.pl", clause(7)), [], [])
                ]
              )
            ]
          ),
          step(
            step(re, c, d),
            rule("diamond-property.pl", clause(13)),
            ['X' = c, 'Y' = d],
            [
              step(
                re(c, d),
                rule("diamond-property.pl", clause(10)),
                ['X' = c, 'Y' = d],
                [
                  step(r(c, d), fact("diamond-property.pl", clause(8)), [], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

