pow([2, 10], 1024.0).
powSlow([2, 10], 1024.0).
powMod1e6([2, 10000], 709376).
powMod1e6([3, 10000], 200001).
tower([2, 4], 65536).
towerMod1e6([2, 5], 156736).

clause(1, fast_power(anonymous(1), 0, 1), true).
clause(2,
       fast_power(var('Base'), var('Exp'), var('Value')),
       (var('Exp') > 0,
        0 is var('Exp') mod 2,
        var('Half') is var('Exp') // 2,
        fast_power(var('Base'), var('Half'), var('Halfvalue')),
        var('Value') is var('Halfvalue') * var('Halfvalue'))).
clause(3,
       fast_power(var('Base'), var('Exp'), var('Value')),
       (var('Exp') > 0,
        1 is var('Exp') mod 2,
        var('Evenexp') is var('Exp') - 1,
        fast_power(var('Base'), var('Evenexp'), var('Evenvalue')),
        var('Value') is var('Base') * var('Evenvalue'))).
clause(4, pow_mod(anonymous(1), 0, anonymous(2), 1), true).
clause(5,
       pow_mod(var('Base'), var('Exp'), var('Mod'), var('Value')),
       (var('Exp') > 0,
        0 is var('Exp') mod 2,
        var('Half') is var('Exp') // 2,
        pow_mod(var('Base'), var('Half'), var('Mod'), var('Halfvalue')),
        var('Square') is var('Halfvalue') * var('Halfvalue'),
        var('Value') is var('Square') mod var('Mod'))).
clause(6,
       pow_mod(var('Base'), var('Exp'), var('Mod'), var('Value')),
       (var('Exp') > 0,
        1 is var('Exp') mod 2,
        var('Evenexp') is var('Exp') - 1,
        pow_mod(var('Base'), var('Evenexp'), var('Mod'), var('Evenvalue')),
        var('Product') is var('Base') * var('Evenvalue'),
        var('Value') is var('Product') mod var('Mod'))).
clause(7, tower(2, 4, 65536), true).
clause(8, tower_mod(2, 5, 1000000, 156736), true).
clause(9,
       pow([2, 10], var('Value')),
       (fast_power(2, 10, var('Power')), var('Value') is var('Power') + 0.0)).
clause(10, powSlow([2, 10], var('Value')), var('Value') is 2 ** 10).
clause(11, powMod1e6([2, 10000], var('Value')), pow_mod(2, 10000, 1000000, var('Value'))).
clause(12, powMod1e6([3, 10000], var('Value')), pow_mod(3, 10000, 1000000, var('Value'))).
clause(13, tower([2, 4], var('Value')), tower(2, 4, var('Value'))).
clause(14, towerMod1e6([2, 5], var('Value')), tower_mod(2, 5, 1000000, var('Value'))).

step(pow([2, 10], 1024.0),
     rule(9),
     ['Value' = 1024.0, 'Power' = 1024],
     [fast_power(2, 10, 1024), 1024.0 is 1024 + 0.0]).
