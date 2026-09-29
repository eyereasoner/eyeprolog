easterDate(y2026, date(2026, april, 5)).
easterDate(y2027, date(2027, march, 28)).
easterDate(y2028, date(2028, april, 16)).
easterDate(y2029, date(2029, april, 1)).
easterDate(y2030, date(2030, april, 21)).
easterDate(y2031, date(2031, april, 13)).
easterDate(y2032, date(2032, march, 28)).
easterDate(y2033, date(2033, april, 17)).
easterDate(y2034, date(2034, april, 9)).
easterDate(y2035, date(2035, march, 25)).
computusRemainders(y2026, remainders(12, 12, 2)).
computusRemainders(y2027, remainders(13, 1, 5)).
computusRemainders(y2028, remainders(14, 20, 5)).
computusRemainders(y2029, remainders(15, 9, 1)).
computusRemainders(y2030, remainders(16, 28, 2)).
computusRemainders(y2031, remainders(17, 17, 5)).
computusRemainders(y2032, remainders(18, 6, 0)).
computusRemainders(y2033, remainders(0, 24, 2)).
computusRemainders(y2034, remainders(1, 13, 5)).
computusRemainders(y2035, remainders(2, 2, 1)).
legalGregorianWindow(y2026, true).
legalGregorianWindow(y2027, true).
legalGregorianWindow(y2028, true).
legalGregorianWindow(y2029, true).
legalGregorianWindow(y2030, true).
legalGregorianWindow(y2031, true).
legalGregorianWindow(y2032, true).
legalGregorianWindow(y2033, true).
legalGregorianWindow(y2034, true).
legalGregorianWindow(y2035, true).

clause(1, case(y2026, 2026), true).
clause(2, case(y2027, 2027), true).
clause(3, case(y2028, 2028), true).
clause(4, case(y2029, 2029), true).
clause(5, case(y2030, 2030), true).
clause(6, case(y2031, 2031), true).
clause(7, case(y2032, 2032), true).
clause(8, case(y2033, 2033), true).
clause(9, case(y2034, 2034), true).
clause(10, case(y2035, 2035), true).
clause(11, valid_golden(var('N')), between(0, 18, var('N'))).
clause(12, valid_epact(var('N')), between(0, 29, var('N'))).
clause(13, valid_weekday(var('N')), between(0, 6, var('N'))).
clause(14, legal_easter_date(3, var('D')), between(22, 31, var('D'))).
clause(15, legal_easter_date(4, var('D')), between(1, 25, var('D'))).
clause(16, month_name(3, march), true).
clause(17, month_name(4, april), true).
clause(18,
       computus(var('Case'), var('Year'), var('Month'), var('Day'), var('J'), var('K'), var('Q'), var('R'), var('V'), var('Z')),
       (case(var('Case'), var('Year')),
        var('J') is var('Year') mod 19,
        var('K') is var('Year') // 100,
        var('H') is var('Year') mod 100,
        var('M') is var('K') // 4,
        var('N') is var('K') mod 4,
        var('Kp8') is var('K') + 8,
        var('P') is var('Kp8') // 25,
        var('Kminusp') is var('K') - var('P'),
        var('Kminuspplus1') is var('Kminusp') + 1,
        var('Q') is var('Kminuspplus1') // 3,
        var('Nineteenj') is 19 * var('J'),
        var('T1') is var('Nineteenj') + var('K'),
        var('T2') is var('T1') - var('M'),
        var('T3') is var('T2') - var('Q'),
        var('T4') is var('T3') + 15,
        var('R') is var('T4') mod 30,
        var('S') is var('H') // 4,
        var('U') is var('H') mod 4,
        var('Twon') is 2 * var('N'),
        var('Twos') is 2 * var('S'),
        var('L1') is 32 + var('Twon'),
        var('L2') is var('L1') + var('Twos'),
        var('L3') is var('L2') - var('R'),
        var('L4') is var('L3') - var('U'),
        var('V') is var('L4') mod 7,
        var('Elevenr') is 11 * var('R'),
        var('Twentytwov') is 22 * var('V'),
        var('W1') is var('J') + var('Elevenr'),
        var('W2') is var('W1') + var('Twentytwov'),
        var('W') is var('W2') // 451,
        var('Sevenw') is 7 * var('W'),
        var('X1') is var('R') + var('V'),
        var('X2') is var('X1') - var('Sevenw'),
        var('X3') is var('X2') + 114,
        var('Month') is var('X3') // 31,
        var('Z') is var('X3') mod 31,
        var('Day') is var('Z') + 1)).
clause(19,
       checks_pass(var('Case')),
       (computus(var('Case'), anonymous(1), var('Month'), var('Day'), var('J'), anonymous(2), anonymous(3), var('R'), var('V'), anonymous(4)),
        valid_golden(var('J')),
        valid_epact(var('R')),
        valid_weekday(var('V')),
        month_name(var('Month'), anonymous(5)),
        legal_easter_date(var('Month'), var('Day')))).
clause(20,
       easterDate(var('Case'), date(var('Year'), var('Monthname'), var('Day'))),
       (computus(var('Case'), var('Year'), var('Month'), var('Day'), anonymous(1), anonymous(2), anonymous(3), anonymous(4), anonymous(5), anonymous(6)),
        month_name(var('Month'), var('Monthname')))).
clause(21,
       computusRemainders(var('Case'), remainders(var('J'), var('R'), var('V'))),
       computus(var('Case'), anonymous(1), anonymous(2), anonymous(3), var('J'), anonymous(4), anonymous(5), var('R'), var('V'), anonymous(6))).
clause(22, legalGregorianWindow(var('Case'), true), checks_pass(var('Case'))).

step(easterDate(y2026, date(2026, april, 5)),
     rule(20),
     ['Case' = y2026, 'Year' = 2026, 'Monthname' = april, 'Day' = 5, 'Month' = 4],
     [computus(y2026, 2026, 4, 5, 12, 20, 6, 12, 2, 4), month_name(4, april)]).
