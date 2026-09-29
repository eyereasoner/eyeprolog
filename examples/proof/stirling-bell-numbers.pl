stirling_bell_answer(stirling_10_4, 34105.0).
stirling_bell_answer(stirling_12_5, 1379400.0).
stirling_bell_answer(bell_10, 115975).
stirling_bell_answer(bell_12, 4213597).

clause(1, factorial(0, 1), true).
clause(2,
       factorial(var('N'), var('Value')),
       (var('N') > 0,
        var('N1') is var('N') - 1,
        factorial(var('N1'), var('Previous')),
        var('Value') is var('N') * var('Previous'))).
clause(12,
       stirling2(var('N'), var('K'), var('Count')),
       (var('N') > 0,
        var('K') > 0,
        sumall(var('Term'), (between(0, var('K'), var('I')), signed_term(var('N'), var('K'), var('I'), var('Term'))), var('Sum')),
        factorial(var('K'), var('Factorial')),
        var('Count') is var('Sum') / var('Factorial'))).
clause(14,
       bell(var('N'), var('Count')),
       (var('N') > 0,
        var('N1') is var('N') - 1,
        sumall(var('Term'), (between(0, var('N1'), var('K')), binomial(var('N1'), var('K'), var('Choose')), bell(var('K'), var('Bell')), var('Term') is var('Choose') * var('Bell')), var('Count')))).
clause(15, stirling_bell_answer(stirling_10_4, var('Count')), stirling2(10, 4, var('Count'))).
clause(16, stirling_bell_answer(stirling_12_5, var('Count')), stirling2(12, 5, var('Count'))).
clause(17, stirling_bell_answer(bell_10, var('Count')), bell(10, var('Count'))).
clause(18, stirling_bell_answer(bell_12, var('Count')), bell(12, var('Count'))).

step(stirling_bell_answer(stirling_10_4, 34105.0),
     rule(15),
     ['Count' = 34105.0],
     [stirling2(10, 4, 34105.0)]).
step(stirling2(10, 4, 34105.0),
     rule(12),
     ['N' = 10, 'K' = 4, 'Count' = 34105.0, 'Sum' = 818520.0, 'Factorial' = 24],
     [10 > 0,
      4 > 0,
      sumall(Expression, (between(0, 4, I), signed_term(10, 4, I, Expression)), 818520.0),
      factorial(4, 24),
      34105.0 is 818520.0 / 24]).
step(10 > 0, builtin, [], []).
step(4 > 0, builtin, [], []).
step(sumall(Expression, (between(0, 4, I), signed_term(10, 4, I, Expression)), 818520.0),
     builtin,
     [],
     []).
step(factorial(4, 24),
     rule(2),
     ['N' = 4, 'Value' = 24, 'N1' = 3, 'Previous' = 6],
     [4 > 0, 3 is 4 - 1, factorial(3, 6), 24 is 4 * 6]).
step(3 is 4 - 1, builtin, [], []).
step(factorial(3, 6),
     rule(2),
     ['N' = 3, 'Value' = 6, 'N1' = 2, 'Previous' = 2],
     [3 > 0, 2 is 3 - 1, factorial(2, 2), 6 is 3 * 2]).
step(3 > 0, builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(factorial(2, 2),
     rule(2),
     ['N' = 2, 'Value' = 2, 'N1' = 1, 'Previous' = 1],
     [2 > 0, 1 is 2 - 1, factorial(1, 1), 2 is 2 * 1]).
step(2 > 0, builtin, [], []).
step(1 is 2 - 1, builtin, [], []).
step(factorial(1, 1),
     rule(2),
     ['N' = 1, 'Value' = 1, 'N1' = 0, 'Previous' = 1],
     [1 > 0, 0 is 1 - 1, factorial(0, 1), 1 is 1 * 1]).
step(1 > 0, builtin, [], []).
step(0 is 1 - 1, builtin, [], []).
step(factorial(0, 1), fact(1), [], []).
step(1 is 1 * 1, builtin, [], []).
step(2 is 2 * 1, builtin, [], []).
step(6 is 3 * 2, builtin, [], []).
step(24 is 4 * 6, builtin, [], []).
step(34105.0 is 818520.0 / 24, builtin, [], []).
step(stirling_bell_answer(stirling_12_5, 1379400.0),
     rule(16),
     ['Count' = 1379400.0],
     [stirling2(12, 5, 1379400.0)]).
step(stirling2(12, 5, 1379400.0),
     rule(12),
     ['N' = 12, 'K' = 5, 'Count' = 1379400.0, 'Sum' = 165528000.0, 'Factorial' = 120],
     [12 > 0,
      5 > 0,
      sumall(Expression, (between(0, 5, I), signed_term(12, 5, I, Expression)), 165528000.0),
      factorial(5, 120),
      1379400.0 is 165528000.0 / 120]).
step(12 > 0, builtin, [], []).
step(5 > 0, builtin, [], []).
step(sumall(Expression, (between(0, 5, I), signed_term(12, 5, I, Expression)), 165528000.0),
     builtin,
     [],
     []).
step(factorial(5, 120),
     rule(2),
     ['N' = 5, 'Value' = 120, 'N1' = 4, 'Previous' = 24],
     [5 > 0, 4 is 5 - 1, factorial(4, 24), 120 is 5 * 24]).
step(4 is 5 - 1, builtin, [], []).
step(120 is 5 * 24, builtin, [], []).
step(1379400.0 is 165528000.0 / 120, builtin, [], []).
step(stirling_bell_answer(bell_10, 115975), rule(17), ['Count' = 115975], [bell(10, 115975)]).
step(bell(10, 115975),
     rule(14),
     ['N' = 10, 'Count' = 115975, 'N1' = 9],
     [10 > 0,
      9 is 10 - 1,
      sumall(Expression, (between(0, 9, K), binomial(9, K, Choose), bell(K, Bell), Expression is Choose * Bell), 115975)]).
step(9 is 10 - 1, builtin, [], []).
step(sumall(Expression, (between(0, 9, K), binomial(9, K, Choose), bell(K, Bell), Expression is Choose * Bell), 115975),
     builtin,
     [],
     []).
step(stirling_bell_answer(bell_12, 4213597), rule(18), ['Count' = 4213597], [bell(12, 4213597)]).
step(bell(12, 4213597),
     rule(14),
     ['N' = 12, 'Count' = 4213597, 'N1' = 11],
     [12 > 0,
      11 is 12 - 1,
      sumall(Expression, (between(0, 11, K), binomial(11, K, Choose), bell(K, Bell), Expression is Choose * Bell), 4213597)]).
step(11 is 12 - 1, builtin, [], []).
step(sumall(Expression, (between(0, 11, K), binomial(11, K, Choose), bell(K, Bell), Expression is Choose * Bell), 4213597),
     builtin,
     [],
     []).
