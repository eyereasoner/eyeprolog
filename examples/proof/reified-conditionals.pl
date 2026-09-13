answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd).
why(
  answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd),
  proof(
    goal(answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd)),
    by(rule("reified-conditionals.pl", clause(3))),
    bindings([binding("Evens", [2, 4, 6, 8]), binding("Odds", [1, 3, 5, 7]), binding("First", even), binding("Second", odd), binding("__anon1", [2, 4, 6, 8])]),
    uses([
      proof(
        goal(tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8])),
        by(library(tfilter, 3))
      ),
      proof(
        goal(tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8], [1, 3, 5, 7])),
        by(library(tpartition, 4))
      ),
      proof(
        goal(if_(even_t(4), =(even, even), =(even, odd))),
        by(library(if_, 3))
      ),
      proof(
        goal(if_(even_t(7), =(odd, even), =(odd, odd))),
        by(library(if_, 3))
      )
    ])
  )
).

