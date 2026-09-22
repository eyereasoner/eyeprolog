answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd).
why(
  answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd),
  step(
    answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd),
    rule("reified-conditionals.pl", clause(3)),
    ['Evens' = [2, 4, 6, 8], 'Odds' = [1, 3, 5, 7], 'First' = even, 'Second' = odd, '__anon1' = [2, 4, 6, 8]],
    [
      step(tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8]), library(tfilter, 3), [], []),
      step(tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8], [1, 3, 5, 7]), library(tpartition, 4), [], []),
      step(if_(even_t(4), =(even, even), =(even, odd)), library(if_, 3), [], []),
      step(if_(even_t(7), =(odd, even), =(odd, odd)), library(if_, 3), [], [])
    ]
  )
).

