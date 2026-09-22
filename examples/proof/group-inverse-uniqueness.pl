sameInverse(x, i, j).
why(
  sameInverse(x, i, j),
  step(
    sameInverse(x, i, j),
    rule("group-inverse-uniqueness.pl", clause(16)),
    ['A' = x, 'B' = i, 'C' = j],
    [
      step(
        leftInverse(x, i),
        rule("group-inverse-uniqueness.pl", clause(14)),
        ['A' = x, 'B' = i],
        [
          step(group_op(i, x, e), fact("group-inverse-uniqueness.pl", clause(7)), [], [])
        ]
      ),
      step(
        rightInverse(x, j),
        rule("group-inverse-uniqueness.pl", clause(15)),
        ['A' = x, 'B' = j],
        [
          step(group_op(x, j, e), fact("group-inverse-uniqueness.pl", clause(8)), [], [])
        ]
      ),
      step(sameTerm(i, j), fact("group-inverse-uniqueness.pl", clause(12)), [], []),
      step(\=(i, j), builtin(\=, 2), [], [])
    ]
  )
).

sameInverse(x, j, i).
why(
  sameInverse(x, j, i),
  step(
    sameInverse(x, j, i),
    rule("group-inverse-uniqueness.pl", clause(16)),
    ['A' = x, 'B' = j, 'C' = i],
    [
      step(
        leftInverse(x, j),
        rule("group-inverse-uniqueness.pl", clause(14)),
        ['A' = x, 'B' = j],
        [
          step(group_op(j, x, e), fact("group-inverse-uniqueness.pl", clause(9)), [], [])
        ]
      ),
      step(
        rightInverse(x, i),
        rule("group-inverse-uniqueness.pl", clause(15)),
        ['A' = x, 'B' = i],
        [
          step(group_op(x, i, e), fact("group-inverse-uniqueness.pl", clause(10)), [], [])
        ]
      ),
      step(sameTerm(j, i), fact("group-inverse-uniqueness.pl", clause(13)), [], []),
      step(\=(j, i), builtin(\=, 2), [], [])
    ]
  )
).

