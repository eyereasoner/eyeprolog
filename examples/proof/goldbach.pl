case(4, [2, 2]).
case(8, [3, 5]).
case(16, [3, 13]).
case(32, [3, 29]).
case(64, [3, 61]).
case(128, [19, 109]).
case(256, [5, 251]).
case(512, [3, 509]).
case(1024, [3, 1021]).
case(2048, [19, 2029]).
case(4096, [3, 4093]).
case(8192, [13, 8179]).
case(16384, [3, 16381]).
case(32768, [19, 32749]).
case(65536, [17, 65519]).
case(131072, [13, 131059]).
case(262144, [5, 262139]).
case(524288, [19, 524269]).
case(1048576, [3, 1048573]).
case(2097152, [19, 2097133]).
case(4194304, [3, 4194301]).
case(8388608, [37, 8388571]).
case(16777216, [3, 16777213]).
case(33554432, [61, 33554371]).

clause(1, goldbach(4, [2, 2]), true).
clause(2,
       goldbach(var('N'), var('L')),
       (0 =:= var('N') rem 2, var('N') > 4, goldb(var('N'), var('L'), 3))).
clause(3,
       goldb(var('N'), [var('P'), var('Q')], var('P')),
       (var('Q') is var('N') - var('P'), is_prime(var('Q')), !)).
clause(4,
       goldb(var('N'), var('L'), var('P')),
       (var('P') < var('N'),
        next_prime(var('P'), var('P1')),
        goldb(var('N'), var('L'), var('P1')))).
clause(5, next_prime(var('P'), var('P1')), (var('P1') is var('P') + 2, is_prime(var('P1')), !)).
clause(6,
       next_prime(var('P'), var('P1')),
       (var('P2') is var('P') + 2, next_prime(var('P2'), var('P1')))).
clause(9,
       is_prime(var('P')),
       (var('P') > 3, 1 =:= var('P') rem 2, smallest_divisor_from(var('P'), 3, var('P')))).
clause(12,
       case(var('N'), var('G')),
       (between(2, 25, var('I')), var('N') is 2 ^ var('I'), goldbach(var('N'), var('G')))).

step(case(4, [2, 2]),
     rule(12),
     ['N' = 4, 'G' = [2, 2], 'I' = 2],
     [between(2, 25, 2), 4 is 2 ^ 2, goldbach(4, [2, 2])]).
step(between(2, 25, 2), builtin, [], []).
step(4 is 2 ^ 2, builtin, [], []).
step(goldbach(4, [2, 2]), fact(1), [], []).
step(case(8, [3, 5]),
     rule(12),
     ['N' = 8, 'G' = [3, 5], 'I' = 3],
     [between(2, 25, 3), 8 is 2 ^ 3, goldbach(8, [3, 5])]).
step(between(2, 25, 3), builtin, [], []).
step(8 is 2 ^ 3, builtin, [], []).
step(goldbach(8, [3, 5]),
     rule(2),
     ['N' = 8, 'L' = [3, 5]],
     [0 =:= 8 rem 2, 8 > 4, goldb(8, [3, 5], 3)]).
step(0 =:= 8 rem 2, builtin, [], []).
step(8 > 4, builtin, [], []).
step(goldb(8, [3, 5], 3), rule(3), ['N' = 8, 'P' = 3, 'Q' = 5], [5 is 8 - 3, is_prime(5), !]).
step(5 is 8 - 3, builtin, [], []).
step(is_prime(5), rule(9), ['P' = 5], [5 > 3, 1 =:= 5 rem 2, smallest_divisor_from(5, 3, 5)]).
step(5 > 3, builtin, [], []).
step(1 =:= 5 rem 2, builtin, [], []).
step(smallest_divisor_from(5, 3, 5), builtin, [], []).
step(!, builtin, [], []).
step(case(16, [3, 13]),
     rule(12),
     ['N' = 16, 'G' = [3, 13], 'I' = 4],
     [between(2, 25, 4), 16 is 2 ^ 4, goldbach(16, [3, 13])]).
step(between(2, 25, 4), builtin, [], []).
step(16 is 2 ^ 4, builtin, [], []).
step(goldbach(16, [3, 13]),
     rule(2),
     ['N' = 16, 'L' = [3, 13]],
     [0 =:= 16 rem 2, 16 > 4, goldb(16, [3, 13], 3)]).
step(0 =:= 16 rem 2, builtin, [], []).
step(16 > 4, builtin, [], []).
step(goldb(16, [3, 13], 3),
     rule(3),
     ['N' = 16, 'P' = 3, 'Q' = 13],
     [13 is 16 - 3, is_prime(13), !]).
step(13 is 16 - 3, builtin, [], []).
step(is_prime(13),
     rule(9),
     ['P' = 13],
     [13 > 3, 1 =:= 13 rem 2, smallest_divisor_from(13, 3, 13)]).
step(13 > 3, builtin, [], []).
step(1 =:= 13 rem 2, builtin, [], []).
step(smallest_divisor_from(13, 3, 13), builtin, [], []).
step(case(32, [3, 29]),
     rule(12),
     ['N' = 32, 'G' = [3, 29], 'I' = 5],
     [between(2, 25, 5), 32 is 2 ^ 5, goldbach(32, [3, 29])]).
step(between(2, 25, 5), builtin, [], []).
step(32 is 2 ^ 5, builtin, [], []).
step(goldbach(32, [3, 29]),
     rule(2),
     ['N' = 32, 'L' = [3, 29]],
     [0 =:= 32 rem 2, 32 > 4, goldb(32, [3, 29], 3)]).
step(0 =:= 32 rem 2, builtin, [], []).
step(32 > 4, builtin, [], []).
step(goldb(32, [3, 29], 3),
     rule(3),
     ['N' = 32, 'P' = 3, 'Q' = 29],
     [29 is 32 - 3, is_prime(29), !]).
step(29 is 32 - 3, builtin, [], []).
step(is_prime(29),
     rule(9),
     ['P' = 29],
     [29 > 3, 1 =:= 29 rem 2, smallest_divisor_from(29, 3, 29)]).
step(29 > 3, builtin, [], []).
step(1 =:= 29 rem 2, builtin, [], []).
step(smallest_divisor_from(29, 3, 29), builtin, [], []).
step(case(64, [3, 61]),
     rule(12),
     ['N' = 64, 'G' = [3, 61], 'I' = 6],
     [between(2, 25, 6), 64 is 2 ^ 6, goldbach(64, [3, 61])]).
step(between(2, 25, 6), builtin, [], []).
step(64 is 2 ^ 6, builtin, [], []).
step(goldbach(64, [3, 61]),
     rule(2),
     ['N' = 64, 'L' = [3, 61]],
     [0 =:= 64 rem 2, 64 > 4, goldb(64, [3, 61], 3)]).
step(0 =:= 64 rem 2, builtin, [], []).
step(64 > 4, builtin, [], []).
step(goldb(64, [3, 61], 3),
     rule(3),
     ['N' = 64, 'P' = 3, 'Q' = 61],
     [61 is 64 - 3, is_prime(61), !]).
step(61 is 64 - 3, builtin, [], []).
step(is_prime(61),
     rule(9),
     ['P' = 61],
     [61 > 3, 1 =:= 61 rem 2, smallest_divisor_from(61, 3, 61)]).
step(61 > 3, builtin, [], []).
step(1 =:= 61 rem 2, builtin, [], []).
step(smallest_divisor_from(61, 3, 61), builtin, [], []).
step(case(128, [19, 109]),
     rule(12),
     ['N' = 128, 'G' = [19, 109], 'I' = 7],
     [between(2, 25, 7), 128 is 2 ^ 7, goldbach(128, [19, 109])]).
step(between(2, 25, 7), builtin, [], []).
step(128 is 2 ^ 7, builtin, [], []).
step(goldbach(128, [19, 109]),
     rule(2),
     ['N' = 128, 'L' = [19, 109]],
     [0 =:= 128 rem 2, 128 > 4, goldb(128, [19, 109], 3)]).
