convergent_answer(convergent_10, fraction(8119, 5741)).
convergent_answer(convergent_15, fraction(665857, 470832)).
convergent_answer(pell_error_15, 1).
convergent_answer(numerator_sum_0_to_10, 13859).

clause(2, conv(0, 1, 1), true).
clause(3, conv(1, 3, 2), true).
clause(4,
       conv(var('N'), var('P'), var('Q')),
       (var('N') > 1,
        var('N1') is var('N') - 1,
        var('N2') is var('N') - 2,
        conv(var('N1'), var('P1'), var('Q1')),
        conv(var('N2'), var('P2'), var('Q2')),
        var('Twicep1') is 2 * var('P1'),
        var('P') is var('Twicep1') + var('P2'),
        var('Twiceq1') is 2 * var('Q1'),
        var('Q') is var('Twiceq1') + var('Q2'))).
clause(5,
       pell_error(var('N'), var('Error')),
       (conv(var('N'), var('P'), var('Q')),
        var('P2') is var('P') * var('P'),
        var('Q2') is var('Q') * var('Q'),
        var('Twiceq2') is 2 * var('Q2'),
        var('Error') is var('P2') - var('Twiceq2'))).
clause(6,
       convergent_answer(convergent_10, fraction(var('P'), var('Q'))),
       conv(10, var('P'), var('Q'))).
clause(7,
       convergent_answer(convergent_15, fraction(var('P'), var('Q'))),
       conv(15, var('P'), var('Q'))).
clause(8, convergent_answer(pell_error_15, var('Error')), pell_error(15, var('Error'))).
clause(9,
       convergent_answer(numerator_sum_0_to_10, var('Sum')),
       sumall(var('P'), (between(0, 10, var('N')), conv(var('N'), var('P'), anonymous(1))), var('Sum'))).

step(convergent_answer(convergent_10, fraction(8119, 5741)),
     rule(6),
     ['P' = 8119, 'Q' = 5741],
     [conv(10, 8119, 5741)]).
step(conv(10, 8119, 5741),
     rule(4),
     ['N' = 10,
      'P' = 8119,
      'Q' = 5741,
      'N1' = 9,
      'N2' = 8,
      'P1' = 3363,
      'Q1' = 2378,
      'P2' = 1393,
      'Q2' = 985,
      'Twicep1' = 6726,
      'Twiceq1' = 4756],
     [10 > 1,
      9 is 10 - 1,
      8 is 10 - 2,
      conv(9, 3363, 2378),
      conv(8, 1393, 985),
      6726 is 2 * 3363,
      8119 is 6726 + 1393,
      4756 is 2 * 2378,
      5741 is 4756 + 985]).
step(10 > 1, builtin, [], []).
step(9 is 10 - 1, builtin, [], []).
step(8 is 10 - 2, builtin, [], []).
step(conv(9, 3363, 2378),
     rule(4),
     ['N' = 9,
      'P' = 3363,
      'Q' = 2378,
      'N1' = 8,
      'N2' = 7,
      'P1' = 1393,
      'Q1' = 985,
      'P2' = 577,
      'Q2' = 408,
      'Twicep1' = 2786,
      'Twiceq1' = 1970],
     [9 > 1,
      8 is 9 - 1,
      7 is 9 - 2,
      conv(8, 1393, 985),
      conv(7, 577, 408),
      2786 is 2 * 1393,
      3363 is 2786 + 577,
      1970 is 2 * 985,
      2378 is 1970 + 408]).
step(9 > 1, builtin, [], []).
step(8 is 9 - 1, builtin, [], []).
step(7 is 9 - 2, builtin, [], []).
step(conv(8, 1393, 985),
     rule(4),
     ['N' = 8,
      'P' = 1393,
      'Q' = 985,
      'N1' = 7,
      'N2' = 6,
      'P1' = 577,
      'Q1' = 408,
      'P2' = 239,
      'Q2' = 169,
      'Twicep1' = 1154,
      'Twiceq1' = 816],
     [8 > 1,
      7 is 8 - 1,
      6 is 8 - 2,
      conv(7, 577, 408),
      conv(6, 239, 169),
      1154 is 2 * 577,
      1393 is 1154 + 239,
      816 is 2 * 408,
      985 is 816 + 169]).
