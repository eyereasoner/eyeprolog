binomial_answer(choose_24_12, 2704156.0).
binomial_answer(symmetry_24_7, true).
binomial_answer(vandermonde_12_10_8, 319770.0).
binomial_answer(row_12_sum, 4096.0).

clause(2,
       choose(var('N'), var('K'), var('C')),
       (var('K') >= 0, var('K') =< var('N'), choose_step(var('N'), var('K'), 0, 1, var('C')))).
clause(3, choose_step(anonymous(1), var('K'), var('K'), var('Acc'), var('Acc')), true).
clause(4,
       choose_step(var('N'), var('K'), var('I'), var('Acc'), var('C')),
       (var('I') < var('K'),
        var('I1') is var('I') + 1,
        var('Factor') is var('N') - var('I'),
        var('Numerator') is var('Acc') * var('Factor'),
        var('Nextacc') is var('Numerator') / var('I1'),
        choose_step(var('N'), var('K'), var('I1'), var('Nextacc'), var('C')))).
clause(5,
       symmetric(var('N'), var('K')),
       (choose(var('N'), var('K'), var('C')),
        var('Otherk') is var('N') - var('K'),
        choose(var('N'), var('Otherk'), var('C')))).
clause(6,
       vandermonde_sum(var('N'), var('M'), var('R'), var('Sum')),
       sumall(var('Product'), (between(0, var('R'), var('K')), var('Rk') is var('R') - var('K'), choose(var('N'), var('K'), var('A')), choose(var('M'), var('Rk'), var('B')), var('Product') is var('A') * var('B')), var('Sum'))).
clause(7,
       vandermonde(var('N'), var('M'), var('R'), var('Sum')),
       (var('Totaln') is var('N') + var('M'),
        choose(var('Totaln'), var('R'), var('Sum')),
        vandermonde_sum(var('N'), var('M'), var('R'), var('Sum')))).
clause(8, binomial_answer(choose_24_12, var('C')), choose(24, 12, var('C'))).
clause(9, binomial_answer(symmetry_24_7, true), symmetric(24, 7)).
clause(10, binomial_answer(vandermonde_12_10_8, var('Sum')), vandermonde(12, 10, 8, var('Sum'))).
clause(11,
       binomial_answer(row_12_sum, var('Sum')),
       sumall(var('C'), (between(0, 12, var('K')), choose(12, var('K'), var('C'))), var('Sum'))).

step(binomial_answer(choose_24_12, 2704156.0),
     rule(8),
     ['C' = 2704156.0],
     [choose(24, 12, 2704156.0)]).
step(choose(24, 12, 2704156.0),
     rule(2),
     ['N' = 24, 'K' = 12, 'C' = 2704156.0],
     [12 >= 0, 12 =< 24, choose_step(24, 12, 0, 1, 2704156.0)]).
step(12 >= 0, builtin, [], []).
step(12 =< 24, builtin, [], []).
step(choose_step(24, 12, 0, 1, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 0,
      'Acc' = 1,
      'C' = 2704156.0,
      'I1' = 1,
      'Factor' = 24,
      'Numerator' = 24,
      'Nextacc' = 24.0],
     [0 < 12,
      1 is 0 + 1,
      24 is 24 - 0,
      24 is 1 * 24,
      24.0 is 24 / 1,
      choose_step(24, 12, 1, 24.0, 2704156.0)]).
step(0 < 12, builtin, [], []).
step(1 is 0 + 1, builtin, [], []).
step(24 is 24 - 0, builtin, [], []).
step(24 is 1 * 24, builtin, [], []).
step(24.0 is 24 / 1, builtin, [], []).
step(choose_step(24, 12, 1, 24.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 1,
      'Acc' = 24.0,
      'C' = 2704156.0,
      'I1' = 2,
      'Factor' = 23,
      'Numerator' = 552.0,
      'Nextacc' = 276.0],
     [1 < 12,
      2 is 1 + 1,
      23 is 24 - 1,
      552.0 is 24.0 * 23,
      276.0 is 552.0 / 2,
      choose_step(24, 12, 2, 276.0, 2704156.0)]).
step(1 < 12, builtin, [], []).
step(2 is 1 + 1, builtin, [], []).
step(23 is 24 - 1, builtin, [], []).
step(552.0 is 24.0 * 23, builtin, [], []).
step(276.0 is 552.0 / 2, builtin, [], []).
step(choose_step(24, 12, 2, 276.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 2,
      'Acc' = 276.0,
      'C' = 2704156.0,
      'I1' = 3,
      'Factor' = 22,
      'Numerator' = 6072.0,
      'Nextacc' = 2024.0],
     [2 < 12,
      3 is 2 + 1,
      22 is 24 - 2,
      6072.0 is 276.0 * 22,
      2024.0 is 6072.0 / 3,
      choose_step(24, 12, 3, 2024.0, 2704156.0)]).