step(0 =:= 128 rem 2, builtin, [], []).
step(128 > 4, builtin, [], []).
step(goldb(128, [19, 109], 3),
     rule(4),
     ['N' = 128, 'L' = [19, 109], 'P' = 3, 'P1' = 5],
     [3 < 128, next_prime(3, 5), goldb(128, [19, 109], 5)]).
step(3 < 128, builtin, [], []).
step(next_prime(3, 5), rule(5), ['P' = 3, 'P1' = 5], [5 is 3 + 2, is_prime(5), !]).
step(5 is 3 + 2, builtin, [], []).
step(goldb(128, [19, 109], 5),
     rule(4),
     ['N' = 128, 'L' = [19, 109], 'P' = 5, 'P1' = 7],
     [5 < 128, next_prime(5, 7), goldb(128, [19, 109], 7)]).
step(5 < 128, builtin, [], []).
step(next_prime(5, 7), rule(5), ['P' = 5, 'P1' = 7], [7 is 5 + 2, is_prime(7), !]).
step(7 is 5 + 2, builtin, [], []).
step(is_prime(7), rule(9), ['P' = 7], [7 > 3, 1 =:= 7 rem 2, smallest_divisor_from(7, 3, 7)]).
step(7 > 3, builtin, [], []).
step(1 =:= 7 rem 2, builtin, [], []).
step(smallest_divisor_from(7, 3, 7), builtin, [], []).
step(goldb(128, [19, 109], 7),
     rule(4),
     ['N' = 128, 'L' = [19, 109], 'P' = 7, 'P1' = 11],
     [7 < 128, next_prime(7, 11), goldb(128, [19, 109], 11)]).
step(7 < 128, builtin, [], []).
step(next_prime(7, 11),
     rule(6),
     ['P' = 7, 'P1' = 11, 'P2' = 9],
     [9 is 7 + 2, next_prime(9, 11)]).
step(9 is 7 + 2, builtin, [], []).
step(next_prime(9, 11), rule(5), ['P' = 9, 'P1' = 11], [11 is 9 + 2, is_prime(11), !]).
step(11 is 9 + 2, builtin, [], []).
step(is_prime(11),
     rule(9),
     ['P' = 11],
     [11 > 3, 1 =:= 11 rem 2, smallest_divisor_from(11, 3, 11)]).
step(11 > 3, builtin, [], []).
step(1 =:= 11 rem 2, builtin, [], []).
step(smallest_divisor_from(11, 3, 11), builtin, [], []).
step(goldb(128, [19, 109], 11),
     rule(4),
     ['N' = 128, 'L' = [19, 109], 'P' = 11, 'P1' = 13],
     [11 < 128, next_prime(11, 13), goldb(128, [19, 109], 13)]).
step(11 < 128, builtin, [], []).
step(next_prime(11, 13), rule(5), ['P' = 11, 'P1' = 13], [13 is 11 + 2, is_prime(13), !]).
step(13 is 11 + 2, builtin, [], []).
step(goldb(128, [19, 109], 13),
     rule(4),
     ['N' = 128, 'L' = [19, 109], 'P' = 13, 'P1' = 17],
     [13 < 128, next_prime(13, 17), goldb(128, [19, 109], 17)]).
step(13 < 128, builtin, [], []).
step(next_prime(13, 17),
     rule(6),
     ['P' = 13, 'P1' = 17, 'P2' = 15],
     [15 is 13 + 2, next_prime(15, 17)]).
step(15 is 13 + 2, builtin, [], []).
step(next_prime(15, 17), rule(5), ['P' = 15, 'P1' = 17], [17 is 15 + 2, is_prime(17), !]).
step(17 is 15 + 2, builtin, [], []).
step(is_prime(17),
     rule(9),
     ['P' = 17],
     [17 > 3, 1 =:= 17 rem 2, smallest_divisor_from(17, 3, 17)]).
step(17 > 3, builtin, [], []).
step(1 =:= 17 rem 2, builtin, [], []).
step(smallest_divisor_from(17, 3, 17), builtin, [], []).
step(goldb(128, [19, 109], 17),
     rule(4),
     ['N' = 128, 'L' = [19, 109], 'P' = 17, 'P1' = 19],
     [17 < 128, next_prime(17, 19), goldb(128, [19, 109], 19)]).
step(17 < 128, builtin, [], []).
step(next_prime(17, 19), rule(5), ['P' = 17, 'P1' = 19], [19 is 17 + 2, is_prime(19), !]).
step(19 is 17 + 2, builtin, [], []).
step(is_prime(19),
     rule(9),
     ['P' = 19],
     [19 > 3, 1 =:= 19 rem 2, smallest_divisor_from(19, 3, 19)]).
step(19 > 3, builtin, [], []).
step(1 =:= 19 rem 2, builtin, [], []).
step(smallest_divisor_from(19, 3, 19), builtin, [], []).
step(goldb(128, [19, 109], 19),
     rule(3),
     ['N' = 128, 'P' = 19, 'Q' = 109],
     [109 is 128 - 19, is_prime(109), !]).
step(109 is 128 - 19, builtin, [], []).
step(is_prime(109),
     rule(9),
     ['P' = 109],
     [109 > 3, 1 =:= 109 rem 2, smallest_divisor_from(109, 3, 109)]).
step(109 > 3, builtin, [], []).
step(1 =:= 109 rem 2, builtin, [], []).
step(smallest_divisor_from(109, 3, 109), builtin, [], []).
step(case(256, [5, 251]),
     rule(12),
     ['N' = 256, 'G' = [5, 251], 'I' = 8],
     [between(2, 25, 8), 256 is 2 ^ 8, goldbach(256, [5, 251])]).
step(between(2, 25, 8), builtin, [], []).
step(256 is 2 ^ 8, builtin, [], []).
step(goldbach(256, [5, 251]),
     rule(2),
     ['N' = 256, 'L' = [5, 251]],
     [0 =:= 256 rem 2, 256 > 4, goldb(256, [5, 251], 3)]).
step(0 =:= 256 rem 2, builtin, [], []).
step(256 > 4, builtin, [], []).
step(goldb(256, [5, 251], 3),
     rule(4),
     ['N' = 256, 'L' = [5, 251], 'P' = 3, 'P1' = 5],
     [3 < 256, next_prime(3, 5), goldb(256, [5, 251], 5)]).
step(3 < 256, builtin, [], []).
step(goldb(256, [5, 251], 5),
     rule(3),
     ['N' = 256, 'P' = 5, 'Q' = 251],
     [251 is 256 - 5, is_prime(251), !]).
step(251 is 256 - 5, builtin, [], []).
step(is_prime(251),
     rule(9),
     ['P' = 251],
     [251 > 3, 1 =:= 251 rem 2, smallest_divisor_from(251, 3, 251)]).
step(251 > 3, builtin, [], []).
step(1 =:= 251 rem 2, builtin, [], []).
step(smallest_divisor_from(251, 3, 251), builtin, [], []).
step(case(512, [3, 509]),
     rule(12),
     ['N' = 512, 'G' = [3, 509], 'I' = 9],
     [between(2, 25, 9), 512 is 2 ^ 9, goldbach(512, [3, 509])]).
step(between(2, 25, 9), builtin, [], []).
step(512 is 2 ^ 9, builtin, [], []).
step(goldbach(512, [3, 509]),
     rule(2),
     ['N' = 512, 'L' = [3, 509]],
     [0 =:= 512 rem 2, 512 > 4, goldb(512, [3, 509], 3)]).
step(0 =:= 512 rem 2, builtin, [], []).
step(512 > 4, builtin, [], []).
step(goldb(512, [3, 509], 3),
     rule(3),
     ['N' = 512, 'P' = 3, 'Q' = 509],
     [509 is 512 - 3, is_prime(509), !]).
