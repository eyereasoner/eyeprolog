modular_answer(pow_7_560_mod_561, 1).
modular_answer(pow_2_1000_mod_1009, 942).
modular_answer(fermat_2_101, true).
modular_answer(fermat_3_101, true).

clause(2,
       pow_mod(anonymous(1), 0, var('Mod'), var('Result')),
       var('Result') is 1 mod var('Mod')).
clause(3,
       pow_mod(var('Base'), var('Exp'), var('Modulus'), var('Result')),
       (var('Exp') > 0,
        0 is var('Exp') mod 2,
        var('Half') is var('Exp') // 2,
        pow_mod(var('Base'), var('Half'), var('Modulus'), var('Halfpower')),
        var('Square') is var('Halfpower') * var('Halfpower'),
        var('Result') is var('Square') mod var('Modulus'))).
clause(4,
       pow_mod(var('Base'), var('Exp'), var('Modulus'), var('Result')),
       (var('Exp') > 0,
        1 is var('Exp') mod 2,
        var('Evenexp') is var('Exp') - 1,
        pow_mod(var('Base'), var('Evenexp'), var('Modulus'), var('Evenpower')),
        var('Product') is var('Base') * var('Evenpower'),
        var('Result') is var('Product') mod var('Modulus'))).
clause(5,
       fermat_witness(var('Base'), var('Primecandidate')),
       (var('Exponent') is var('Primecandidate') - 1,
        pow_mod(var('Base'), var('Exponent'), var('Primecandidate'), 1))).
clause(6, modular_answer(pow_7_560_mod_561, var('R')), pow_mod(7, 560, 561, var('R'))).
clause(7, modular_answer(pow_2_1000_mod_1009, var('R')), pow_mod(2, 1000, 1009, var('R'))).
clause(8, modular_answer(fermat_2_101, true), fermat_witness(2, 101)).
clause(9, modular_answer(fermat_3_101, true), fermat_witness(3, 101)).

step(modular_answer(pow_7_560_mod_561, 1), rule(6), ['R' = 1], [pow_mod(7, 560, 561, 1)]).
step(pow_mod(7, 560, 561, 1),
     rule(3),
     ['Base' = 7,
      'Exp' = 560,
      'Modulus' = 561,
      'Result' = 1,
      'Half' = 280,
      'Halfpower' = 67,
      'Square' = 4489],
     [560 > 0,
      0 is 560 mod 2,
      280 is 560 // 2,
      pow_mod(7, 280, 561, 67),
      4489 is 67 * 67,
      1 is 4489 mod 561]).