step(2 < 12, builtin, [], []).
step(3 is 2 + 1, builtin, [], []).
step(22 is 24 - 2, builtin, [], []).
step(6072.0 is 276.0 * 22, builtin, [], []).
step(2024.0 is 6072.0 / 3, builtin, [], []).
step(choose_step(24, 12, 3, 2024.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 3,
      'Acc' = 2024.0,
      'C' = 2704156.0,
      'I1' = 4,
      'Factor' = 21,
      'Numerator' = 42504.0,
      'Nextacc' = 10626.0],
     [3 < 12,
      4 is 3 + 1,
      21 is 24 - 3,
      42504.0 is 2024.0 * 21,
      10626.0 is 42504.0 / 4,
      choose_step(24, 12, 4, 10626.0, 2704156.0)]).
step(3 < 12, builtin, [], []).
step(4 is 3 + 1, builtin, [], []).
step(21 is 24 - 3, builtin, [], []).
step(42504.0 is 2024.0 * 21, builtin, [], []).
step(10626.0 is 42504.0 / 4, builtin, [], []).
step(choose_step(24, 12, 4, 10626.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 4,
      'Acc' = 10626.0,
      'C' = 2704156.0,
      'I1' = 5,
      'Factor' = 20,
      'Numerator' = 212520.0,
      'Nextacc' = 42504.0],
     [4 < 12,
      5 is 4 + 1,
      20 is 24 - 4,
      212520.0 is 10626.0 * 20,
      42504.0 is 212520.0 / 5,
      choose_step(24, 12, 5, 42504.0, 2704156.0)]).
step(4 < 12, builtin, [], []).
step(5 is 4 + 1, builtin, [], []).
step(20 is 24 - 4, builtin, [], []).
step(212520.0 is 10626.0 * 20, builtin, [], []).
step(42504.0 is 212520.0 / 5, builtin, [], []).
step(choose_step(24, 12, 5, 42504.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 5,
      'Acc' = 42504.0,
      'C' = 2704156.0,
      'I1' = 6,
      'Factor' = 19,
      'Numerator' = 807576.0,
      'Nextacc' = 134596.0],
     [5 < 12,
      6 is 5 + 1,
      19 is 24 - 5,
      807576.0 is 42504.0 * 19,
      134596.0 is 807576.0 / 6,
      choose_step(24, 12, 6, 134596.0, 2704156.0)]).
step(5 < 12, builtin, [], []).
step(6 is 5 + 1, builtin, [], []).
step(19 is 24 - 5, builtin, [], []).
step(807576.0 is 42504.0 * 19, builtin, [], []).
step(134596.0 is 807576.0 / 6, builtin, [], []).
step(choose_step(24, 12, 6, 134596.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 6,
      'Acc' = 134596.0,
      'C' = 2704156.0,
      'I1' = 7,
      'Factor' = 18,
      'Numerator' = 2422728.0,
      'Nextacc' = 346104.0],
     [6 < 12,
      7 is 6 + 1,
      18 is 24 - 6,
      2422728.0 is 134596.0 * 18,
      346104.0 is 2422728.0 / 7,
      choose_step(24, 12, 7, 346104.0, 2704156.0)]).
step(6 < 12, builtin, [], []).
step(7 is 6 + 1, builtin, [], []).
step(18 is 24 - 6, builtin, [], []).
step(2422728.0 is 134596.0 * 18, builtin, [], []).
step(346104.0 is 2422728.0 / 7, builtin, [], []).
step(choose_step(24, 12, 7, 346104.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 7,
      'Acc' = 346104.0,
      'C' = 2704156.0,
      'I1' = 8,
      'Factor' = 17,
      'Numerator' = 5883768.0,
      'Nextacc' = 735471.0],
     [7 < 12,
      8 is 7 + 1,
      17 is 24 - 7,
      5883768.0 is 346104.0 * 17,
      735471.0 is 5883768.0 / 8,
      choose_step(24, 12, 8, 735471.0, 2704156.0)]).
step(7 < 12, builtin, [], []).
step(8 is 7 + 1, builtin, [], []).
step(17 is 24 - 7, builtin, [], []).
step(5883768.0 is 346104.0 * 17, builtin, [], []).
step(735471.0 is 5883768.0 / 8, builtin, [], []).
step(choose_step(24, 12, 8, 735471.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 8,
      'Acc' = 735471.0,
      'C' = 2704156.0,
      'I1' = 9,
      'Factor' = 16,
      'Numerator' = 11767536.0,
      'Nextacc' = 1307504.0],
     [8 < 12,
      9 is 8 + 1,
      16 is 24 - 8,
      11767536.0 is 735471.0 * 16,
      1307504.0 is 11767536.0 / 9,
      choose_step(24, 12, 9, 1307504.0, 2704156.0)]).
