n(case, 202692987).
factorsSmallest(case, [3, 3, 7, 829, 3881]).
factorsLargest(case, [3881, 829, 7, 3, 3]).
product(case, 202692987).
expectedFactorsMatched(case, true).
productReconstructsInput(case, true).
distinctPrimeCount(case, 4).
smallestPrimeFactor(case, 3).
largestPrimeFactor(case, 3881).

clause(2, case(fta, 202692987), true).
clause(3, expected_factors(fta, [3, 3, 7, 829, 3881]), true).
clause(6, trial_prime(3), true).
clause(7, trial_prime(var('P')), (var('P') > 3, smallest_divisor_from(var('P'), 2, var('P')))).
clause(9,
       factor_smallest(var('N'), [var('N')]),
       (var('N') >= 2, smallest_divisor_from(var('N'), 2, var('N')))).
clause(10,
       factor_smallest(var('N'), var('Factors')),
       (var('N') >= 2,
        smallest_divisor_from(var('N'), 2, var('D')),
        var('D') \= var('N'),
        var('Q') is var('N') // var('D'),
        factor_smallest(var('D'), var('Left')),
        factor_smallest(var('Q'), var('Right')),
        append(var('Left'), var('Right'), var('Factors')))).
clause(11,
       factor_largest(var('N'), var('Factors')),
       (factor_smallest(var('N'), var('Smallest')), reverse(var('Smallest'), var('Factors')))).
clause(12, factor_product([], 1), true).
clause(13,
       factor_product([var('X') | var('Rest')], var('P')),
       (factor_product(var('Rest'), var('P0')), var('P') is var('X') * var('P0'))).
clause(14,
       all_expected_primes(true),
       (trial_prime(3), trial_prime(7), trial_prime(829), trial_prime(3881))).
clause(15, n(case, var('N')), case(fta, var('N'))).
clause(16,
       factorsSmallest(case, var('Factors')),
       (case(fta, var('N')), factor_smallest(var('N'), var('Factors')))).
clause(17,
       factorsLargest(case, var('Factors')),
       (case(fta, var('N')), factor_largest(var('N'), var('Factors')))).
clause(18,
       product(case, var('Product')),
       (case(fta, var('N')),
        factor_smallest(var('N'), var('Factors')),
        factor_product(var('Factors'), var('Product')))).
clause(19,
       expectedFactorsMatched(case, true),
       (case(fta, var('N')),
        expected_factors(fta, var('Factors')),
        factor_smallest(var('N'), var('Factors')))).
clause(20,
       productReconstructsInput(case, true),
       (case(fta, var('N')),
        factor_smallest(var('N'), var('Factors')),
        factor_product(var('Factors'), var('N')))).
clause(21, distinctPrimeCount(case, 4), all_expected_primes(true)).
clause(22,
       smallestPrimeFactor(case, 3),
       (case(fta, var('N')), factor_smallest(var('N'), [3 | anonymous(1)]))).
clause(23,
       largestPrimeFactor(case, 3881),
       (case(fta, var('N')), factor_largest(var('N'), [3881 | anonymous(1)]))).

step(n(case, 202692987), rule(15), ['N' = 202692987], [case(fta, 202692987)]).
step(case(fta, 202692987), fact(2), [], []).
step(factorsSmallest(case, [3, 3, 7, 829, 3881]),
     rule(16),
     ['Factors' = [3, 3, 7, 829, 3881], 'N' = 202692987],
     [case(fta, 202692987), factor_smallest(202692987, [3, 3, 7, 829, 3881])]).
step(factor_smallest(202692987, [3, 3, 7, 829, 3881]),
     rule(10),
     ['N' = 202692987,
      'Factors' = [3, 3, 7, 829, 3881],
      'D' = 3,
      'Q' = 67564329,
      'Left' = [3],
      'Right' = [3, 7, 829, 3881]],
     [202692987 >= 2,
      smallest_divisor_from(202692987, 2, 3),
      3 \= 202692987,
      67564329 is 202692987 // 3,
      factor_smallest(3, [3]),
      factor_smallest(67564329, [3, 7, 829, 3881]),
      append([3], [3, 7, 829, 3881], [3, 3, 7, 829, 3881])]).