step(8 > 1, builtin, [], []).
step(7 is 8 - 1, builtin, [], []).
step(6 is 8 - 2, builtin, [], []).
step(conv(7, 577, 408),
     rule(4),
     ['N' = 7,
      'P' = 577,
      'Q' = 408,
      'N1' = 6,
      'N2' = 5,
      'P1' = 239,
      'Q1' = 169,
      'P2' = 99,
      'Q2' = 70,
      'Twicep1' = 478,
      'Twiceq1' = 338],
     [7 > 1,
      6 is 7 - 1,
      5 is 7 - 2,
      conv(6, 239, 169),
      conv(5, 99, 70),
      478 is 2 * 239,
      577 is 478 + 99,
      338 is 2 * 169,
      408 is 338 + 70]).
step(7 > 1, builtin, [], []).
step(6 is 7 - 1, builtin, [], []).
step(5 is 7 - 2, builtin, [], []).
step(conv(6, 239, 169),
     rule(4),
     ['N' = 6,
      'P' = 239,
      'Q' = 169,
      'N1' = 5,
      'N2' = 4,
      'P1' = 99,
      'Q1' = 70,
      'P2' = 41,
      'Q2' = 29,
      'Twicep1' = 198,
      'Twiceq1' = 140],
     [6 > 1,
      5 is 6 - 1,
      4 is 6 - 2,
      conv(5, 99, 70),
      conv(4, 41, 29),
      198 is 2 * 99,
      239 is 198 + 41,
      140 is 2 * 70,
      169 is 140 + 29]).
step(6 > 1, builtin, [], []).
step(5 is 6 - 1, builtin, [], []).
step(4 is 6 - 2, builtin, [], []).
step(conv(5, 99, 70),
     rule(4),
     ['N' = 5,
      'P' = 99,
      'Q' = 70,
      'N1' = 4,
      'N2' = 3,
      'P1' = 41,
      'Q1' = 29,
      'P2' = 17,
      'Q2' = 12,
      'Twicep1' = 82,
      'Twiceq1' = 58],
     [5 > 1,
      4 is 5 - 1,
      3 is 5 - 2,
      conv(4, 41, 29),
      conv(3, 17, 12),
      82 is 2 * 41,
      99 is 82 + 17,
      58 is 2 * 29,
      70 is 58 + 12]).
step(5 > 1, builtin, [], []).
step(4 is 5 - 1, builtin, [], []).
step(3 is 5 - 2, builtin, [], []).
step(conv(4, 41, 29),
     rule(4),
     ['N' = 4,
      'P' = 41,
      'Q' = 29,
      'N1' = 3,
      'N2' = 2,
      'P1' = 17,
      'Q1' = 12,
      'P2' = 7,
      'Q2' = 5,
      'Twicep1' = 34,
      'Twiceq1' = 24],
     [4 > 1,
      3 is 4 - 1,
      2 is 4 - 2,
      conv(3, 17, 12),
      conv(2, 7, 5),
      34 is 2 * 17,
      41 is 34 + 7,
      24 is 2 * 12,
      29 is 24 + 5]).
step(4 > 1, builtin, [], []).
step(3 is 4 - 1, builtin, [], []).
step(2 is 4 - 2, builtin, [], []).
step(conv(3, 17, 12),
     rule(4),
     ['N' = 3,
      'P' = 17,
      'Q' = 12,
      'N1' = 2,
      'N2' = 1,
      'P1' = 7,
      'Q1' = 5,
      'P2' = 3,
      'Q2' = 2,
      'Twicep1' = 14,
      'Twiceq1' = 10],
     [3 > 1,
      2 is 3 - 1,
      1 is 3 - 2,
      conv(2, 7, 5),
      conv(1, 3, 2),
      14 is 2 * 7,
      17 is 14 + 3,
      10 is 2 * 5,
      12 is 10 + 2]).
