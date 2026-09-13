catalan_answer(catalan_12, 208012).
why(
  catalan_answer(catalan_12, 208012),
  proof(
    goal(catalan_answer(catalan_12, 208012)),
    by(rule("catalan-convolution.pl", clause(6))),
    bindings([binding("C", 208012)]),
    uses([
      proof(
        goal(catalan(12, 208012)),
        by(rule("catalan-convolution.pl", clause(3))),
        bindings([binding("N", 12), binding("C", 208012), binding("N1", 11)]),
        uses([
          proof(
            goal(>(12, 0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(is(11, '-'(12, 1))),
            by(builtin(is, 2))
          ),
          proof(
            goal(sumall(Expression, (between(0, 11, I), is(J, '-'(11, I)), catalan(I, A), catalan(J, B), is(Expression, *(A, B))), 208012)),
            by(library(sumall, 3))
          )
        ])
      )
    ])
  )
).

catalan_answer(triangulations_14_gon, 208012).
why(
  catalan_answer(triangulations_14_gon, 208012),
  proof(
    goal(catalan_answer(triangulations_14_gon, 208012)),
    by(rule("catalan-convolution.pl", clause(7))),
    bindings([binding("Count", 208012)]),
    uses([
      proof(
        goal(polygon_triangulations(14, 208012)),
        by(rule("catalan-convolution.pl", clause(4))),
        bindings([binding("Sides", 14), binding("Count", 208012), binding("N", 12)]),
        uses([
          proof(
            goal(>=(14, 3)),
            by(builtin(>=, 2))
          ),
          proof(
            goal(is(12, '-'(14, 2))),
            by(builtin(is, 2))
          ),
          proof(
            goal(catalan(12, 208012)),
            by(rule("catalan-convolution.pl", clause(3))),
            bindings([binding("N", 12), binding("C", 208012), binding("N1", 11)]),
            uses([
              proof(
                goal(>(12, 0)),
                by(builtin(>, 2))
              ),
              proof(
                goal(is(11, '-'(12, 1))),
                by(builtin(is, 2))
              ),
              proof(
                goal(sumall(Expression, (between(0, 11, I), is(J, '-'(11, I)), catalan(I, A), catalan(J, B), is(Expression, *(A, B))), 208012)),
                by(library(sumall, 3))
              )
            ])
          )
        ])
      )
    ])
  )
).

catalan_answer(parenthesizations_13_factors, 208012).
why(
  catalan_answer(parenthesizations_13_factors, 208012),
  proof(
    goal(catalan_answer(parenthesizations_13_factors, 208012)),
    by(rule("catalan-convolution.pl", clause(8))),
    bindings([binding("Count", 208012)]),
    uses([
      proof(
        goal(parenthesizations(13, 208012)),
        by(rule("catalan-convolution.pl", clause(5))),
        bindings([binding("Factors", 13), binding("Count", 208012), binding("N", 12)]),
        uses([
          proof(
            goal(>=(13, 1)),
            by(builtin(>=, 2))
          ),
          proof(
            goal(is(12, '-'(13, 1))),
            by(builtin(is, 2))
          ),
          proof(
            goal(catalan(12, 208012)),
            by(rule("catalan-convolution.pl", clause(3))),
            bindings([binding("N", 12), binding("C", 208012), binding("N1", 11)]),
            uses([
              proof(
                goal(>(12, 0)),
                by(builtin(>, 2))
              ),
              proof(
                goal(is(11, '-'(12, 1))),
                by(builtin(is, 2))
              ),
              proof(
                goal(sumall(Expression, (between(0, 11, I), is(J, '-'(11, I)), catalan(I, A), catalan(J, B), is(Expression, *(A, B))), 208012)),
                by(library(sumall, 3))
              )
            ])
          )
        ])
      )
    ])
  )
).

catalan_answer(first_ten_sum, 6918).
why(
  catalan_answer(first_ten_sum, 6918),
  proof(
    goal(catalan_answer(first_ten_sum, 6918)),
    by(rule("catalan-convolution.pl", clause(9))),
    bindings([binding("Sum", 6918)]),
    uses([
      proof(
        goal(sumall(Expression, (between(0, 9, N), catalan(N, Expression)), 6918)),
        by(library(sumall, 3))
      )
    ])
  )
).