step(8 < 12, builtin, [], []).
step(9 is 8 + 1, builtin, [], []).
step(16 is 24 - 8, builtin, [], []).
step(11767536.0 is 735471.0 * 16, builtin, [], []).
step(1307504.0 is 11767536.0 / 9, builtin, [], []).
step(choose_step(24, 12, 9, 1307504.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 9,
      'Acc' = 1307504.0,
      'C' = 2704156.0,
      'I1' = 10,
      'Factor' = 15,
      'Numerator' = 19612560.0,
      'Nextacc' = 1961256.0],
     [9 < 12,
      10 is 9 + 1,
      15 is 24 - 9,
      19612560.0 is 1307504.0 * 15,
      1961256.0 is 19612560.0 / 10,
      choose_step(24, 12, 10, 1961256.0, 2704156.0)]).
step(9 < 12, builtin, [], []).
step(10 is 9 + 1, builtin, [], []).
step(15 is 24 - 9, builtin, [], []).
step(19612560.0 is 1307504.0 * 15, builtin, [], []).
step(1961256.0 is 19612560.0 / 10, builtin, [], []).
step(choose_step(24, 12, 10, 1961256.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 10,
      'Acc' = 1961256.0,
      'C' = 2704156.0,
      'I1' = 11,
      'Factor' = 14,
      'Numerator' = 27457584.0,
      'Nextacc' = 2496144.0],
     [10 < 12,
      11 is 10 + 1,
      14 is 24 - 10,
      27457584.0 is 1961256.0 * 14,
      2496144.0 is 27457584.0 / 11,
      choose_step(24, 12, 11, 2496144.0, 2704156.0)]).
step(10 < 12, builtin, [], []).
step(11 is 10 + 1, builtin, [], []).
step(14 is 24 - 10, builtin, [], []).
step(27457584.0 is 1961256.0 * 14, builtin, [], []).
step(2496144.0 is 27457584.0 / 11, builtin, [], []).
step(choose_step(24, 12, 11, 2496144.0, 2704156.0),
     rule(4),
     ['N' = 24,
      'K' = 12,
      'I' = 11,
      'Acc' = 2496144.0,
      'C' = 2704156.0,
      'I1' = 12,
      'Factor' = 13,
      'Numerator' = 32449872.0,
      'Nextacc' = 2704156.0],
     [11 < 12,
      12 is 11 + 1,
      13 is 24 - 11,
      32449872.0 is 2496144.0 * 13,
      2704156.0 is 32449872.0 / 12,
      choose_step(24, 12, 12, 2704156.0, 2704156.0)]).
step(11 < 12, builtin, [], []).
step(12 is 11 + 1, builtin, [], []).
step(13 is 24 - 11, builtin, [], []).
step(32449872.0 is 2496144.0 * 13, builtin, [], []).
step(2704156.0 is 32449872.0 / 12, builtin, [], []).
step(choose_step(24, 12, 12, 2704156.0, 2704156.0), fact(3), ['K' = 12, 'Acc' = 2704156.0], []).
step(binomial_answer(symmetry_24_7, true), rule(9), [], [symmetric(24, 7)]).
step(symmetric(24, 7),
     rule(5),
     ['N' = 24, 'K' = 7, 'C' = 346104.0, 'Otherk' = 17],
     [choose(24, 7, 346104.0), 17 is 24 - 7, choose(24, 17, 346104.0)]).
step(choose(24, 7, 346104.0),
     rule(2),
     ['N' = 24, 'K' = 7, 'C' = 346104.0],
     [7 >= 0, 7 =< 24, choose_step(24, 7, 0, 1, 346104.0)]).
step(7 >= 0, builtin, [], []).
step(7 =< 24, builtin, [], []).
step(choose_step(24, 7, 0, 1, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 7,
      'I' = 0,
      'Acc' = 1,
      'C' = 346104.0,
      'I1' = 1,
      'Factor' = 24,
      'Numerator' = 24,
      'Nextacc' = 24.0],
     [0 < 7,
      1 is 0 + 1,
      24 is 24 - 0,
      24 is 1 * 24,
      24.0 is 24 / 1,
      choose_step(24, 7, 1, 24.0, 346104.0)]).