step(fast_power(2, 10, 1024),
     rule(2),
     ['Base' = 2, 'Exp' = 10, 'Value' = 1024, 'Half' = 5, 'Halfvalue' = 32],
     [10 > 0, 0 is 10 mod 2, 5 is 10 // 2, fast_power(2, 5, 32), 1024 is 32 * 32]).
step(10 > 0, builtin, [], []).
step(0 is 10 mod 2, builtin, [], []).
step(5 is 10 // 2, builtin, [], []).
step(fast_power(2, 5, 32),
     rule(3),
     ['Base' = 2, 'Exp' = 5, 'Value' = 32, 'Evenexp' = 4, 'Evenvalue' = 16],
     [5 > 0, 1 is 5 mod 2, 4 is 5 - 1, fast_power(2, 4, 16), 32 is 2 * 16]).
step(5 > 0, builtin, [], []).
step(1 is 5 mod 2, builtin, [], []).
step(4 is 5 - 1, builtin, [], []).
step(fast_power(2, 4, 16),
     rule(2),
     ['Base' = 2, 'Exp' = 4, 'Value' = 16, 'Half' = 2, 'Halfvalue' = 4],
     [4 > 0, 0 is 4 mod 2, 2 is 4 // 2, fast_power(2, 2, 4), 16 is 4 * 4]).
step(4 > 0, builtin, [], []).
step(0 is 4 mod 2, builtin, [], []).
step(2 is 4 // 2, builtin, [], []).
step(fast_power(2, 2, 4),
     rule(2),
     ['Base' = 2, 'Exp' = 2, 'Value' = 4, 'Half' = 1, 'Halfvalue' = 2],
     [2 > 0, 0 is 2 mod 2, 1 is 2 // 2, fast_power(2, 1, 2), 4 is 2 * 2]).
step(2 > 0, builtin, [], []).
step(0 is 2 mod 2, builtin, [], []).
step(1 is 2 // 2, builtin, [], []).
step(fast_power(2, 1, 2),
     rule(3),
     ['Base' = 2, 'Exp' = 1, 'Value' = 2, 'Evenexp' = 0, 'Evenvalue' = 1],
     [1 > 0, 1 is 1 mod 2, 0 is 1 - 1, fast_power(2, 0, 1), 2 is 2 * 1]).
step(1 > 0, builtin, [], []).
step(1 is 1 mod 2, builtin, [], []).
step(0 is 1 - 1, builtin, [], []).
step(fast_power(2, 0, 1), fact(1), [], []).
step(2 is 2 * 1, builtin, [], []).
step(4 is 2 * 2, builtin, [], []).
step(16 is 4 * 4, builtin, [], []).
step(32 is 2 * 16, builtin, [], []).
step(1024 is 32 * 32, builtin, [], []).
step(1024.0 is 1024 + 0.0, builtin, [], []).
step(powSlow([2, 10], 1024.0), rule(10), ['Value' = 1024.0], [1024.0 is 2 ** 10]).
step(1024.0 is 2 ** 10, builtin, [], []).
step(powMod1e6([2, 10000], 709376),
     rule(11),
     ['Value' = 709376],
     [pow_mod(2, 10000, 1000000, 709376)]).
step(pow_mod(2, 10000, 1000000, 709376),
     rule(5),
     ['Base' = 2,
      'Exp' = 10000,
      'Mod' = 1000000,
      'Value' = 709376,
      'Half' = 5000,
      'Halfvalue' = 909376,
      'Square' = 826964709376],
     [10000 > 0,
      0 is 10000 mod 2,
      5000 is 10000 // 2,
      pow_mod(2, 5000, 1000000, 909376),
      826964709376 is 909376 * 909376,
      709376 is 826964709376 mod 1000000]).
step(10000 > 0, builtin, [], []).
step(0 is 10000 mod 2, builtin, [], []).
step(5000 is 10000 // 2, builtin, [], []).
step(pow_mod(2, 5000, 1000000, 909376),
     rule(5),
     ['Base' = 2,
      'Exp' = 5000,
      'Mod' = 1000000,
      'Value' = 909376,
      'Half' = 2500,
      'Halfvalue' = 509376,
      'Square' = 259463909376],
     [5000 > 0,
      0 is 5000 mod 2,
      2500 is 5000 // 2,
      pow_mod(2, 2500, 1000000, 509376),
      259463909376 is 509376 * 509376,
      909376 is 259463909376 mod 1000000]).
step(5000 > 0, builtin, [], []).
step(0 is 5000 mod 2, builtin, [], []).
step(2500 is 5000 // 2, builtin, [], []).
step(pow_mod(2, 2500, 1000000, 509376),
     rule(5),
     ['Base' = 2,
      'Exp' = 2500,
      'Mod' = 1000000,
      'Value' = 509376,
      'Half' = 1250,
      'Halfvalue' = 690624,
      'Square' = 476961509376],
     [2500 > 0,
      0 is 2500 mod 2,
      1250 is 2500 // 2,
      pow_mod(2, 1250, 1000000, 690624),
      476961509376 is 690624 * 690624,
      509376 is 476961509376 mod 1000000]).
step(2500 > 0, builtin, [], []).
step(0 is 2500 mod 2, builtin, [], []).
step(1250 is 2500 // 2, builtin, [], []).
step(pow_mod(2, 1250, 1000000, 690624),
     rule(5),
     ['Base' = 2,
      'Exp' = 1250,
      'Mod' = 1000000,
      'Value' = 690624,
      'Half' = 625,
      'Halfvalue' = 386432,
      'Square' = 149329690624],
     [1250 > 0,
      0 is 1250 mod 2,
      625 is 1250 // 2,
      pow_mod(2, 625, 1000000, 386432),
      149329690624 is 386432 * 386432,
      690624 is 149329690624 mod 1000000]).
step(1250 > 0, builtin, [], []).
step(0 is 1250 mod 2, builtin, [], []).
step(625 is 1250 // 2, builtin, [], []).
step(pow_mod(2, 625, 1000000, 386432),
     rule(6),
     ['Base' = 2,
      'Exp' = 625,
      'Mod' = 1000000,
      'Value' = 386432,
      'Evenexp' = 624,
      'Evenvalue' = 193216,
      'Product' = 386432],
     [625 > 0,
      1 is 625 mod 2,
      624 is 625 - 1,
      pow_mod(2, 624, 1000000, 193216),
      386432 is 2 * 193216,
      386432 is 386432 mod 1000000]).
step(625 > 0, builtin, [], []).
step(1 is 625 mod 2, builtin, [], []).
step(624 is 625 - 1, builtin, [], []).
step(pow_mod(2, 624, 1000000, 193216),
     rule(5),
     ['Base' = 2,
      'Exp' = 624,
      'Mod' = 1000000,
      'Value' = 193216,
      'Half' = 312,
      'Halfvalue' = 652096,
      'Square' = 425229193216],
     [624 > 0,
      0 is 624 mod 2,
      312 is 624 // 2,
      pow_mod(2, 312, 1000000, 652096),
      425229193216 is 652096 * 652096,
      193216 is 425229193216 mod 1000000]).
step(624 > 0, builtin, [], []).
step(0 is 624 mod 2, builtin, [], []).
step(312 is 624 // 2, builtin, [], []).
step(pow_mod(2, 312, 1000000, 652096),
     rule(5),
     ['Base' = 2,
      'Exp' = 312,
      'Mod' = 1000000,
      'Value' = 652096,
      'Half' = 156,
      'Halfvalue' = 783936,
      'Square' = 614555652096],
     [312 > 0,
      0 is 312 mod 2,
      156 is 312 // 2,
      pow_mod(2, 156, 1000000, 783936),
      614555652096 is 783936 * 783936,
      652096 is 614555652096 mod 1000000]).
step(312 > 0, builtin, [], []).
step(0 is 312 mod 2, builtin, [], []).
step(156 is 312 // 2, builtin, [], []).
step(pow_mod(2, 156, 1000000, 783936),
     rule(5),
     ['Base' = 2,
      'Exp' = 156,
      'Mod' = 1000000,
      'Value' = 783936,
      'Half' = 78,
      'Halfvalue' = 676544,
      'Square' = 457711783936],
     [156 > 0,
      0 is 156 mod 2,
      78 is 156 // 2,
      pow_mod(2, 78, 1000000, 676544),
      457711783936 is 676544 * 676544,
      783936 is 457711783936 mod 1000000]).
step(156 > 0, builtin, [], []).
step(0 is 156 mod 2, builtin, [], []).
step(78 is 156 // 2, builtin, [], []).
step(pow_mod(2, 78, 1000000, 676544),
     rule(5),
     ['Base' = 2,
      'Exp' = 78,
      'Mod' = 1000000,
      'Value' = 676544,
      'Half' = 39,
      'Halfvalue' = 813888,
      'Square' = 662413676544],
     [78 > 0,
      0 is 78 mod 2,
      39 is 78 // 2,
      pow_mod(2, 39, 1000000, 813888),
      662413676544 is 813888 * 813888,
      676544 is 662413676544 mod 1000000]).
step(78 > 0, builtin, [], []).
step(0 is 78 mod 2, builtin, [], []).
step(39 is 78 // 2, builtin, [], []).
step(pow_mod(2, 39, 1000000, 813888),
     rule(6),
     ['Base' = 2,
      'Exp' = 39,
      'Mod' = 1000000,
      'Value' = 813888,
      'Evenexp' = 38,
      'Evenvalue' = 906944,
      'Product' = 1813888],
     [39 > 0,
      1 is 39 mod 2,
      38 is 39 - 1,
      pow_mod(2, 38, 1000000, 906944),
      1813888 is 2 * 906944,
      813888 is 1813888 mod 1000000]).
step(39 > 0, builtin, [], []).
step(1 is 39 mod 2, builtin, [], []).
step(38 is 39 - 1, builtin, [], []).
step(pow_mod(2, 38, 1000000, 906944),
     rule(5),
     ['Base' = 2,
      'Exp' = 38,
      'Mod' = 1000000,
      'Value' = 906944,
      'Half' = 19,
      'Halfvalue' = 524288,
      'Square' = 274877906944],
     [38 > 0,
      0 is 38 mod 2,
      19 is 38 // 2,
      pow_mod(2, 19, 1000000, 524288),
      274877906944 is 524288 * 524288,
      906944 is 274877906944 mod 1000000]).
step(38 > 0, builtin, [], []).
step(0 is 38 mod 2, builtin, [], []).
step(19 is 38 // 2, builtin, [], []).
step(pow_mod(2, 19, 1000000, 524288),
     rule(6),
     ['Base' = 2,
      'Exp' = 19,
      'Mod' = 1000000,
      'Value' = 524288,
      'Evenexp' = 18,
      'Evenvalue' = 262144,
      'Product' = 524288],
     [19 > 0,
      1 is 19 mod 2,
      18 is 19 - 1,
      pow_mod(2, 18, 1000000, 262144),
      524288 is 2 * 262144,
      524288 is 524288 mod 1000000]).
step(19 > 0, builtin, [], []).
step(1 is 19 mod 2, builtin, [], []).
step(18 is 19 - 1, builtin, [], []).
step(pow_mod(2, 18, 1000000, 262144),
     rule(5),
     ['Base' = 2,
      'Exp' = 18,
      'Mod' = 1000000,
      'Value' = 262144,
      'Half' = 9,
      'Halfvalue' = 512,
      'Square' = 262144],
     [18 > 0,
      0 is 18 mod 2,
      9 is 18 // 2,
      pow_mod(2, 9, 1000000, 512),
      262144 is 512 * 512,
      262144 is 262144 mod 1000000]).
step(18 > 0, builtin, [], []).
step(0 is 18 mod 2, builtin, [], []).
step(9 is 18 // 2, builtin, [], []).
step(pow_mod(2, 9, 1000000, 512),
     rule(6),
     ['Base' = 2,
      'Exp' = 9,
      'Mod' = 1000000,
      'Value' = 512,
      'Evenexp' = 8,
      'Evenvalue' = 256,
      'Product' = 512],
     [9 > 0,
      1 is 9 mod 2,
      8 is 9 - 1,
      pow_mod(2, 8, 1000000, 256),
      512 is 2 * 256,
      512 is 512 mod 1000000]).
step(9 > 0, builtin, [], []).
step(1 is 9 mod 2, builtin, [], []).
step(8 is 9 - 1, builtin, [], []).
step(pow_mod(2, 8, 1000000, 256),
     rule(5),
     ['Base' = 2,
      'Exp' = 8,
      'Mod' = 1000000,
      'Value' = 256,
      'Half' = 4,
      'Halfvalue' = 16,
      'Square' = 256],
     [8 > 0,
      0 is 8 mod 2,
      4 is 8 // 2,
      pow_mod(2, 4, 1000000, 16),
      256 is 16 * 16,
      256 is 256 mod 1000000]).
step(8 > 0, builtin, [], []).
step(0 is 8 mod 2, builtin, [], []).
step(4 is 8 // 2, builtin, [], []).
step(pow_mod(2, 4, 1000000, 16),
     rule(5),
     ['Base' = 2,
      'Exp' = 4,
      'Mod' = 1000000,
      'Value' = 16,
      'Half' = 2,
      'Halfvalue' = 4,
      'Square' = 16],
     [4 > 0,
      0 is 4 mod 2,
      2 is 4 // 2,
      pow_mod(2, 2, 1000000, 4),
      16 is 4 * 4,
      16 is 16 mod 1000000]).
step(pow_mod(2, 2, 1000000, 4),
     rule(5),
     ['Base' = 2,
      'Exp' = 2,
      'Mod' = 1000000,
      'Value' = 4,
      'Half' = 1,
      'Halfvalue' = 2,
      'Square' = 4],
     [2 > 0,
      0 is 2 mod 2,
      1 is 2 // 2,
      pow_mod(2, 1, 1000000, 2),
      4 is 2 * 2,
      4 is 4 mod 1000000]).
step(pow_mod(2, 1, 1000000, 2),
     rule(6),
     ['Base' = 2,
      'Exp' = 1,
      'Mod' = 1000000,
      'Value' = 2,
      'Evenexp' = 0,
      'Evenvalue' = 1,
      'Product' = 2],
     [1 > 0,
      1 is 1 mod 2,
      0 is 1 - 1,
      pow_mod(2, 0, 1000000, 1),
      2 is 2 * 1,
      2 is 2 mod 1000000]).
step(pow_mod(2, 0, 1000000, 1), fact(4), [], []).
step(2 is 2 mod 1000000, builtin, [], []).
step(4 is 4 mod 1000000, builtin, [], []).
step(16 is 16 mod 1000000, builtin, [], []).
step(256 is 16 * 16, builtin, [], []).
step(256 is 256 mod 1000000, builtin, [], []).
step(512 is 2 * 256, builtin, [], []).
step(512 is 512 mod 1000000, builtin, [], []).
step(262144 is 512 * 512, builtin, [], []).
step(262144 is 262144 mod 1000000, builtin, [], []).
step(524288 is 2 * 262144, builtin, [], []).
step(524288 is 524288 mod 1000000, builtin, [], []).
step(274877906944 is 524288 * 524288, builtin, [], []).
step(906944 is 274877906944 mod 1000000, builtin, [], []).
step(1813888 is 2 * 906944, builtin, [], []).
step(813888 is 1813888 mod 1000000, builtin, [], []).
step(662413676544 is 813888 * 813888, builtin, [], []).
step(676544 is 662413676544 mod 1000000, builtin, [], []).
step(457711783936 is 676544 * 676544, builtin, [], []).
step(783936 is 457711783936 mod 1000000, builtin, [], []).
step(614555652096 is 783936 * 783936, builtin, [], []).
step(652096 is 614555652096 mod 1000000, builtin, [], []).
step(425229193216 is 652096 * 652096, builtin, [], []).
step(193216 is 425229193216 mod 1000000, builtin, [], []).
step(386432 is 2 * 193216, builtin, [], []).
step(386432 is 386432 mod 1000000, builtin, [], []).
step(149329690624 is 386432 * 386432, builtin, [], []).
step(690624 is 149329690624 mod 1000000, builtin, [], []).
step(476961509376 is 690624 * 690624, builtin, [], []).
step(509376 is 476961509376 mod 1000000, builtin, [], []).
step(259463909376 is 509376 * 509376, builtin, [], []).
step(909376 is 259463909376 mod 1000000, builtin, [], []).
step(826964709376 is 909376 * 909376, builtin, [], []).
step(709376 is 826964709376 mod 1000000, builtin, [], []).
step(powMod1e6([3, 10000], 200001),
     rule(12),
     ['Value' = 200001],
     [pow_mod(3, 10000, 1000000, 200001)]).
step(pow_mod(3, 10000, 1000000, 200001),
     rule(5),
     ['Base' = 3,
      'Exp' = 10000,
      'Mod' = 1000000,
      'Value' = 200001,
      'Half' = 5000,
      'Halfvalue' = 100001,
      'Square' = 10000200001],
     [10000 > 0,
      0 is 10000 mod 2,
      5000 is 10000 // 2,
      pow_mod(3, 5000, 1000000, 100001),
      10000200001 is 100001 * 100001,
      200001 is 10000200001 mod 1000000]).
step(pow_mod(3, 5000, 1000000, 100001),
     rule(5),
     ['Base' = 3,
      'Exp' = 5000,
      'Mod' = 1000000,
      'Value' = 100001,
      'Half' = 2500,
      'Halfvalue' = 50001,
      'Square' = 2500100001],
     [5000 > 0,
      0 is 5000 mod 2,
      2500 is 5000 // 2,
      pow_mod(3, 2500, 1000000, 50001),
      2500100001 is 50001 * 50001,
      100001 is 2500100001 mod 1000000]).
step(pow_mod(3, 2500, 1000000, 50001),
     rule(5),
     ['Base' = 3,
      'Exp' = 2500,
      'Mod' = 1000000,
      'Value' = 50001,
      'Half' = 1250,
      'Halfvalue' = 506249,
      'Square' = 256288050001],
     [2500 > 0,
      0 is 2500 mod 2,
      1250 is 2500 // 2,
      pow_mod(3, 1250, 1000000, 506249),
      256288050001 is 506249 * 506249,
      50001 is 256288050001 mod 1000000]).
step(pow_mod(3, 1250, 1000000, 506249),
     rule(5),
     ['Base' = 3,
      'Exp' = 1250,
      'Mod' = 1000000,
      'Value' = 506249,
      'Half' = 625,
      'Halfvalue' = 85443,
      'Square' = 7300506249],
     [1250 > 0,
      0 is 1250 mod 2,
      625 is 1250 // 2,
      pow_mod(3, 625, 1000000, 85443),
      7300506249 is 85443 * 85443,
      506249 is 7300506249 mod 1000000]).
step(pow_mod(3, 625, 1000000, 85443),
     rule(6),
     ['Base' = 3,
      'Exp' = 625,
      'Mod' = 1000000,
      'Value' = 85443,
      'Evenexp' = 624,
      'Evenvalue' = 28481,
      'Product' = 85443],
     [625 > 0,
      1 is 625 mod 2,
      624 is 625 - 1,
      pow_mod(3, 624, 1000000, 28481),
      85443 is 3 * 28481,
      85443 is 85443 mod 1000000]).
step(pow_mod(3, 624, 1000000, 28481),
     rule(5),
     ['Base' = 3,
      'Exp' = 624,
      'Mod' = 1000000,
      'Value' = 28481,
      'Half' = 312,
      'Halfvalue' = 137441,
      'Square' = 18890028481],
     [624 > 0,
      0 is 624 mod 2,
      312 is 624 // 2,
      pow_mod(3, 312, 1000000, 137441),
      18890028481 is 137441 * 137441,
      28481 is 18890028481 mod 1000000]).
step(pow_mod(3, 312, 1000000, 137441),
     rule(5),
     ['Base' = 3,
      'Exp' = 312,
      'Mod' = 1000000,
      'Value' = 137441,
      'Half' = 156,
      'Halfvalue' = 473521,
      'Square' = 224222137441],
     [312 > 0,
      0 is 312 mod 2,
      156 is 312 // 2,
      pow_mod(3, 156, 1000000, 473521),
      224222137441 is 473521 * 473521,
      137441 is 224222137441 mod 1000000]).
step(pow_mod(3, 156, 1000000, 473521),
     rule(5),
     ['Base' = 3,
      'Exp' = 156,
      'Mod' = 1000000,
      'Value' = 473521,
      'Half' = 78,
      'Halfvalue' = 255289,
      'Square' = 65172473521],
     [156 > 0,
      0 is 156 mod 2,
      78 is 156 // 2,
      pow_mod(3, 78, 1000000, 255289),
      65172473521 is 255289 * 255289,
      473521 is 65172473521 mod 1000000]).
step(pow_mod(3, 78, 1000000, 255289),
     rule(5),
     ['Base' = 3,
      'Exp' = 78,
      'Mod' = 1000000,
      'Value' = 255289,
      'Half' = 39,
      'Halfvalue' = 976267,
      'Square' = 953097255289],
     [78 > 0,
      0 is 78 mod 2,
      39 is 78 // 2,
      pow_mod(3, 39, 1000000, 976267),
      953097255289 is 976267 * 976267,
      255289 is 953097255289 mod 1000000]).
step(pow_mod(3, 39, 1000000, 976267),
     rule(6),
     ['Base' = 3,
      'Exp' = 39,
      'Mod' = 1000000,
      'Value' = 976267,
      'Evenexp' = 38,
      'Evenvalue' = 992089,
      'Product' = 2976267],
     [39 > 0,
      1 is 39 mod 2,
      38 is 39 - 1,
      pow_mod(3, 38, 1000000, 992089),
      2976267 is 3 * 992089,
      976267 is 2976267 mod 1000000]).
step(pow_mod(3, 38, 1000000, 992089),
     rule(5),
     ['Base' = 3,
      'Exp' = 38,
      'Mod' = 1000000,
      'Value' = 992089,
      'Half' = 19,
      'Halfvalue' = 261467,
      'Square' = 68364992089],
     [38 > 0,
      0 is 38 mod 2,
      19 is 38 // 2,
      pow_mod(3, 19, 1000000, 261467),
      68364992089 is 261467 * 261467,
      992089 is 68364992089 mod 1000000]).
step(pow_mod(3, 19, 1000000, 261467),
     rule(6),
     ['Base' = 3,
      'Exp' = 19,
      'Mod' = 1000000,
      'Value' = 261467,
      'Evenexp' = 18,
      'Evenvalue' = 420489,
      'Product' = 1261467],
     [19 > 0,
      1 is 19 mod 2,
      18 is 19 - 1,
      pow_mod(3, 18, 1000000, 420489),
      1261467 is 3 * 420489,
      261467 is 1261467 mod 1000000]).
step(pow_mod(3, 18, 1000000, 420489),
     rule(5),
     ['Base' = 3,
      'Exp' = 18,
      'Mod' = 1000000,
      'Value' = 420489,
      'Half' = 9,
      'Halfvalue' = 19683,
      'Square' = 387420489],
     [18 > 0,
      0 is 18 mod 2,
      9 is 18 // 2,
      pow_mod(3, 9, 1000000, 19683),
      387420489 is 19683 * 19683,
      420489 is 387420489 mod 1000000]).
step(pow_mod(3, 9, 1000000, 19683),
     rule(6),
     ['Base' = 3,
      'Exp' = 9,
      'Mod' = 1000000,
      'Value' = 19683,
      'Evenexp' = 8,
      'Evenvalue' = 6561,
      'Product' = 19683],
     [9 > 0,
      1 is 9 mod 2,
      8 is 9 - 1,
      pow_mod(3, 8, 1000000, 6561),
      19683 is 3 * 6561,
      19683 is 19683 mod 1000000]).
step(pow_mod(3, 8, 1000000, 6561),
     rule(5),
     ['Base' = 3,
      'Exp' = 8,
      'Mod' = 1000000,
      'Value' = 6561,
      'Half' = 4,
      'Halfvalue' = 81,
      'Square' = 6561],
     [8 > 0,
      0 is 8 mod 2,
      4 is 8 // 2,
      pow_mod(3, 4, 1000000, 81),
      6561 is 81 * 81,
      6561 is 6561 mod 1000000]).
step(pow_mod(3, 4, 1000000, 81),
     rule(5),
     ['Base' = 3,
      'Exp' = 4,
      'Mod' = 1000000,
      'Value' = 81,
      'Half' = 2,
      'Halfvalue' = 9,
      'Square' = 81],
     [4 > 0,
      0 is 4 mod 2,
      2 is 4 // 2,
      pow_mod(3, 2, 1000000, 9),
      81 is 9 * 9,
      81 is 81 mod 1000000]).
step(pow_mod(3, 2, 1000000, 9),
     rule(5),
     ['Base' = 3,
      'Exp' = 2,
      'Mod' = 1000000,
      'Value' = 9,
      'Half' = 1,
      'Halfvalue' = 3,
      'Square' = 9],
     [2 > 0,
      0 is 2 mod 2,
      1 is 2 // 2,
      pow_mod(3, 1, 1000000, 3),
      9 is 3 * 3,
      9 is 9 mod 1000000]).
step(pow_mod(3, 1, 1000000, 3),
     rule(6),
     ['Base' = 3,
      'Exp' = 1,
      'Mod' = 1000000,
      'Value' = 3,
      'Evenexp' = 0,
      'Evenvalue' = 1,
      'Product' = 3],
     [1 > 0,
      1 is 1 mod 2,
      0 is 1 - 1,
      pow_mod(3, 0, 1000000, 1),
      3 is 3 * 1,
      3 is 3 mod 1000000]).
step(pow_mod(3, 0, 1000000, 1), fact(4), [], []).
step(3 is 3 * 1, builtin, [], []).
step(3 is 3 mod 1000000, builtin, [], []).
step(9 is 3 * 3, builtin, [], []).
step(9 is 9 mod 1000000, builtin, [], []).
step(81 is 9 * 9, builtin, [], []).
step(81 is 81 mod 1000000, builtin, [], []).
step(6561 is 81 * 81, builtin, [], []).
step(6561 is 6561 mod 1000000, builtin, [], []).
step(19683 is 3 * 6561, builtin, [], []).
step(19683 is 19683 mod 1000000, builtin, [], []).
step(387420489 is 19683 * 19683, builtin, [], []).
step(420489 is 387420489 mod 1000000, builtin, [], []).
step(1261467 is 3 * 420489, builtin, [], []).
step(261467 is 1261467 mod 1000000, builtin, [], []).
step(68364992089 is 261467 * 261467, builtin, [], []).
step(992089 is 68364992089 mod 1000000, builtin, [], []).
step(2976267 is 3 * 992089, builtin, [], []).
step(976267 is 2976267 mod 1000000, builtin, [], []).
step(953097255289 is 976267 * 976267, builtin, [], []).
step(255289 is 953097255289 mod 1000000, builtin, [], []).
step(65172473521 is 255289 * 255289, builtin, [], []).
step(473521 is 65172473521 mod 1000000, builtin, [], []).
step(224222137441 is 473521 * 473521, builtin, [], []).
step(137441 is 224222137441 mod 1000000, builtin, [], []).
step(18890028481 is 137441 * 137441, builtin, [], []).
step(28481 is 18890028481 mod 1000000, builtin, [], []).
step(85443 is 3 * 28481, builtin, [], []).
step(85443 is 85443 mod 1000000, builtin, [], []).
step(7300506249 is 85443 * 85443, builtin, [], []).
step(506249 is 7300506249 mod 1000000, builtin, [], []).
step(256288050001 is 506249 * 506249, builtin, [], []).
step(50001 is 256288050001 mod 1000000, builtin, [], []).
step(2500100001 is 50001 * 50001, builtin, [], []).
step(100001 is 2500100001 mod 1000000, builtin, [], []).
step(10000200001 is 100001 * 100001, builtin, [], []).
step(200001 is 10000200001 mod 1000000, builtin, [], []).
step(tower([2, 4], 65536), rule(13), ['Value' = 65536], [tower(2, 4, 65536)]).
step(tower(2, 4, 65536), fact(7), [], []).
step(towerMod1e6([2, 5], 156736),
     rule(14),
     ['Value' = 156736],
     [tower_mod(2, 5, 1000000, 156736)]).
step(tower_mod(2, 5, 1000000, 156736), fact(8), [], []).