step(3 > 1, builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(1 is 3 - 2, builtin, [], []).
step(conv(2, 7, 5),
     rule(4),
     ['N' = 2,
      'P' = 7,
      'Q' = 5,
      'N1' = 1,
      'N2' = 0,
      'P1' = 3,
      'Q1' = 2,
      'P2' = 1,
      'Q2' = 1,
      'Twicep1' = 6,
      'Twiceq1' = 4],
     [2 > 1,
      1 is 2 - 1,
      0 is 2 - 2,
      conv(1, 3, 2),
      conv(0, 1, 1),
      6 is 2 * 3,
      7 is 6 + 1,
      4 is 2 * 2,
      5 is 4 + 1]).
step(2 > 1, builtin, [], []).
step(1 is 2 - 1, builtin, [], []).
step(0 is 2 - 2, builtin, [], []).
step(conv(1, 3, 2), fact(3), [], []).
step(conv(0, 1, 1), fact(2), [], []).
step(6 is 2 * 3, builtin, [], []).
step(7 is 6 + 1, builtin, [], []).
step(4 is 2 * 2, builtin, [], []).
step(5 is 4 + 1, builtin, [], []).
step(14 is 2 * 7, builtin, [], []).
step(17 is 14 + 3, builtin, [], []).
step(10 is 2 * 5, builtin, [], []).
step(12 is 10 + 2, builtin, [], []).
step(34 is 2 * 17, builtin, [], []).
step(41 is 34 + 7, builtin, [], []).
step(24 is 2 * 12, builtin, [], []).
step(29 is 24 + 5, builtin, [], []).
step(82 is 2 * 41, builtin, [], []).
step(99 is 82 + 17, builtin, [], []).
step(58 is 2 * 29, builtin, [], []).
step(70 is 58 + 12, builtin, [], []).
step(198 is 2 * 99, builtin, [], []).
step(239 is 198 + 41, builtin, [], []).
step(140 is 2 * 70, builtin, [], []).
step(169 is 140 + 29, builtin, [], []).
step(478 is 2 * 239, builtin, [], []).
step(577 is 478 + 99, builtin, [], []).
step(338 is 2 * 169, builtin, [], []).
step(408 is 338 + 70, builtin, [], []).
step(1154 is 2 * 577, builtin, [], []).
step(1393 is 1154 + 239, builtin, [], []).
step(816 is 2 * 408, builtin, [], []).
step(985 is 816 + 169, builtin, [], []).
step(2786 is 2 * 1393, builtin, [], []).
step(3363 is 2786 + 577, builtin, [], []).
step(1970 is 2 * 985, builtin, [], []).
step(2378 is 1970 + 408, builtin, [], []).
step(6726 is 2 * 3363, builtin, [], []).
step(8119 is 6726 + 1393, builtin, [], []).
step(4756 is 2 * 2378, builtin, [], []).
step(5741 is 4756 + 985, builtin, [], []).
step(convergent_answer(convergent_15, fraction(665857, 470832)),
     rule(7),
     ['P' = 665857, 'Q' = 470832],
     [conv(15, 665857, 470832)]).
step(conv(15, 665857, 470832),
     rule(4),
     ['N' = 15,
      'P' = 665857,
      'Q' = 470832,
      'N1' = 14,
      'N2' = 13,
      'P1' = 275807,
      'Q1' = 195025,
      'P2' = 114243,
      'Q2' = 80782,
      'Twicep1' = 551614,
      'Twiceq1' = 390050],
     [15 > 1,
      14 is 15 - 1,
      13 is 15 - 2,
      conv(14, 275807, 195025),
      conv(13, 114243, 80782),
      551614 is 2 * 275807,
      665857 is 551614 + 114243,
      390050 is 2 * 195025,
      470832 is 390050 + 80782]).
step(15 > 1, builtin, [], []).
step(14 is 15 - 1, builtin, [], []).
step(13 is 15 - 2, builtin, [], []).
step(conv(14, 275807, 195025),
     rule(4),
     ['N' = 14,
      'P' = 275807,
      'Q' = 195025,
      'N1' = 13,
      'N2' = 12,
      'P1' = 114243,
      'Q1' = 80782,
      'P2' = 47321,
      'Q2' = 33461,
      'Twicep1' = 228486,
      'Twiceq1' = 161564],
     [14 > 1,
      13 is 14 - 1,
      12 is 14 - 2,
      conv(13, 114243, 80782),
      conv(12, 47321, 33461),
      228486 is 2 * 114243,
      275807 is 228486 + 47321,
      161564 is 2 * 80782,
      195025 is 161564 + 33461]).
step(14 > 1, builtin, [], []).
step(13 is 14 - 1, builtin, [], []).
step(12 is 14 - 2, builtin, [], []).
step(conv(13, 114243, 80782),
     rule(4),
     ['N' = 13,
      'P' = 114243,
      'Q' = 80782,
      'N1' = 12,
      'N2' = 11,
      'P1' = 47321,
      'Q1' = 33461,
      'P2' = 19601,
      'Q2' = 13860,
      'Twicep1' = 94642,
      'Twiceq1' = 66922],
     [13 > 1,
      12 is 13 - 1,
      11 is 13 - 2,
      conv(12, 47321, 33461),
      conv(11, 19601, 13860),
      94642 is 2 * 47321,
      114243 is 94642 + 19601,
      66922 is 2 * 33461,
      80782 is 66922 + 13860]).
step(13 > 1, builtin, [], []).
step(12 is 13 - 1, builtin, [], []).
step(11 is 13 - 2, builtin, [], []).
step(conv(12, 47321, 33461),
     rule(4),
     ['N' = 12,
      'P' = 47321,
      'Q' = 33461,
      'N1' = 11,
      'N2' = 10,
      'P1' = 19601,
      'Q1' = 13860,
      'P2' = 8119,
      'Q2' = 5741,
      'Twicep1' = 39202,
      'Twiceq1' = 27720],
     [12 > 1,
      11 is 12 - 1,
      10 is 12 - 2,
      conv(11, 19601, 13860),
      conv(10, 8119, 5741),
      39202 is 2 * 19601,
      47321 is 39202 + 8119,
      27720 is 2 * 13860,
      33461 is 27720 + 5741]).
step(12 > 1, builtin, [], []).
step(11 is 12 - 1, builtin, [], []).
step(10 is 12 - 2, builtin, [], []).
step(conv(11, 19601, 13860),
     rule(4),
     ['N' = 11,
      'P' = 19601,
      'Q' = 13860,
      'N1' = 10,
      'N2' = 9,
      'P1' = 8119,
      'Q1' = 5741,
      'P2' = 3363,
      'Q2' = 2378,
      'Twicep1' = 16238,
      'Twiceq1' = 11482],
     [11 > 1,
      10 is 11 - 1,
      9 is 11 - 2,
      conv(10, 8119, 5741),
      conv(9, 3363, 2378),
      16238 is 2 * 8119,
      19601 is 16238 + 3363,
      11482 is 2 * 5741,
      13860 is 11482 + 2378]).
step(11 > 1, builtin, [], []).
step(10 is 11 - 1, builtin, [], []).
step(9 is 11 - 2, builtin, [], []).
step(16238 is 2 * 8119, builtin, [], []).
step(19601 is 16238 + 3363, builtin, [], []).
step(11482 is 2 * 5741, builtin, [], []).
step(13860 is 11482 + 2378, builtin, [], []).
step(39202 is 2 * 19601, builtin, [], []).
step(47321 is 39202 + 8119, builtin, [], []).
step(27720 is 2 * 13860, builtin, [], []).
step(33461 is 27720 + 5741, builtin, [], []).
step(94642 is 2 * 47321, builtin, [], []).
step(114243 is 94642 + 19601, builtin, [], []).
step(66922 is 2 * 33461, builtin, [], []).
step(80782 is 66922 + 13860, builtin, [], []).
step(228486 is 2 * 114243, builtin, [], []).
step(275807 is 228486 + 47321, builtin, [], []).
step(161564 is 2 * 80782, builtin, [], []).
step(195025 is 161564 + 33461, builtin, [], []).
step(551614 is 2 * 275807, builtin, [], []).
step(665857 is 551614 + 114243, builtin, [], []).
step(390050 is 2 * 195025, builtin, [], []).
step(470832 is 390050 + 80782, builtin, [], []).
step(convergent_answer(pell_error_15, 1), rule(8), ['Error' = 1], [pell_error(15, 1)]).
step(pell_error(15, 1),
     rule(5),
     ['N' = 15,
      'Error' = 1,
      'P' = 665857,
      'Q' = 470832,
      'P2' = 443365544449,
      'Q2' = 221682772224,
      'Twiceq2' = 443365544448],
     [conv(15, 665857, 470832),
      443365544449 is 665857 * 665857,
      221682772224 is 470832 * 470832,
      443365544448 is 2 * 221682772224,
      1 is 443365544449 - 443365544448]).
step(443365544449 is 665857 * 665857, builtin, [], []).
step(221682772224 is 470832 * 470832, builtin, [], []).
step(443365544448 is 2 * 221682772224, builtin, [], []).
step(1 is 443365544449 - 443365544448, builtin, [], []).
step(convergent_answer(numerator_sum_0_to_10, 13859),
     rule(9),
     ['Sum' = 13859],
     [sumall(Expression, (between(0, 10, N), conv(N, Expression, _q)), 13859)]).
step(sumall(Expression, (between(0, 10, N), conv(N, Expression, _q)), 13859), builtin, [], []).
