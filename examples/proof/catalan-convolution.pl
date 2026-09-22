catalan_answer(catalan_12, 208012).
why(
  catalan_answer(catalan_12, 208012),
  step(
    catalan_answer(catalan_12, 208012),
    rule("catalan-convolution.pl", clause(6)),
    ['C' = 208012],
    [
      step(
        catalan(12, 208012),
        rule("catalan-convolution.pl", clause(3)),
        ['N' = 12, 'C' = 208012, 'N1' = 11],
        [
          step(>(12, 0), builtin(>, 2), [], []),
          step(is(11, '-'(12, 1)), builtin(is, 2), [], []),
          step(sumall(Expression, (between(0, 11, I), is(J, '-'(11, I)), catalan(I, A), catalan(J, B), is(Expression, *(A, B))), 208012), library(sumall, 3), [], [])
        ]
      )
    ]
  )
).

catalan_answer(triangulations_14_gon, 208012).
why(
  catalan_answer(triangulations_14_gon, 208012),
  step(
    catalan_answer(triangulations_14_gon, 208012),
    rule("catalan-convolution.pl", clause(7)),
    ['Count' = 208012],
    [
      step(
        polygon_triangulations(14, 208012),
        rule("catalan-convolution.pl", clause(4)),
        ['Sides' = 14, 'Count' = 208012, 'N' = 12],
        [
          step(>=(14, 3), builtin(>=, 2), [], []),
          step(is(12, '-'(14, 2)), builtin(is, 2), [], []),
          step(
            catalan(12, 208012),
            rule("catalan-convolution.pl", clause(3)),
            ['N' = 12, 'C' = 208012, 'N1' = 11],
            [
              step(>(12, 0), builtin(>, 2), [], []),
              step(is(11, '-'(12, 1)), builtin(is, 2), [], []),
              step(sumall(Expression, (between(0, 11, I), is(J, '-'(11, I)), catalan(I, A), catalan(J, B), is(Expression, *(A, B))), 208012), library(sumall, 3), [], [])
            ]
          )
        ]
      )
    ]
  )
).

catalan_answer(parenthesizations_13_factors, 208012).
why(
  catalan_answer(parenthesizations_13_factors, 208012),
  step(
    catalan_answer(parenthesizations_13_factors, 208012),
    rule("catalan-convolution.pl", clause(8)),
    ['Count' = 208012],
    [
      step(
        parenthesizations(13, 208012),
        rule("catalan-convolution.pl", clause(5)),
        ['Factors' = 13, 'Count' = 208012, 'N' = 12],
        [
          step(>=(13, 1), builtin(>=, 2), [], []),
          step(is(12, '-'(13, 1)), builtin(is, 2), [], []),
          step(
            catalan(12, 208012),
            rule("catalan-convolution.pl", clause(3)),
            ['N' = 12, 'C' = 208012, 'N1' = 11],
            [
              step(>(12, 0), builtin(>, 2), [], []),
              step(is(11, '-'(12, 1)), builtin(is, 2), [], []),
              step(sumall(Expression, (between(0, 11, I), is(J, '-'(11, I)), catalan(I, A), catalan(J, B), is(Expression, *(A, B))), 208012), library(sumall, 3), [], [])
            ]
          )
        ]
      )
    ]
  )
).

catalan_answer(first_ten_sum, 6918).
why(
  catalan_answer(first_ten_sum, 6918),
  step(
    catalan_answer(first_ten_sum, 6918),
    rule("catalan-convolution.pl", clause(9)),
    ['Sum' = 6918],
    [
      step(sumall(Expression, (between(0, 9, N), catalan(N, Expression)), 6918), library(sumall, 3), [], [])
    ]
  )
).