step(509 is 512 - 3, builtin, [], []).
step(is_prime(509),
     rule(9),
     ['P' = 509],
     [509 > 3, 1 =:= 509 rem 2, smallest_divisor_from(509, 3, 509)]).
step(509 > 3, builtin, [], []).
step(1 =:= 509 rem 2, builtin, [], []).
step(smallest_divisor_from(509, 3, 509), builtin, [], []).
step(case(1024, [3, 1021]),
     rule(12),
     ['N' = 1024, 'G' = [3, 1021], 'I' = 10],
     [between(2, 25, 10), 1024 is 2 ^ 10, goldbach(1024, [3, 1021])]).
step(between(2, 25, 10), builtin, [], []).
step(1024 is 2 ^ 10, builtin, [], []).
step(goldbach(1024, [3, 1021]),
     rule(2),
     ['N' = 1024, 'L' = [3, 1021]],
     [0 =:= 1024 rem 2, 1024 > 4, goldb(1024, [3, 1021], 3)]).
step(0 =:= 1024 rem 2, builtin, [], []).
step(1024 > 4, builtin, [], []).
step(goldb(1024, [3, 1021], 3),
     rule(3),
     ['N' = 1024, 'P' = 3, 'Q' = 1021],
     [1021 is 1024 - 3, is_prime(1021), !]).
step(1021 is 1024 - 3, builtin, [], []).
step(is_prime(1021),
     rule(9),
     ['P' = 1021],
     [1021 > 3, 1 =:= 1021 rem 2, smallest_divisor_from(1021, 3, 1021)]).
step(1021 > 3, builtin, [], []).
step(1 =:= 1021 rem 2, builtin, [], []).
step(smallest_divisor_from(1021, 3, 1021), builtin, [], []).
step(case(2048, [19, 2029]),
     rule(12),
     ['N' = 2048, 'G' = [19, 2029], 'I' = 11],
     [between(2, 25, 11), 2048 is 2 ^ 11, goldbach(2048, [19, 2029])]).
step(between(2, 25, 11), builtin, [], []).
step(2048 is 2 ^ 11, builtin, [], []).
step(goldbach(2048, [19, 2029]),
     rule(2),
     ['N' = 2048, 'L' = [19, 2029]],
     [0 =:= 2048 rem 2, 2048 > 4, goldb(2048, [19, 2029], 3)]).
step(0 =:= 2048 rem 2, builtin, [], []).
step(2048 > 4, builtin, [], []).
step(goldb(2048, [19, 2029], 3),
     rule(4),
     ['N' = 2048, 'L' = [19, 2029], 'P' = 3, 'P1' = 5],
     [3 < 2048, next_prime(3, 5), goldb(2048, [19, 2029], 5)]).
step(3 < 2048, builtin, [], []).
step(goldb(2048, [19, 2029], 5),
     rule(4),
     ['N' = 2048, 'L' = [19, 2029], 'P' = 5, 'P1' = 7],
     [5 < 2048, next_prime(5, 7), goldb(2048, [19, 2029], 7)]).
step(5 < 2048, builtin, [], []).
step(goldb(2048, [19, 2029], 7),
     rule(4),
     ['N' = 2048, 'L' = [19, 2029], 'P' = 7, 'P1' = 11],
     [7 < 2048, next_prime(7, 11), goldb(2048, [19, 2029], 11)]).
step(7 < 2048, builtin, [], []).
step(goldb(2048, [19, 2029], 11),
     rule(4),
     ['N' = 2048, 'L' = [19, 2029], 'P' = 11, 'P1' = 13],
     [11 < 2048, next_prime(11, 13), goldb(2048, [19, 2029], 13)]).
step(11 < 2048, builtin, [], []).
step(goldb(2048, [19, 2029], 13),
     rule(4),
     ['N' = 2048, 'L' = [19, 2029], 'P' = 13, 'P1' = 17],
     [13 < 2048, next_prime(13, 17), goldb(2048, [19, 2029], 17)]).
step(13 < 2048, builtin, [], []).
step(goldb(2048, [19, 2029], 17),
     rule(4),
     ['N' = 2048, 'L' = [19, 2029], 'P' = 17, 'P1' = 19],
     [17 < 2048, next_prime(17, 19), goldb(2048, [19, 2029], 19)]).
step(17 < 2048, builtin, [], []).
step(goldb(2048, [19, 2029], 19),
     rule(3),
     ['N' = 2048, 'P' = 19, 'Q' = 2029],
     [2029 is 2048 - 19, is_prime(2029), !]).
step(2029 is 2048 - 19, builtin, [], []).
step(is_prime(2029),
     rule(9),
     ['P' = 2029],
     [2029 > 3, 1 =:= 2029 rem 2, smallest_divisor_from(2029, 3, 2029)]).
step(2029 > 3, builtin, [], []).
step(1 =:= 2029 rem 2, builtin, [], []).
step(smallest_divisor_from(2029, 3, 2029), builtin, [], []).
step(case(4096, [3, 4093]),
     rule(12),
     ['N' = 4096, 'G' = [3, 4093], 'I' = 12],
     [between(2, 25, 12), 4096 is 2 ^ 12, goldbach(4096, [3, 4093])]).
step(between(2, 25, 12), builtin, [], []).
step(4096 is 2 ^ 12, builtin, [], []).
step(goldbach(4096, [3, 4093]),
     rule(2),
     ['N' = 4096, 'L' = [3, 4093]],
     [0 =:= 4096 rem 2, 4096 > 4, goldb(4096, [3, 4093], 3)]).
step(0 =:= 4096 rem 2, builtin, [], []).
step(4096 > 4, builtin, [], []).
step(goldb(4096, [3, 4093], 3),
     rule(3),
     ['N' = 4096, 'P' = 3, 'Q' = 4093],
     [4093 is 4096 - 3, is_prime(4093), !]).
step(4093 is 4096 - 3, builtin, [], []).
step(is_prime(4093),
     rule(9),
     ['P' = 4093],
     [4093 > 3, 1 =:= 4093 rem 2, smallest_divisor_from(4093, 3, 4093)]).
step(4093 > 3, builtin, [], []).
step(1 =:= 4093 rem 2, builtin, [], []).
step(smallest_divisor_from(4093, 3, 4093), builtin, [], []).
step(case(8192, [13, 8179]),
     rule(12),
     ['N' = 8192, 'G' = [13, 8179], 'I' = 13],
     [between(2, 25, 13), 8192 is 2 ^ 13, goldbach(8192, [13, 8179])]).
step(between(2, 25, 13), builtin, [], []).
step(8192 is 2 ^ 13, builtin, [], []).
step(goldbach(8192, [13, 8179]),
     rule(2),
     ['N' = 8192, 'L' = [13, 8179]],
     [0 =:= 8192 rem 2, 8192 > 4, goldb(8192, [13, 8179], 3)]).
step(0 =:= 8192 rem 2, builtin, [], []).
step(8192 > 4, builtin, [], []).
step(goldb(8192, [13, 8179], 3),
     rule(4),
     ['N' = 8192, 'L' = [13, 8179], 'P' = 3, 'P1' = 5],
     [3 < 8192, next_prime(3, 5), goldb(8192, [13, 8179], 5)]).
step(3 < 8192, builtin, [], []).
step(goldb(8192, [13, 8179], 5),
     rule(4),
     ['N' = 8192, 'L' = [13, 8179], 'P' = 5, 'P1' = 7],
     [5 < 8192, next_prime(5, 7), goldb(8192, [13, 8179], 7)]).
step(5 < 8192, builtin, [], []).
step(goldb(8192, [13, 8179], 7),
     rule(4),
     ['N' = 8192, 'L' = [13, 8179], 'P' = 7, 'P1' = 11],
     [7 < 8192, next_prime(7, 11), goldb(8192, [13, 8179], 11)]).