step(computus(y2026, 2026, 4, 5, 12, 20, 6, 12, 2, 4),
     rule(18),
     ['Case' = y2026,
      'Year' = 2026,
      'Month' = 4,
      'Day' = 5,
      'J' = 12,
      'K' = 20,
      'Q' = 6,
      'R' = 12,
      'V' = 2,
      'Z' = 4,
      'H' = 26,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 228,
      'T1' = 248,
      'T2' = 243,
      'T3' = 237,
      'T4' = 252,
      'S' = 6,
      'U' = 2,
      'Twon' = 0,
      'Twos' = 12,
      'L1' = 32,
      'L2' = 44,
      'L3' = 32,
      'L4' = 30,
      'Elevenr' = 132,
      'Twentytwov' = 44,
      'W1' = 144,
      'W2' = 188,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 14,
      'X2' = 14,
      'X3' = 128],
     [case(y2026, 2026),
      12 is 2026 mod 19,
      20 is 2026 // 100,
      26 is 2026 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      228 is 19 * 12,
      248 is 228 + 20,
      243 is 248 - 5,
      237 is 243 - 6,
      252 is 237 + 15,
      12 is 252 mod 30,
      6 is 26 // 4,
      2 is 26 mod 4,
      0 is 2 * 0,
      12 is 2 * 6,
      32 is 32 + 0,
      44 is 32 + 12,
      32 is 44 - 12,
      30 is 32 - 2,
      2 is 30 mod 7,
      132 is 11 * 12,
      44 is 22 * 2,
      144 is 12 + 132,
      188 is 144 + 44,
      0 is 188 // 451,
      0 is 7 * 0,
      14 is 12 + 2,
      14 is 14 - 0,
      128 is 14 + 114,
      4 is 128 // 31,
      4 is 128 mod 31,
      5 is 4 + 1]).