step(202692987 >= 2, builtin, [], []).
step(smallest_divisor_from(202692987, 2, 3), builtin, [], []).
step(3 \= 202692987, builtin, [], []).
step(67564329 is 202692987 // 3, builtin, [], []).
step(factor_smallest(3, [3]), rule(9), ['N' = 3], [3 >= 2, smallest_divisor_from(3, 2, 3)]).
step(3 >= 2, builtin, [], []).
step(smallest_divisor_from(3, 2, 3), builtin, [], []).
step(factor_smallest(67564329, [3, 7, 829, 3881]),
     rule(10),
     ['N' = 67564329,
      'Factors' = [3, 7, 829, 3881],
      'D' = 3,
      'Q' = 22521443,
      'Left' = [3],
      'Right' = [7, 829, 3881]],
     [67564329 >= 2,
      smallest_divisor_from(67564329, 2, 3),
      3 \= 67564329,
      22521443 is 67564329 // 3,
      factor_smallest(3, [3]),
      factor_smallest(22521443, [7, 829, 3881]),
      append([3], [7, 829, 3881], [3, 7, 829, 3881])]).
step(67564329 >= 2, builtin, [], []).
step(smallest_divisor_from(67564329, 2, 3), builtin, [], []).
step(3 \= 67564329, builtin, [], []).
step(22521443 is 67564329 // 3, builtin, [], []).
step(factor_smallest(22521443, [7, 829, 3881]),
     rule(10),
     ['N' = 22521443,
      'Factors' = [7, 829, 3881],
      'D' = 7,
      'Q' = 3217349,
      'Left' = [7],
      'Right' = [829, 3881]],
     [22521443 >= 2,
      smallest_divisor_from(22521443, 2, 7),
      7 \= 22521443,
      3217349 is 22521443 // 7,
      factor_smallest(7, [7]),
      factor_smallest(3217349, [829, 3881]),
      append([7], [829, 3881], [7, 829, 3881])]).
step(22521443 >= 2, builtin, [], []).
step(smallest_divisor_from(22521443, 2, 7), builtin, [], []).
step(7 \= 22521443, builtin, [], []).
step(3217349 is 22521443 // 7, builtin, [], []).
step(factor_smallest(7, [7]), rule(9), ['N' = 7], [7 >= 2, smallest_divisor_from(7, 2, 7)]).
step(7 >= 2, builtin, [], []).
step(smallest_divisor_from(7, 2, 7), builtin, [], []).
step(factor_smallest(3217349, [829, 3881]),
     rule(10),
     ['N' = 3217349,
      'Factors' = [829, 3881],
      'D' = 829,
      'Q' = 3881,
      'Left' = [829],
      'Right' = [3881]],
     [3217349 >= 2,
      smallest_divisor_from(3217349, 2, 829),
      829 \= 3217349,
      3881 is 3217349 // 829,
      factor_smallest(829, [829]),
      factor_smallest(3881, [3881]),
      append([829], [3881], [829, 3881])]).
step(3217349 >= 2, builtin, [], []).
step(smallest_divisor_from(3217349, 2, 829), builtin, [], []).
step(829 \= 3217349, builtin, [], []).
step(3881 is 3217349 // 829, builtin, [], []).
step(factor_smallest(829, [829]),
     rule(9),
     ['N' = 829],
     [829 >= 2, smallest_divisor_from(829, 2, 829)]).
step(829 >= 2, builtin, [], []).
step(smallest_divisor_from(829, 2, 829), builtin, [], []).
step(factor_smallest(3881, [3881]),
     rule(9),
     ['N' = 3881],
     [3881 >= 2, smallest_divisor_from(3881, 2, 3881)]).
step(3881 >= 2, builtin, [], []).
step(smallest_divisor_from(3881, 2, 3881), builtin, [], []).
step(append([829], [3881], [829, 3881]), builtin, [], []).
step(append([7], [829, 3881], [7, 829, 3881]), builtin, [], []).
step(append([3], [7, 829, 3881], [3, 7, 829, 3881]), builtin, [], []).
step(append([3], [3, 7, 829, 3881], [3, 3, 7, 829, 3881]), builtin, [], []).
step(factorsLargest(case, [3881, 829, 7, 3, 3]),
     rule(17),
     ['Factors' = [3881, 829, 7, 3, 3], 'N' = 202692987],
     [case(fta, 202692987), factor_largest(202692987, [3881, 829, 7, 3, 3])]).
step(factor_largest(202692987, [3881, 829, 7, 3, 3]),
     rule(11),
     ['N' = 202692987, 'Factors' = [3881, 829, 7, 3, 3], 'Smallest' = [3, 3, 7, 829, 3881]],
     [factor_smallest(202692987, [3, 3, 7, 829, 3881]),
      reverse([3, 3, 7, 829, 3881], [3881, 829, 7, 3, 3])]).
step(reverse([3, 3, 7, 829, 3881], [3881, 829, 7, 3, 3]), builtin, [], []).
step(product(case, 202692987),
     rule(18),
     ['Product' = 202692987, 'N' = 202692987, 'Factors' = [3, 3, 7, 829, 3881]],
     [case(fta, 202692987),
      factor_smallest(202692987, [3, 3, 7, 829, 3881]),
      factor_product([3, 3, 7, 829, 3881], 202692987)]).
step(factor_product([3, 3, 7, 829, 3881], 202692987),
     rule(13),
     ['X' = 3, 'Rest' = [3, 7, 829, 3881], 'P' = 202692987, 'P0' = 67564329],
     [factor_product([3, 7, 829, 3881], 67564329), 202692987 is 3 * 67564329]).
step(factor_product([3, 7, 829, 3881], 67564329),
     rule(13),
     ['X' = 3, 'Rest' = [7, 829, 3881], 'P' = 67564329, 'P0' = 22521443],
     [factor_product([7, 829, 3881], 22521443), 67564329 is 3 * 22521443]).
step(factor_product([7, 829, 3881], 22521443),
     rule(13),
     ['X' = 7, 'Rest' = [829, 3881], 'P' = 22521443, 'P0' = 3217349],
     [factor_product([829, 3881], 3217349), 22521443 is 7 * 3217349]).
step(factor_product([829, 3881], 3217349),
     rule(13),
     ['X' = 829, 'Rest' = [3881], 'P' = 3217349, 'P0' = 3881],
     [factor_product([3881], 3881), 3217349 is 829 * 3881]).
step(factor_product([3881], 3881),
     rule(13),
     ['X' = 3881, 'Rest' = [], 'P' = 3881, 'P0' = 1],
     [factor_product([], 1), 3881 is 3881 * 1]).
step(factor_product([], 1), fact(12), [], []).
step(3881 is 3881 * 1, builtin, [], []).
step(3217349 is 829 * 3881, builtin, [], []).
step(22521443 is 7 * 3217349, builtin, [], []).
step(67564329 is 3 * 22521443, builtin, [], []).
step(202692987 is 3 * 67564329, builtin, [], []).
step(expectedFactorsMatched(case, true),
     rule(19),
     ['N' = 202692987, 'Factors' = [3, 3, 7, 829, 3881]],
     [case(fta, 202692987),
      expected_factors(fta, [3, 3, 7, 829, 3881]),
      factor_smallest(202692987, [3, 3, 7, 829, 3881])]).
step(expected_factors(fta, [3, 3, 7, 829, 3881]), fact(3), [], []).
step(productReconstructsInput(case, true),
     rule(20),
     ['N' = 202692987, 'Factors' = [3, 3, 7, 829, 3881]],
     [case(fta, 202692987),
      factor_smallest(202692987, [3, 3, 7, 829, 3881]),
      factor_product([3, 3, 7, 829, 3881], 202692987)]).
step(distinctPrimeCount(case, 4), rule(21), [], [all_expected_primes(true)]).
step(all_expected_primes(true),
     rule(14),
     [],
     [trial_prime(3), trial_prime(7), trial_prime(829), trial_prime(3881)]).
step(trial_prime(3), fact(6), [], []).
step(trial_prime(7), rule(7), ['P' = 7], [7 > 3, smallest_divisor_from(7, 2, 7)]).
step(7 > 3, builtin, [], []).
step(trial_prime(829), rule(7), ['P' = 829], [829 > 3, smallest_divisor_from(829, 2, 829)]).
step(829 > 3, builtin, [], []).
step(trial_prime(3881), rule(7), ['P' = 3881], [3881 > 3, smallest_divisor_from(3881, 2, 3881)]).
step(3881 > 3, builtin, [], []).
step(smallestPrimeFactor(case, 3),
     rule(22),
     ['N' = 202692987],
     [case(fta, 202692987), factor_smallest(202692987, [3, 3, 7, 829, 3881])]).
step(largestPrimeFactor(case, 3881),
     rule(23),
     ['N' = 202692987],
     [case(fta, 202692987), factor_largest(202692987, [3881, 829, 7, 3, 3])]).