step(7 < 8192, builtin, [], []).
step(goldb(8192, [13, 8179], 11),
     rule(4),
     ['N' = 8192, 'L' = [13, 8179], 'P' = 11, 'P1' = 13],
     [11 < 8192, next_prime(11, 13), goldb(8192, [13, 8179], 13)]).
step(11 < 8192, builtin, [], []).
step(goldb(8192, [13, 8179], 13),
     rule(3),
     ['N' = 8192, 'P' = 13, 'Q' = 8179],
     [8179 is 8192 - 13, is_prime(8179), !]).
step(8179 is 8192 - 13, builtin, [], []).
step(is_prime(8179),
     rule(9),
     ['P' = 8179],
     [8179 > 3, 1 =:= 8179 rem 2, smallest_divisor_from(8179, 3, 8179)]).
step(8179 > 3, builtin, [], []).
step(1 =:= 8179 rem 2, builtin, [], []).
step(smallest_divisor_from(8179, 3, 8179), builtin, [], []).
step(case(16384, [3, 16381]),
     rule(12),
     ['N' = 16384, 'G' = [3, 16381], 'I' = 14],
     [between(2, 25, 14), 16384 is 2 ^ 14, goldbach(16384, [3, 16381])]).
step(between(2, 25, 14), builtin, [], []).
step(16384 is 2 ^ 14, builtin, [], []).
step(goldbach(16384, [3, 16381]),
     rule(2),
     ['N' = 16384, 'L' = [3, 16381]],
     [0 =:= 16384 rem 2, 16384 > 4, goldb(16384, [3, 16381], 3)]).
step(0 =:= 16384 rem 2, builtin, [], []).
step(16384 > 4, builtin, [], []).
step(goldb(16384, [3, 16381], 3),
     rule(3),
     ['N' = 16384, 'P' = 3, 'Q' = 16381],
     [16381 is 16384 - 3, is_prime(16381), !]).
step(16381 is 16384 - 3, builtin, [], []).
step(is_prime(16381),
     rule(9),
     ['P' = 16381],
     [16381 > 3, 1 =:= 16381 rem 2, smallest_divisor_from(16381, 3, 16381)]).
step(16381 > 3, builtin, [], []).
step(1 =:= 16381 rem 2, builtin, [], []).
step(smallest_divisor_from(16381, 3, 16381), builtin, [], []).
step(case(32768, [19, 32749]),
     rule(12),
     ['N' = 32768, 'G' = [19, 32749], 'I' = 15],
     [between(2, 25, 15), 32768 is 2 ^ 15, goldbach(32768, [19, 32749])]).
step(between(2, 25, 15), builtin, [], []).
step(32768 is 2 ^ 15, builtin, [], []).
step(goldbach(32768, [19, 32749]),
     rule(2),
     ['N' = 32768, 'L' = [19, 32749]],
     [0 =:= 32768 rem 2, 32768 > 4, goldb(32768, [19, 32749], 3)]).
step(0 =:= 32768 rem 2, builtin, [], []).
step(32768 > 4, builtin, [], []).
step(goldb(32768, [19, 32749], 3),
     rule(4),
     ['N' = 32768, 'L' = [19, 32749], 'P' = 3, 'P1' = 5],
     [3 < 32768, next_prime(3, 5), goldb(32768, [19, 32749], 5)]).
step(3 < 32768, builtin, [], []).
step(goldb(32768, [19, 32749], 5),
     rule(4),
     ['N' = 32768, 'L' = [19, 32749], 'P' = 5, 'P1' = 7],
     [5 < 32768, next_prime(5, 7), goldb(32768, [19, 32749], 7)]).
step(5 < 32768, builtin, [], []).
step(goldb(32768, [19, 32749], 7),
     rule(4),
     ['N' = 32768, 'L' = [19, 32749], 'P' = 7, 'P1' = 11],
     [7 < 32768, next_prime(7, 11), goldb(32768, [19, 32749], 11)]).
step(7 < 32768, builtin, [], []).
step(goldb(32768, [19, 32749], 11),
     rule(4),
     ['N' = 32768, 'L' = [19, 32749], 'P' = 11, 'P1' = 13],
     [11 < 32768, next_prime(11, 13), goldb(32768, [19, 32749], 13)]).
step(11 < 32768, builtin, [], []).
step(goldb(32768, [19, 32749], 13),
     rule(4),
     ['N' = 32768, 'L' = [19, 32749], 'P' = 13, 'P1' = 17],
     [13 < 32768, next_prime(13, 17), goldb(32768, [19, 32749], 17)]).
step(13 < 32768, builtin, [], []).
step(goldb(32768, [19, 32749], 17),
     rule(4),
     ['N' = 32768, 'L' = [19, 32749], 'P' = 17, 'P1' = 19],
     [17 < 32768, next_prime(17, 19), goldb(32768, [19, 32749], 19)]).
step(17 < 32768, builtin, [], []).
step(goldb(32768, [19, 32749], 19),
     rule(3),
     ['N' = 32768, 'P' = 19, 'Q' = 32749],
     [32749 is 32768 - 19, is_prime(32749), !]).
step(32749 is 32768 - 19, builtin, [], []).
step(is_prime(32749),
     rule(9),
     ['P' = 32749],
     [32749 > 3, 1 =:= 32749 rem 2, smallest_divisor_from(32749, 3, 32749)]).
step(32749 > 3, builtin, [], []).
step(1 =:= 32749 rem 2, builtin, [], []).
step(smallest_divisor_from(32749, 3, 32749), builtin, [], []).
step(case(65536, [17, 65519]),
     rule(12),
     ['N' = 65536, 'G' = [17, 65519], 'I' = 16],
     [between(2, 25, 16), 65536 is 2 ^ 16, goldbach(65536, [17, 65519])]).
step(between(2, 25, 16), builtin, [], []).
step(65536 is 2 ^ 16, builtin, [], []).
step(goldbach(65536, [17, 65519]),
     rule(2),
     ['N' = 65536, 'L' = [17, 65519]],
     [0 =:= 65536 rem 2, 65536 > 4, goldb(65536, [17, 65519], 3)]).
step(0 =:= 65536 rem 2, builtin, [], []).
step(65536 > 4, builtin, [], []).
step(goldb(65536, [17, 65519], 3),
     rule(4),
     ['N' = 65536, 'L' = [17, 65519], 'P' = 3, 'P1' = 5],
     [3 < 65536, next_prime(3, 5), goldb(65536, [17, 65519], 5)]).
step(3 < 65536, builtin, [], []).
step(goldb(65536, [17, 65519], 5),
     rule(4),
     ['N' = 65536, 'L' = [17, 65519], 'P' = 5, 'P1' = 7],
     [5 < 65536, next_prime(5, 7), goldb(65536, [17, 65519], 7)]).
step(5 < 65536, builtin, [], []).
step(goldb(65536, [17, 65519], 7),
     rule(4),
     ['N' = 65536, 'L' = [17, 65519], 'P' = 7, 'P1' = 11],
     [7 < 65536, next_prime(7, 11), goldb(65536, [17, 65519], 11)]).
step(7 < 65536, builtin, [], []).
step(goldb(65536, [17, 65519], 11),
     rule(4),
     ['N' = 65536, 'L' = [17, 65519], 'P' = 11, 'P1' = 13],
     [11 < 65536, next_prime(11, 13), goldb(65536, [17, 65519], 13)]).
step(11 < 65536, builtin, [], []).
step(goldb(65536, [17, 65519], 13),
     rule(4),
     ['N' = 65536, 'L' = [17, 65519], 'P' = 13, 'P1' = 17],
     [13 < 65536, next_prime(13, 17), goldb(65536, [17, 65519], 17)]).
