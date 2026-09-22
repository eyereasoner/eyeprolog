prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]).
why(
  prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]),
  step(
    prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]),
    rule("prime-range.pl", clause(8)),
    ['Primes' = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]],
    [
      step(findall(P, prime(P), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]), builtin(findall, 3), [], [])
    ]
  )
).

prime_result(count_2_30, 10).
why(
  prime_result(count_2_30, 10),
  step(
    prime_result(count_2_30, 10),
    rule("prime-range.pl", clause(9)),
    ['Count' = 10],
    [
      step(countall(prime(_P), 10), library(countall, 2), [], [])
    ]
  )
).

prime_result(totient_271, 270).
why(
  prime_result(totient_271, 270),
  step(
    prime_result(totient_271, 270),
    rule("prime-range.pl", clause(10)),
    ['Phi' = 270],
    [
      step(
        totient(271, 270),
        rule("prime-range.pl", clause(7)),
        ['N' = 271, 'Phi' = 270],
        [
          step(countall(coprime(271, _k), 270), library(countall, 2), [], [])
        ]
      )
    ]
  )
).