step(0 < 7, builtin, [], []).
step(choose_step(24, 7, 1, 24.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 7,
      'I' = 1,
      'Acc' = 24.0,
      'C' = 346104.0,
      'I1' = 2,
      'Factor' = 23,
      'Numerator' = 552.0,
      'Nextacc' = 276.0],
     [1 < 7,
      2 is 1 + 1,
      23 is 24 - 1,
      552.0 is 24.0 * 23,
      276.0 is 552.0 / 2,
      choose_step(24, 7, 2, 276.0, 346104.0)]).
step(1 < 7, builtin, [], []).
step(choose_step(24, 7, 2, 276.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 7,
      'I' = 2,
      'Acc' = 276.0,
      'C' = 346104.0,
      'I1' = 3,
      'Factor' = 22,
      'Numerator' = 6072.0,
      'Nextacc' = 2024.0],
     [2 < 7,
      3 is 2 + 1,
      22 is 24 - 2,
      6072.0 is 276.0 * 22,
      2024.0 is 6072.0 / 3,
      choose_step(24, 7, 3, 2024.0, 346104.0)]).
step(2 < 7, builtin, [], []).
step(choose_step(24, 7, 3, 2024.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 7,
      'I' = 3,
      'Acc' = 2024.0,
      'C' = 346104.0,
      'I1' = 4,
      'Factor' = 21,
      'Numerator' = 42504.0,
      'Nextacc' = 10626.0],
     [3 < 7,
      4 is 3 + 1,
      21 is 24 - 3,
      42504.0 is 2024.0 * 21,
      10626.0 is 42504.0 / 4,
      choose_step(24, 7, 4, 10626.0, 346104.0)]).
step(3 < 7, builtin, [], []).
step(choose_step(24, 7, 4, 10626.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 7,
      'I' = 4,
      'Acc' = 10626.0,
      'C' = 346104.0,
      'I1' = 5,
      'Factor' = 20,
      'Numerator' = 212520.0,
      'Nextacc' = 42504.0],
     [4 < 7,
      5 is 4 + 1,
      20 is 24 - 4,
      212520.0 is 10626.0 * 20,
      42504.0 is 212520.0 / 5,
      choose_step(24, 7, 5, 42504.0, 346104.0)]).
step(4 < 7, builtin, [], []).
step(choose_step(24, 7, 5, 42504.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 7,
      'I' = 5,
      'Acc' = 42504.0,
      'C' = 346104.0,
      'I1' = 6,
      'Factor' = 19,
      'Numerator' = 807576.0,
      'Nextacc' = 134596.0],
     [5 < 7,
      6 is 5 + 1,
      19 is 24 - 5,
      807576.0 is 42504.0 * 19,
      134596.0 is 807576.0 / 6,
      choose_step(24, 7, 6, 134596.0, 346104.0)]).
step(5 < 7, builtin, [], []).
step(choose_step(24, 7, 6, 134596.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 7,
      'I' = 6,
      'Acc' = 134596.0,
      'C' = 346104.0,
      'I1' = 7,
      'Factor' = 18,
      'Numerator' = 2422728.0,
      'Nextacc' = 346104.0],
     [6 < 7,
      7 is 6 + 1,
      18 is 24 - 6,
      2422728.0 is 134596.0 * 18,
      346104.0 is 2422728.0 / 7,
      choose_step(24, 7, 7, 346104.0, 346104.0)]).
step(6 < 7, builtin, [], []).
step(choose_step(24, 7, 7, 346104.0, 346104.0), fact(3), ['K' = 7, 'Acc' = 346104.0], []).
step(choose(24, 17, 346104.0),
     rule(2),
     ['N' = 24, 'K' = 17, 'C' = 346104.0],
     [17 >= 0, 17 =< 24, choose_step(24, 17, 0, 1, 346104.0)]).
step(17 >= 0, builtin, [], []).
step(17 =< 24, builtin, [], []).
step(choose_step(24, 17, 0, 1, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 0,
      'Acc' = 1,
      'C' = 346104.0,
      'I1' = 1,
      'Factor' = 24,
      'Numerator' = 24,
      'Nextacc' = 24.0],
     [0 < 17,
      1 is 0 + 1,
      24 is 24 - 0,
      24 is 1 * 24,
      24.0 is 24 / 1,
      choose_step(24, 17, 1, 24.0, 346104.0)]).
step(0 < 17, builtin, [], []).
step(choose_step(24, 17, 1, 24.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 1,
      'Acc' = 24.0,
      'C' = 346104.0,
      'I1' = 2,
      'Factor' = 23,
      'Numerator' = 552.0,
      'Nextacc' = 276.0],
     [1 < 17,
      2 is 1 + 1,
      23 is 24 - 1,
      552.0 is 24.0 * 23,
      276.0 is 552.0 / 2,
      choose_step(24, 17, 2, 276.0, 346104.0)]).