step(13 < 65536, builtin, [], []).
step(goldb(65536, [17, 65519], 17),
     rule(3),
     ['N' = 65536, 'P' = 17, 'Q' = 65519],
     [65519 is 65536 - 17, is_prime(65519), !]).
step(65519 is 65536 - 17, builtin, [], []).
step(is_prime(65519),
     rule(9),
     ['P' = 65519],
     [65519 > 3, 1 =:= 65519 rem 2, smallest_divisor_from(65519, 3, 65519)]).
step(65519 > 3, builtin, [], []).
step(1 =:= 65519 rem 2, builtin, [], []).
step(smallest_divisor_from(65519, 3, 65519), builtin, [], []).
step(case(131072, [13, 131059]),
     rule(12),
     ['N' = 131072, 'G' = [13, 131059], 'I' = 17],
     [between(2, 25, 17), 131072 is 2 ^ 17, goldbach(131072, [13, 131059])]).
step(between(2, 25, 17), builtin, [], []).
step(131072 is 2 ^ 17, builtin, [], []).
step(goldbach(131072, [13, 131059]),
     rule(2),
     ['N' = 131072, 'L' = [13, 131059]],
     [0 =:= 131072 rem 2, 131072 > 4, goldb(131072, [13, 131059], 3)]).
step(0 =:= 131072 rem 2, builtin, [], []).
step(131072 > 4, builtin, [], []).
step(goldb(131072, [13, 131059], 3),
     rule(4),
     ['N' = 131072, 'L' = [13, 131059], 'P' = 3, 'P1' = 5],
     [3 < 131072, next_prime(3, 5), goldb(131072, [13, 131059], 5)]).
step(3 < 131072, builtin, [], []).
step(goldb(131072, [13, 131059], 5),
     rule(4),
     ['N' = 131072, 'L' = [13, 131059], 'P' = 5, 'P1' = 7],
     [5 < 131072, next_prime(5, 7), goldb(131072, [13, 131059], 7)]).
step(5 < 131072, builtin, [], []).
step(goldb(131072, [13, 131059], 7),
     rule(4),
     ['N' = 131072, 'L' = [13, 131059], 'P' = 7, 'P1' = 11],
     [7 < 131072, next_prime(7, 11), goldb(131072, [13, 131059], 11)]).
step(7 < 131072, builtin, [], []).
step(goldb(131072, [13, 131059], 11),
     rule(4),
     ['N' = 131072, 'L' = [13, 131059], 'P' = 11, 'P1' = 13],
     [11 < 131072, next_prime(11, 13), goldb(131072, [13, 131059], 13)]).
step(11 < 131072, builtin, [], []).
step(goldb(131072, [13, 131059], 13),
     rule(3),
     ['N' = 131072, 'P' = 13, 'Q' = 131059],
     [131059 is 131072 - 13, is_prime(131059), !]).
step(131059 is 131072 - 13, builtin, [], []).
step(is_prime(131059),
     rule(9),
     ['P' = 131059],
     [131059 > 3, 1 =:= 131059 rem 2, smallest_divisor_from(131059, 3, 131059)]).
step(131059 > 3, builtin, [], []).
step(1 =:= 131059 rem 2, builtin, [], []).
step(smallest_divisor_from(131059, 3, 131059), builtin, [], []).
step(case(262144, [5, 262139]),
     rule(12),
     ['N' = 262144, 'G' = [5, 262139], 'I' = 18],
     [between(2, 25, 18), 262144 is 2 ^ 18, goldbach(262144, [5, 262139])]).
step(between(2, 25, 18), builtin, [], []).
step(262144 is 2 ^ 18, builtin, [], []).
step(goldbach(262144, [5, 262139]),
     rule(2),
     ['N' = 262144, 'L' = [5, 262139]],
     [0 =:= 262144 rem 2, 262144 > 4, goldb(262144, [5, 262139], 3)]).
step(0 =:= 262144 rem 2, builtin, [], []).
step(262144 > 4, builtin, [], []).
step(goldb(262144, [5, 262139], 3),
     rule(4),
     ['N' = 262144, 'L' = [5, 262139], 'P' = 3, 'P1' = 5],
     [3 < 262144, next_prime(3, 5), goldb(262144, [5, 262139], 5)]).
step(3 < 262144, builtin, [], []).
step(goldb(262144, [5, 262139], 5),
     rule(3),
     ['N' = 262144, 'P' = 5, 'Q' = 262139],
     [262139 is 262144 - 5, is_prime(262139), !]).
step(262139 is 262144 - 5, builtin, [], []).
step(is_prime(262139),
     rule(9),
     ['P' = 262139],
     [262139 > 3, 1 =:= 262139 rem 2, smallest_divisor_from(262139, 3, 262139)]).
step(262139 > 3, builtin, [], []).
step(1 =:= 262139 rem 2, builtin, [], []).
step(smallest_divisor_from(262139, 3, 262139), builtin, [], []).
step(case(524288, [19, 524269]),
     rule(12),
     ['N' = 524288, 'G' = [19, 524269], 'I' = 19],
     [between(2, 25, 19), 524288 is 2 ^ 19, goldbach(524288, [19, 524269])]).
step(between(2, 25, 19), builtin, [], []).
step(524288 is 2 ^ 19, builtin, [], []).
step(goldbach(524288, [19, 524269]),
     rule(2),
     ['N' = 524288, 'L' = [19, 524269]],
     [0 =:= 524288 rem 2, 524288 > 4, goldb(524288, [19, 524269], 3)]).
step(0 =:= 524288 rem 2, builtin, [], []).
step(524288 > 4, builtin, [], []).
step(goldb(524288, [19, 524269], 3),
     rule(4),
     ['N' = 524288, 'L' = [19, 524269], 'P' = 3, 'P1' = 5],
     [3 < 524288, next_prime(3, 5), goldb(524288, [19, 524269], 5)]).
step(3 < 524288, builtin, [], []).
step(goldb(524288, [19, 524269], 5),
     rule(4),
     ['N' = 524288, 'L' = [19, 524269], 'P' = 5, 'P1' = 7],
     [5 < 524288, next_prime(5, 7), goldb(524288, [19, 524269], 7)]).
step(5 < 524288, builtin, [], []).
step(goldb(524288, [19, 524269], 7),
     rule(4),
     ['N' = 524288, 'L' = [19, 524269], 'P' = 7, 'P1' = 11],
     [7 < 524288, next_prime(7, 11), goldb(524288, [19, 524269], 11)]).
step(7 < 524288, builtin, [], []).
step(goldb(524288, [19, 524269], 11),
     rule(4),
     ['N' = 524288, 'L' = [19, 524269], 'P' = 11, 'P1' = 13],
     [11 < 524288, next_prime(11, 13), goldb(524288, [19, 524269], 13)]).
step(11 < 524288, builtin, [], []).
step(goldb(524288, [19, 524269], 13),
     rule(4),
     ['N' = 524288, 'L' = [19, 524269], 'P' = 13, 'P1' = 17],
     [13 < 524288, next_prime(13, 17), goldb(524288, [19, 524269], 17)]).
step(13 < 524288, builtin, [], []).
step(goldb(524288, [19, 524269], 17),
     rule(4),
     ['N' = 524288, 'L' = [19, 524269], 'P' = 17, 'P1' = 19],
     [17 < 524288, next_prime(17, 19), goldb(524288, [19, 524269], 19)]).
step(17 < 524288, builtin, [], []).
step(goldb(524288, [19, 524269], 19),
     rule(3),
     ['N' = 524288, 'P' = 19, 'Q' = 524269],
     [524269 is 524288 - 19, is_prime(524269), !]).
step(524269 is 524288 - 19, builtin, [], []).
step(is_prime(524269),
     rule(9),
     ['P' = 524269],
     [524269 > 3, 1 =:= 524269 rem 2, smallest_divisor_from(524269, 3, 524269)]).
