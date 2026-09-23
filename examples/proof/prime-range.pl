prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]).
prime_result(count_2_30, 10).
prime_result(totient_271, 270).

clause(7, totient(var('N'), var('Phi')), countall(coprime(var('N'), anonymous(1)), var('Phi'))).
clause(8,
       prime_result(range_2_30, var('Primes')),
       findall(var('P'), prime(var('P')), var('Primes'))).
clause(9, prime_result(count_2_30, var('Count')), countall(prime(anonymous(1)), var('Count'))).
clause(10, prime_result(totient_271, var('Phi')), totient(271, var('Phi'))).

step(prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]),
     rule(8),
     ['Primes' = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]],
     [findall(P, prime(P), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29])]).
step(findall(P, prime(P), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]), collected, [], []).
step(prime_result(count_2_30, 10), rule(9), ['Count' = 10], [countall(prime(_P), 10)]).
step(countall(prime(_P), 10), builtin, [], []).
step(prime_result(totient_271, 270), rule(10), ['Phi' = 270], [totient(271, 270)]).
step(totient(271, 270), rule(7), ['N' = 271, 'Phi' = 270], [countall(coprime(271, _k), 270)]).
step(countall(coprime(271, _k), 270), builtin, [], []).