step(1 < 17, builtin, [], []).
step(choose_step(24, 17, 2, 276.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 2,
      'Acc' = 276.0,
      'C' = 346104.0,
      'I1' = 3,
      'Factor' = 22,
      'Numerator' = 6072.0,
      'Nextacc' = 2024.0],
     [2 < 17,
      3 is 2 + 1,
      22 is 24 - 2,
      6072.0 is 276.0 * 22,
      2024.0 is 6072.0 / 3,
      choose_step(24, 17, 3, 2024.0, 346104.0)]).
step(2 < 17, builtin, [], []).
step(choose_step(24, 17, 3, 2024.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 3,
      'Acc' = 2024.0,
      'C' = 346104.0,
      'I1' = 4,
      'Factor' = 21,
      'Numerator' = 42504.0,
      'Nextacc' = 10626.0],
     [3 < 17,
      4 is 3 + 1,
      21 is 24 - 3,
      42504.0 is 2024.0 * 21,
      10626.0 is 42504.0 / 4,
      choose_step(24, 17, 4, 10626.0, 346104.0)]).
step(3 < 17, builtin, [], []).
step(choose_step(24, 17, 4, 10626.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 4,
      'Acc' = 10626.0,
      'C' = 346104.0,
      'I1' = 5,
      'Factor' = 20,
      'Numerator' = 212520.0,
      'Nextacc' = 42504.0],
     [4 < 17,
      5 is 4 + 1,
      20 is 24 - 4,
      212520.0 is 10626.0 * 20,
      42504.0 is 212520.0 / 5,
      choose_step(24, 17, 5, 42504.0, 346104.0)]).
step(4 < 17, builtin, [], []).
step(choose_step(24, 17, 5, 42504.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 5,
      'Acc' = 42504.0,
      'C' = 346104.0,
      'I1' = 6,
      'Factor' = 19,
      'Numerator' = 807576.0,
      'Nextacc' = 134596.0],
     [5 < 17,
      6 is 5 + 1,
      19 is 24 - 5,
      807576.0 is 42504.0 * 19,
      134596.0 is 807576.0 / 6,
      choose_step(24, 17, 6, 134596.0, 346104.0)]).
step(5 < 17, builtin, [], []).
step(choose_step(24, 17, 6, 134596.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 6,
      'Acc' = 134596.0,
      'C' = 346104.0,
      'I1' = 7,
      'Factor' = 18,
      'Numerator' = 2422728.0,
      'Nextacc' = 346104.0],
     [6 < 17,
      7 is 6 + 1,
      18 is 24 - 6,
      2422728.0 is 134596.0 * 18,
      346104.0 is 2422728.0 / 7,
      choose_step(24, 17, 7, 346104.0, 346104.0)]).
step(6 < 17, builtin, [], []).
step(choose_step(24, 17, 7, 346104.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 7,
      'Acc' = 346104.0,
      'C' = 346104.0,
      'I1' = 8,
      'Factor' = 17,
      'Numerator' = 5883768.0,
      'Nextacc' = 735471.0],
     [7 < 17,
      8 is 7 + 1,
      17 is 24 - 7,
      5883768.0 is 346104.0 * 17,
      735471.0 is 5883768.0 / 8,
      choose_step(24, 17, 8, 735471.0, 346104.0)]).
step(7 < 17, builtin, [], []).
step(choose_step(24, 17, 8, 735471.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 8,
      'Acc' = 735471.0,
      'C' = 346104.0,
      'I1' = 9,
      'Factor' = 16,
      'Numerator' = 11767536.0,
      'Nextacc' = 1307504.0],
     [8 < 17,
      9 is 8 + 1,
      16 is 24 - 8,
      11767536.0 is 735471.0 * 16,
      1307504.0 is 11767536.0 / 9,
      choose_step(24, 17, 9, 1307504.0, 346104.0)]).
step(8 < 17, builtin, [], []).
step(choose_step(24, 17, 9, 1307504.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 9,
      'Acc' = 1307504.0,
      'C' = 346104.0,
      'I1' = 10,
      'Factor' = 15,
      'Numerator' = 19612560.0,
      'Nextacc' = 1961256.0],
     [9 < 17,
      10 is 9 + 1,
      15 is 24 - 9,
      19612560.0 is 1307504.0 * 15,
      1961256.0 is 19612560.0 / 10,
      choose_step(24, 17, 10, 1961256.0, 346104.0)]).