step(524269 > 3, builtin, [], []).
step(1 =:= 524269 rem 2, builtin, [], []).
step(smallest_divisor_from(524269, 3, 524269), builtin, [], []).
step(case(1048576, [3, 1048573]),
     rule(12),
     ['N' = 1048576, 'G' = [3, 1048573], 'I' = 20],
     [between(2, 25, 20), 1048576 is 2 ^ 20, goldbach(1048576, [3, 1048573])]).
step(between(2, 25, 20), builtin, [], []).
step(1048576 is 2 ^ 20, builtin, [], []).
step(goldbach(1048576, [3, 1048573]),
     rule(2),
     ['N' = 1048576, 'L' = [3, 1048573]],
     [0 =:= 1048576 rem 2, 1048576 > 4, goldb(1048576, [3, 1048573], 3)]).
step(0 =:= 1048576 rem 2, builtin, [], []).
step(1048576 > 4, builtin, [], []).
step(goldb(1048576, [3, 1048573], 3),
     rule(3),
     ['N' = 1048576, 'P' = 3, 'Q' = 1048573],
     [1048573 is 1048576 - 3, is_prime(1048573), !]).
step(1048573 is 1048576 - 3, builtin, [], []).
step(is_prime(1048573),
     rule(9),
     ['P' = 1048573],
     [1048573 > 3, 1 =:= 1048573 rem 2, smallest_divisor_from(1048573, 3, 1048573)]).
step(1048573 > 3, builtin, [], []).
step(1 =:= 1048573 rem 2, builtin, [], []).
step(smallest_divisor_from(1048573, 3, 1048573), builtin, [], []).
step(case(2097152, [19, 2097133]),
     rule(12),
     ['N' = 2097152, 'G' = [19, 2097133], 'I' = 21],
     [between(2, 25, 21), 2097152 is 2 ^ 21, goldbach(2097152, [19, 2097133])]).
step(between(2, 25, 21), builtin, [], []).
step(2097152 is 2 ^ 21, builtin, [], []).
step(goldbach(2097152, [19, 2097133]),
     rule(2),
     ['N' = 2097152, 'L' = [19, 2097133]],
     [0 =:= 2097152 rem 2, 2097152 > 4, goldb(2097152, [19, 2097133], 3)]).
step(0 =:= 2097152 rem 2, builtin, [], []).
step(2097152 > 4, builtin, [], []).
step(goldb(2097152, [19, 2097133], 3),
     rule(4),
     ['N' = 2097152, 'L' = [19, 2097133], 'P' = 3, 'P1' = 5],
     [3 < 2097152, next_prime(3, 5), goldb(2097152, [19, 2097133], 5)]).
step(3 < 2097152, builtin, [], []).
step(goldb(2097152, [19, 2097133], 5),
     rule(4),
     ['N' = 2097152, 'L' = [19, 2097133], 'P' = 5, 'P1' = 7],
     [5 < 2097152, next_prime(5, 7), goldb(2097152, [19, 2097133], 7)]).
step(5 < 2097152, builtin, [], []).
step(goldb(2097152, [19, 2097133], 7),
     rule(4),
     ['N' = 2097152, 'L' = [19, 2097133], 'P' = 7, 'P1' = 11],
     [7 < 2097152, next_prime(7, 11), goldb(2097152, [19, 2097133], 11)]).
step(7 < 2097152, builtin, [], []).
step(goldb(2097152, [19, 2097133], 11),
     rule(4),
     ['N' = 2097152, 'L' = [19, 2097133], 'P' = 11, 'P1' = 13],
     [11 < 2097152, next_prime(11, 13), goldb(2097152, [19, 2097133], 13)]).
step(11 < 2097152, builtin, [], []).
step(goldb(2097152, [19, 2097133], 13),
     rule(4),
     ['N' = 2097152, 'L' = [19, 2097133], 'P' = 13, 'P1' = 17],
     [13 < 2097152, next_prime(13, 17), goldb(2097152, [19, 2097133], 17)]).
step(13 < 2097152, builtin, [], []).
step(goldb(2097152, [19, 2097133], 17),
     rule(4),
     ['N' = 2097152, 'L' = [19, 2097133], 'P' = 17, 'P1' = 19],
     [17 < 2097152, next_prime(17, 19), goldb(2097152, [19, 2097133], 19)]).
step(17 < 2097152, builtin, [], []).
step(goldb(2097152, [19, 2097133], 19),
     rule(3),
     ['N' = 2097152, 'P' = 19, 'Q' = 2097133],
     [2097133 is 2097152 - 19, is_prime(2097133), !]).
step(2097133 is 2097152 - 19, builtin, [], []).
step(is_prime(2097133),
     rule(9),
     ['P' = 2097133],
     [2097133 > 3, 1 =:= 2097133 rem 2, smallest_divisor_from(2097133, 3, 2097133)]).
step(2097133 > 3, builtin, [], []).
step(1 =:= 2097133 rem 2, builtin, [], []).
step(smallest_divisor_from(2097133, 3, 2097133), builtin, [], []).
step(case(4194304, [3, 4194301]),
     rule(12),
     ['N' = 4194304, 'G' = [3, 4194301], 'I' = 22],
     [between(2, 25, 22), 4194304 is 2 ^ 22, goldbach(4194304, [3, 4194301])]).
step(between(2, 25, 22), builtin, [], []).
step(4194304 is 2 ^ 22, builtin, [], []).
step(goldbach(4194304, [3, 4194301]),
     rule(2),
     ['N' = 4194304, 'L' = [3, 4194301]],
     [0 =:= 4194304 rem 2, 4194304 > 4, goldb(4194304, [3, 4194301], 3)]).
step(0 =:= 4194304 rem 2, builtin, [], []).
step(4194304 > 4, builtin, [], []).
step(goldb(4194304, [3, 4194301], 3),
     rule(3),
     ['N' = 4194304, 'P' = 3, 'Q' = 4194301],
     [4194301 is 4194304 - 3, is_prime(4194301), !]).
step(4194301 is 4194304 - 3, builtin, [], []).
step(is_prime(4194301),
     rule(9),
     ['P' = 4194301],
     [4194301 > 3, 1 =:= 4194301 rem 2, smallest_divisor_from(4194301, 3, 4194301)]).
step(4194301 > 3, builtin, [], []).
step(1 =:= 4194301 rem 2, builtin, [], []).
step(smallest_divisor_from(4194301, 3, 4194301), builtin, [], []).
step(case(8388608, [37, 8388571]),
     rule(12),
     ['N' = 8388608, 'G' = [37, 8388571], 'I' = 23],
     [between(2, 25, 23), 8388608 is 2 ^ 23, goldbach(8388608, [37, 8388571])]).
step(between(2, 25, 23), builtin, [], []).
step(8388608 is 2 ^ 23, builtin, [], []).
step(goldbach(8388608, [37, 8388571]),
     rule(2),
     ['N' = 8388608, 'L' = [37, 8388571]],
     [0 =:= 8388608 rem 2, 8388608 > 4, goldb(8388608, [37, 8388571], 3)]).
step(0 =:= 8388608 rem 2, builtin, [], []).
step(8388608 > 4, builtin, [], []).
step(goldb(8388608, [37, 8388571], 3),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 3, 'P1' = 5],
     [3 < 8388608, next_prime(3, 5), goldb(8388608, [37, 8388571], 5)]).
step(3 < 8388608, builtin, [], []).
step(goldb(8388608, [37, 8388571], 5),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 5, 'P1' = 7],
     [5 < 8388608, next_prime(5, 7), goldb(8388608, [37, 8388571], 7)]).
step(5 < 8388608, builtin, [], []).
step(goldb(8388608, [37, 8388571], 7),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 7, 'P1' = 11],
     [7 < 8388608, next_prime(7, 11), goldb(8388608, [37, 8388571], 11)]).
