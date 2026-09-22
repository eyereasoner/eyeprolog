result(root, 12).
why(
  result(root, 12),
  step(
    result(root, 12),
    rule("expression-eval.pl", clause(13)),
    ['Value' = 12, 'Node' = eAdd],
    [
      step(root(eAdd), fact("expression-eval.pl", clause(8)), [], []),
      step(
        value(eAdd, 12),
        rule("expression-eval.pl", clause(10)),
        ['Node' = eAdd, 'Value' = 12, 'Left' = eMul, 'Right' = eSub, 'Leftvalue' = 6, 'Rightvalue' = 6],
        [
          step(expr(eAdd, add, eMul, eSub), fact("expression-eval.pl", clause(7)), [], []),
          step(
            value(eMul, 6),
            rule("expression-eval.pl", clause(12)),
            ['Node' = eMul, 'Value' = 6, 'Left' = n2, 'Right' = n3, 'Leftvalue' = 2, 'Rightvalue' = 3],
            [
              step(expr(eMul, mul, n2, n3), fact("expression-eval.pl", clause(5)), [], []),
              step(
                value(n2, 2),
                rule("expression-eval.pl", clause(9)),
                ['Node' = n2, 'Value' = 2],
                [
                  step(number(n2, 2), fact("expression-eval.pl", clause(1)), [], [])
                ]
              ),
              step(
                value(n3, 3),
                rule("expression-eval.pl", clause(9)),
                ['Node' = n3, 'Value' = 3],
                [
                  step(number(n3, 3), fact("expression-eval.pl", clause(2)), [], [])
                ]
              ),
              step(is(6, *(2, 3)), builtin(is, 2), [], [])
            ]
          ),
          step(
            value(eSub, 6),
            rule("expression-eval.pl", clause(11)),
            ['Node' = eSub, 'Value' = 6, 'Left' = n10, 'Right' = n4, 'Leftvalue' = 10, 'Rightvalue' = 4],
            [
              step(expr(eSub, sub, n10, n4), fact("expression-eval.pl", clause(6)), [], []),
              step(
                value(n10, 10),
                rule("expression-eval.pl", clause(9)),
                ['Node' = n10, 'Value' = 10],
                [
                  step(number(n10, 10), fact("expression-eval.pl", clause(3)), [], [])
                ]
              ),
              step(
                value(n4, 4),
                rule("expression-eval.pl", clause(9)),
                ['Node' = n4, 'Value' = 4],
                [
                  step(number(n4, 4), fact("expression-eval.pl", clause(4)), [], [])
                ]
              ),
              step(is(6, '-'(10, 4)), builtin(is, 2), [], [])
            ]
          ),
          step(is(12, '+'(6, 6)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

