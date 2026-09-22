ancestor(pat, jan).
why(
  ancestor(pat, jan),
  step(
    ancestor(pat, jan),
    rule("ancestor.pl", clause(4)),
    ['X' = pat, 'Y' = jan],
    [
      step(parent(pat, jan), fact("ancestor.pl", clause(1)), [], [])
    ]
  )
).

ancestor(jan, lies).
why(
  ancestor(jan, lies),
  step(
    ancestor(jan, lies),
    rule("ancestor.pl", clause(4)),
    ['X' = jan, 'Y' = lies],
    [
      step(parent(jan, lies), fact("ancestor.pl", clause(2)), [], [])
    ]
  )
).

ancestor(lies, emma).
why(
  ancestor(lies, emma),
  step(
    ancestor(lies, emma),
    rule("ancestor.pl", clause(4)),
    ['X' = lies, 'Y' = emma],
    [
      step(parent(lies, emma), fact("ancestor.pl", clause(3)), [], [])
    ]
  )
).

ancestor(pat, lies).
why(
  ancestor(pat, lies),
  step(
    ancestor(pat, lies),
    rule("ancestor.pl", clause(5)),
    ['X' = pat, 'Z' = lies, 'Y' = jan],
    [
      step(parent(pat, jan), fact("ancestor.pl", clause(1)), [], []),
      step(
        ancestor(jan, lies),
        rule("ancestor.pl", clause(4)),
        ['X' = jan, 'Y' = lies],
        [
          step(parent(jan, lies), fact("ancestor.pl", clause(2)), [], [])
        ]
      )
    ]
  )
).

ancestor(pat, emma).
why(
  ancestor(pat, emma),
  step(
    ancestor(pat, emma),
    rule("ancestor.pl", clause(5)),
    ['X' = pat, 'Z' = emma, 'Y' = jan],
    [
      step(parent(pat, jan), fact("ancestor.pl", clause(1)), [], []),
      step(
        ancestor(jan, emma),
        rule("ancestor.pl", clause(5)),
        ['X' = jan, 'Z' = emma, 'Y' = lies],
        [
          step(parent(jan, lies), fact("ancestor.pl", clause(2)), [], []),
          step(
            ancestor(lies, emma),
            rule("ancestor.pl", clause(4)),
            ['X' = lies, 'Y' = emma],
            [
              step(parent(lies, emma), fact("ancestor.pl", clause(3)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

ancestor(jan, emma).
why(
  ancestor(jan, emma),
  step(
    ancestor(jan, emma),
    rule("ancestor.pl", clause(5)),
    ['X' = jan, 'Z' = emma, 'Y' = lies],
    [
      step(parent(jan, lies), fact("ancestor.pl", clause(2)), [], []),
      step(
        ancestor(lies, emma),
        rule("ancestor.pl", clause(4)),
        ['X' = lies, 'Y' = emma],
        [
          step(parent(lies, emma), fact("ancestor.pl", clause(3)), [], [])
        ]
      )
    ]
  )
).