step(7 < 8388608, builtin, [], []).
step(goldb(8388608, [37, 8388571], 11),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 11, 'P1' = 13],
     [11 < 8388608, next_prime(11, 13), goldb(8388608, [37, 8388571], 13)]).
step(11 < 8388608, builtin, [], []).
step(goldb(8388608, [37, 8388571], 13),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 13, 'P1' = 17],
     [13 < 8388608, next_prime(13, 17), goldb(8388608, [37, 8388571], 17)]).
step(13 < 8388608, builtin, [], []).
step(goldb(8388608, [37, 8388571], 17),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 17, 'P1' = 19],
     [17 < 8388608, next_prime(17, 19), goldb(8388608, [37, 8388571], 19)]).
step(17 < 8388608, builtin, [], []).
step(goldb(8388608, [37, 8388571], 19),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 19, 'P1' = 23],
     [19 < 8388608, next_prime(19, 23), goldb(8388608, [37, 8388571], 23)]).
step(19 < 8388608, builtin, [], []).
step(next_prime(19, 23),
     rule(6),
     ['P' = 19, 'P1' = 23, 'P2' = 21],
     [21 is 19 + 2, next_prime(21, 23)]).
step(21 is 19 + 2, builtin, [], []).
step(next_prime(21, 23), rule(5), ['P' = 21, 'P1' = 23], [23 is 21 + 2, is_prime(23), !]).
step(23 is 21 + 2, builtin, [], []).
step(is_prime(23),
     rule(9),
     ['P' = 23],
     [23 > 3, 1 =:= 23 rem 2, smallest_divisor_from(23, 3, 23)]).
step(23 > 3, builtin, [], []).
step(1 =:= 23 rem 2, builtin, [], []).
step(smallest_divisor_from(23, 3, 23), builtin, [], []).
step(goldb(8388608, [37, 8388571], 23),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 23, 'P1' = 29],
     [23 < 8388608, next_prime(23, 29), goldb(8388608, [37, 8388571], 29)]).
step(23 < 8388608, builtin, [], []).
step(next_prime(23, 29),
     rule(6),
     ['P' = 23, 'P1' = 29, 'P2' = 25],
     [25 is 23 + 2, next_prime(25, 29)]).
step(25 is 23 + 2, builtin, [], []).
step(next_prime(25, 29),
     rule(6),
     ['P' = 25, 'P1' = 29, 'P2' = 27],
     [27 is 25 + 2, next_prime(27, 29)]).
step(27 is 25 + 2, builtin, [], []).
step(next_prime(27, 29), rule(5), ['P' = 27, 'P1' = 29], [29 is 27 + 2, is_prime(29), !]).
step(29 is 27 + 2, builtin, [], []).
step(goldb(8388608, [37, 8388571], 29),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 29, 'P1' = 31],
     [29 < 8388608, next_prime(29, 31), goldb(8388608, [37, 8388571], 31)]).
step(29 < 8388608, builtin, [], []).
step(next_prime(29, 31), rule(5), ['P' = 29, 'P1' = 31], [31 is 29 + 2, is_prime(31), !]).
step(31 is 29 + 2, builtin, [], []).
step(is_prime(31),
     rule(9),
     ['P' = 31],
     [31 > 3, 1 =:= 31 rem 2, smallest_divisor_from(31, 3, 31)]).
step(31 > 3, builtin, [], []).
step(1 =:= 31 rem 2, builtin, [], []).
step(smallest_divisor_from(31, 3, 31), builtin, [], []).
step(goldb(8388608, [37, 8388571], 31),
     rule(4),
     ['N' = 8388608, 'L' = [37, 8388571], 'P' = 31, 'P1' = 37],
     [31 < 8388608, next_prime(31, 37), goldb(8388608, [37, 8388571], 37)]).
step(31 < 8388608, builtin, [], []).
step(next_prime(31, 37),
     rule(6),
     ['P' = 31, 'P1' = 37, 'P2' = 33],
     [33 is 31 + 2, next_prime(33, 37)]).
step(33 is 31 + 2, builtin, [], []).
step(next_prime(33, 37),
     rule(6),
     ['P' = 33, 'P1' = 37, 'P2' = 35],
     [35 is 33 + 2, next_prime(35, 37)]).
step(35 is 33 + 2, builtin, [], []).
step(next_prime(35, 37), rule(5), ['P' = 35, 'P1' = 37], [37 is 35 + 2, is_prime(37), !]).
step(37 is 35 + 2, builtin, [], []).
step(is_prime(37),
     rule(9),
     ['P' = 37],
     [37 > 3, 1 =:= 37 rem 2, smallest_divisor_from(37, 3, 37)]).
step(37 > 3, builtin, [], []).
step(1 =:= 37 rem 2, builtin, [], []).
step(smallest_divisor_from(37, 3, 37), builtin, [], []).
step(goldb(8388608, [37, 8388571], 37),
     rule(3),
     ['N' = 8388608, 'P' = 37, 'Q' = 8388571],
     [8388571 is 8388608 - 37, is_prime(8388571), !]).
step(8388571 is 8388608 - 37, builtin, [], []).
step(is_prime(8388571),
     rule(9),
     ['P' = 8388571],
     [8388571 > 3, 1 =:= 8388571 rem 2, smallest_divisor_from(8388571, 3, 8388571)]).
step(8388571 > 3, builtin, [], []).
step(1 =:= 8388571 rem 2, builtin, [], []).
step(smallest_divisor_from(8388571, 3, 8388571), builtin, [], []).
step(case(16777216, [3, 16777213]),
     rule(12),
     ['N' = 16777216, 'G' = [3, 16777213], 'I' = 24],
     [between(2, 25, 24), 16777216 is 2 ^ 24, goldbach(16777216, [3, 16777213])]).
step(between(2, 25, 24), builtin, [], []).
step(16777216 is 2 ^ 24, builtin, [], []).
step(goldbach(16777216, [3, 16777213]),
     rule(2),
     ['N' = 16777216, 'L' = [3, 16777213]],
     [0 =:= 16777216 rem 2, 16777216 > 4, goldb(16777216, [3, 16777213], 3)]).
step(0 =:= 16777216 rem 2, builtin, [], []).
step(16777216 > 4, builtin, [], []).
step(goldb(16777216, [3, 16777213], 3),
     rule(3),
     ['N' = 16777216, 'P' = 3, 'Q' = 16777213],
     [16777213 is 16777216 - 3, is_prime(16777213), !]).
step(16777213 is 16777216 - 3, builtin, [], []).
step(is_prime(16777213),
     rule(9),
     ['P' = 16777213],
     [16777213 > 3, 1 =:= 16777213 rem 2, smallest_divisor_from(16777213, 3, 16777213)]).
step(16777213 > 3, builtin, [], []).
step(1 =:= 16777213 rem 2, builtin, [], []).
step(smallest_divisor_from(16777213, 3, 16777213), builtin, [], []).
step(case(33554432, [61, 33554371]),
     rule(12),
     ['N' = 33554432, 'G' = [61, 33554371], 'I' = 25],
     [between(2, 25, 25), 33554432 is 2 ^ 25, goldbach(33554432, [61, 33554371])]).
step(between(2, 25, 25), builtin, [], []).
step(33554432 is 2 ^ 25, builtin, [], []).
step(goldbach(33554432, [61, 33554371]),
     rule(2),
     ['N' = 33554432, 'L' = [61, 33554371]],
     [0 =:= 33554432 rem 2, 33554432 > 4, goldb(33554432, [61, 33554371], 3)]).
step(0 =:= 33554432 rem 2, builtin, [], []).
step(33554432 > 4, builtin, [], []).
step(goldb(33554432, [61, 33554371], 3),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 3, 'P1' = 5],
     [3 < 33554432, next_prime(3, 5), goldb(33554432, [61, 33554371], 5)]).
step(3 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 5),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 5, 'P1' = 7],
     [5 < 33554432, next_prime(5, 7), goldb(33554432, [61, 33554371], 7)]).