step(9 < 17, builtin, [], []).
step(choose_step(24, 17, 10, 1961256.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 10,
      'Acc' = 1961256.0,
      'C' = 346104.0,
      'I1' = 11,
      'Factor' = 14,
      'Numerator' = 27457584.0,
      'Nextacc' = 2496144.0],
     [10 < 17,
      11 is 10 + 1,
      14 is 24 - 10,
      27457584.0 is 1961256.0 * 14,
      2496144.0 is 27457584.0 / 11,
      choose_step(24, 17, 11, 2496144.0, 346104.0)]).
step(10 < 17, builtin, [], []).
step(choose_step(24, 17, 11, 2496144.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 11,
      'Acc' = 2496144.0,
      'C' = 346104.0,
      'I1' = 12,
      'Factor' = 13,
      'Numerator' = 32449872.0,
      'Nextacc' = 2704156.0],
     [11 < 17,
      12 is 11 + 1,
      13 is 24 - 11,
      32449872.0 is 2496144.0 * 13,
      2704156.0 is 32449872.0 / 12,
      choose_step(24, 17, 12, 2704156.0, 346104.0)]).
step(11 < 17, builtin, [], []).
step(choose_step(24, 17, 12, 2704156.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 12,
      'Acc' = 2704156.0,
      'C' = 346104.0,
      'I1' = 13,
      'Factor' = 12,
      'Numerator' = 32449872.0,
      'Nextacc' = 2496144.0],
     [12 < 17,
      13 is 12 + 1,
      12 is 24 - 12,
      32449872.0 is 2704156.0 * 12,
      2496144.0 is 32449872.0 / 13,
      choose_step(24, 17, 13, 2496144.0, 346104.0)]).
step(12 < 17, builtin, [], []).
step(13 is 12 + 1, builtin, [], []).
step(12 is 24 - 12, builtin, [], []).
step(32449872.0 is 2704156.0 * 12, builtin, [], []).
step(2496144.0 is 32449872.0 / 13, builtin, [], []).
step(choose_step(24, 17, 13, 2496144.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 13,
      'Acc' = 2496144.0,
      'C' = 346104.0,
      'I1' = 14,
      'Factor' = 11,
      'Numerator' = 27457584.0,
      'Nextacc' = 1961256.0],
     [13 < 17,
      14 is 13 + 1,
      11 is 24 - 13,
      27457584.0 is 2496144.0 * 11,
      1961256.0 is 27457584.0 / 14,
      choose_step(24, 17, 14, 1961256.0, 346104.0)]).
step(13 < 17, builtin, [], []).
step(14 is 13 + 1, builtin, [], []).
step(11 is 24 - 13, builtin, [], []).
step(27457584.0 is 2496144.0 * 11, builtin, [], []).
step(1961256.0 is 27457584.0 / 14, builtin, [], []).
step(choose_step(24, 17, 14, 1961256.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 14,
      'Acc' = 1961256.0,
      'C' = 346104.0,
      'I1' = 15,
      'Factor' = 10,
      'Numerator' = 19612560.0,
      'Nextacc' = 1307504.0],
     [14 < 17,
      15 is 14 + 1,
      10 is 24 - 14,
      19612560.0 is 1961256.0 * 10,
      1307504.0 is 19612560.0 / 15,
      choose_step(24, 17, 15, 1307504.0, 346104.0)]).
step(14 < 17, builtin, [], []).
step(15 is 14 + 1, builtin, [], []).
step(10 is 24 - 14, builtin, [], []).
step(19612560.0 is 1961256.0 * 10, builtin, [], []).
step(1307504.0 is 19612560.0 / 15, builtin, [], []).
step(choose_step(24, 17, 15, 1307504.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 15,
      'Acc' = 1307504.0,
      'C' = 346104.0,
      'I1' = 16,
      'Factor' = 9,
      'Numerator' = 11767536.0,
      'Nextacc' = 735471.0],
     [15 < 17,
      16 is 15 + 1,
      9 is 24 - 15,
      11767536.0 is 1307504.0 * 9,
      735471.0 is 11767536.0 / 16,
      choose_step(24, 17, 16, 735471.0, 346104.0)]).
step(15 < 17, builtin, [], []).
step(16 is 15 + 1, builtin, [], []).
step(9 is 24 - 15, builtin, [], []).
step(11767536.0 is 1307504.0 * 9, builtin, [], []).
step(735471.0 is 11767536.0 / 16, builtin, [], []).
step(choose_step(24, 17, 16, 735471.0, 346104.0),
     rule(4),
     ['N' = 24,
      'K' = 17,
      'I' = 16,
      'Acc' = 735471.0,
      'C' = 346104.0,
      'I1' = 17,
      'Factor' = 8,
      'Numerator' = 5883768.0,
      'Nextacc' = 346104.0],
     [16 < 17,
      17 is 16 + 1,
      8 is 24 - 16,
      5883768.0 is 735471.0 * 8,
      346104.0 is 5883768.0 / 17,
      choose_step(24, 17, 17, 346104.0, 346104.0)]).
