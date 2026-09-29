pell_answer(solution_5, solution(3363, 2378)).
pell_answer(solution_8, solution(665857, 470832)).
pell_answer(check_8, true).
pell_answer(y_sum_1_to_8, 568344).

clause(2, pell(0, 1, 0), true).
clause(3,
       pell(var('N'), var('X'), var('Y')),
       (var('N') > 0,
        var('N1') is var('N') - 1,
        pell(var('N1'), var('X0'), var('Y0')),
        var('Ax') is 3 * var('X0'),
        var('By') is 4 * var('Y0'),
        var('X') is var('Ax') + var('By'),
        var('Cx') is 2 * var('X0'),
        var('Dy') is 3 * var('Y0'),
        var('Y') is var('Cx') + var('Dy'))).
clause(4,
       pell_holds(var('N'), true),
       (pell(var('N'), var('X'), var('Y')),
        var('X2') is var('X') * var('X'),
        var('Y2') is var('Y') * var('Y'),
        var('Twicey2') is 2 * var('Y2'),
        1 is var('X2') - var('Twicey2'))).
clause(5, pell_answer(solution_5, solution(var('X'), var('Y'))), pell(5, var('X'), var('Y'))).
clause(6, pell_answer(solution_8, solution(var('X'), var('Y'))), pell(8, var('X'), var('Y'))).
clause(7, pell_answer(check_8, true), pell_holds(8, true)).
clause(8,
       pell_answer(y_sum_1_to_8, var('Sum')),
       sumall(var('Y'), (between(1, 8, var('N')), pell(var('N'), anonymous(1), var('Y'))), var('Sum'))).

step(pell_answer(solution_5, solution(3363, 2378)),
     rule(5),
     ['X' = 3363, 'Y' = 2378],
     [pell(5, 3363, 2378)]).
step(pell(5, 3363, 2378),
     rule(3),
     ['N' = 5,
      'X' = 3363,
      'Y' = 2378,
      'N1' = 4,
      'X0' = 577,
      'Y0' = 408,
      'Ax' = 1731,
      'By' = 1632,
      'Cx' = 1154,
      'Dy' = 1224],
     [5 > 0,
      4 is 5 - 1,
      pell(4, 577, 408),
      1731 is 3 * 577,
      1632 is 4 * 408,
      3363 is 1731 + 1632,
      1154 is 2 * 577,
      1224 is 3 * 408,
      2378 is 1154 + 1224]).
step(5 > 0, builtin, [], []).
step(4 is 5 - 1, builtin, [], []).
step(pell(4, 577, 408),
     rule(3),
     ['N' = 4,
      'X' = 577,
      'Y' = 408,
      'N1' = 3,
      'X0' = 99,
      'Y0' = 70,
      'Ax' = 297,
      'By' = 280,
      'Cx' = 198,
      'Dy' = 210],
     [4 > 0,
      3 is 4 - 1,
      pell(3, 99, 70),
      297 is 3 * 99,
      280 is 4 * 70,
      577 is 297 + 280,
      198 is 2 * 99,
      210 is 3 * 70,
      408 is 198 + 210]).
step(4 > 0, builtin, [], []).
step(3 is 4 - 1, builtin, [], []).
step(pell(3, 99, 70),
     rule(3),
     ['N' = 3,
      'X' = 99,
      'Y' = 70,
      'N1' = 2,
      'X0' = 17,
      'Y0' = 12,
      'Ax' = 51,
      'By' = 48,
      'Cx' = 34,
      'Dy' = 36],
     [3 > 0,
      2 is 3 - 1,
      pell(2, 17, 12),
      51 is 3 * 17,
      48 is 4 * 12,
      99 is 51 + 48,
      34 is 2 * 17,
      36 is 3 * 12,
      70 is 34 + 36]).