step(560 > 0, builtin, [], []).
step(0 is 560 mod 2, builtin, [], []).
step(280 is 560 // 2, builtin, [], []).
step(pow_mod(7, 280, 561, 67),
     rule(3),
     ['Base' = 7,
      'Exp' = 280,
      'Modulus' = 561,
      'Result' = 67,
      'Half' = 140,
      'Halfpower' = 166,
      'Square' = 27556],
     [280 > 0,
      0 is 280 mod 2,
      140 is 280 // 2,
      pow_mod(7, 140, 561, 166),
      27556 is 166 * 166,
      67 is 27556 mod 561]).
step(280 > 0, builtin, [], []).
step(0 is 280 mod 2, builtin, [], []).
step(140 is 280 // 2, builtin, [], []).
step(pow_mod(7, 140, 561, 166),
     rule(3),
     ['Base' = 7,
      'Exp' = 140,
      'Modulus' = 561,
      'Result' = 166,
      'Half' = 70,
      'Halfpower' = 298,
      'Square' = 88804],
     [140 > 0,
      0 is 140 mod 2,
      70 is 140 // 2,
      pow_mod(7, 70, 561, 298),
      88804 is 298 * 298,
      166 is 88804 mod 561]).
step(140 > 0, builtin, [], []).
step(0 is 140 mod 2, builtin, [], []).
step(70 is 140 // 2, builtin, [], []).
step(pow_mod(7, 70, 561, 298),
     rule(3),
     ['Base' = 7,
      'Exp' = 70,
      'Modulus' = 561,
      'Result' = 298,
      'Half' = 35,
      'Halfpower' = 241,
      'Square' = 58081],
     [70 > 0,
      0 is 70 mod 2,
      35 is 70 // 2,
      pow_mod(7, 35, 561, 241),
      58081 is 241 * 241,
      298 is 58081 mod 561]).
step(70 > 0, builtin, [], []).
step(0 is 70 mod 2, builtin, [], []).
step(35 is 70 // 2, builtin, [], []).
step(pow_mod(7, 35, 561, 241),
     rule(4),
     ['Base' = 7,
      'Exp' = 35,
      'Modulus' = 561,
      'Result' = 241,
      'Evenexp' = 34,
      'Evenpower' = 355,
      'Product' = 2485],
     [35 > 0,
      1 is 35 mod 2,
      34 is 35 - 1,
      pow_mod(7, 34, 561, 355),
      2485 is 7 * 355,
      241 is 2485 mod 561]).
step(35 > 0, builtin, [], []).
step(1 is 35 mod 2, builtin, [], []).
step(34 is 35 - 1, builtin, [], []).
step(pow_mod(7, 34, 561, 355),
     rule(3),
     ['Base' = 7,
      'Exp' = 34,
      'Modulus' = 561,
      'Result' = 355,
      'Half' = 17,
      'Halfpower' = 160,
      'Square' = 25600],
     [34 > 0,
      0 is 34 mod 2,
      17 is 34 // 2,
      pow_mod(7, 17, 561, 160),
      25600 is 160 * 160,
      355 is 25600 mod 561]).
step(34 > 0, builtin, [], []).
step(0 is 34 mod 2, builtin, [], []).
step(17 is 34 // 2, builtin, [], []).
step(pow_mod(7, 17, 561, 160),
     rule(4),
     ['Base' = 7,
      'Exp' = 17,
      'Modulus' = 561,
      'Result' = 160,
      'Evenexp' = 16,
      'Evenpower' = 103,
      'Product' = 721],
     [17 > 0,
      1 is 17 mod 2,
      16 is 17 - 1,
      pow_mod(7, 16, 561, 103),
      721 is 7 * 103,
      160 is 721 mod 561]).
step(17 > 0, builtin, [], []).
step(1 is 17 mod 2, builtin, [], []).
step(16 is 17 - 1, builtin, [], []).
step(pow_mod(7, 16, 561, 103),
     rule(3),
     ['Base' = 7,
      'Exp' = 16,
      'Modulus' = 561,
      'Result' = 103,
      'Half' = 8,
      'Halfpower' = 526,
      'Square' = 276676],
     [16 > 0,
      0 is 16 mod 2,
      8 is 16 // 2,
      pow_mod(7, 8, 561, 526),
      276676 is 526 * 526,
      103 is 276676 mod 561]).
step(16 > 0, builtin, [], []).
step(0 is 16 mod 2, builtin, [], []).
step(8 is 16 // 2, builtin, [], []).
step(pow_mod(7, 8, 561, 526),
     rule(3),
     ['Base' = 7,
      'Exp' = 8,
      'Modulus' = 561,
      'Result' = 526,
      'Half' = 4,
      'Halfpower' = 157,
      'Square' = 24649],
     [8 > 0,
      0 is 8 mod 2,
      4 is 8 // 2,
      pow_mod(7, 4, 561, 157),
      24649 is 157 * 157,
      526 is 24649 mod 561]).
step(8 > 0, builtin, [], []).
step(0 is 8 mod 2, builtin, [], []).
step(4 is 8 // 2, builtin, [], []).
step(pow_mod(7, 4, 561, 157),
     rule(3),
     ['Base' = 7,
      'Exp' = 4,
      'Modulus' = 561,
      'Result' = 157,
      'Half' = 2,
      'Halfpower' = 49,
      'Square' = 2401],
     [4 > 0,
      0 is 4 mod 2,
      2 is 4 // 2,
      pow_mod(7, 2, 561, 49),
      2401 is 49 * 49,
      157 is 2401 mod 561]).
step(4 > 0, builtin, [], []).
step(0 is 4 mod 2, builtin, [], []).
step(2 is 4 // 2, builtin, [], []).
step(pow_mod(7, 2, 561, 49),
     rule(3),
     ['Base' = 7,
      'Exp' = 2,
      'Modulus' = 561,
      'Result' = 49,
      'Half' = 1,
      'Halfpower' = 7,
      'Square' = 49],
     [2 > 0, 0 is 2 mod 2, 1 is 2 // 2, pow_mod(7, 1, 561, 7), 49 is 7 * 7, 49 is 49 mod 561]).
step(2 > 0, builtin, [], []).
step(0 is 2 mod 2, builtin, [], []).
step(1 is 2 // 2, builtin, [], []).
step(pow_mod(7, 1, 561, 7),
     rule(4),
     ['Base' = 7,
      'Exp' = 1,
      'Modulus' = 561,
      'Result' = 7,
      'Evenexp' = 0,
      'Evenpower' = 1,
      'Product' = 7],
     [1 > 0, 1 is 1 mod 2, 0 is 1 - 1, pow_mod(7, 0, 561, 1), 7 is 7 * 1, 7 is 7 mod 561]).
step(1 > 0, builtin, [], []).
step(1 is 1 mod 2, builtin, [], []).
step(0 is 1 - 1, builtin, [], []).
step(pow_mod(7, 0, 561, 1), rule(2), ['Mod' = 561, 'Result' = 1], [1 is 1 mod 561]).
step(1 is 1 mod 561, builtin, [], []).
step(7 is 7 * 1, builtin, [], []).
step(7 is 7 mod 561, builtin, [], []).
step(49 is 7 * 7, builtin, [], []).
step(49 is 49 mod 561, builtin, [], []).
step(2401 is 49 * 49, builtin, [], []).
step(157 is 2401 mod 561, builtin, [], []).
step(24649 is 157 * 157, builtin, [], []).
step(526 is 24649 mod 561, builtin, [], []).
step(276676 is 526 * 526, builtin, [], []).
step(103 is 276676 mod 561, builtin, [], []).
step(721 is 7 * 103, builtin, [], []).
step(160 is 721 mod 561, builtin, [], []).
step(25600 is 160 * 160, builtin, [], []).
step(355 is 25600 mod 561, builtin, [], []).
step(2485 is 7 * 355, builtin, [], []).
step(241 is 2485 mod 561, builtin, [], []).
step(58081 is 241 * 241, builtin, [], []).
step(298 is 58081 mod 561, builtin, [], []).
step(88804 is 298 * 298, builtin, [], []).
step(166 is 88804 mod 561, builtin, [], []).
step(27556 is 166 * 166, builtin, [], []).
step(67 is 27556 mod 561, builtin, [], []).
step(4489 is 67 * 67, builtin, [], []).
step(1 is 4489 mod 561, builtin, [], []).
step(modular_answer(pow_2_1000_mod_1009, 942),
     rule(7),
     ['R' = 942],
     [pow_mod(2, 1000, 1009, 942)]).
step(pow_mod(2, 1000, 1009, 942),
     rule(3),
     ['Base' = 2,
      'Exp' = 1000,
      'Modulus' = 1009,
      'Result' = 942,
      'Half' = 500,
      'Halfpower' = 946,
      'Square' = 894916],
     [1000 > 0,
      0 is 1000 mod 2,
      500 is 1000 // 2,
      pow_mod(2, 500, 1009, 946),
      894916 is 946 * 946,
      942 is 894916 mod 1009]).
step(1000 > 0, builtin, [], []).
step(0 is 1000 mod 2, builtin, [], []).
step(500 is 1000 // 2, builtin, [], []).
step(pow_mod(2, 500, 1009, 946),
     rule(3),
     ['Base' = 2,
      'Exp' = 500,
      'Modulus' = 1009,
      'Result' = 946,
      'Half' = 250,
      'Halfpower' = 252,
      'Square' = 63504],
     [500 > 0,
      0 is 500 mod 2,
      250 is 500 // 2,
      pow_mod(2, 250, 1009, 252),
      63504 is 252 * 252,
      946 is 63504 mod 1009]).
step(500 > 0, builtin, [], []).
step(0 is 500 mod 2, builtin, [], []).
step(250 is 500 // 2, builtin, [], []).
step(pow_mod(2, 250, 1009, 252),
     rule(3),
     ['Base' = 2,
      'Exp' = 250,
      'Modulus' = 1009,
      'Result' = 252,
      'Half' = 125,
      'Halfpower' = 270,
      'Square' = 72900],
     [250 > 0,
      0 is 250 mod 2,
      125 is 250 // 2,
      pow_mod(2, 125, 1009, 270),
      72900 is 270 * 270,
      252 is 72900 mod 1009]).
step(250 > 0, builtin, [], []).
step(0 is 250 mod 2, builtin, [], []).
step(125 is 250 // 2, builtin, [], []).
step(pow_mod(2, 125, 1009, 270),
     rule(4),
     ['Base' = 2,
      'Exp' = 125,
      'Modulus' = 1009,
      'Result' = 270,
      'Evenexp' = 124,
      'Evenpower' = 135,
      'Product' = 270],
     [125 > 0,
      1 is 125 mod 2,
      124 is 125 - 1,
      pow_mod(2, 124, 1009, 135),
      270 is 2 * 135,
      270 is 270 mod 1009]).
step(125 > 0, builtin, [], []).
step(1 is 125 mod 2, builtin, [], []).
step(124 is 125 - 1, builtin, [], []).
step(pow_mod(2, 124, 1009, 135),
     rule(3),
     ['Base' = 2,
      'Exp' = 124,
      'Modulus' = 1009,
      'Result' = 135,
      'Half' = 62,
      'Halfpower' = 96,
      'Square' = 9216],
     [124 > 0,
      0 is 124 mod 2,
      62 is 124 // 2,
      pow_mod(2, 62, 1009, 96),
      9216 is 96 * 96,
      135 is 9216 mod 1009]).
step(124 > 0, builtin, [], []).
step(0 is 124 mod 2, builtin, [], []).
step(62 is 124 // 2, builtin, [], []).
step(pow_mod(2, 62, 1009, 96),
     rule(3),
     ['Base' = 2,
      'Exp' = 62,
      'Modulus' = 1009,
      'Result' = 96,
      'Half' = 31,
      'Halfpower' = 696,
      'Square' = 484416],
     [62 > 0,
      0 is 62 mod 2,
      31 is 62 // 2,
      pow_mod(2, 31, 1009, 696),
      484416 is 696 * 696,
      96 is 484416 mod 1009]).
step(62 > 0, builtin, [], []).
step(0 is 62 mod 2, builtin, [], []).
step(31 is 62 // 2, builtin, [], []).
step(pow_mod(2, 31, 1009, 696),
     rule(4),
     ['Base' = 2,
      'Exp' = 31,
      'Modulus' = 1009,
      'Result' = 696,
      'Evenexp' = 30,
      'Evenpower' = 348,
      'Product' = 696],
     [31 > 0,
      1 is 31 mod 2,
      30 is 31 - 1,
      pow_mod(2, 30, 1009, 348),
      696 is 2 * 348,
      696 is 696 mod 1009]).
step(31 > 0, builtin, [], []).
step(1 is 31 mod 2, builtin, [], []).
step(30 is 31 - 1, builtin, [], []).
step(pow_mod(2, 30, 1009, 348),
     rule(3),
     ['Base' = 2,
      'Exp' = 30,
      'Modulus' = 1009,
      'Result' = 348,
      'Half' = 15,
      'Halfpower' = 480,
      'Square' = 230400],
     [30 > 0,
      0 is 30 mod 2,
      15 is 30 // 2,
      pow_mod(2, 15, 1009, 480),
      230400 is 480 * 480,
      348 is 230400 mod 1009]).
step(30 > 0, builtin, [], []).
step(0 is 30 mod 2, builtin, [], []).
step(15 is 30 // 2, builtin, [], []).
step(pow_mod(2, 15, 1009, 480),
     rule(4),
     ['Base' = 2,
      'Exp' = 15,
      'Modulus' = 1009,
      'Result' = 480,
      'Evenexp' = 14,
      'Evenpower' = 240,
      'Product' = 480],
     [15 > 0,
      1 is 15 mod 2,
      14 is 15 - 1,
      pow_mod(2, 14, 1009, 240),
      480 is 2 * 240,
      480 is 480 mod 1009]).
step(15 > 0, builtin, [], []).
step(1 is 15 mod 2, builtin, [], []).
step(14 is 15 - 1, builtin, [], []).
step(pow_mod(2, 14, 1009, 240),
     rule(3),
     ['Base' = 2,
      'Exp' = 14,
      'Modulus' = 1009,
      'Result' = 240,
      'Half' = 7,
      'Halfpower' = 128,
      'Square' = 16384],
     [14 > 0,
      0 is 14 mod 2,
      7 is 14 // 2,
      pow_mod(2, 7, 1009, 128),
      16384 is 128 * 128,
      240 is 16384 mod 1009]).
step(14 > 0, builtin, [], []).
step(0 is 14 mod 2, builtin, [], []).
step(7 is 14 // 2, builtin, [], []).
step(pow_mod(2, 7, 1009, 128),
     rule(4),
     ['Base' = 2,
      'Exp' = 7,
      'Modulus' = 1009,
      'Result' = 128,
      'Evenexp' = 6,
      'Evenpower' = 64,
      'Product' = 128],
     [7 > 0,
      1 is 7 mod 2,
      6 is 7 - 1,
      pow_mod(2, 6, 1009, 64),
      128 is 2 * 64,
      128 is 128 mod 1009]).
step(7 > 0, builtin, [], []).
step(1 is 7 mod 2, builtin, [], []).
step(6 is 7 - 1, builtin, [], []).
step(pow_mod(2, 6, 1009, 64),
     rule(3),
     ['Base' = 2,
      'Exp' = 6,
      'Modulus' = 1009,
      'Result' = 64,
      'Half' = 3,
      'Halfpower' = 8,
      'Square' = 64],
     [6 > 0, 0 is 6 mod 2, 3 is 6 // 2, pow_mod(2, 3, 1009, 8), 64 is 8 * 8, 64 is 64 mod 1009]).
step(6 > 0, builtin, [], []).
step(0 is 6 mod 2, builtin, [], []).
step(3 is 6 // 2, builtin, [], []).
step(pow_mod(2, 3, 1009, 8),
     rule(4),
     ['Base' = 2,
      'Exp' = 3,
      'Modulus' = 1009,
      'Result' = 8,
      'Evenexp' = 2,
      'Evenpower' = 4,
      'Product' = 8],
     [3 > 0, 1 is 3 mod 2, 2 is 3 - 1, pow_mod(2, 2, 1009, 4), 8 is 2 * 4, 8 is 8 mod 1009]).
step(3 > 0, builtin, [], []).
step(1 is 3 mod 2, builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(pow_mod(2, 2, 1009, 4),
     rule(3),
     ['Base' = 2,
      'Exp' = 2,
      'Modulus' = 1009,
      'Result' = 4,
      'Half' = 1,
      'Halfpower' = 2,
      'Square' = 4],
     [2 > 0, 0 is 2 mod 2, 1 is 2 // 2, pow_mod(2, 1, 1009, 2), 4 is 2 * 2, 4 is 4 mod 1009]).
step(pow_mod(2, 1, 1009, 2),
     rule(4),
     ['Base' = 2,
      'Exp' = 1,
      'Modulus' = 1009,
      'Result' = 2,
      'Evenexp' = 0,
      'Evenpower' = 1,
      'Product' = 2],
     [1 > 0, 1 is 1 mod 2, 0 is 1 - 1, pow_mod(2, 0, 1009, 1), 2 is 2 * 1, 2 is 2 mod 1009]).
step(pow_mod(2, 0, 1009, 1), rule(2), ['Mod' = 1009, 'Result' = 1], [1 is 1 mod 1009]).
step(1 is 1 mod 1009, builtin, [], []).
step(2 is 2 * 1, builtin, [], []).
step(2 is 2 mod 1009, builtin, [], []).
step(4 is 2 * 2, builtin, [], []).
step(4 is 4 mod 1009, builtin, [], []).
step(8 is 2 * 4, builtin, [], []).
step(8 is 8 mod 1009, builtin, [], []).
step(64 is 8 * 8, builtin, [], []).
step(64 is 64 mod 1009, builtin, [], []).
step(128 is 2 * 64, builtin, [], []).
step(128 is 128 mod 1009, builtin, [], []).
step(16384 is 128 * 128, builtin, [], []).
step(240 is 16384 mod 1009, builtin, [], []).
step(480 is 2 * 240, builtin, [], []).
step(480 is 480 mod 1009, builtin, [], []).
step(230400 is 480 * 480, builtin, [], []).
step(348 is 230400 mod 1009, builtin, [], []).
step(696 is 2 * 348, builtin, [], []).
step(696 is 696 mod 1009, builtin, [], []).
step(484416 is 696 * 696, builtin, [], []).
step(96 is 484416 mod 1009, builtin, [], []).
step(9216 is 96 * 96, builtin, [], []).
step(135 is 9216 mod 1009, builtin, [], []).
step(270 is 2 * 135, builtin, [], []).
step(270 is 270 mod 1009, builtin, [], []).
step(72900 is 270 * 270, builtin, [], []).
step(252 is 72900 mod 1009, builtin, [], []).
step(63504 is 252 * 252, builtin, [], []).
step(946 is 63504 mod 1009, builtin, [], []).
step(894916 is 946 * 946, builtin, [], []).
step(942 is 894916 mod 1009, builtin, [], []).
step(modular_answer(fermat_2_101, true), rule(8), [], [fermat_witness(2, 101)]).
step(fermat_witness(2, 101),
     rule(5),
     ['Base' = 2, 'Primecandidate' = 101, 'Exponent' = 100],
     [100 is 101 - 1, pow_mod(2, 100, 101, 1)]).
step(100 is 101 - 1, builtin, [], []).
step(pow_mod(2, 100, 101, 1),
     rule(3),
     ['Base' = 2,
      'Exp' = 100,
      'Modulus' = 101,
      'Result' = 1,
      'Half' = 50,
      'Halfpower' = 100,
      'Square' = 10000],
     [100 > 0,
      0 is 100 mod 2,
      50 is 100 // 2,
      pow_mod(2, 50, 101, 100),
      10000 is 100 * 100,
      1 is 10000 mod 101]).
step(100 > 0, builtin, [], []).
step(0 is 100 mod 2, builtin, [], []).
step(50 is 100 // 2, builtin, [], []).
step(pow_mod(2, 50, 101, 100),
     rule(3),
     ['Base' = 2,
      'Exp' = 50,
      'Modulus' = 101,
      'Result' = 100,
      'Half' = 25,
      'Halfpower' = 10,
      'Square' = 100],
     [50 > 0,
      0 is 50 mod 2,
      25 is 50 // 2,
      pow_mod(2, 25, 101, 10),
      100 is 10 * 10,
      100 is 100 mod 101]).
step(50 > 0, builtin, [], []).
step(0 is 50 mod 2, builtin, [], []).
step(25 is 50 // 2, builtin, [], []).
step(pow_mod(2, 25, 101, 10),
     rule(4),
     ['Base' = 2,
      'Exp' = 25,
      'Modulus' = 101,
      'Result' = 10,
      'Evenexp' = 24,
      'Evenpower' = 5,
      'Product' = 10],
     [25 > 0,
      1 is 25 mod 2,
      24 is 25 - 1,
      pow_mod(2, 24, 101, 5),
      10 is 2 * 5,
      10 is 10 mod 101]).
step(25 > 0, builtin, [], []).
step(1 is 25 mod 2, builtin, [], []).
step(24 is 25 - 1, builtin, [], []).
step(pow_mod(2, 24, 101, 5),
     rule(3),
     ['Base' = 2,
      'Exp' = 24,
      'Modulus' = 101,
      'Result' = 5,
      'Half' = 12,
      'Halfpower' = 56,
      'Square' = 3136],
     [24 > 0,
      0 is 24 mod 2,
      12 is 24 // 2,
      pow_mod(2, 12, 101, 56),
      3136 is 56 * 56,
      5 is 3136 mod 101]).
step(24 > 0, builtin, [], []).
step(0 is 24 mod 2, builtin, [], []).
step(12 is 24 // 2, builtin, [], []).
step(pow_mod(2, 12, 101, 56),
     rule(3),
     ['Base' = 2,
      'Exp' = 12,
      'Modulus' = 101,
      'Result' = 56,
      'Half' = 6,
      'Halfpower' = 64,
      'Square' = 4096],
     [12 > 0,
      0 is 12 mod 2,
      6 is 12 // 2,
      pow_mod(2, 6, 101, 64),
      4096 is 64 * 64,
      56 is 4096 mod 101]).
step(12 > 0, builtin, [], []).
step(0 is 12 mod 2, builtin, [], []).
step(6 is 12 // 2, builtin, [], []).
step(pow_mod(2, 6, 101, 64),
     rule(3),
     ['Base' = 2,
      'Exp' = 6,
      'Modulus' = 101,
      'Result' = 64,
      'Half' = 3,
      'Halfpower' = 8,
      'Square' = 64],
     [6 > 0, 0 is 6 mod 2, 3 is 6 // 2, pow_mod(2, 3, 101, 8), 64 is 8 * 8, 64 is 64 mod 101]).
step(pow_mod(2, 3, 101, 8),
     rule(4),
     ['Base' = 2,
      'Exp' = 3,
      'Modulus' = 101,
      'Result' = 8,
      'Evenexp' = 2,
      'Evenpower' = 4,
      'Product' = 8],
     [3 > 0, 1 is 3 mod 2, 2 is 3 - 1, pow_mod(2, 2, 101, 4), 8 is 2 * 4, 8 is 8 mod 101]).
step(pow_mod(2, 2, 101, 4),
     rule(3),
     ['Base' = 2,
      'Exp' = 2,
      'Modulus' = 101,
      'Result' = 4,
      'Half' = 1,
      'Halfpower' = 2,
      'Square' = 4],
     [2 > 0, 0 is 2 mod 2, 1 is 2 // 2, pow_mod(2, 1, 101, 2), 4 is 2 * 2, 4 is 4 mod 101]).
step(pow_mod(2, 1, 101, 2),
     rule(4),
     ['Base' = 2,
      'Exp' = 1,
      'Modulus' = 101,
      'Result' = 2,
      'Evenexp' = 0,
      'Evenpower' = 1,
      'Product' = 2],
     [1 > 0, 1 is 1 mod 2, 0 is 1 - 1, pow_mod(2, 0, 101, 1), 2 is 2 * 1, 2 is 2 mod 101]).
step(pow_mod(2, 0, 101, 1), rule(2), ['Mod' = 101, 'Result' = 1], [1 is 1 mod 101]).
step(1 is 1 mod 101, builtin, [], []).
step(2 is 2 mod 101, builtin, [], []).
step(4 is 4 mod 101, builtin, [], []).
step(8 is 8 mod 101, builtin, [], []).
step(64 is 64 mod 101, builtin, [], []).
step(4096 is 64 * 64, builtin, [], []).
step(56 is 4096 mod 101, builtin, [], []).
step(3136 is 56 * 56, builtin, [], []).
step(5 is 3136 mod 101, builtin, [], []).
step(10 is 2 * 5, builtin, [], []).
step(10 is 10 mod 101, builtin, [], []).
step(100 is 10 * 10, builtin, [], []).
step(100 is 100 mod 101, builtin, [], []).
step(10000 is 100 * 100, builtin, [], []).
step(1 is 10000 mod 101, builtin, [], []).
step(modular_answer(fermat_3_101, true), rule(9), [], [fermat_witness(3, 101)]).
step(fermat_witness(3, 101),
     rule(5),
     ['Base' = 3, 'Primecandidate' = 101, 'Exponent' = 100],
     [100 is 101 - 1, pow_mod(3, 100, 101, 1)]).
step(pow_mod(3, 100, 101, 1),
     rule(3),
     ['Base' = 3,
      'Exp' = 100,
      'Modulus' = 101,
      'Result' = 1,
      'Half' = 50,
      'Halfpower' = 100,
      'Square' = 10000],
     [100 > 0,
      0 is 100 mod 2,
      50 is 100 // 2,
      pow_mod(3, 50, 101, 100),
      10000 is 100 * 100,
      1 is 10000 mod 101]).
step(pow_mod(3, 50, 101, 100),
     rule(3),
     ['Base' = 3,
      'Exp' = 50,
      'Modulus' = 101,
      'Result' = 100,
      'Half' = 25,
      'Halfpower' = 10,
      'Square' = 100],
     [50 > 0,
      0 is 50 mod 2,
      25 is 50 // 2,
      pow_mod(3, 25, 101, 10),
      100 is 10 * 10,
      100 is 100 mod 101]).
step(pow_mod(3, 25, 101, 10),
     rule(4),
     ['Base' = 3,
      'Exp' = 25,
      'Modulus' = 101,
      'Result' = 10,
      'Evenexp' = 24,
      'Evenpower' = 37,
      'Product' = 111],
     [25 > 0,
      1 is 25 mod 2,
      24 is 25 - 1,
      pow_mod(3, 24, 101, 37),
      111 is 3 * 37,
      10 is 111 mod 101]).
step(pow_mod(3, 24, 101, 37),
     rule(3),
     ['Base' = 3,
      'Exp' = 24,
      'Modulus' = 101,
      'Result' = 37,
      'Half' = 12,
      'Halfpower' = 80,
      'Square' = 6400],
     [24 > 0,
      0 is 24 mod 2,
      12 is 24 // 2,
      pow_mod(3, 12, 101, 80),
      6400 is 80 * 80,
      37 is 6400 mod 101]).
step(pow_mod(3, 12, 101, 80),
     rule(3),
     ['Base' = 3,
      'Exp' = 12,
      'Modulus' = 101,
      'Result' = 80,
      'Half' = 6,
      'Halfpower' = 22,
      'Square' = 484],
     [12 > 0,
      0 is 12 mod 2,
      6 is 12 // 2,
      pow_mod(3, 6, 101, 22),
      484 is 22 * 22,
      80 is 484 mod 101]).
step(pow_mod(3, 6, 101, 22),
     rule(3),
     ['Base' = 3,
      'Exp' = 6,
      'Modulus' = 101,
      'Result' = 22,
      'Half' = 3,
      'Halfpower' = 27,
      'Square' = 729],
     [6 > 0,
      0 is 6 mod 2,
      3 is 6 // 2,
      pow_mod(3, 3, 101, 27),
      729 is 27 * 27,
      22 is 729 mod 101]).
step(pow_mod(3, 3, 101, 27),
     rule(4),
     ['Base' = 3,
      'Exp' = 3,
      'Modulus' = 101,
      'Result' = 27,
      'Evenexp' = 2,
      'Evenpower' = 9,
      'Product' = 27],
     [3 > 0, 1 is 3 mod 2, 2 is 3 - 1, pow_mod(3, 2, 101, 9), 27 is 3 * 9, 27 is 27 mod 101]).
step(pow_mod(3, 2, 101, 9),
     rule(3),
     ['Base' = 3,
      'Exp' = 2,
      'Modulus' = 101,
      'Result' = 9,
      'Half' = 1,
      'Halfpower' = 3,
      'Square' = 9],
     [2 > 0, 0 is 2 mod 2, 1 is 2 // 2, pow_mod(3, 1, 101, 3), 9 is 3 * 3, 9 is 9 mod 101]).
step(pow_mod(3, 1, 101, 3),
     rule(4),
     ['Base' = 3,
      'Exp' = 1,
      'Modulus' = 101,
      'Result' = 3,
      'Evenexp' = 0,
      'Evenpower' = 1,
      'Product' = 3],
     [1 > 0, 1 is 1 mod 2, 0 is 1 - 1, pow_mod(3, 0, 101, 1), 3 is 3 * 1, 3 is 3 mod 101]).
step(pow_mod(3, 0, 101, 1), rule(2), ['Mod' = 101, 'Result' = 1], [1 is 1 mod 101]).
step(3 is 3 * 1, builtin, [], []).
step(3 is 3 mod 101, builtin, [], []).
step(9 is 3 * 3, builtin, [], []).
step(9 is 9 mod 101, builtin, [], []).
step(27 is 3 * 9, builtin, [], []).
step(27 is 27 mod 101, builtin, [], []).
step(729 is 27 * 27, builtin, [], []).
step(22 is 729 mod 101, builtin, [], []).
step(484 is 22 * 22, builtin, [], []).
step(80 is 484 mod 101, builtin, [], []).
step(6400 is 80 * 80, builtin, [], []).
step(37 is 6400 mod 101, builtin, [], []).
step(111 is 3 * 37, builtin, [], []).
step(10 is 111 mod 101, builtin, [], []).