step(16 < 17, builtin, [], []).
step(17 is 16 + 1, builtin, [], []).
step(8 is 24 - 16, builtin, [], []).
step(5883768.0 is 735471.0 * 8, builtin, [], []).
step(346104.0 is 5883768.0 / 17, builtin, [], []).
step(choose_step(24, 17, 17, 346104.0, 346104.0), fact(3), ['K' = 17, 'Acc' = 346104.0], []).
step(binomial_answer(vandermonde_12_10_8, 319770.0),
     rule(10),
     ['Sum' = 319770.0],
     [vandermonde(12, 10, 8, 319770.0)]).
step(vandermonde(12, 10, 8, 319770.0),
     rule(7),
     ['N' = 12, 'M' = 10, 'R' = 8, 'Sum' = 319770.0, 'Totaln' = 22],
     [22 is 12 + 10, choose(22, 8, 319770.0), vandermonde_sum(12, 10, 8, 319770.0)]).
step(22 is 12 + 10, builtin, [], []).
step(choose(22, 8, 319770.0),
     rule(2),
     ['N' = 22, 'K' = 8, 'C' = 319770.0],
     [8 >= 0, 8 =< 22, choose_step(22, 8, 0, 1, 319770.0)]).
step(8 >= 0, builtin, [], []).
step(8 =< 22, builtin, [], []).
step(choose_step(22, 8, 0, 1, 319770.0),
     rule(4),
     ['N' = 22,
      'K' = 8,
      'I' = 0,
      'Acc' = 1,
      'C' = 319770.0,
      'I1' = 1,
      'Factor' = 22,
      'Numerator' = 22,
      'Nextacc' = 22.0],
     [0 < 8,
      1 is 0 + 1,
      22 is 22 - 0,
      22 is 1 * 22,
      22.0 is 22 / 1,
      choose_step(22, 8, 1, 22.0, 319770.0)]).
step(0 < 8, builtin, [], []).
step(22 is 22 - 0, builtin, [], []).
step(22 is 1 * 22, builtin, [], []).
step(22.0 is 22 / 1, builtin, [], []).
step(choose_step(22, 8, 1, 22.0, 319770.0),
     rule(4),
     ['N' = 22,
      'K' = 8,
      'I' = 1,
      'Acc' = 22.0,
      'C' = 319770.0,
      'I1' = 2,
      'Factor' = 21,
      'Numerator' = 462.0,
      'Nextacc' = 231.0],
     [1 < 8,
      2 is 1 + 1,
      21 is 22 - 1,
      462.0 is 22.0 * 21,
      231.0 is 462.0 / 2,
      choose_step(22, 8, 2, 231.0, 319770.0)]).
step(1 < 8, builtin, [], []).
step(21 is 22 - 1, builtin, [], []).
step(462.0 is 22.0 * 21, builtin, [], []).
step(231.0 is 462.0 / 2, builtin, [], []).
step(choose_step(22, 8, 2, 231.0, 319770.0),
     rule(4),
     ['N' = 22,
      'K' = 8,
      'I' = 2,
      'Acc' = 231.0,
      'C' = 319770.0,
      'I1' = 3,
      'Factor' = 20,
      'Numerator' = 4620.0,
      'Nextacc' = 1540.0],
     [2 < 8,
      3 is 2 + 1,
      20 is 22 - 2,
      4620.0 is 231.0 * 20,
      1540.0 is 4620.0 / 3,
      choose_step(22, 8, 3, 1540.0, 319770.0)]).
step(2 < 8, builtin, [], []).
step(20 is 22 - 2, builtin, [], []).
step(4620.0 is 231.0 * 20, builtin, [], []).
step(1540.0 is 4620.0 / 3, builtin, [], []).
step(choose_step(22, 8, 3, 1540.0, 319770.0),
     rule(4),
     ['N' = 22,
      'K' = 8,
      'I' = 3,
      'Acc' = 1540.0,
      'C' = 319770.0,
      'I1' = 4,
      'Factor' = 19,
      'Numerator' = 29260.0,
      'Nextacc' = 7315.0],
     [3 < 8,
      4 is 3 + 1,
      19 is 22 - 3,
      29260.0 is 1540.0 * 19,
      7315.0 is 29260.0 / 4,
      choose_step(22, 8, 4, 7315.0, 319770.0)]).