step(5 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 7),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 7, 'P1' = 11],
     [7 < 33554432, next_prime(7, 11), goldb(33554432, [61, 33554371], 11)]).
step(7 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 11),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 11, 'P1' = 13],
     [11 < 33554432, next_prime(11, 13), goldb(33554432, [61, 33554371], 13)]).
step(11 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 13),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 13, 'P1' = 17],
     [13 < 33554432, next_prime(13, 17), goldb(33554432, [61, 33554371], 17)]).
step(13 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 17),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 17, 'P1' = 19],
     [17 < 33554432, next_prime(17, 19), goldb(33554432, [61, 33554371], 19)]).
step(17 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 19),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 19, 'P1' = 23],
     [19 < 33554432, next_prime(19, 23), goldb(33554432, [61, 33554371], 23)]).
step(19 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 23),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 23, 'P1' = 29],
     [23 < 33554432, next_prime(23, 29), goldb(33554432, [61, 33554371], 29)]).
step(23 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 29),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 29, 'P1' = 31],
     [29 < 33554432, next_prime(29, 31), goldb(33554432, [61, 33554371], 31)]).
step(29 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 31),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 31, 'P1' = 37],
     [31 < 33554432, next_prime(31, 37), goldb(33554432, [61, 33554371], 37)]).
step(31 < 33554432, builtin, [], []).
step(goldb(33554432, [61, 33554371], 37),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 37, 'P1' = 41],
     [37 < 33554432, next_prime(37, 41), goldb(33554432, [61, 33554371], 41)]).
step(37 < 33554432, builtin, [], []).
step(next_prime(37, 41),
     rule(6),
     ['P' = 37, 'P1' = 41, 'P2' = 39],
     [39 is 37 + 2, next_prime(39, 41)]).
step(39 is 37 + 2, builtin, [], []).
step(next_prime(39, 41), rule(5), ['P' = 39, 'P1' = 41], [41 is 39 + 2, is_prime(41), !]).
step(41 is 39 + 2, builtin, [], []).
step(is_prime(41),
     rule(9),
     ['P' = 41],
     [41 > 3, 1 =:= 41 rem 2, smallest_divisor_from(41, 3, 41)]).
step(41 > 3, builtin, [], []).
step(1 =:= 41 rem 2, builtin, [], []).
step(smallest_divisor_from(41, 3, 41), builtin, [], []).
step(goldb(33554432, [61, 33554371], 41),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 41, 'P1' = 43],
     [41 < 33554432, next_prime(41, 43), goldb(33554432, [61, 33554371], 43)]).
step(41 < 33554432, builtin, [], []).
step(next_prime(41, 43), rule(5), ['P' = 41, 'P1' = 43], [43 is 41 + 2, is_prime(43), !]).
step(43 is 41 + 2, builtin, [], []).
step(is_prime(43),
     rule(9),
     ['P' = 43],
     [43 > 3, 1 =:= 43 rem 2, smallest_divisor_from(43, 3, 43)]).
step(43 > 3, builtin, [], []).
step(1 =:= 43 rem 2, builtin, [], []).
step(smallest_divisor_from(43, 3, 43), builtin, [], []).
step(goldb(33554432, [61, 33554371], 43),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 43, 'P1' = 47],
     [43 < 33554432, next_prime(43, 47), goldb(33554432, [61, 33554371], 47)]).
step(43 < 33554432, builtin, [], []).
step(next_prime(43, 47),
     rule(6),
     ['P' = 43, 'P1' = 47, 'P2' = 45],
     [45 is 43 + 2, next_prime(45, 47)]).
step(45 is 43 + 2, builtin, [], []).
step(next_prime(45, 47), rule(5), ['P' = 45, 'P1' = 47], [47 is 45 + 2, is_prime(47), !]).
step(47 is 45 + 2, builtin, [], []).
step(is_prime(47),
     rule(9),
     ['P' = 47],
     [47 > 3, 1 =:= 47 rem 2, smallest_divisor_from(47, 3, 47)]).
step(47 > 3, builtin, [], []).
step(1 =:= 47 rem 2, builtin, [], []).
step(smallest_divisor_from(47, 3, 47), builtin, [], []).
step(goldb(33554432, [61, 33554371], 47),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 47, 'P1' = 53],
     [47 < 33554432, next_prime(47, 53), goldb(33554432, [61, 33554371], 53)]).
step(47 < 33554432, builtin, [], []).
step(next_prime(47, 53),
     rule(6),
     ['P' = 47, 'P1' = 53, 'P2' = 49],
     [49 is 47 + 2, next_prime(49, 53)]).
step(49 is 47 + 2, builtin, [], []).
step(next_prime(49, 53),
     rule(6),
     ['P' = 49, 'P1' = 53, 'P2' = 51],
     [51 is 49 + 2, next_prime(51, 53)]).
step(51 is 49 + 2, builtin, [], []).
step(next_prime(51, 53), rule(5), ['P' = 51, 'P1' = 53], [53 is 51 + 2, is_prime(53), !]).
step(53 is 51 + 2, builtin, [], []).
step(is_prime(53),
     rule(9),
     ['P' = 53],
     [53 > 3, 1 =:= 53 rem 2, smallest_divisor_from(53, 3, 53)]).
step(53 > 3, builtin, [], []).
step(1 =:= 53 rem 2, builtin, [], []).
step(smallest_divisor_from(53, 3, 53), builtin, [], []).
step(goldb(33554432, [61, 33554371], 53),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 53, 'P1' = 59],
     [53 < 33554432, next_prime(53, 59), goldb(33554432, [61, 33554371], 59)]).
step(53 < 33554432, builtin, [], []).
step(next_prime(53, 59),
     rule(6),
     ['P' = 53, 'P1' = 59, 'P2' = 55],
     [55 is 53 + 2, next_prime(55, 59)]).
step(55 is 53 + 2, builtin, [], []).
step(next_prime(55, 59),
     rule(6),
     ['P' = 55, 'P1' = 59, 'P2' = 57],
     [57 is 55 + 2, next_prime(57, 59)]).
step(57 is 55 + 2, builtin, [], []).
step(next_prime(57, 59), rule(5), ['P' = 57, 'P1' = 59], [59 is 57 + 2, is_prime(59), !]).
step(59 is 57 + 2, builtin, [], []).
step(is_prime(59),
     rule(9),
     ['P' = 59],
     [59 > 3, 1 =:= 59 rem 2, smallest_divisor_from(59, 3, 59)]).
step(59 > 3, builtin, [], []).
step(1 =:= 59 rem 2, builtin, [], []).
step(smallest_divisor_from(59, 3, 59), builtin, [], []).
step(goldb(33554432, [61, 33554371], 59),
     rule(4),
     ['N' = 33554432, 'L' = [61, 33554371], 'P' = 59, 'P1' = 61],
     [59 < 33554432, next_prime(59, 61), goldb(33554432, [61, 33554371], 61)]).
step(59 < 33554432, builtin, [], []).
step(next_prime(59, 61), rule(5), ['P' = 59, 'P1' = 61], [61 is 59 + 2, is_prime(61), !]).
step(61 is 59 + 2, builtin, [], []).
step(goldb(33554432, [61, 33554371], 61),
     rule(3),
     ['N' = 33554432, 'P' = 61, 'Q' = 33554371],
     [33554371 is 33554432 - 61, is_prime(33554371), !]).
step(33554371 is 33554432 - 61, builtin, [], []).
step(is_prime(33554371),
     rule(9),
     ['P' = 33554371],
     [33554371 > 3, 1 =:= 33554371 rem 2, smallest_divisor_from(33554371, 3, 33554371)]).
step(33554371 > 3, builtin, [], []).
step(1 =:= 33554371 rem 2, builtin, [], []).
step(smallest_divisor_from(33554371, 3, 33554371), builtin, [], []).