step(case(y2026, 2026), fact(1), [], []).
step(12 is 2026 mod 19, builtin, [], []).
step(20 is 2026 // 100, builtin, [], []).
step(26 is 2026 mod 100, builtin, [], []).
step(5 is 20 // 4, builtin, [], []).
step(0 is 20 mod 4, builtin, [], []).
step(28 is 20 + 8, builtin, [], []).
step(1 is 28 // 25, builtin, [], []).
step(19 is 20 - 1, builtin, [], []).
step(20 is 19 + 1, builtin, [], []).
step(6 is 20 // 3, builtin, [], []).
step(228 is 19 * 12, builtin, [], []).
step(248 is 228 + 20, builtin, [], []).
step(243 is 248 - 5, builtin, [], []).
step(237 is 243 - 6, builtin, [], []).
step(252 is 237 + 15, builtin, [], []).
step(12 is 252 mod 30, builtin, [], []).
step(6 is 26 // 4, builtin, [], []).
step(2 is 26 mod 4, builtin, [], []).
step(0 is 2 * 0, builtin, [], []).
step(12 is 2 * 6, builtin, [], []).
step(32 is 32 + 0, builtin, [], []).
step(44 is 32 + 12, builtin, [], []).
step(32 is 44 - 12, builtin, [], []).
step(30 is 32 - 2, builtin, [], []).
step(2 is 30 mod 7, builtin, [], []).
step(132 is 11 * 12, builtin, [], []).
step(44 is 22 * 2, builtin, [], []).
step(144 is 12 + 132, builtin, [], []).
step(188 is 144 + 44, builtin, [], []).
step(0 is 188 // 451, builtin, [], []).
step(0 is 7 * 0, builtin, [], []).
step(14 is 12 + 2, builtin, [], []).
step(14 is 14 - 0, builtin, [], []).
step(128 is 14 + 114, builtin, [], []).
step(4 is 128 // 31, builtin, [], []).
step(4 is 128 mod 31, builtin, [], []).
step(5 is 4 + 1, builtin, [], []).
step(month_name(4, april), fact(17), [], []).
step(easterDate(y2027, date(2027, march, 28)),
     rule(20),
     ['Case' = y2027, 'Year' = 2027, 'Monthname' = march, 'Day' = 28, 'Month' = 3],
     [computus(y2027, 2027, 3, 28, 13, 20, 6, 1, 5, 27), month_name(3, march)]).
step(computus(y2027, 2027, 3, 28, 13, 20, 6, 1, 5, 27),
     rule(18),
     ['Case' = y2027,
      'Year' = 2027,
      'Month' = 3,
      'Day' = 28,
      'J' = 13,
      'K' = 20,
      'Q' = 6,
      'R' = 1,
      'V' = 5,
      'Z' = 27,
      'H' = 27,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 247,
      'T1' = 267,
      'T2' = 262,
      'T3' = 256,
      'T4' = 271,
      'S' = 6,
      'U' = 3,
      'Twon' = 0,
      'Twos' = 12,
      'L1' = 32,
      'L2' = 44,
      'L3' = 43,
      'L4' = 40,
      'Elevenr' = 11,
      'Twentytwov' = 110,
      'W1' = 24,
      'W2' = 134,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 6,
      'X2' = 6,
      'X3' = 120],
     [case(y2027, 2027),
      13 is 2027 mod 19,
      20 is 2027 // 100,
      27 is 2027 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      247 is 19 * 13,
      267 is 247 + 20,
      262 is 267 - 5,
      256 is 262 - 6,
      271 is 256 + 15,
      1 is 271 mod 30,
      6 is 27 // 4,
      3 is 27 mod 4,
      0 is 2 * 0,
      12 is 2 * 6,
      32 is 32 + 0,
      44 is 32 + 12,
      43 is 44 - 1,
      40 is 43 - 3,
      5 is 40 mod 7,
      11 is 11 * 1,
      110 is 22 * 5,
      24 is 13 + 11,
      134 is 24 + 110,
      0 is 134 // 451,
      0 is 7 * 0,
      6 is 1 + 5,
      6 is 6 - 0,
      120 is 6 + 114,
      3 is 120 // 31,
      27 is 120 mod 31,
      28 is 27 + 1]).
step(case(y2027, 2027), fact(2), [], []).
step(13 is 2027 mod 19, builtin, [], []).
step(20 is 2027 // 100, builtin, [], []).
step(27 is 2027 mod 100, builtin, [], []).
step(247 is 19 * 13, builtin, [], []).
step(267 is 247 + 20, builtin, [], []).
step(262 is 267 - 5, builtin, [], []).
step(256 is 262 - 6, builtin, [], []).
step(271 is 256 + 15, builtin, [], []).
step(1 is 271 mod 30, builtin, [], []).
step(6 is 27 // 4, builtin, [], []).
step(3 is 27 mod 4, builtin, [], []).
step(43 is 44 - 1, builtin, [], []).
step(40 is 43 - 3, builtin, [], []).
step(5 is 40 mod 7, builtin, [], []).
step(11 is 11 * 1, builtin, [], []).
step(110 is 22 * 5, builtin, [], []).
step(24 is 13 + 11, builtin, [], []).
step(134 is 24 + 110, builtin, [], []).
step(0 is 134 // 451, builtin, [], []).
step(6 is 1 + 5, builtin, [], []).
step(6 is 6 - 0, builtin, [], []).
step(120 is 6 + 114, builtin, [], []).
step(3 is 120 // 31, builtin, [], []).
step(27 is 120 mod 31, builtin, [], []).
step(28 is 27 + 1, builtin, [], []).
step(month_name(3, march), fact(16), [], []).
step(easterDate(y2028, date(2028, april, 16)),
     rule(20),
     ['Case' = y2028, 'Year' = 2028, 'Monthname' = april, 'Day' = 16, 'Month' = 4],
     [computus(y2028, 2028, 4, 16, 14, 20, 6, 20, 5, 15), month_name(4, april)]).
step(computus(y2028, 2028, 4, 16, 14, 20, 6, 20, 5, 15),
     rule(18),
     ['Case' = y2028,
      'Year' = 2028,
      'Month' = 4,
      'Day' = 16,
      'J' = 14,
      'K' = 20,
      'Q' = 6,
      'R' = 20,
      'V' = 5,
      'Z' = 15,
      'H' = 28,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 266,
      'T1' = 286,
      'T2' = 281,
      'T3' = 275,
      'T4' = 290,
      'S' = 7,
      'U' = 0,
      'Twon' = 0,
      'Twos' = 14,
      'L1' = 32,
      'L2' = 46,
      'L3' = 26,
      'L4' = 26,
      'Elevenr' = 220,
      'Twentytwov' = 110,
      'W1' = 234,
      'W2' = 344,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 25,
      'X2' = 25,
      'X3' = 139],
     [case(y2028, 2028),
      14 is 2028 mod 19,
      20 is 2028 // 100,
      28 is 2028 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      266 is 19 * 14,
      286 is 266 + 20,
      281 is 286 - 5,
      275 is 281 - 6,
      290 is 275 + 15,
      20 is 290 mod 30,
      7 is 28 // 4,
      0 is 28 mod 4,
      0 is 2 * 0,
      14 is 2 * 7,
      32 is 32 + 0,
      46 is 32 + 14,
      26 is 46 - 20,
      26 is 26 - 0,
      5 is 26 mod 7,
      220 is 11 * 20,
      110 is 22 * 5,
      234 is 14 + 220,
      344 is 234 + 110,
      0 is 344 // 451,
      0 is 7 * 0,
      25 is 20 + 5,
      25 is 25 - 0,
      139 is 25 + 114,
      4 is 139 // 31,
      15 is 139 mod 31,
      16 is 15 + 1]).
step(case(y2028, 2028), fact(3), [], []).
step(14 is 2028 mod 19, builtin, [], []).
step(20 is 2028 // 100, builtin, [], []).
step(28 is 2028 mod 100, builtin, [], []).
step(266 is 19 * 14, builtin, [], []).
step(286 is 266 + 20, builtin, [], []).
step(281 is 286 - 5, builtin, [], []).
step(275 is 281 - 6, builtin, [], []).
step(290 is 275 + 15, builtin, [], []).
step(20 is 290 mod 30, builtin, [], []).
step(7 is 28 // 4, builtin, [], []).
step(0 is 28 mod 4, builtin, [], []).
step(14 is 2 * 7, builtin, [], []).
step(46 is 32 + 14, builtin, [], []).
step(26 is 46 - 20, builtin, [], []).
step(26 is 26 - 0, builtin, [], []).
step(5 is 26 mod 7, builtin, [], []).
step(220 is 11 * 20, builtin, [], []).
step(234 is 14 + 220, builtin, [], []).
step(344 is 234 + 110, builtin, [], []).
step(0 is 344 // 451, builtin, [], []).
step(25 is 20 + 5, builtin, [], []).
step(25 is 25 - 0, builtin, [], []).
step(139 is 25 + 114, builtin, [], []).
step(4 is 139 // 31, builtin, [], []).
step(15 is 139 mod 31, builtin, [], []).
step(16 is 15 + 1, builtin, [], []).
step(easterDate(y2029, date(2029, april, 1)),
     rule(20),
     ['Case' = y2029, 'Year' = 2029, 'Monthname' = april, 'Day' = 1, 'Month' = 4],
     [computus(y2029, 2029, 4, 1, 15, 20, 6, 9, 1, 0), month_name(4, april)]).
step(computus(y2029, 2029, 4, 1, 15, 20, 6, 9, 1, 0),
     rule(18),
     ['Case' = y2029,
      'Year' = 2029,
      'Month' = 4,
      'Day' = 1,
      'J' = 15,
      'K' = 20,
      'Q' = 6,
      'R' = 9,
      'V' = 1,
      'Z' = 0,
      'H' = 29,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 285,
      'T1' = 305,
      'T2' = 300,
      'T3' = 294,
      'T4' = 309,
      'S' = 7,
      'U' = 1,
      'Twon' = 0,
      'Twos' = 14,
      'L1' = 32,
      'L2' = 46,
      'L3' = 37,
      'L4' = 36,
      'Elevenr' = 99,
      'Twentytwov' = 22,
      'W1' = 114,
      'W2' = 136,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 10,
      'X2' = 10,
      'X3' = 124],
     [case(y2029, 2029),
      15 is 2029 mod 19,
      20 is 2029 // 100,
      29 is 2029 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      285 is 19 * 15,
      305 is 285 + 20,
      300 is 305 - 5,
      294 is 300 - 6,
      309 is 294 + 15,
      9 is 309 mod 30,
      7 is 29 // 4,
      1 is 29 mod 4,
      0 is 2 * 0,
      14 is 2 * 7,
      32 is 32 + 0,
      46 is 32 + 14,
      37 is 46 - 9,
      36 is 37 - 1,
      1 is 36 mod 7,
      99 is 11 * 9,
      22 is 22 * 1,
      114 is 15 + 99,
      136 is 114 + 22,
      0 is 136 // 451,
      0 is 7 * 0,
      10 is 9 + 1,
      10 is 10 - 0,
      124 is 10 + 114,
      4 is 124 // 31,
      0 is 124 mod 31,
      1 is 0 + 1]).
step(case(y2029, 2029), fact(4), [], []).
step(15 is 2029 mod 19, builtin, [], []).
step(20 is 2029 // 100, builtin, [], []).
step(29 is 2029 mod 100, builtin, [], []).
step(285 is 19 * 15, builtin, [], []).
step(305 is 285 + 20, builtin, [], []).
step(300 is 305 - 5, builtin, [], []).
step(294 is 300 - 6, builtin, [], []).
step(309 is 294 + 15, builtin, [], []).
step(9 is 309 mod 30, builtin, [], []).
step(7 is 29 // 4, builtin, [], []).
step(1 is 29 mod 4, builtin, [], []).
step(37 is 46 - 9, builtin, [], []).
step(36 is 37 - 1, builtin, [], []).
step(1 is 36 mod 7, builtin, [], []).
step(99 is 11 * 9, builtin, [], []).
step(22 is 22 * 1, builtin, [], []).
step(114 is 15 + 99, builtin, [], []).
step(136 is 114 + 22, builtin, [], []).
step(0 is 136 // 451, builtin, [], []).
step(10 is 9 + 1, builtin, [], []).
step(10 is 10 - 0, builtin, [], []).
step(124 is 10 + 114, builtin, [], []).
step(4 is 124 // 31, builtin, [], []).
step(0 is 124 mod 31, builtin, [], []).
step(1 is 0 + 1, builtin, [], []).
step(easterDate(y2030, date(2030, april, 21)),
     rule(20),
     ['Case' = y2030, 'Year' = 2030, 'Monthname' = april, 'Day' = 21, 'Month' = 4],
     [computus(y2030, 2030, 4, 21, 16, 20, 6, 28, 2, 20), month_name(4, april)]).
step(computus(y2030, 2030, 4, 21, 16, 20, 6, 28, 2, 20),
     rule(18),
     ['Case' = y2030,
      'Year' = 2030,
      'Month' = 4,
      'Day' = 21,
      'J' = 16,
      'K' = 20,
      'Q' = 6,
      'R' = 28,
      'V' = 2,
      'Z' = 20,
      'H' = 30,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 304,
      'T1' = 324,
      'T2' = 319,
      'T3' = 313,
      'T4' = 328,
      'S' = 7,
      'U' = 2,
      'Twon' = 0,
      'Twos' = 14,
      'L1' = 32,
      'L2' = 46,
      'L3' = 18,
      'L4' = 16,
      'Elevenr' = 308,
      'Twentytwov' = 44,
      'W1' = 324,
      'W2' = 368,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 30,
      'X2' = 30,
      'X3' = 144],
     [case(y2030, 2030),
      16 is 2030 mod 19,
      20 is 2030 // 100,
      30 is 2030 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      304 is 19 * 16,
      324 is 304 + 20,
      319 is 324 - 5,
      313 is 319 - 6,
      328 is 313 + 15,
      28 is 328 mod 30,
      7 is 30 // 4,
      2 is 30 mod 4,
      0 is 2 * 0,
      14 is 2 * 7,
      32 is 32 + 0,
      46 is 32 + 14,
      18 is 46 - 28,
      16 is 18 - 2,
      2 is 16 mod 7,
      308 is 11 * 28,
      44 is 22 * 2,
      324 is 16 + 308,
      368 is 324 + 44,
      0 is 368 // 451,
      0 is 7 * 0,
      30 is 28 + 2,
      30 is 30 - 0,
      144 is 30 + 114,
      4 is 144 // 31,
      20 is 144 mod 31,
      21 is 20 + 1]).
step(case(y2030, 2030), fact(5), [], []).
step(16 is 2030 mod 19, builtin, [], []).
step(20 is 2030 // 100, builtin, [], []).
step(30 is 2030 mod 100, builtin, [], []).
step(304 is 19 * 16, builtin, [], []).
step(324 is 304 + 20, builtin, [], []).
step(319 is 324 - 5, builtin, [], []).
step(313 is 319 - 6, builtin, [], []).
step(328 is 313 + 15, builtin, [], []).
step(28 is 328 mod 30, builtin, [], []).
step(7 is 30 // 4, builtin, [], []).
step(2 is 30 mod 4, builtin, [], []).
step(18 is 46 - 28, builtin, [], []).
step(16 is 18 - 2, builtin, [], []).
step(2 is 16 mod 7, builtin, [], []).
step(308 is 11 * 28, builtin, [], []).
step(324 is 16 + 308, builtin, [], []).
step(368 is 324 + 44, builtin, [], []).
step(0 is 368 // 451, builtin, [], []).
step(30 is 28 + 2, builtin, [], []).
step(30 is 30 - 0, builtin, [], []).
step(144 is 30 + 114, builtin, [], []).
step(4 is 144 // 31, builtin, [], []).
step(20 is 144 mod 31, builtin, [], []).
step(21 is 20 + 1, builtin, [], []).
step(easterDate(y2031, date(2031, april, 13)),
     rule(20),
     ['Case' = y2031, 'Year' = 2031, 'Monthname' = april, 'Day' = 13, 'Month' = 4],
     [computus(y2031, 2031, 4, 13, 17, 20, 6, 17, 5, 12), month_name(4, april)]).
step(computus(y2031, 2031, 4, 13, 17, 20, 6, 17, 5, 12),
     rule(18),
     ['Case' = y2031,
      'Year' = 2031,
      'Month' = 4,
      'Day' = 13,
      'J' = 17,
      'K' = 20,
      'Q' = 6,
      'R' = 17,
      'V' = 5,
      'Z' = 12,
      'H' = 31,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 323,
      'T1' = 343,
      'T2' = 338,
      'T3' = 332,
      'T4' = 347,
      'S' = 7,
      'U' = 3,
      'Twon' = 0,
      'Twos' = 14,
      'L1' = 32,
      'L2' = 46,
      'L3' = 29,
      'L4' = 26,
      'Elevenr' = 187,
      'Twentytwov' = 110,
      'W1' = 204,
      'W2' = 314,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 22,
      'X2' = 22,
      'X3' = 136],
     [case(y2031, 2031),
      17 is 2031 mod 19,
      20 is 2031 // 100,
      31 is 2031 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      323 is 19 * 17,
      343 is 323 + 20,
      338 is 343 - 5,
      332 is 338 - 6,
      347 is 332 + 15,
      17 is 347 mod 30,
      7 is 31 // 4,
      3 is 31 mod 4,
      0 is 2 * 0,
      14 is 2 * 7,
      32 is 32 + 0,
      46 is 32 + 14,
      29 is 46 - 17,
      26 is 29 - 3,
      5 is 26 mod 7,
      187 is 11 * 17,
      110 is 22 * 5,
      204 is 17 + 187,
      314 is 204 + 110,
      0 is 314 // 451,
      0 is 7 * 0,
      22 is 17 + 5,
      22 is 22 - 0,
      136 is 22 + 114,
      4 is 136 // 31,
      12 is 136 mod 31,
      13 is 12 + 1]).
step(case(y2031, 2031), fact(6), [], []).
step(17 is 2031 mod 19, builtin, [], []).
step(20 is 2031 // 100, builtin, [], []).
step(31 is 2031 mod 100, builtin, [], []).
step(323 is 19 * 17, builtin, [], []).
step(343 is 323 + 20, builtin, [], []).
step(338 is 343 - 5, builtin, [], []).
step(332 is 338 - 6, builtin, [], []).
step(347 is 332 + 15, builtin, [], []).
step(17 is 347 mod 30, builtin, [], []).
step(7 is 31 // 4, builtin, [], []).
step(3 is 31 mod 4, builtin, [], []).
step(29 is 46 - 17, builtin, [], []).
step(26 is 29 - 3, builtin, [], []).
step(187 is 11 * 17, builtin, [], []).
step(204 is 17 + 187, builtin, [], []).
step(314 is 204 + 110, builtin, [], []).
step(0 is 314 // 451, builtin, [], []).
step(22 is 17 + 5, builtin, [], []).
step(22 is 22 - 0, builtin, [], []).
step(136 is 22 + 114, builtin, [], []).
step(4 is 136 // 31, builtin, [], []).
step(12 is 136 mod 31, builtin, [], []).
step(13 is 12 + 1, builtin, [], []).
step(easterDate(y2032, date(2032, march, 28)),
     rule(20),
     ['Case' = y2032, 'Year' = 2032, 'Monthname' = march, 'Day' = 28, 'Month' = 3],
     [computus(y2032, 2032, 3, 28, 18, 20, 6, 6, 0, 27), month_name(3, march)]).
step(computus(y2032, 2032, 3, 28, 18, 20, 6, 6, 0, 27),
     rule(18),
     ['Case' = y2032,
      'Year' = 2032,
      'Month' = 3,
      'Day' = 28,
      'J' = 18,
      'K' = 20,
      'Q' = 6,
      'R' = 6,
      'V' = 0,
      'Z' = 27,
      'H' = 32,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 342,
      'T1' = 362,
      'T2' = 357,
      'T3' = 351,
      'T4' = 366,
      'S' = 8,
      'U' = 0,
      'Twon' = 0,
      'Twos' = 16,
      'L1' = 32,
      'L2' = 48,
      'L3' = 42,
      'L4' = 42,
      'Elevenr' = 66,
      'Twentytwov' = 0,
      'W1' = 84,
      'W2' = 84,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 6,
      'X2' = 6,
      'X3' = 120],
     [case(y2032, 2032),
      18 is 2032 mod 19,
      20 is 2032 // 100,
      32 is 2032 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      342 is 19 * 18,
      362 is 342 + 20,
      357 is 362 - 5,
      351 is 357 - 6,
      366 is 351 + 15,
      6 is 366 mod 30,
      8 is 32 // 4,
      0 is 32 mod 4,
      0 is 2 * 0,
      16 is 2 * 8,
      32 is 32 + 0,
      48 is 32 + 16,
      42 is 48 - 6,
      42 is 42 - 0,
      0 is 42 mod 7,
      66 is 11 * 6,
      0 is 22 * 0,
      84 is 18 + 66,
      84 is 84 + 0,
      0 is 84 // 451,
      0 is 7 * 0,
      6 is 6 + 0,
      6 is 6 - 0,
      120 is 6 + 114,
      3 is 120 // 31,
      27 is 120 mod 31,
      28 is 27 + 1]).
step(case(y2032, 2032), fact(7), [], []).
step(18 is 2032 mod 19, builtin, [], []).
step(20 is 2032 // 100, builtin, [], []).
step(32 is 2032 mod 100, builtin, [], []).
step(342 is 19 * 18, builtin, [], []).
step(362 is 342 + 20, builtin, [], []).
step(357 is 362 - 5, builtin, [], []).
step(351 is 357 - 6, builtin, [], []).
step(366 is 351 + 15, builtin, [], []).
step(6 is 366 mod 30, builtin, [], []).
step(8 is 32 // 4, builtin, [], []).
step(0 is 32 mod 4, builtin, [], []).
step(16 is 2 * 8, builtin, [], []).
step(48 is 32 + 16, builtin, [], []).
step(42 is 48 - 6, builtin, [], []).
step(42 is 42 - 0, builtin, [], []).
step(0 is 42 mod 7, builtin, [], []).
step(66 is 11 * 6, builtin, [], []).
step(0 is 22 * 0, builtin, [], []).
step(84 is 18 + 66, builtin, [], []).
step(84 is 84 + 0, builtin, [], []).
step(0 is 84 // 451, builtin, [], []).
step(6 is 6 + 0, builtin, [], []).
step(easterDate(y2033, date(2033, april, 17)),
     rule(20),
     ['Case' = y2033, 'Year' = 2033, 'Monthname' = april, 'Day' = 17, 'Month' = 4],
     [computus(y2033, 2033, 4, 17, 0, 20, 6, 24, 2, 16), month_name(4, april)]).
step(computus(y2033, 2033, 4, 17, 0, 20, 6, 24, 2, 16),
     rule(18),
     ['Case' = y2033,
      'Year' = 2033,
      'Month' = 4,
      'Day' = 17,
      'J' = 0,
      'K' = 20,
      'Q' = 6,
      'R' = 24,
      'V' = 2,
      'Z' = 16,
      'H' = 33,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 0,
      'T1' = 20,
      'T2' = 15,
      'T3' = 9,
      'T4' = 24,
      'S' = 8,
      'U' = 1,
      'Twon' = 0,
      'Twos' = 16,
      'L1' = 32,
      'L2' = 48,
      'L3' = 24,
      'L4' = 23,
      'Elevenr' = 264,
      'Twentytwov' = 44,
      'W1' = 264,
      'W2' = 308,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 26,
      'X2' = 26,
      'X3' = 140],
     [case(y2033, 2033),
      0 is 2033 mod 19,
      20 is 2033 // 100,
      33 is 2033 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      0 is 19 * 0,
      20 is 0 + 20,
      15 is 20 - 5,
      9 is 15 - 6,
      24 is 9 + 15,
      24 is 24 mod 30,
      8 is 33 // 4,
      1 is 33 mod 4,
      0 is 2 * 0,
      16 is 2 * 8,
      32 is 32 + 0,
      48 is 32 + 16,
      24 is 48 - 24,
      23 is 24 - 1,
      2 is 23 mod 7,
      264 is 11 * 24,
      44 is 22 * 2,
      264 is 0 + 264,
      308 is 264 + 44,
      0 is 308 // 451,
      0 is 7 * 0,
      26 is 24 + 2,
      26 is 26 - 0,
      140 is 26 + 114,
      4 is 140 // 31,
      16 is 140 mod 31,
      17 is 16 + 1]).
step(case(y2033, 2033), fact(8), [], []).
step(0 is 2033 mod 19, builtin, [], []).
step(20 is 2033 // 100, builtin, [], []).
step(33 is 2033 mod 100, builtin, [], []).
step(0 is 19 * 0, builtin, [], []).
step(20 is 0 + 20, builtin, [], []).
step(15 is 20 - 5, builtin, [], []).
step(9 is 15 - 6, builtin, [], []).
step(24 is 9 + 15, builtin, [], []).
step(24 is 24 mod 30, builtin, [], []).
step(8 is 33 // 4, builtin, [], []).
step(1 is 33 mod 4, builtin, [], []).
step(24 is 48 - 24, builtin, [], []).
step(23 is 24 - 1, builtin, [], []).
step(2 is 23 mod 7, builtin, [], []).
step(264 is 11 * 24, builtin, [], []).
step(264 is 0 + 264, builtin, [], []).
step(308 is 264 + 44, builtin, [], []).
step(0 is 308 // 451, builtin, [], []).
step(26 is 24 + 2, builtin, [], []).
step(140 is 26 + 114, builtin, [], []).
step(4 is 140 // 31, builtin, [], []).
step(16 is 140 mod 31, builtin, [], []).
step(17 is 16 + 1, builtin, [], []).
step(easterDate(y2034, date(2034, april, 9)),
     rule(20),
     ['Case' = y2034, 'Year' = 2034, 'Monthname' = april, 'Day' = 9, 'Month' = 4],
     [computus(y2034, 2034, 4, 9, 1, 20, 6, 13, 5, 8), month_name(4, april)]).
step(computus(y2034, 2034, 4, 9, 1, 20, 6, 13, 5, 8),
     rule(18),
     ['Case' = y2034,
      'Year' = 2034,
      'Month' = 4,
      'Day' = 9,
      'J' = 1,
      'K' = 20,
      'Q' = 6,
      'R' = 13,
      'V' = 5,
      'Z' = 8,
      'H' = 34,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 19,
      'T1' = 39,
      'T2' = 34,
      'T3' = 28,
      'T4' = 43,
      'S' = 8,
      'U' = 2,
      'Twon' = 0,
      'Twos' = 16,
      'L1' = 32,
      'L2' = 48,
      'L3' = 35,
      'L4' = 33,
      'Elevenr' = 143,
      'Twentytwov' = 110,
      'W1' = 144,
      'W2' = 254,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 18,
      'X2' = 18,
      'X3' = 132],
     [case(y2034, 2034),
      1 is 2034 mod 19,
      20 is 2034 // 100,
      34 is 2034 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      19 is 19 * 1,
      39 is 19 + 20,
      34 is 39 - 5,
      28 is 34 - 6,
      43 is 28 + 15,
      13 is 43 mod 30,
      8 is 34 // 4,
      2 is 34 mod 4,
      0 is 2 * 0,
      16 is 2 * 8,
      32 is 32 + 0,
      48 is 32 + 16,
      35 is 48 - 13,
      33 is 35 - 2,
      5 is 33 mod 7,
      143 is 11 * 13,
      110 is 22 * 5,
      144 is 1 + 143,
      254 is 144 + 110,
      0 is 254 // 451,
      0 is 7 * 0,
      18 is 13 + 5,
      18 is 18 - 0,
      132 is 18 + 114,
      4 is 132 // 31,
      8 is 132 mod 31,
      9 is 8 + 1]).
step(case(y2034, 2034), fact(9), [], []).
step(1 is 2034 mod 19, builtin, [], []).
step(20 is 2034 // 100, builtin, [], []).
step(34 is 2034 mod 100, builtin, [], []).
step(19 is 19 * 1, builtin, [], []).
step(39 is 19 + 20, builtin, [], []).
step(34 is 39 - 5, builtin, [], []).
step(28 is 34 - 6, builtin, [], []).
step(43 is 28 + 15, builtin, [], []).
step(13 is 43 mod 30, builtin, [], []).
step(8 is 34 // 4, builtin, [], []).
step(2 is 34 mod 4, builtin, [], []).
step(35 is 48 - 13, builtin, [], []).
step(33 is 35 - 2, builtin, [], []).
step(5 is 33 mod 7, builtin, [], []).
step(143 is 11 * 13, builtin, [], []).
step(144 is 1 + 143, builtin, [], []).
step(254 is 144 + 110, builtin, [], []).
step(0 is 254 // 451, builtin, [], []).
step(18 is 13 + 5, builtin, [], []).
step(18 is 18 - 0, builtin, [], []).
step(132 is 18 + 114, builtin, [], []).
step(4 is 132 // 31, builtin, [], []).
step(8 is 132 mod 31, builtin, [], []).
step(9 is 8 + 1, builtin, [], []).
step(easterDate(y2035, date(2035, march, 25)),
     rule(20),
     ['Case' = y2035, 'Year' = 2035, 'Monthname' = march, 'Day' = 25, 'Month' = 3],
     [computus(y2035, 2035, 3, 25, 2, 20, 6, 2, 1, 24), month_name(3, march)]).
step(computus(y2035, 2035, 3, 25, 2, 20, 6, 2, 1, 24),
     rule(18),
     ['Case' = y2035,
      'Year' = 2035,
      'Month' = 3,
      'Day' = 25,
      'J' = 2,
      'K' = 20,
      'Q' = 6,
      'R' = 2,
      'V' = 1,
      'Z' = 24,
      'H' = 35,
      'M' = 5,
      'N' = 0,
      'Kp8' = 28,
      'P' = 1,
      'Kminusp' = 19,
      'Kminuspplus1' = 20,
      'Nineteenj' = 38,
      'T1' = 58,
      'T2' = 53,
      'T3' = 47,
      'T4' = 62,
      'S' = 8,
      'U' = 3,
      'Twon' = 0,
      'Twos' = 16,
      'L1' = 32,
      'L2' = 48,
      'L3' = 46,
      'L4' = 43,
      'Elevenr' = 22,
      'Twentytwov' = 22,
      'W1' = 24,
      'W2' = 46,
      'W' = 0,
      'Sevenw' = 0,
      'X1' = 3,
      'X2' = 3,
      'X3' = 117],
     [case(y2035, 2035),
      2 is 2035 mod 19,
      20 is 2035 // 100,
      35 is 2035 mod 100,
      5 is 20 // 4,
      0 is 20 mod 4,
      28 is 20 + 8,
      1 is 28 // 25,
      19 is 20 - 1,
      20 is 19 + 1,
      6 is 20 // 3,
      38 is 19 * 2,
      58 is 38 + 20,
      53 is 58 - 5,
      47 is 53 - 6,
      62 is 47 + 15,
      2 is 62 mod 30,
      8 is 35 // 4,
      3 is 35 mod 4,
      0 is 2 * 0,
      16 is 2 * 8,
      32 is 32 + 0,
      48 is 32 + 16,
      46 is 48 - 2,
      43 is 46 - 3,
      1 is 43 mod 7,
      22 is 11 * 2,
      22 is 22 * 1,
      24 is 2 + 22,
      46 is 24 + 22,
      0 is 46 // 451,
      0 is 7 * 0,
      3 is 2 + 1,
      3 is 3 - 0,
      117 is 3 + 114,
      3 is 117 // 31,
      24 is 117 mod 31,
      25 is 24 + 1]).
step(case(y2035, 2035), fact(10), [], []).
step(2 is 2035 mod 19, builtin, [], []).
step(20 is 2035 // 100, builtin, [], []).
step(35 is 2035 mod 100, builtin, [], []).
step(38 is 19 * 2, builtin, [], []).
step(58 is 38 + 20, builtin, [], []).
step(53 is 58 - 5, builtin, [], []).
step(47 is 53 - 6, builtin, [], []).
step(62 is 47 + 15, builtin, [], []).
step(2 is 62 mod 30, builtin, [], []).
step(8 is 35 // 4, builtin, [], []).
step(3 is 35 mod 4, builtin, [], []).
step(46 is 48 - 2, builtin, [], []).
step(43 is 46 - 3, builtin, [], []).
step(1 is 43 mod 7, builtin, [], []).
step(22 is 11 * 2, builtin, [], []).
step(24 is 2 + 22, builtin, [], []).
step(46 is 24 + 22, builtin, [], []).
step(0 is 46 // 451, builtin, [], []).
step(3 is 2 + 1, builtin, [], []).
step(3 is 3 - 0, builtin, [], []).
step(117 is 3 + 114, builtin, [], []).
step(3 is 117 // 31, builtin, [], []).
step(24 is 117 mod 31, builtin, [], []).
step(25 is 24 + 1, builtin, [], []).
step(computusRemainders(y2026, remainders(12, 12, 2)),
     rule(21),
     ['Case' = y2026, 'J' = 12, 'R' = 12, 'V' = 2],
     [computus(y2026, 2026, 4, 5, 12, 20, 6, 12, 2, 4)]).
step(computusRemainders(y2027, remainders(13, 1, 5)),
     rule(21),
     ['Case' = y2027, 'J' = 13, 'R' = 1, 'V' = 5],
     [computus(y2027, 2027, 3, 28, 13, 20, 6, 1, 5, 27)]).
step(computusRemainders(y2028, remainders(14, 20, 5)),
     rule(21),
     ['Case' = y2028, 'J' = 14, 'R' = 20, 'V' = 5],
     [computus(y2028, 2028, 4, 16, 14, 20, 6, 20, 5, 15)]).
step(computusRemainders(y2029, remainders(15, 9, 1)),
     rule(21),
     ['Case' = y2029, 'J' = 15, 'R' = 9, 'V' = 1],
     [computus(y2029, 2029, 4, 1, 15, 20, 6, 9, 1, 0)]).
step(computusRemainders(y2030, remainders(16, 28, 2)),
     rule(21),
     ['Case' = y2030, 'J' = 16, 'R' = 28, 'V' = 2],
     [computus(y2030, 2030, 4, 21, 16, 20, 6, 28, 2, 20)]).
step(computusRemainders(y2031, remainders(17, 17, 5)),
     rule(21),
     ['Case' = y2031, 'J' = 17, 'R' = 17, 'V' = 5],
     [computus(y2031, 2031, 4, 13, 17, 20, 6, 17, 5, 12)]).
step(computusRemainders(y2032, remainders(18, 6, 0)),
     rule(21),
     ['Case' = y2032, 'J' = 18, 'R' = 6, 'V' = 0],
     [computus(y2032, 2032, 3, 28, 18, 20, 6, 6, 0, 27)]).
step(computusRemainders(y2033, remainders(0, 24, 2)),
     rule(21),
     ['Case' = y2033, 'J' = 0, 'R' = 24, 'V' = 2],
     [computus(y2033, 2033, 4, 17, 0, 20, 6, 24, 2, 16)]).
step(computusRemainders(y2034, remainders(1, 13, 5)),
     rule(21),
     ['Case' = y2034, 'J' = 1, 'R' = 13, 'V' = 5],
     [computus(y2034, 2034, 4, 9, 1, 20, 6, 13, 5, 8)]).
step(computusRemainders(y2035, remainders(2, 2, 1)),
     rule(21),
     ['Case' = y2035, 'J' = 2, 'R' = 2, 'V' = 1],
     [computus(y2035, 2035, 3, 25, 2, 20, 6, 2, 1, 24)]).
step(legalGregorianWindow(y2026, true), rule(22), ['Case' = y2026], [checks_pass(y2026)]).
step(checks_pass(y2026),
     rule(19),
     ['Case' = y2026, 'Month' = 4, 'Day' = 5, 'J' = 12, 'R' = 12, 'V' = 2],
     [computus(y2026, 2026, 4, 5, 12, 20, 6, 12, 2, 4),
      valid_golden(12),
      valid_epact(12),
      valid_weekday(2),
      month_name(4, april),
      legal_easter_date(4, 5)]).
step(valid_golden(12), rule(11), ['N' = 12], [between(0, 18, 12)]).
step(between(0, 18, 12), builtin, [], []).
step(valid_epact(12), rule(12), ['N' = 12], [between(0, 29, 12)]).
step(between(0, 29, 12), builtin, [], []).
step(valid_weekday(2), rule(13), ['N' = 2], [between(0, 6, 2)]).
step(between(0, 6, 2), builtin, [], []).
step(legal_easter_date(4, 5), rule(15), ['D' = 5], [between(1, 25, 5)]).
step(between(1, 25, 5), builtin, [], []).
step(legalGregorianWindow(y2027, true), rule(22), ['Case' = y2027], [checks_pass(y2027)]).
step(checks_pass(y2027),
     rule(19),
     ['Case' = y2027, 'Month' = 3, 'Day' = 28, 'J' = 13, 'R' = 1, 'V' = 5],
     [computus(y2027, 2027, 3, 28, 13, 20, 6, 1, 5, 27),
      valid_golden(13),
      valid_epact(1),
      valid_weekday(5),
      month_name(3, march),
      legal_easter_date(3, 28)]).
step(valid_golden(13), rule(11), ['N' = 13], [between(0, 18, 13)]).
step(between(0, 18, 13), builtin, [], []).
step(valid_epact(1), rule(12), ['N' = 1], [between(0, 29, 1)]).
step(between(0, 29, 1), builtin, [], []).
step(valid_weekday(5), rule(13), ['N' = 5], [between(0, 6, 5)]).
step(between(0, 6, 5), builtin, [], []).
step(legal_easter_date(3, 28), rule(14), ['D' = 28], [between(22, 31, 28)]).
step(between(22, 31, 28), builtin, [], []).
step(legalGregorianWindow(y2028, true), rule(22), ['Case' = y2028], [checks_pass(y2028)]).
step(checks_pass(y2028),
     rule(19),
     ['Case' = y2028, 'Month' = 4, 'Day' = 16, 'J' = 14, 'R' = 20, 'V' = 5],
     [computus(y2028, 2028, 4, 16, 14, 20, 6, 20, 5, 15),
      valid_golden(14),
      valid_epact(20),
      valid_weekday(5),
      month_name(4, april),
      legal_easter_date(4, 16)]).
step(valid_golden(14), rule(11), ['N' = 14], [between(0, 18, 14)]).
step(between(0, 18, 14), builtin, [], []).
step(valid_epact(20), rule(12), ['N' = 20], [between(0, 29, 20)]).
step(between(0, 29, 20), builtin, [], []).
step(legal_easter_date(4, 16), rule(15), ['D' = 16], [between(1, 25, 16)]).
step(between(1, 25, 16), builtin, [], []).
step(legalGregorianWindow(y2029, true), rule(22), ['Case' = y2029], [checks_pass(y2029)]).
step(checks_pass(y2029),
     rule(19),
     ['Case' = y2029, 'Month' = 4, 'Day' = 1, 'J' = 15, 'R' = 9, 'V' = 1],
     [computus(y2029, 2029, 4, 1, 15, 20, 6, 9, 1, 0),
      valid_golden(15),
      valid_epact(9),
      valid_weekday(1),
      month_name(4, april),
      legal_easter_date(4, 1)]).
step(valid_golden(15), rule(11), ['N' = 15], [between(0, 18, 15)]).
step(between(0, 18, 15), builtin, [], []).
step(valid_epact(9), rule(12), ['N' = 9], [between(0, 29, 9)]).
step(between(0, 29, 9), builtin, [], []).
step(valid_weekday(1), rule(13), ['N' = 1], [between(0, 6, 1)]).
step(between(0, 6, 1), builtin, [], []).
step(legal_easter_date(4, 1), rule(15), ['D' = 1], [between(1, 25, 1)]).
step(between(1, 25, 1), builtin, [], []).
step(legalGregorianWindow(y2030, true), rule(22), ['Case' = y2030], [checks_pass(y2030)]).
step(checks_pass(y2030),
     rule(19),
     ['Case' = y2030, 'Month' = 4, 'Day' = 21, 'J' = 16, 'R' = 28, 'V' = 2],
     [computus(y2030, 2030, 4, 21, 16, 20, 6, 28, 2, 20),
      valid_golden(16),
      valid_epact(28),
      valid_weekday(2),
      month_name(4, april),
      legal_easter_date(4, 21)]).
step(valid_golden(16), rule(11), ['N' = 16], [between(0, 18, 16)]).
step(between(0, 18, 16), builtin, [], []).
step(valid_epact(28), rule(12), ['N' = 28], [between(0, 29, 28)]).
step(between(0, 29, 28), builtin, [], []).
step(legal_easter_date(4, 21), rule(15), ['D' = 21], [between(1, 25, 21)]).
step(between(1, 25, 21), builtin, [], []).
step(legalGregorianWindow(y2031, true), rule(22), ['Case' = y2031], [checks_pass(y2031)]).
step(checks_pass(y2031),
     rule(19),
     ['Case' = y2031, 'Month' = 4, 'Day' = 13, 'J' = 17, 'R' = 17, 'V' = 5],
     [computus(y2031, 2031, 4, 13, 17, 20, 6, 17, 5, 12),
      valid_golden(17),
      valid_epact(17),
      valid_weekday(5),
      month_name(4, april),
      legal_easter_date(4, 13)]).
step(valid_golden(17), rule(11), ['N' = 17], [between(0, 18, 17)]).
step(between(0, 18, 17), builtin, [], []).
step(valid_epact(17), rule(12), ['N' = 17], [between(0, 29, 17)]).
step(between(0, 29, 17), builtin, [], []).
step(legal_easter_date(4, 13), rule(15), ['D' = 13], [between(1, 25, 13)]).
step(between(1, 25, 13), builtin, [], []).
step(legalGregorianWindow(y2032, true), rule(22), ['Case' = y2032], [checks_pass(y2032)]).
step(checks_pass(y2032),
     rule(19),
     ['Case' = y2032, 'Month' = 3, 'Day' = 28, 'J' = 18, 'R' = 6, 'V' = 0],
     [computus(y2032, 2032, 3, 28, 18, 20, 6, 6, 0, 27),
      valid_golden(18),
      valid_epact(6),
      valid_weekday(0),
      month_name(3, march),
      legal_easter_date(3, 28)]).
step(valid_golden(18), rule(11), ['N' = 18], [between(0, 18, 18)]).
step(between(0, 18, 18), builtin, [], []).
step(valid_epact(6), rule(12), ['N' = 6], [between(0, 29, 6)]).
step(between(0, 29, 6), builtin, [], []).
step(valid_weekday(0), rule(13), ['N' = 0], [between(0, 6, 0)]).
step(between(0, 6, 0), builtin, [], []).
step(legalGregorianWindow(y2033, true), rule(22), ['Case' = y2033], [checks_pass(y2033)]).
step(checks_pass(y2033),
     rule(19),
     ['Case' = y2033, 'Month' = 4, 'Day' = 17, 'J' = 0, 'R' = 24, 'V' = 2],
     [computus(y2033, 2033, 4, 17, 0, 20, 6, 24, 2, 16),
      valid_golden(0),
      valid_epact(24),
      valid_weekday(2),
      month_name(4, april),
      legal_easter_date(4, 17)]).
step(valid_golden(0), rule(11), ['N' = 0], [between(0, 18, 0)]).
step(between(0, 18, 0), builtin, [], []).
step(valid_epact(24), rule(12), ['N' = 24], [between(0, 29, 24)]).
step(between(0, 29, 24), builtin, [], []).
step(legal_easter_date(4, 17), rule(15), ['D' = 17], [between(1, 25, 17)]).
step(between(1, 25, 17), builtin, [], []).
step(legalGregorianWindow(y2034, true), rule(22), ['Case' = y2034], [checks_pass(y2034)]).
step(checks_pass(y2034),
     rule(19),
     ['Case' = y2034, 'Month' = 4, 'Day' = 9, 'J' = 1, 'R' = 13, 'V' = 5],
     [computus(y2034, 2034, 4, 9, 1, 20, 6, 13, 5, 8),
      valid_golden(1),
      valid_epact(13),
      valid_weekday(5),
      month_name(4, april),
      legal_easter_date(4, 9)]).
step(valid_golden(1), rule(11), ['N' = 1], [between(0, 18, 1)]).
step(between(0, 18, 1), builtin, [], []).
step(valid_epact(13), rule(12), ['N' = 13], [between(0, 29, 13)]).
step(between(0, 29, 13), builtin, [], []).
step(legal_easter_date(4, 9), rule(15), ['D' = 9], [between(1, 25, 9)]).
step(between(1, 25, 9), builtin, [], []).
step(legalGregorianWindow(y2035, true), rule(22), ['Case' = y2035], [checks_pass(y2035)]).
step(checks_pass(y2035),
     rule(19),
     ['Case' = y2035, 'Month' = 3, 'Day' = 25, 'J' = 2, 'R' = 2, 'V' = 1],
     [computus(y2035, 2035, 3, 25, 2, 20, 6, 2, 1, 24),
      valid_golden(2),
      valid_epact(2),
      valid_weekday(1),
      month_name(3, march),
      legal_easter_date(3, 25)]).
step(valid_golden(2), rule(11), ['N' = 2], [between(0, 18, 2)]).
step(between(0, 18, 2), builtin, [], []).
step(valid_epact(2), rule(12), ['N' = 2], [between(0, 29, 2)]).
step(between(0, 29, 2), builtin, [], []).
step(legal_easter_date(3, 25), rule(14), ['D' = 25], [between(22, 31, 25)]).
step(between(22, 31, 25), builtin, [], []).
