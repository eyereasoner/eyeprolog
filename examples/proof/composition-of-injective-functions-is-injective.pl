sameInputByCompositeInjectivity(h, a, b).
why(
  sameInputByCompositeInjectivity(h, a, b),
  step(
    sameInputByCompositeInjectivity(h, a, b),
    rule("composition-of-injective-functions-is-injective.pl", clause(21)),
    ['H' = h, 'X' = a, 'Y' = b, 'G' = g, 'F' = f, 'Z' = e],
    [
      step(compositeOf(h, g, f), fact("composition-of-injective-functions-is-injective.pl", clause(18)), [], []),
      step(injective(g), fact("composition-of-injective-functions-is-injective.pl", clause(17)), [], []),
      step(injective(f), fact("composition-of-injective-functions-is-injective.pl", clause(16)), [], []),
      step(
        app(h, a, e),
        rule("composition-of-injective-functions-is-injective.pl", clause(19)),
        ['H' = h, 'X' = a, 'Z' = e, 'G' = g, 'F' = f, 'Y' = c],
        [
          step(compositeOf(h, g, f), fact("composition-of-injective-functions-is-injective.pl", clause(18)), [], []),
          step(app(f, a, c), fact("composition-of-injective-functions-is-injective.pl", clause(12)), [], []),
          step(app(g, c, e), fact("composition-of-injective-functions-is-injective.pl", clause(14)), [], [])
        ]
      ),
      step(
        app(h, b, e),
        rule("composition-of-injective-functions-is-injective.pl", clause(19)),
        ['H' = h, 'X' = b, 'Z' = e, 'G' = g, 'F' = f, 'Y' = d],
        [
          step(compositeOf(h, g, f), fact("composition-of-injective-functions-is-injective.pl", clause(18)), [], []),
          step(app(f, b, d), fact("composition-of-injective-functions-is-injective.pl", clause(13)), [], []),
          step(app(g, d, e), fact("composition-of-injective-functions-is-injective.pl", clause(15)), [], [])
        ]
      ),
      step(
        sameTerm(a, b),
        rule("composition-of-injective-functions-is-injective.pl", clause(11)),
        ['Y' = a, 'X' = b],
        [
          step(@<(a, b), builtin(@<, 2), [], []),
          step(
            sameTerm(b, a),
            rule("composition-of-injective-functions-is-injective.pl", clause(20)),
            ['X' = b, 'Y' = a, 'F' = f, 'U' = d, 'V' = c],
            [
              step(injective(f), fact("composition-of-injective-functions-is-injective.pl", clause(16)), [], []),
              step(app(f, b, d), fact("composition-of-injective-functions-is-injective.pl", clause(13)), [], []),
              step(app(f, a, c), fact("composition-of-injective-functions-is-injective.pl", clause(12)), [], []),
              step(
                sameTerm(d, c),
                rule("composition-of-injective-functions-is-injective.pl", clause(20)),
                ['X' = d, 'Y' = c, 'F' = g, 'U' = e, 'V' = e],
                [
                  step(injective(g), fact("composition-of-injective-functions-is-injective.pl", clause(17)), [], []),
                  step(app(g, d, e), fact("composition-of-injective-functions-is-injective.pl", clause(15)), [], []),
                  step(app(g, c, e), fact("composition-of-injective-functions-is-injective.pl", clause(14)), [], []),
                  step(
                    sameTerm(e, e),
                    rule("composition-of-injective-functions-is-injective.pl", clause(10)),
                    ['X' = e],
                    [
                      step(inZ(e), fact("composition-of-injective-functions-is-injective.pl", clause(7)), [], [])
                    ]
                  )
                ]
              )
            ]
          )
        ]
      ),
      step(\=(a, b), builtin(\=, 2), [], [])
    ]
  )
).

sameInputByCompositeInjectivity(h, b, a).
why(
  sameInputByCompositeInjectivity(h, b, a),
  step(
    sameInputByCompositeInjectivity(h, b, a),
    rule("composition-of-injective-functions-is-injective.pl", clause(21)),
    ['H' = h, 'X' = b, 'Y' = a, 'G' = g, 'F' = f, 'Z' = e],
    [
      step(compositeOf(h, g, f), fact("composition-of-injective-functions-is-injective.pl", clause(18)), [], []),
      step(injective(g), fact("composition-of-injective-functions-is-injective.pl", clause(17)), [], []),
      step(injective(f), fact("composition-of-injective-functions-is-injective.pl", clause(16)), [], []),
      step(
        app(h, b, e),
        rule("composition-of-injective-functions-is-injective.pl", clause(19)),
        ['H' = h, 'X' = b, 'Z' = e, 'G' = g, 'F' = f, 'Y' = d],
        [
          step(compositeOf(h, g, f), fact("composition-of-injective-functions-is-injective.pl", clause(18)), [], []),
          step(app(f, b, d), fact("composition-of-injective-functions-is-injective.pl", clause(13)), [], []),
          step(app(g, d, e), fact("composition-of-injective-functions-is-injective.pl", clause(15)), [], [])
        ]
      ),
      step(
        app(h, a, e),
        rule("composition-of-injective-functions-is-injective.pl", clause(19)),
        ['H' = h, 'X' = a, 'Z' = e, 'G' = g, 'F' = f, 'Y' = c],
        [
          step(compositeOf(h, g, f), fact("composition-of-injective-functions-is-injective.pl", clause(18)), [], []),
          step(app(f, a, c), fact("composition-of-injective-functions-is-injective.pl", clause(12)), [], []),
          step(app(g, c, e), fact("composition-of-injective-functions-is-injective.pl", clause(14)), [], [])
        ]
      ),
      step(
        sameTerm(b, a),
        rule("composition-of-injective-functions-is-injective.pl", clause(20)),
        ['X' = b, 'Y' = a, 'F' = f, 'U' = d, 'V' = c],
        [
          step(injective(f), fact("composition-of-injective-functions-is-injective.pl", clause(16)), [], []),
          step(app(f, b, d), fact("composition-of-injective-functions-is-injective.pl", clause(13)), [], []),
          step(app(f, a, c), fact("composition-of-injective-functions-is-injective.pl", clause(12)), [], []),
          step(
            sameTerm(d, c),
            rule("composition-of-injective-functions-is-injective.pl", clause(20)),
            ['X' = d, 'Y' = c, 'F' = g, 'U' = e, 'V' = e],
            [
              step(injective(g), fact("composition-of-injective-functions-is-injective.pl", clause(17)), [], []),
              step(app(g, d, e), fact("composition-of-injective-functions-is-injective.pl", clause(15)), [], []),
              step(app(g, c, e), fact("composition-of-injective-functions-is-injective.pl", clause(14)), [], []),
              step(
                sameTerm(e, e),
                rule("composition-of-injective-functions-is-injective.pl", clause(10)),
                ['X' = e],
                [
                  step(inZ(e), fact("composition-of-injective-functions-is-injective.pl", clause(7)), [], [])
                ]
              )
            ]
          )
        ]
      ),
      step(\=(b, a), builtin(\=, 2), [], [])
    ]
  )
).

