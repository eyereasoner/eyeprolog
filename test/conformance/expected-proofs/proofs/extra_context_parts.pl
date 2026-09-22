answer(context_parts, alpha, []).
why(
  answer(context_parts, alpha, []),
  step(
    answer(context_parts, alpha, []),
    rule("<stdin>", clause(4)),
    ['Name' = alpha, 'Args' = []],
    [
      step(
        context_parts(alpha, []),
        rule("<stdin>", clause(3)),
        ['Name' = alpha, 'Args' = [], 'Statement' = alpha],
        [
          step(context_statement(alpha), fact("<stdin>", clause(1)), [], []),
          step('=..'(alpha, [alpha]), builtin('=..', 2), [], []),
          step(atom(alpha), builtin(atom, 1), [], [])
        ]
      )
    ]
  )
).

answer(context_parts, beta, [2]).
why(
  answer(context_parts, beta, [2]),
  step(
    answer(context_parts, beta, [2]),
    rule("<stdin>", clause(4)),
    ['Name' = beta, 'Args' = [2]],
    [
      step(
        context_parts(beta, [2]),
        rule("<stdin>", clause(3)),
        ['Name' = beta, 'Args' = [2], 'Statement' = beta(2)],
        [
          step(context_statement(beta(2)), fact("<stdin>", clause(2)), [], []),
          step('=..'(beta(2), [beta, 2]), builtin('=..', 2), [], []),
          step(atom(beta), builtin(atom, 1), [], [])
        ]
      )
    ]
  )
).