step(3 < 8, builtin, [], []).
step(19 is 22 - 3, builtin, [], []).
step(29260.0 is 1540.0 * 19, builtin, [], []).
step(7315.0 is 29260.0 / 4, builtin, [], []).
step(choose_step(22, 8, 4, 7315.0, 319770.0),
     rule(4),
     ['N' = 22,
      'K' = 8,
      'I' = 4,
      'Acc' = 7315.0,
      'C' = 319770.0,
      'I1' = 5,
      'Factor' = 18,
      'Numerator' = 131670.0,
      'Nextacc' = 26334.0],
     [4 < 8,
      5 is 4 + 1,
      18 is 22 - 4,
      131670.0 is 7315.0 * 18,
      26334.0 is 131670.0 / 5,
      choose_step(22, 8, 5, 26334.0, 319770.0)]).
step(4 < 8, builtin, [], []).
step(18 is 22 - 4, builtin, [], []).
step(131670.0 is 7315.0 * 18, builtin, [], []).
step(26334.0 is 131670.0 / 5, builtin, [], []).
step(choose_step(22, 8, 5, 26334.0, 319770.0),
     rule(4),
     ['N' = 22,
      'K' = 8,
      'I' = 5,
      'Acc' = 26334.0,
      'C' = 319770.0,
      'I1' = 6,
      'Factor' = 17,
      'Numerator' = 447678.0,
      'Nextacc' = 74613.0],
     [5 < 8,
      6 is 5 + 1,
      17 is 22 - 5,
      447678.0 is 26334.0 * 17,
      74613.0 is 447678.0 / 6,
      choose_step(22, 8, 6, 74613.0, 319770.0)]).
step(5 < 8, builtin, [], []).
step(17 is 22 - 5, builtin, [], []).
step(447678.0 is 26334.0 * 17, builtin, [], []).
step(74613.0 is 447678.0 / 6, builtin, [], []).
step(choose_step(22, 8, 6, 74613.0, 319770.0),
     rule(4),
     ['N' = 22,
      'K' = 8,
      'I' = 6,
      'Acc' = 74613.0,
      'C' = 319770.0,
      'I1' = 7,
      'Factor' = 16,
      'Numerator' = 1193808.0,
      'Nextacc' = 170544.0],
     [6 < 8,
      7 is 6 + 1,
      16 is 22 - 6,
      1193808.0 is 74613.0 * 16,
      170544.0 is 1193808.0 / 7,
      choose_step(22, 8, 7, 170544.0, 319770.0)]).
step(6 < 8, builtin, [], []).
step(16 is 22 - 6, builtin, [], []).
step(1193808.0 is 74613.0 * 16, builtin, [], []).
step(170544.0 is 1193808.0 / 7, builtin, [], []).
step(choose_step(22, 8, 7, 170544.0, 319770.0),
     rule(4),
     ['N' = 22,
      'K' = 8,
      'I' = 7,
      'Acc' = 170544.0,
      'C' = 319770.0,
      'I1' = 8,
      'Factor' = 15,
      'Numerator' = 2558160.0,
      'Nextacc' = 319770.0],
     [7 < 8,
      8 is 7 + 1,
      15 is 22 - 7,
      2558160.0 is 170544.0 * 15,
      319770.0 is 2558160.0 / 8,
      choose_step(22, 8, 8, 319770.0, 319770.0)]).
step(7 < 8, builtin, [], []).
step(15 is 22 - 7, builtin, [], []).
step(2558160.0 is 170544.0 * 15, builtin, [], []).
step(319770.0 is 2558160.0 / 8, builtin, [], []).
step(choose_step(22, 8, 8, 319770.0, 319770.0), fact(3), ['K' = 8, 'Acc' = 319770.0], []).
step(vandermonde_sum(12, 10, 8, 319770.0),
     rule(6),
     ['N' = 12, 'M' = 10, 'R' = 8, 'Sum' = 319770.0],
     [sumall(Expression, (between(0, 8, K), Rk is 8 - K, choose(12, K, A), choose(10, Rk, B), Expression is A * B), 319770.0)]).
step(sumall(Expression, (between(0, 8, K), Rk is 8 - K, choose(12, K, A), choose(10, Rk, B), Expression is A * B), 319770.0),
     builtin,
     [],
     []).
step(binomial_answer(row_12_sum, 4096.0),
     rule(11),
     ['Sum' = 4096.0],
     [sumall(Expression, (between(0, 12, K), choose(12, K, Expression)), 4096.0)]).
step(sumall(Expression, (between(0, 12, K), choose(12, K, Expression)), 4096.0),
     builtin,
     [],
     []).