step(3 > 0, builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(pell(2, 17, 12),
     rule(3),
     ['N' = 2,
      'X' = 17,
      'Y' = 12,
      'N1' = 1,
      'X0' = 3,
      'Y0' = 2,
      'Ax' = 9,
      'By' = 8,
      'Cx' = 6,
      'Dy' = 6],
     [2 > 0,
      1 is 2 - 1,
      pell(1, 3, 2),
      9 is 3 * 3,
      8 is 4 * 2,
      17 is 9 + 8,
      6 is 2 * 3,
      6 is 3 * 2,
      12 is 6 + 6]).
step(2 > 0, builtin, [], []).
step(1 is 2 - 1, builtin, [], []).
step(pell(1, 3, 2),
     rule(3),
     ['N' = 1,
      'X' = 3,
      'Y' = 2,
      'N1' = 0,
      'X0' = 1,
      'Y0' = 0,
      'Ax' = 3,
      'By' = 0,
      'Cx' = 2,
      'Dy' = 0],
     [1 > 0,
      0 is 1 - 1,
      pell(0, 1, 0),
      3 is 3 * 1,
      0 is 4 * 0,
      3 is 3 + 0,
      2 is 2 * 1,
      0 is 3 * 0,
      2 is 2 + 0]).
step(1 > 0, builtin, [], []).
step(0 is 1 - 1, builtin, [], []).
step(pell(0, 1, 0), fact(2), [], []).
step(3 is 3 * 1, builtin, [], []).
step(0 is 4 * 0, builtin, [], []).
step(3 is 3 + 0, builtin, [], []).
step(2 is 2 * 1, builtin, [], []).
step(0 is 3 * 0, builtin, [], []).
step(2 is 2 + 0, builtin, [], []).
step(9 is 3 * 3, builtin, [], []).
step(8 is 4 * 2, builtin, [], []).
step(17 is 9 + 8, builtin, [], []).
step(6 is 2 * 3, builtin, [], []).
step(6 is 3 * 2, builtin, [], []).
step(12 is 6 + 6, builtin, [], []).
step(51 is 3 * 17, builtin, [], []).
step(48 is 4 * 12, builtin, [], []).
step(99 is 51 + 48, builtin, [], []).
step(34 is 2 * 17, builtin, [], []).
step(36 is 3 * 12, builtin, [], []).
step(70 is 34 + 36, builtin, [], []).
step(297 is 3 * 99, builtin, [], []).
step(280 is 4 * 70, builtin, [], []).
step(577 is 297 + 280, builtin, [], []).
step(198 is 2 * 99, builtin, [], []).
step(210 is 3 * 70, builtin, [], []).
step(408 is 198 + 210, builtin, [], []).
step(1731 is 3 * 577, builtin, [], []).
step(1632 is 4 * 408, builtin, [], []).
step(3363 is 1731 + 1632, builtin, [], []).
step(1154 is 2 * 577, builtin, [], []).
step(1224 is 3 * 408, builtin, [], []).
step(2378 is 1154 + 1224, builtin, [], []).
step(pell_answer(solution_8, solution(665857, 470832)),
     rule(6),
     ['X' = 665857, 'Y' = 470832],
     [pell(8, 665857, 470832)]).
step(pell(8, 665857, 470832),
     rule(3),
     ['N' = 8,
      'X' = 665857,
      'Y' = 470832,
      'N1' = 7,
      'X0' = 114243,
      'Y0' = 80782,
      'Ax' = 342729,
      'By' = 323128,
      'Cx' = 228486,
      'Dy' = 242346],
     [8 > 0,
      7 is 8 - 1,
      pell(7, 114243, 80782),
      342729 is 3 * 114243,
      323128 is 4 * 80782,
      665857 is 342729 + 323128,
      228486 is 2 * 114243,
      242346 is 3 * 80782,
      470832 is 228486 + 242346]).
step(8 > 0, builtin, [], []).
step(7 is 8 - 1, builtin, [], []).
step(pell(7, 114243, 80782),
     rule(3),
     ['N' = 7,
      'X' = 114243,
      'Y' = 80782,
      'N1' = 6,
      'X0' = 19601,
      'Y0' = 13860,
      'Ax' = 58803,
      'By' = 55440,
      'Cx' = 39202,
      'Dy' = 41580],
     [7 > 0,
      6 is 7 - 1,
      pell(6, 19601, 13860),
      58803 is 3 * 19601,
      55440 is 4 * 13860,
      114243 is 58803 + 55440,
      39202 is 2 * 19601,
      41580 is 3 * 13860,
      80782 is 39202 + 41580]).
step(7 > 0, builtin, [], []).
step(6 is 7 - 1, builtin, [], []).
step(pell(6, 19601, 13860),
     rule(3),
     ['N' = 6,
      'X' = 19601,
      'Y' = 13860,
      'N1' = 5,
      'X0' = 3363,
      'Y0' = 2378,
      'Ax' = 10089,
      'By' = 9512,
      'Cx' = 6726,
      'Dy' = 7134],
     [6 > 0,
      5 is 6 - 1,
      pell(5, 3363, 2378),
      10089 is 3 * 3363,
      9512 is 4 * 2378,
      19601 is 10089 + 9512,
      6726 is 2 * 3363,
      7134 is 3 * 2378,
      13860 is 6726 + 7134]).
step(6 > 0, builtin, [], []).
step(5 is 6 - 1, builtin, [], []).
step(10089 is 3 * 3363, builtin, [], []).
step(9512 is 4 * 2378, builtin, [], []).
step(19601 is 10089 + 9512, builtin, [], []).
step(6726 is 2 * 3363, builtin, [], []).
step(7134 is 3 * 2378, builtin, [], []).
step(13860 is 6726 + 7134, builtin, [], []).
step(58803 is 3 * 19601, builtin, [], []).
step(55440 is 4 * 13860, builtin, [], []).
step(114243 is 58803 + 55440, builtin, [], []).
step(39202 is 2 * 19601, builtin, [], []).
step(41580 is 3 * 13860, builtin, [], []).
step(80782 is 39202 + 41580, builtin, [], []).
step(342729 is 3 * 114243, builtin, [], []).
step(323128 is 4 * 80782, builtin, [], []).
step(665857 is 342729 + 323128, builtin, [], []).
step(228486 is 2 * 114243, builtin, [], []).
step(242346 is 3 * 80782, builtin, [], []).
step(470832 is 228486 + 242346, builtin, [], []).
step(pell_answer(check_8, true), rule(7), [], [pell_holds(8, true)]).
step(pell_holds(8, true),
     rule(4),
     ['N' = 8,
      'X' = 665857,
      'Y' = 470832,
      'X2' = 443365544449,
      'Y2' = 221682772224,
      'Twicey2' = 443365544448],
     [pell(8, 665857, 470832),
      443365544449 is 665857 * 665857,
      221682772224 is 470832 * 470832,
      443365544448 is 2 * 221682772224,
      1 is 443365544449 - 443365544448]).
step(443365544449 is 665857 * 665857, builtin, [], []).
step(221682772224 is 470832 * 470832, builtin, [], []).
step(443365544448 is 2 * 221682772224, builtin, [], []).
step(1 is 443365544449 - 443365544448, builtin, [], []).
step(pell_answer(y_sum_1_to_8, 568344),
     rule(8),
     ['Sum' = 568344],
     [sumall(Expression, (between(1, 8, N), pell(N, _x, Expression)), 568344)]).
step(sumall(Expression, (between(1, 8, N), pell(N, _x, Expression)), 568344), builtin, [], []).
