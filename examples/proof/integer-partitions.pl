partition_answer(p_12, 77).
partition_answer(p_15, 176).
partition_answer(p_16_using_parts_at_most_5, 101).
partition_answer(cumulative_p_1_to_8, 66).

clause(2, partitions(0, anonymous(1), 1), true).
clause(3, partitions(var('N'), 0, 0), var('N') > 0).
clause(4,
       partitions(var('N'), var('K'), var('Count')),
       (var('N') > 0,
        var('K') > 0,
        var('K') > var('N'),
        var('K1') is var('K') - 1,
        partitions(var('N'), var('K1'), var('Count')))).
clause(5,
       partitions(var('N'), var('K'), var('Count')),
       (var('N') > 0,
        var('K') > 0,
        var('K') =< var('N'),
        var('Remainder') is var('N') - var('K'),
        partitions(var('Remainder'), var('K'), var('Withk')),
        var('K1') is var('K') - 1,
        partitions(var('N'), var('K1'), var('Withoutk')),
        var('Count') is var('Withk') + var('Withoutk'))).
clause(6, partition_count(var('N'), var('Count')), partitions(var('N'), var('N'), var('Count'))).
clause(7, partition_answer(p_12, var('Count')), partition_count(12, var('Count'))).
clause(8, partition_answer(p_15, var('Count')), partition_count(15, var('Count'))).
clause(9,
       partition_answer(p_16_using_parts_at_most_5, var('Count')),
       partitions(16, 5, var('Count'))).
clause(10,
       partition_answer(cumulative_p_1_to_8, var('Sum')),
       sumall(var('C'), (between(1, 8, var('N')), partition_count(var('N'), var('C'))), var('Sum'))).

step(partition_answer(p_12, 77), rule(7), ['Count' = 77], [partition_count(12, 77)]).
step(partition_count(12, 77), rule(6), ['N' = 12, 'Count' = 77], [partitions(12, 12, 77)]).
step(partitions(12, 12, 77),
     rule(5),
     ['N' = 12,
      'K' = 12,
      'Count' = 77,
      'Remainder' = 0,
      'Withk' = 1,
      'K1' = 11,
      'Withoutk' = 76],
     [12 > 0,
      12 > 0,
      12 =< 12,
      0 is 12 - 12,
      partitions(0, 12, 1),
      11 is 12 - 1,
      partitions(12, 11, 76),
      77 is 1 + 76]).
step(12 > 0, builtin, [], []).
step(12 =< 12, builtin, [], []).
step(0 is 12 - 12, builtin, [], []).
step(partitions(0, 12, 1), fact(2), [], []).
step(11 is 12 - 1, builtin, [], []).
step(partitions(12, 11, 76),
     rule(5),
     ['N' = 12,
      'K' = 11,
      'Count' = 76,
      'Remainder' = 1,
      'Withk' = 1,
      'K1' = 10,
      'Withoutk' = 75],
     [12 > 0,
      11 > 0,
      11 =< 12,
      1 is 12 - 11,
      partitions(1, 11, 1),
      10 is 11 - 1,
      partitions(12, 10, 75),
      76 is 1 + 75]).
step(11 > 0, builtin, [], []).
step(11 =< 12, builtin, [], []).
step(1 is 12 - 11, builtin, [], []).
step(partitions(1, 11, 1),
     rule(4),
     ['N' = 1, 'K' = 11, 'Count' = 1, 'K1' = 10],
     [1 > 0, 11 > 0, 11 > 1, 10 is 11 - 1, partitions(1, 10, 1)]).
step(1 > 0, builtin, [], []).
step(11 > 1, builtin, [], []).
step(10 is 11 - 1, builtin, [], []).
step(partitions(1, 10, 1),
     rule(4),
     ['N' = 1, 'K' = 10, 'Count' = 1, 'K1' = 9],
     [1 > 0, 10 > 0, 10 > 1, 9 is 10 - 1, partitions(1, 9, 1)]).
step(10 > 0, builtin, [], []).
step(10 > 1, builtin, [], []).
step(9 is 10 - 1, builtin, [], []).
step(partitions(1, 9, 1),
     rule(4),
     ['N' = 1, 'K' = 9, 'Count' = 1, 'K1' = 8],
     [1 > 0, 9 > 0, 9 > 1, 8 is 9 - 1, partitions(1, 8, 1)]).
step(9 > 0, builtin, [], []).
step(9 > 1, builtin, [], []).
step(8 is 9 - 1, builtin, [], []).
step(partitions(1, 8, 1),
     rule(4),
     ['N' = 1, 'K' = 8, 'Count' = 1, 'K1' = 7],
     [1 > 0, 8 > 0, 8 > 1, 7 is 8 - 1, partitions(1, 7, 1)]).
step(8 > 0, builtin, [], []).
step(8 > 1, builtin, [], []).
step(7 is 8 - 1, builtin, [], []).
step(partitions(1, 7, 1),
     rule(4),
     ['N' = 1, 'K' = 7, 'Count' = 1, 'K1' = 6],
     [1 > 0, 7 > 0, 7 > 1, 6 is 7 - 1, partitions(1, 6, 1)]).
step(7 > 0, builtin, [], []).
step(7 > 1, builtin, [], []).
step(6 is 7 - 1, builtin, [], []).
step(partitions(1, 6, 1),
     rule(4),
     ['N' = 1, 'K' = 6, 'Count' = 1, 'K1' = 5],
     [1 > 0, 6 > 0, 6 > 1, 5 is 6 - 1, partitions(1, 5, 1)]).
step(6 > 0, builtin, [], []).
step(6 > 1, builtin, [], []).
step(5 is 6 - 1, builtin, [], []).
step(partitions(1, 5, 1),
     rule(4),
     ['N' = 1, 'K' = 5, 'Count' = 1, 'K1' = 4],
     [1 > 0, 5 > 0, 5 > 1, 4 is 5 - 1, partitions(1, 4, 1)]).
step(5 > 0, builtin, [], []).
step(5 > 1, builtin, [], []).
step(4 is 5 - 1, builtin, [], []).
step(partitions(1, 4, 1),
     rule(4),
     ['N' = 1, 'K' = 4, 'Count' = 1, 'K1' = 3],
     [1 > 0, 4 > 0, 4 > 1, 3 is 4 - 1, partitions(1, 3, 1)]).
step(4 > 0, builtin, [], []).
step(4 > 1, builtin, [], []).
step(3 is 4 - 1, builtin, [], []).
step(partitions(1, 3, 1),
     rule(4),
     ['N' = 1, 'K' = 3, 'Count' = 1, 'K1' = 2],
     [1 > 0, 3 > 0, 3 > 1, 2 is 3 - 1, partitions(1, 2, 1)]).
step(3 > 0, builtin, [], []).
step(3 > 1, builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(partitions(1, 2, 1),
     rule(4),
     ['N' = 1, 'K' = 2, 'Count' = 1, 'K1' = 1],
     [1 > 0, 2 > 0, 2 > 1, 1 is 2 - 1, partitions(1, 1, 1)]).
step(2 > 0, builtin, [], []).
step(2 > 1, builtin, [], []).
step(1 is 2 - 1, builtin, [], []).
step(partitions(1, 1, 1),
     rule(5),
     ['N' = 1, 'K' = 1, 'Count' = 1, 'Remainder' = 0, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [1 > 0,
      1 > 0,
      1 =< 1,
      0 is 1 - 1,
      partitions(0, 1, 1),
      0 is 1 - 1,
      partitions(1, 0, 0),
      1 is 1 + 0]).
step(1 =< 1, builtin, [], []).
step(0 is 1 - 1, builtin, [], []).
step(partitions(0, 1, 1), fact(2), [], []).
step(partitions(1, 0, 0), rule(3), ['N' = 1], [1 > 0]).
step(1 is 1 + 0, builtin, [], []).
step(partitions(12, 10, 75),
     rule(5),
     ['N' = 12, 'K' = 10, 'Count' = 75, 'Remainder' = 2, 'Withk' = 2, 'K1' = 9, 'Withoutk' = 73],
     [12 > 0,
      10 > 0,
      10 =< 12,
      2 is 12 - 10,
      partitions(2, 10, 2),
      9 is 10 - 1,
      partitions(12, 9, 73),
      75 is 2 + 73]).
step(10 =< 12, builtin, [], []).
step(2 is 12 - 10, builtin, [], []).
step(partitions(2, 10, 2),
     rule(4),
     ['N' = 2, 'K' = 10, 'Count' = 2, 'K1' = 9],
     [2 > 0, 10 > 0, 10 > 2, 9 is 10 - 1, partitions(2, 9, 2)]).
step(10 > 2, builtin, [], []).
step(partitions(2, 9, 2),
     rule(4),
     ['N' = 2, 'K' = 9, 'Count' = 2, 'K1' = 8],
     [2 > 0, 9 > 0, 9 > 2, 8 is 9 - 1, partitions(2, 8, 2)]).
step(9 > 2, builtin, [], []).
step(partitions(2, 8, 2),
     rule(4),
     ['N' = 2, 'K' = 8, 'Count' = 2, 'K1' = 7],
     [2 > 0, 8 > 0, 8 > 2, 7 is 8 - 1, partitions(2, 7, 2)]).
step(8 > 2, builtin, [], []).
step(partitions(2, 7, 2),
     rule(4),
     ['N' = 2, 'K' = 7, 'Count' = 2, 'K1' = 6],
     [2 > 0, 7 > 0, 7 > 2, 6 is 7 - 1, partitions(2, 6, 2)]).
step(7 > 2, builtin, [], []).
step(partitions(2, 6, 2),
     rule(4),
     ['N' = 2, 'K' = 6, 'Count' = 2, 'K1' = 5],
     [2 > 0, 6 > 0, 6 > 2, 5 is 6 - 1, partitions(2, 5, 2)]).
step(6 > 2, builtin, [], []).
step(partitions(2, 5, 2),
     rule(4),
     ['N' = 2, 'K' = 5, 'Count' = 2, 'K1' = 4],
     [2 > 0, 5 > 0, 5 > 2, 4 is 5 - 1, partitions(2, 4, 2)]).
step(5 > 2, builtin, [], []).
step(partitions(2, 4, 2),
     rule(4),
     ['N' = 2, 'K' = 4, 'Count' = 2, 'K1' = 3],
     [2 > 0, 4 > 0, 4 > 2, 3 is 4 - 1, partitions(2, 3, 2)]).
step(4 > 2, builtin, [], []).
step(partitions(2, 3, 2),
     rule(4),
     ['N' = 2, 'K' = 3, 'Count' = 2, 'K1' = 2],
     [2 > 0, 3 > 0, 3 > 2, 2 is 3 - 1, partitions(2, 2, 2)]).
step(3 > 2, builtin, [], []).
step(partitions(2, 2, 2),
     rule(5),
     ['N' = 2, 'K' = 2, 'Count' = 2, 'Remainder' = 0, 'Withk' = 1, 'K1' = 1, 'Withoutk' = 1],
     [2 > 0,
      2 > 0,
      2 =< 2,
      0 is 2 - 2,
      partitions(0, 2, 1),
      1 is 2 - 1,
      partitions(2, 1, 1),
      2 is 1 + 1]).
step(2 =< 2, builtin, [], []).
step(0 is 2 - 2, builtin, [], []).
step(partitions(0, 2, 1), fact(2), [], []).
step(partitions(2, 1, 1),
     rule(5),
     ['N' = 2, 'K' = 1, 'Count' = 1, 'Remainder' = 1, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [2 > 0,
      1 > 0,
      1 =< 2,
      1 is 2 - 1,
      partitions(1, 1, 1),
      0 is 1 - 1,
      partitions(2, 0, 0),
      1 is 1 + 0]).
step(1 =< 2, builtin, [], []).
step(partitions(2, 0, 0), rule(3), ['N' = 2], [2 > 0]).
step(2 is 1 + 1, builtin, [], []).
step(partitions(12, 9, 73),
     rule(5),
     ['N' = 12, 'K' = 9, 'Count' = 73, 'Remainder' = 3, 'Withk' = 3, 'K1' = 8, 'Withoutk' = 70],
     [12 > 0,
      9 > 0,
      9 =< 12,
      3 is 12 - 9,
      partitions(3, 9, 3),
      8 is 9 - 1,
      partitions(12, 8, 70),
      73 is 3 + 70]).
step(9 =< 12, builtin, [], []).
step(3 is 12 - 9, builtin, [], []).
step(partitions(3, 9, 3),
     rule(4),
     ['N' = 3, 'K' = 9, 'Count' = 3, 'K1' = 8],
     [3 > 0, 9 > 0, 9 > 3, 8 is 9 - 1, partitions(3, 8, 3)]).
step(9 > 3, builtin, [], []).
step(partitions(3, 8, 3),
     rule(4),
     ['N' = 3, 'K' = 8, 'Count' = 3, 'K1' = 7],
     [3 > 0, 8 > 0, 8 > 3, 7 is 8 - 1, partitions(3, 7, 3)]).
step(8 > 3, builtin, [], []).
step(partitions(3, 7, 3),
     rule(4),
     ['N' = 3, 'K' = 7, 'Count' = 3, 'K1' = 6],
     [3 > 0, 7 > 0, 7 > 3, 6 is 7 - 1, partitions(3, 6, 3)]).
step(7 > 3, builtin, [], []).
step(partitions(3, 6, 3),
     rule(4),
     ['N' = 3, 'K' = 6, 'Count' = 3, 'K1' = 5],
     [3 > 0, 6 > 0, 6 > 3, 5 is 6 - 1, partitions(3, 5, 3)]).
step(6 > 3, builtin, [], []).
step(partitions(3, 5, 3),
     rule(4),
     ['N' = 3, 'K' = 5, 'Count' = 3, 'K1' = 4],
     [3 > 0, 5 > 0, 5 > 3, 4 is 5 - 1, partitions(3, 4, 3)]).
step(5 > 3, builtin, [], []).
step(partitions(3, 4, 3),
     rule(4),
     ['N' = 3, 'K' = 4, 'Count' = 3, 'K1' = 3],
     [3 > 0, 4 > 0, 4 > 3, 3 is 4 - 1, partitions(3, 3, 3)]).
step(4 > 3, builtin, [], []).
step(partitions(3, 3, 3),
     rule(5),
     ['N' = 3, 'K' = 3, 'Count' = 3, 'Remainder' = 0, 'Withk' = 1, 'K1' = 2, 'Withoutk' = 2],
     [3 > 0,
      3 > 0,
      3 =< 3,
      0 is 3 - 3,
      partitions(0, 3, 1),
      2 is 3 - 1,
      partitions(3, 2, 2),
      3 is 1 + 2]).
step(3 =< 3, builtin, [], []).
step(0 is 3 - 3, builtin, [], []).
step(partitions(0, 3, 1), fact(2), [], []).
step(partitions(3, 2, 2),
     rule(5),
     ['N' = 3, 'K' = 2, 'Count' = 2, 'Remainder' = 1, 'Withk' = 1, 'K1' = 1, 'Withoutk' = 1],
     [3 > 0,
      2 > 0,
      2 =< 3,
      1 is 3 - 2,
      partitions(1, 2, 1),
      1 is 2 - 1,
      partitions(3, 1, 1),
      2 is 1 + 1]).
step(2 =< 3, builtin, [], []).
step(1 is 3 - 2, builtin, [], []).
step(partitions(3, 1, 1),
     rule(5),
     ['N' = 3, 'K' = 1, 'Count' = 1, 'Remainder' = 2, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [3 > 0,
      1 > 0,
      1 =< 3,
      2 is 3 - 1,
      partitions(2, 1, 1),
      0 is 1 - 1,
      partitions(3, 0, 0),
      1 is 1 + 0]).
step(1 =< 3, builtin, [], []).
step(partitions(3, 0, 0), rule(3), ['N' = 3], [3 > 0]).
step(3 is 1 + 2, builtin, [], []).
step(partitions(12, 8, 70),
     rule(5),
     ['N' = 12, 'K' = 8, 'Count' = 70, 'Remainder' = 4, 'Withk' = 5, 'K1' = 7, 'Withoutk' = 65],
     [12 > 0,
      8 > 0,
      8 =< 12,
      4 is 12 - 8,
      partitions(4, 8, 5),
      7 is 8 - 1,
      partitions(12, 7, 65),
      70 is 5 + 65]).
step(8 =< 12, builtin, [], []).
step(4 is 12 - 8, builtin, [], []).
step(partitions(4, 8, 5),
     rule(4),
     ['N' = 4, 'K' = 8, 'Count' = 5, 'K1' = 7],
     [4 > 0, 8 > 0, 8 > 4, 7 is 8 - 1, partitions(4, 7, 5)]).
step(8 > 4, builtin, [], []).
step(partitions(4, 7, 5),
     rule(4),
     ['N' = 4, 'K' = 7, 'Count' = 5, 'K1' = 6],
     [4 > 0, 7 > 0, 7 > 4, 6 is 7 - 1, partitions(4, 6, 5)]).
step(7 > 4, builtin, [], []).
step(partitions(4, 6, 5),
     rule(4),
     ['N' = 4, 'K' = 6, 'Count' = 5, 'K1' = 5],
     [4 > 0, 6 > 0, 6 > 4, 5 is 6 - 1, partitions(4, 5, 5)]).
step(6 > 4, builtin, [], []).
step(partitions(4, 5, 5),
     rule(4),
     ['N' = 4, 'K' = 5, 'Count' = 5, 'K1' = 4],
     [4 > 0, 5 > 0, 5 > 4, 4 is 5 - 1, partitions(4, 4, 5)]).
step(5 > 4, builtin, [], []).
step(partitions(4, 4, 5),
     rule(5),
     ['N' = 4, 'K' = 4, 'Count' = 5, 'Remainder' = 0, 'Withk' = 1, 'K1' = 3, 'Withoutk' = 4],
     [4 > 0,
      4 > 0,
      4 =< 4,
      0 is 4 - 4,
      partitions(0, 4, 1),
      3 is 4 - 1,
      partitions(4, 3, 4),
      5 is 1 + 4]).
step(4 =< 4, builtin, [], []).
step(0 is 4 - 4, builtin, [], []).
step(partitions(0, 4, 1), fact(2), [], []).
step(partitions(4, 3, 4),
     rule(5),
     ['N' = 4, 'K' = 3, 'Count' = 4, 'Remainder' = 1, 'Withk' = 1, 'K1' = 2, 'Withoutk' = 3],
     [4 > 0,
      3 > 0,
      3 =< 4,
      1 is 4 - 3,
      partitions(1, 3, 1),
      2 is 3 - 1,
      partitions(4, 2, 3),
      4 is 1 + 3]).
step(3 =< 4, builtin, [], []).
step(1 is 4 - 3, builtin, [], []).
step(partitions(4, 2, 3),
     rule(5),
     ['N' = 4, 'K' = 2, 'Count' = 3, 'Remainder' = 2, 'Withk' = 2, 'K1' = 1, 'Withoutk' = 1],
     [4 > 0,
      2 > 0,
      2 =< 4,
      2 is 4 - 2,
      partitions(2, 2, 2),
      1 is 2 - 1,
      partitions(4, 1, 1),
      3 is 2 + 1]).
step(2 =< 4, builtin, [], []).
step(2 is 4 - 2, builtin, [], []).
step(partitions(4, 1, 1),
     rule(5),
     ['N' = 4, 'K' = 1, 'Count' = 1, 'Remainder' = 3, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [4 > 0,
      1 > 0,
      1 =< 4,
      3 is 4 - 1,
      partitions(3, 1, 1),
      0 is 1 - 1,
      partitions(4, 0, 0),
      1 is 1 + 0]).
step(1 =< 4, builtin, [], []).
step(partitions(4, 0, 0), rule(3), ['N' = 4], [4 > 0]).
step(3 is 2 + 1, builtin, [], []).
step(4 is 1 + 3, builtin, [], []).
step(5 is 1 + 4, builtin, [], []).
step(partitions(12, 7, 65),
     rule(5),
     ['N' = 12, 'K' = 7, 'Count' = 65, 'Remainder' = 5, 'Withk' = 7, 'K1' = 6, 'Withoutk' = 58],
     [12 > 0,
      7 > 0,
      7 =< 12,
      5 is 12 - 7,
      partitions(5, 7, 7),
      6 is 7 - 1,
      partitions(12, 6, 58),
      65 is 7 + 58]).
step(7 =< 12, builtin, [], []).
step(5 is 12 - 7, builtin, [], []).
step(partitions(5, 7, 7),
     rule(4),
     ['N' = 5, 'K' = 7, 'Count' = 7, 'K1' = 6],
     [5 > 0, 7 > 0, 7 > 5, 6 is 7 - 1, partitions(5, 6, 7)]).
step(7 > 5, builtin, [], []).
step(partitions(5, 6, 7),
     rule(4),
     ['N' = 5, 'K' = 6, 'Count' = 7, 'K1' = 5],
     [5 > 0, 6 > 0, 6 > 5, 5 is 6 - 1, partitions(5, 5, 7)]).
step(6 > 5, builtin, [], []).
step(partitions(5, 5, 7),
     rule(5),
     ['N' = 5, 'K' = 5, 'Count' = 7, 'Remainder' = 0, 'Withk' = 1, 'K1' = 4, 'Withoutk' = 6],
     [5 > 0,
      5 > 0,
      5 =< 5,
      0 is 5 - 5,
      partitions(0, 5, 1),
      4 is 5 - 1,
      partitions(5, 4, 6),
      7 is 1 + 6]).
step(5 =< 5, builtin, [], []).
step(0 is 5 - 5, builtin, [], []).
step(partitions(0, 5, 1), fact(2), [], []).
step(partitions(5, 4, 6),
     rule(5),
     ['N' = 5, 'K' = 4, 'Count' = 6, 'Remainder' = 1, 'Withk' = 1, 'K1' = 3, 'Withoutk' = 5],
     [5 > 0,
      4 > 0,
      4 =< 5,
      1 is 5 - 4,
      partitions(1, 4, 1),
      3 is 4 - 1,
      partitions(5, 3, 5),
      6 is 1 + 5]).
step(4 =< 5, builtin, [], []).
step(1 is 5 - 4, builtin, [], []).
step(partitions(5, 3, 5),
     rule(5),
     ['N' = 5, 'K' = 3, 'Count' = 5, 'Remainder' = 2, 'Withk' = 2, 'K1' = 2, 'Withoutk' = 3],
     [5 > 0,
      3 > 0,
      3 =< 5,
      2 is 5 - 3,
      partitions(2, 3, 2),
      2 is 3 - 1,
      partitions(5, 2, 3),
      5 is 2 + 3]).
step(3 =< 5, builtin, [], []).
step(2 is 5 - 3, builtin, [], []).
step(partitions(5, 2, 3),
     rule(5),
     ['N' = 5, 'K' = 2, 'Count' = 3, 'Remainder' = 3, 'Withk' = 2, 'K1' = 1, 'Withoutk' = 1],
     [5 > 0,
      2 > 0,
      2 =< 5,
      3 is 5 - 2,
      partitions(3, 2, 2),
      1 is 2 - 1,
      partitions(5, 1, 1),
      3 is 2 + 1]).
step(2 =< 5, builtin, [], []).
step(3 is 5 - 2, builtin, [], []).
step(partitions(5, 1, 1),
     rule(5),
     ['N' = 5, 'K' = 1, 'Count' = 1, 'Remainder' = 4, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [5 > 0,
      1 > 0,
      1 =< 5,
      4 is 5 - 1,
      partitions(4, 1, 1),
      0 is 1 - 1,
      partitions(5, 0, 0),
      1 is 1 + 0]).
step(1 =< 5, builtin, [], []).
step(partitions(5, 0, 0), rule(3), ['N' = 5], [5 > 0]).
step(5 is 2 + 3, builtin, [], []).
step(6 is 1 + 5, builtin, [], []).
step(7 is 1 + 6, builtin, [], []).
step(partitions(12, 6, 58),
     rule(5),
     ['N' = 12, 'K' = 6, 'Count' = 58, 'Remainder' = 6, 'Withk' = 11, 'K1' = 5, 'Withoutk' = 47],
     [12 > 0,
      6 > 0,
      6 =< 12,
      6 is 12 - 6,
      partitions(6, 6, 11),
      5 is 6 - 1,
      partitions(12, 5, 47),
      58 is 11 + 47]).
step(6 =< 12, builtin, [], []).
step(6 is 12 - 6, builtin, [], []).
step(partitions(6, 6, 11),
     rule(5),
     ['N' = 6, 'K' = 6, 'Count' = 11, 'Remainder' = 0, 'Withk' = 1, 'K1' = 5, 'Withoutk' = 10],
     [6 > 0,
      6 > 0,
      6 =< 6,
      0 is 6 - 6,
      partitions(0, 6, 1),
      5 is 6 - 1,
      partitions(6, 5, 10),
      11 is 1 + 10]).
step(6 =< 6, builtin, [], []).
step(0 is 6 - 6, builtin, [], []).
step(partitions(0, 6, 1), fact(2), [], []).
step(partitions(6, 5, 10),
     rule(5),
     ['N' = 6, 'K' = 5, 'Count' = 10, 'Remainder' = 1, 'Withk' = 1, 'K1' = 4, 'Withoutk' = 9],
     [6 > 0,
      5 > 0,
      5 =< 6,
      1 is 6 - 5,
      partitions(1, 5, 1),
      4 is 5 - 1,
      partitions(6, 4, 9),
      10 is 1 + 9]).
step(5 =< 6, builtin, [], []).
step(1 is 6 - 5, builtin, [], []).
step(partitions(6, 4, 9),
     rule(5),
     ['N' = 6, 'K' = 4, 'Count' = 9, 'Remainder' = 2, 'Withk' = 2, 'K1' = 3, 'Withoutk' = 7],
     [6 > 0,
      4 > 0,
      4 =< 6,
      2 is 6 - 4,
      partitions(2, 4, 2),
      3 is 4 - 1,
      partitions(6, 3, 7),
      9 is 2 + 7]).
step(4 =< 6, builtin, [], []).
step(2 is 6 - 4, builtin, [], []).
step(partitions(6, 3, 7),
     rule(5),
     ['N' = 6, 'K' = 3, 'Count' = 7, 'Remainder' = 3, 'Withk' = 3, 'K1' = 2, 'Withoutk' = 4],
     [6 > 0,
      3 > 0,
      3 =< 6,
      3 is 6 - 3,
      partitions(3, 3, 3),
      2 is 3 - 1,
      partitions(6, 2, 4),
      7 is 3 + 4]).
step(3 =< 6, builtin, [], []).
step(3 is 6 - 3, builtin, [], []).
step(partitions(6, 2, 4),
     rule(5),
     ['N' = 6, 'K' = 2, 'Count' = 4, 'Remainder' = 4, 'Withk' = 3, 'K1' = 1, 'Withoutk' = 1],
     [6 > 0,
      2 > 0,
      2 =< 6,
      4 is 6 - 2,
      partitions(4, 2, 3),
      1 is 2 - 1,
      partitions(6, 1, 1),
      4 is 3 + 1]).
step(2 =< 6, builtin, [], []).
step(4 is 6 - 2, builtin, [], []).
step(partitions(6, 1, 1),
     rule(5),
     ['N' = 6, 'K' = 1, 'Count' = 1, 'Remainder' = 5, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [6 > 0,
      1 > 0,
      1 =< 6,
      5 is 6 - 1,
      partitions(5, 1, 1),
      0 is 1 - 1,
      partitions(6, 0, 0),
      1 is 1 + 0]).
step(1 =< 6, builtin, [], []).
step(partitions(6, 0, 0), rule(3), ['N' = 6], [6 > 0]).
step(4 is 3 + 1, builtin, [], []).
step(7 is 3 + 4, builtin, [], []).
step(9 is 2 + 7, builtin, [], []).
step(10 is 1 + 9, builtin, [], []).
step(11 is 1 + 10, builtin, [], []).
step(partitions(12, 5, 47),
     rule(5),
     ['N' = 12, 'K' = 5, 'Count' = 47, 'Remainder' = 7, 'Withk' = 13, 'K1' = 4, 'Withoutk' = 34],
     [12 > 0,
      5 > 0,
      5 =< 12,
      7 is 12 - 5,
      partitions(7, 5, 13),
      4 is 5 - 1,
      partitions(12, 4, 34),
      47 is 13 + 34]).
step(5 =< 12, builtin, [], []).
step(7 is 12 - 5, builtin, [], []).
step(partitions(7, 5, 13),
     rule(5),
     ['N' = 7, 'K' = 5, 'Count' = 13, 'Remainder' = 2, 'Withk' = 2, 'K1' = 4, 'Withoutk' = 11],
     [7 > 0,
      5 > 0,
      5 =< 7,
      2 is 7 - 5,
      partitions(2, 5, 2),
      4 is 5 - 1,
      partitions(7, 4, 11),
      13 is 2 + 11]).
step(5 =< 7, builtin, [], []).
step(2 is 7 - 5, builtin, [], []).
step(partitions(7, 4, 11),
     rule(5),
     ['N' = 7, 'K' = 4, 'Count' = 11, 'Remainder' = 3, 'Withk' = 3, 'K1' = 3, 'Withoutk' = 8],
     [7 > 0,
      4 > 0,
      4 =< 7,
      3 is 7 - 4,
      partitions(3, 4, 3),
      3 is 4 - 1,
      partitions(7, 3, 8),
      11 is 3 + 8]).
step(4 =< 7, builtin, [], []).
step(3 is 7 - 4, builtin, [], []).
step(partitions(7, 3, 8),
     rule(5),
     ['N' = 7, 'K' = 3, 'Count' = 8, 'Remainder' = 4, 'Withk' = 4, 'K1' = 2, 'Withoutk' = 4],
     [7 > 0,
      3 > 0,
      3 =< 7,
      4 is 7 - 3,
      partitions(4, 3, 4),
      2 is 3 - 1,
      partitions(7, 2, 4),
      8 is 4 + 4]).
step(3 =< 7, builtin, [], []).
step(4 is 7 - 3, builtin, [], []).
step(partitions(7, 2, 4),
     rule(5),
     ['N' = 7, 'K' = 2, 'Count' = 4, 'Remainder' = 5, 'Withk' = 3, 'K1' = 1, 'Withoutk' = 1],
     [7 > 0,
      2 > 0,
      2 =< 7,
      5 is 7 - 2,
      partitions(5, 2, 3),
      1 is 2 - 1,
      partitions(7, 1, 1),
      4 is 3 + 1]).
step(2 =< 7, builtin, [], []).
step(5 is 7 - 2, builtin, [], []).
step(partitions(7, 1, 1),
     rule(5),
     ['N' = 7, 'K' = 1, 'Count' = 1, 'Remainder' = 6, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [7 > 0,
      1 > 0,
      1 =< 7,
      6 is 7 - 1,
      partitions(6, 1, 1),
      0 is 1 - 1,
      partitions(7, 0, 0),
      1 is 1 + 0]).
step(1 =< 7, builtin, [], []).
step(partitions(7, 0, 0), rule(3), ['N' = 7], [7 > 0]).
step(8 is 4 + 4, builtin, [], []).
step(11 is 3 + 8, builtin, [], []).
step(13 is 2 + 11, builtin, [], []).
step(partitions(12, 4, 34),
     rule(5),
     ['N' = 12, 'K' = 4, 'Count' = 34, 'Remainder' = 8, 'Withk' = 15, 'K1' = 3, 'Withoutk' = 19],
     [12 > 0,
      4 > 0,
      4 =< 12,
      8 is 12 - 4,
      partitions(8, 4, 15),
      3 is 4 - 1,
      partitions(12, 3, 19),
      34 is 15 + 19]).
step(4 =< 12, builtin, [], []).
step(8 is 12 - 4, builtin, [], []).
step(partitions(8, 4, 15),
     rule(5),
     ['N' = 8, 'K' = 4, 'Count' = 15, 'Remainder' = 4, 'Withk' = 5, 'K1' = 3, 'Withoutk' = 10],
     [8 > 0,
      4 > 0,
      4 =< 8,
      4 is 8 - 4,
      partitions(4, 4, 5),
      3 is 4 - 1,
      partitions(8, 3, 10),
      15 is 5 + 10]).
step(4 =< 8, builtin, [], []).
step(4 is 8 - 4, builtin, [], []).
step(partitions(8, 3, 10),
     rule(5),
     ['N' = 8, 'K' = 3, 'Count' = 10, 'Remainder' = 5, 'Withk' = 5, 'K1' = 2, 'Withoutk' = 5],
     [8 > 0,
      3 > 0,
      3 =< 8,
      5 is 8 - 3,
      partitions(5, 3, 5),
      2 is 3 - 1,
      partitions(8, 2, 5),
      10 is 5 + 5]).
step(3 =< 8, builtin, [], []).
step(5 is 8 - 3, builtin, [], []).
step(partitions(8, 2, 5),
     rule(5),
     ['N' = 8, 'K' = 2, 'Count' = 5, 'Remainder' = 6, 'Withk' = 4, 'K1' = 1, 'Withoutk' = 1],
     [8 > 0,
      2 > 0,
      2 =< 8,
      6 is 8 - 2,
      partitions(6, 2, 4),
      1 is 2 - 1,
      partitions(8, 1, 1),
      5 is 4 + 1]).
step(2 =< 8, builtin, [], []).
step(6 is 8 - 2, builtin, [], []).
step(partitions(8, 1, 1),
     rule(5),
     ['N' = 8, 'K' = 1, 'Count' = 1, 'Remainder' = 7, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [8 > 0,
      1 > 0,
      1 =< 8,
      7 is 8 - 1,
      partitions(7, 1, 1),
      0 is 1 - 1,
      partitions(8, 0, 0),
      1 is 1 + 0]).
step(1 =< 8, builtin, [], []).
step(partitions(8, 0, 0), rule(3), ['N' = 8], [8 > 0]).
step(5 is 4 + 1, builtin, [], []).
step(10 is 5 + 5, builtin, [], []).
step(15 is 5 + 10, builtin, [], []).
step(partitions(12, 3, 19),
     rule(5),
     ['N' = 12, 'K' = 3, 'Count' = 19, 'Remainder' = 9, 'Withk' = 12, 'K1' = 2, 'Withoutk' = 7],
     [12 > 0,
      3 > 0,
      3 =< 12,
      9 is 12 - 3,
      partitions(9, 3, 12),
      2 is 3 - 1,
      partitions(12, 2, 7),
      19 is 12 + 7]).
step(3 =< 12, builtin, [], []).
step(9 is 12 - 3, builtin, [], []).
step(partitions(9, 3, 12),
     rule(5),
     ['N' = 9, 'K' = 3, 'Count' = 12, 'Remainder' = 6, 'Withk' = 7, 'K1' = 2, 'Withoutk' = 5],
     [9 > 0,
      3 > 0,
      3 =< 9,
      6 is 9 - 3,
      partitions(6, 3, 7),
      2 is 3 - 1,
      partitions(9, 2, 5),
      12 is 7 + 5]).
step(3 =< 9, builtin, [], []).
step(6 is 9 - 3, builtin, [], []).
step(partitions(9, 2, 5),
     rule(5),
     ['N' = 9, 'K' = 2, 'Count' = 5, 'Remainder' = 7, 'Withk' = 4, 'K1' = 1, 'Withoutk' = 1],
     [9 > 0,
      2 > 0,
      2 =< 9,
      7 is 9 - 2,
      partitions(7, 2, 4),
      1 is 2 - 1,
      partitions(9, 1, 1),
      5 is 4 + 1]).
step(2 =< 9, builtin, [], []).
step(7 is 9 - 2, builtin, [], []).
step(partitions(9, 1, 1),
     rule(5),
     ['N' = 9, 'K' = 1, 'Count' = 1, 'Remainder' = 8, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [9 > 0,
      1 > 0,
      1 =< 9,
      8 is 9 - 1,
      partitions(8, 1, 1),
      0 is 1 - 1,
      partitions(9, 0, 0),
      1 is 1 + 0]).
step(1 =< 9, builtin, [], []).
step(partitions(9, 0, 0), rule(3), ['N' = 9], [9 > 0]).
step(12 is 7 + 5, builtin, [], []).
step(partitions(12, 2, 7),
     rule(5),
     ['N' = 12, 'K' = 2, 'Count' = 7, 'Remainder' = 10, 'Withk' = 6, 'K1' = 1, 'Withoutk' = 1],
     [12 > 0,
      2 > 0,
      2 =< 12,
      10 is 12 - 2,
      partitions(10, 2, 6),
      1 is 2 - 1,
      partitions(12, 1, 1),
      7 is 6 + 1]).
step(2 =< 12, builtin, [], []).
step(10 is 12 - 2, builtin, [], []).
step(partitions(10, 2, 6),
     rule(5),
     ['N' = 10, 'K' = 2, 'Count' = 6, 'Remainder' = 8, 'Withk' = 5, 'K1' = 1, 'Withoutk' = 1],
     [10 > 0,
      2 > 0,
      2 =< 10,
      8 is 10 - 2,
      partitions(8, 2, 5),
      1 is 2 - 1,
      partitions(10, 1, 1),
      6 is 5 + 1]).
step(2 =< 10, builtin, [], []).
step(8 is 10 - 2, builtin, [], []).
step(partitions(10, 1, 1),
     rule(5),
     ['N' = 10, 'K' = 1, 'Count' = 1, 'Remainder' = 9, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [10 > 0,
      1 > 0,
      1 =< 10,
      9 is 10 - 1,
      partitions(9, 1, 1),
      0 is 1 - 1,
      partitions(10, 0, 0),
      1 is 1 + 0]).
step(1 =< 10, builtin, [], []).
step(partitions(10, 0, 0), rule(3), ['N' = 10], [10 > 0]).
step(6 is 5 + 1, builtin, [], []).
step(partitions(12, 1, 1),
     rule(5),
     ['N' = 12, 'K' = 1, 'Count' = 1, 'Remainder' = 11, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [12 > 0,
      1 > 0,
      1 =< 12,
      11 is 12 - 1,
      partitions(11, 1, 1),
      0 is 1 - 1,
      partitions(12, 0, 0),
      1 is 1 + 0]).
step(1 =< 12, builtin, [], []).
step(partitions(11, 1, 1),
     rule(5),
     ['N' = 11, 'K' = 1, 'Count' = 1, 'Remainder' = 10, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [11 > 0,
      1 > 0,
      1 =< 11,
      10 is 11 - 1,
      partitions(10, 1, 1),
      0 is 1 - 1,
      partitions(11, 0, 0),
      1 is 1 + 0]).
step(1 =< 11, builtin, [], []).
step(partitions(11, 0, 0), rule(3), ['N' = 11], [11 > 0]).
step(partitions(12, 0, 0), rule(3), ['N' = 12], [12 > 0]).
step(7 is 6 + 1, builtin, [], []).
step(19 is 12 + 7, builtin, [], []).
step(34 is 15 + 19, builtin, [], []).
step(47 is 13 + 34, builtin, [], []).
step(58 is 11 + 47, builtin, [], []).
step(65 is 7 + 58, builtin, [], []).
step(70 is 5 + 65, builtin, [], []).
step(73 is 3 + 70, builtin, [], []).
step(75 is 2 + 73, builtin, [], []).
step(76 is 1 + 75, builtin, [], []).
step(77 is 1 + 76, builtin, [], []).
step(partition_answer(p_15, 176), rule(8), ['Count' = 176], [partition_count(15, 176)]).
step(partition_count(15, 176), rule(6), ['N' = 15, 'Count' = 176], [partitions(15, 15, 176)]).
step(partitions(15, 15, 176),
     rule(5),
     ['N' = 15,
      'K' = 15,
      'Count' = 176,
      'Remainder' = 0,
      'Withk' = 1,
      'K1' = 14,
      'Withoutk' = 175],
     [15 > 0,
      15 > 0,
      15 =< 15,
      0 is 15 - 15,
      partitions(0, 15, 1),
      14 is 15 - 1,
      partitions(15, 14, 175),
      176 is 1 + 175]).
step(15 > 0, builtin, [], []).
step(15 =< 15, builtin, [], []).
step(0 is 15 - 15, builtin, [], []).
step(partitions(0, 15, 1), fact(2), [], []).
step(14 is 15 - 1, builtin, [], []).
step(partitions(15, 14, 175),
     rule(5),
     ['N' = 15,
      'K' = 14,
      'Count' = 175,
      'Remainder' = 1,
      'Withk' = 1,
      'K1' = 13,
      'Withoutk' = 174],
     [15 > 0,
      14 > 0,
      14 =< 15,
      1 is 15 - 14,
      partitions(1, 14, 1),
      13 is 14 - 1,
      partitions(15, 13, 174),
      175 is 1 + 174]).
step(14 > 0, builtin, [], []).
step(14 =< 15, builtin, [], []).
step(1 is 15 - 14, builtin, [], []).
step(partitions(1, 14, 1),
     rule(4),
     ['N' = 1, 'K' = 14, 'Count' = 1, 'K1' = 13],
     [1 > 0, 14 > 0, 14 > 1, 13 is 14 - 1, partitions(1, 13, 1)]).
step(14 > 1, builtin, [], []).
step(13 is 14 - 1, builtin, [], []).
step(partitions(1, 13, 1),
     rule(4),
     ['N' = 1, 'K' = 13, 'Count' = 1, 'K1' = 12],
     [1 > 0, 13 > 0, 13 > 1, 12 is 13 - 1, partitions(1, 12, 1)]).
step(13 > 0, builtin, [], []).
step(13 > 1, builtin, [], []).
step(12 is 13 - 1, builtin, [], []).
step(partitions(1, 12, 1),
     rule(4),
     ['N' = 1, 'K' = 12, 'Count' = 1, 'K1' = 11],
     [1 > 0, 12 > 0, 12 > 1, 11 is 12 - 1, partitions(1, 11, 1)]).
step(12 > 1, builtin, [], []).
step(partitions(15, 13, 174),
     rule(5),
     ['N' = 15,
      'K' = 13,
      'Count' = 174,
      'Remainder' = 2,
      'Withk' = 2,
      'K1' = 12,
      'Withoutk' = 172],
     [15 > 0,
      13 > 0,
      13 =< 15,
      2 is 15 - 13,
      partitions(2, 13, 2),
      12 is 13 - 1,
      partitions(15, 12, 172),
      174 is 2 + 172]).
step(13 =< 15, builtin, [], []).
step(2 is 15 - 13, builtin, [], []).
step(partitions(2, 13, 2),
     rule(4),
     ['N' = 2, 'K' = 13, 'Count' = 2, 'K1' = 12],
     [2 > 0, 13 > 0, 13 > 2, 12 is 13 - 1, partitions(2, 12, 2)]).
step(13 > 2, builtin, [], []).
step(partitions(2, 12, 2),
     rule(4),
     ['N' = 2, 'K' = 12, 'Count' = 2, 'K1' = 11],
     [2 > 0, 12 > 0, 12 > 2, 11 is 12 - 1, partitions(2, 11, 2)]).
step(12 > 2, builtin, [], []).
step(partitions(2, 11, 2),
     rule(4),
     ['N' = 2, 'K' = 11, 'Count' = 2, 'K1' = 10],
     [2 > 0, 11 > 0, 11 > 2, 10 is 11 - 1, partitions(2, 10, 2)]).
step(11 > 2, builtin, [], []).
step(partitions(15, 12, 172),
     rule(5),
     ['N' = 15,
      'K' = 12,
      'Count' = 172,
      'Remainder' = 3,
      'Withk' = 3,
      'K1' = 11,
      'Withoutk' = 169],
     [15 > 0,
      12 > 0,
      12 =< 15,
      3 is 15 - 12,
      partitions(3, 12, 3),
      11 is 12 - 1,
      partitions(15, 11, 169),
      172 is 3 + 169]).
step(12 =< 15, builtin, [], []).
step(3 is 15 - 12, builtin, [], []).
step(partitions(3, 12, 3),
     rule(4),
     ['N' = 3, 'K' = 12, 'Count' = 3, 'K1' = 11],
     [3 > 0, 12 > 0, 12 > 3, 11 is 12 - 1, partitions(3, 11, 3)]).
step(12 > 3, builtin, [], []).
step(partitions(3, 11, 3),
     rule(4),
     ['N' = 3, 'K' = 11, 'Count' = 3, 'K1' = 10],
     [3 > 0, 11 > 0, 11 > 3, 10 is 11 - 1, partitions(3, 10, 3)]).
step(11 > 3, builtin, [], []).
step(partitions(3, 10, 3),
     rule(4),
     ['N' = 3, 'K' = 10, 'Count' = 3, 'K1' = 9],
     [3 > 0, 10 > 0, 10 > 3, 9 is 10 - 1, partitions(3, 9, 3)]).
step(10 > 3, builtin, [], []).
step(partitions(15, 11, 169),
     rule(5),
     ['N' = 15,
      'K' = 11,
      'Count' = 169,
      'Remainder' = 4,
      'Withk' = 5,
      'K1' = 10,
      'Withoutk' = 164],
     [15 > 0,
      11 > 0,
      11 =< 15,
      4 is 15 - 11,
      partitions(4, 11, 5),
      10 is 11 - 1,
      partitions(15, 10, 164),
      169 is 5 + 164]).
step(11 =< 15, builtin, [], []).
step(4 is 15 - 11, builtin, [], []).
step(partitions(4, 11, 5),
     rule(4),
     ['N' = 4, 'K' = 11, 'Count' = 5, 'K1' = 10],
     [4 > 0, 11 > 0, 11 > 4, 10 is 11 - 1, partitions(4, 10, 5)]).
step(11 > 4, builtin, [], []).
step(partitions(4, 10, 5),
     rule(4),
     ['N' = 4, 'K' = 10, 'Count' = 5, 'K1' = 9],
     [4 > 0, 10 > 0, 10 > 4, 9 is 10 - 1, partitions(4, 9, 5)]).
step(10 > 4, builtin, [], []).
step(partitions(4, 9, 5),
     rule(4),
     ['N' = 4, 'K' = 9, 'Count' = 5, 'K1' = 8],
     [4 > 0, 9 > 0, 9 > 4, 8 is 9 - 1, partitions(4, 8, 5)]).
step(9 > 4, builtin, [], []).
step(partitions(15, 10, 164),
     rule(5),
     ['N' = 15,
      'K' = 10,
      'Count' = 164,
      'Remainder' = 5,
      'Withk' = 7,
      'K1' = 9,
      'Withoutk' = 157],
     [15 > 0,
      10 > 0,
      10 =< 15,
      5 is 15 - 10,
      partitions(5, 10, 7),
      9 is 10 - 1,
      partitions(15, 9, 157),
      164 is 7 + 157]).
step(10 =< 15, builtin, [], []).
step(5 is 15 - 10, builtin, [], []).
step(partitions(5, 10, 7),
     rule(4),
     ['N' = 5, 'K' = 10, 'Count' = 7, 'K1' = 9],
     [5 > 0, 10 > 0, 10 > 5, 9 is 10 - 1, partitions(5, 9, 7)]).
step(10 > 5, builtin, [], []).
step(partitions(5, 9, 7),
     rule(4),
     ['N' = 5, 'K' = 9, 'Count' = 7, 'K1' = 8],
     [5 > 0, 9 > 0, 9 > 5, 8 is 9 - 1, partitions(5, 8, 7)]).
step(9 > 5, builtin, [], []).
step(partitions(5, 8, 7),
     rule(4),
     ['N' = 5, 'K' = 8, 'Count' = 7, 'K1' = 7],
     [5 > 0, 8 > 0, 8 > 5, 7 is 8 - 1, partitions(5, 7, 7)]).
step(8 > 5, builtin, [], []).
step(partitions(15, 9, 157),
     rule(5),
     ['N' = 15,
      'K' = 9,
      'Count' = 157,
      'Remainder' = 6,
      'Withk' = 11,
      'K1' = 8,
      'Withoutk' = 146],
     [15 > 0,
      9 > 0,
      9 =< 15,
      6 is 15 - 9,
      partitions(6, 9, 11),
      8 is 9 - 1,
      partitions(15, 8, 146),
      157 is 11 + 146]).
step(9 =< 15, builtin, [], []).
step(6 is 15 - 9, builtin, [], []).
step(partitions(6, 9, 11),
     rule(4),
     ['N' = 6, 'K' = 9, 'Count' = 11, 'K1' = 8],
     [6 > 0, 9 > 0, 9 > 6, 8 is 9 - 1, partitions(6, 8, 11)]).
step(9 > 6, builtin, [], []).
step(partitions(6, 8, 11),
     rule(4),
     ['N' = 6, 'K' = 8, 'Count' = 11, 'K1' = 7],
     [6 > 0, 8 > 0, 8 > 6, 7 is 8 - 1, partitions(6, 7, 11)]).
step(8 > 6, builtin, [], []).
step(partitions(6, 7, 11),
     rule(4),
     ['N' = 6, 'K' = 7, 'Count' = 11, 'K1' = 6],
     [6 > 0, 7 > 0, 7 > 6, 6 is 7 - 1, partitions(6, 6, 11)]).
step(7 > 6, builtin, [], []).
step(partitions(15, 8, 146),
     rule(5),
     ['N' = 15,
      'K' = 8,
      'Count' = 146,
      'Remainder' = 7,
      'Withk' = 15,
      'K1' = 7,
      'Withoutk' = 131],
     [15 > 0,
      8 > 0,
      8 =< 15,
      7 is 15 - 8,
      partitions(7, 8, 15),
      7 is 8 - 1,
      partitions(15, 7, 131),
      146 is 15 + 131]).
step(8 =< 15, builtin, [], []).
step(7 is 15 - 8, builtin, [], []).
step(partitions(7, 8, 15),
     rule(4),
     ['N' = 7, 'K' = 8, 'Count' = 15, 'K1' = 7],
     [7 > 0, 8 > 0, 8 > 7, 7 is 8 - 1, partitions(7, 7, 15)]).
step(8 > 7, builtin, [], []).
step(partitions(7, 7, 15),
     rule(5),
     ['N' = 7, 'K' = 7, 'Count' = 15, 'Remainder' = 0, 'Withk' = 1, 'K1' = 6, 'Withoutk' = 14],
     [7 > 0,
      7 > 0,
      7 =< 7,
      0 is 7 - 7,
      partitions(0, 7, 1),
      6 is 7 - 1,
      partitions(7, 6, 14),
      15 is 1 + 14]).
step(7 =< 7, builtin, [], []).
step(0 is 7 - 7, builtin, [], []).
step(partitions(0, 7, 1), fact(2), [], []).
step(partitions(7, 6, 14),
     rule(5),
     ['N' = 7, 'K' = 6, 'Count' = 14, 'Remainder' = 1, 'Withk' = 1, 'K1' = 5, 'Withoutk' = 13],
     [7 > 0,
      6 > 0,
      6 =< 7,
      1 is 7 - 6,
      partitions(1, 6, 1),
      5 is 6 - 1,
      partitions(7, 5, 13),
      14 is 1 + 13]).
step(6 =< 7, builtin, [], []).
step(1 is 7 - 6, builtin, [], []).
step(14 is 1 + 13, builtin, [], []).
step(15 is 1 + 14, builtin, [], []).
step(partitions(15, 7, 131),
     rule(5),
     ['N' = 15,
      'K' = 7,
      'Count' = 131,
      'Remainder' = 8,
      'Withk' = 21,
      'K1' = 6,
      'Withoutk' = 110],
     [15 > 0,
      7 > 0,
      7 =< 15,
      8 is 15 - 7,
      partitions(8, 7, 21),
      6 is 7 - 1,
      partitions(15, 6, 110),
      131 is 21 + 110]).
step(7 =< 15, builtin, [], []).
step(8 is 15 - 7, builtin, [], []).
step(partitions(8, 7, 21),
     rule(5),
     ['N' = 8, 'K' = 7, 'Count' = 21, 'Remainder' = 1, 'Withk' = 1, 'K1' = 6, 'Withoutk' = 20],
     [8 > 0,
      7 > 0,
      7 =< 8,
      1 is 8 - 7,
      partitions(1, 7, 1),
      6 is 7 - 1,
      partitions(8, 6, 20),
      21 is 1 + 20]).
step(7 =< 8, builtin, [], []).
step(1 is 8 - 7, builtin, [], []).
step(partitions(8, 6, 20),
     rule(5),
     ['N' = 8, 'K' = 6, 'Count' = 20, 'Remainder' = 2, 'Withk' = 2, 'K1' = 5, 'Withoutk' = 18],
     [8 > 0,
      6 > 0,
      6 =< 8,
      2 is 8 - 6,
      partitions(2, 6, 2),
      5 is 6 - 1,
      partitions(8, 5, 18),
      20 is 2 + 18]).
step(6 =< 8, builtin, [], []).
step(2 is 8 - 6, builtin, [], []).
step(partitions(8, 5, 18),
     rule(5),
     ['N' = 8, 'K' = 5, 'Count' = 18, 'Remainder' = 3, 'Withk' = 3, 'K1' = 4, 'Withoutk' = 15],
     [8 > 0,
      5 > 0,
      5 =< 8,
      3 is 8 - 5,
      partitions(3, 5, 3),
      4 is 5 - 1,
      partitions(8, 4, 15),
      18 is 3 + 15]).
step(5 =< 8, builtin, [], []).
step(3 is 8 - 5, builtin, [], []).
step(18 is 3 + 15, builtin, [], []).
step(20 is 2 + 18, builtin, [], []).
step(21 is 1 + 20, builtin, [], []).
step(partitions(15, 6, 110),
     rule(5),
     ['N' = 15,
      'K' = 6,
      'Count' = 110,
      'Remainder' = 9,
      'Withk' = 26,
      'K1' = 5,
      'Withoutk' = 84],
     [15 > 0,
      6 > 0,
      6 =< 15,
      9 is 15 - 6,
      partitions(9, 6, 26),
      5 is 6 - 1,
      partitions(15, 5, 84),
      110 is 26 + 84]).
step(6 =< 15, builtin, [], []).
step(9 is 15 - 6, builtin, [], []).
step(partitions(9, 6, 26),
     rule(5),
     ['N' = 9, 'K' = 6, 'Count' = 26, 'Remainder' = 3, 'Withk' = 3, 'K1' = 5, 'Withoutk' = 23],
     [9 > 0,
      6 > 0,
      6 =< 9,
      3 is 9 - 6,
      partitions(3, 6, 3),
      5 is 6 - 1,
      partitions(9, 5, 23),
      26 is 3 + 23]).
step(6 =< 9, builtin, [], []).
step(3 is 9 - 6, builtin, [], []).
step(partitions(9, 5, 23),
     rule(5),
     ['N' = 9, 'K' = 5, 'Count' = 23, 'Remainder' = 4, 'Withk' = 5, 'K1' = 4, 'Withoutk' = 18],
     [9 > 0,
      5 > 0,
      5 =< 9,
      4 is 9 - 5,
      partitions(4, 5, 5),
      4 is 5 - 1,
      partitions(9, 4, 18),
      23 is 5 + 18]).
step(5 =< 9, builtin, [], []).
step(4 is 9 - 5, builtin, [], []).
step(partitions(9, 4, 18),
     rule(5),
     ['N' = 9, 'K' = 4, 'Count' = 18, 'Remainder' = 5, 'Withk' = 6, 'K1' = 3, 'Withoutk' = 12],
     [9 > 0,
      4 > 0,
      4 =< 9,
      5 is 9 - 4,
      partitions(5, 4, 6),
      3 is 4 - 1,
      partitions(9, 3, 12),
      18 is 6 + 12]).
step(4 =< 9, builtin, [], []).
step(5 is 9 - 4, builtin, [], []).
step(18 is 6 + 12, builtin, [], []).
step(23 is 5 + 18, builtin, [], []).
step(26 is 3 + 23, builtin, [], []).
step(partitions(15, 5, 84),
     rule(5),
     ['N' = 15,
      'K' = 5,
      'Count' = 84,
      'Remainder' = 10,
      'Withk' = 30,
      'K1' = 4,
      'Withoutk' = 54],
     [15 > 0,
      5 > 0,
      5 =< 15,
      10 is 15 - 5,
      partitions(10, 5, 30),
      4 is 5 - 1,
      partitions(15, 4, 54),
      84 is 30 + 54]).
step(5 =< 15, builtin, [], []).
step(10 is 15 - 5, builtin, [], []).
step(partitions(10, 5, 30),
     rule(5),
     ['N' = 10, 'K' = 5, 'Count' = 30, 'Remainder' = 5, 'Withk' = 7, 'K1' = 4, 'Withoutk' = 23],
     [10 > 0,
      5 > 0,
      5 =< 10,
      5 is 10 - 5,
      partitions(5, 5, 7),
      4 is 5 - 1,
      partitions(10, 4, 23),
      30 is 7 + 23]).
step(5 =< 10, builtin, [], []).
step(5 is 10 - 5, builtin, [], []).
step(partitions(10, 4, 23),
     rule(5),
     ['N' = 10, 'K' = 4, 'Count' = 23, 'Remainder' = 6, 'Withk' = 9, 'K1' = 3, 'Withoutk' = 14],
     [10 > 0,
      4 > 0,
      4 =< 10,
      6 is 10 - 4,
      partitions(6, 4, 9),
      3 is 4 - 1,
      partitions(10, 3, 14),
      23 is 9 + 14]).
step(4 =< 10, builtin, [], []).
step(6 is 10 - 4, builtin, [], []).
step(partitions(10, 3, 14),
     rule(5),
     ['N' = 10, 'K' = 3, 'Count' = 14, 'Remainder' = 7, 'Withk' = 8, 'K1' = 2, 'Withoutk' = 6],
     [10 > 0,
      3 > 0,
      3 =< 10,
      7 is 10 - 3,
      partitions(7, 3, 8),
      2 is 3 - 1,
      partitions(10, 2, 6),
      14 is 8 + 6]).
step(3 =< 10, builtin, [], []).
step(7 is 10 - 3, builtin, [], []).
step(14 is 8 + 6, builtin, [], []).
step(23 is 9 + 14, builtin, [], []).
step(30 is 7 + 23, builtin, [], []).
step(partitions(15, 4, 54),
     rule(5),
     ['N' = 15,
      'K' = 4,
      'Count' = 54,
      'Remainder' = 11,
      'Withk' = 27,
      'K1' = 3,
      'Withoutk' = 27],
     [15 > 0,
      4 > 0,
      4 =< 15,
      11 is 15 - 4,
      partitions(11, 4, 27),
      3 is 4 - 1,
      partitions(15, 3, 27),
      54 is 27 + 27]).
step(4 =< 15, builtin, [], []).
step(11 is 15 - 4, builtin, [], []).
step(partitions(11, 4, 27),
     rule(5),
     ['N' = 11, 'K' = 4, 'Count' = 27, 'Remainder' = 7, 'Withk' = 11, 'K1' = 3, 'Withoutk' = 16],
     [11 > 0,
      4 > 0,
      4 =< 11,
      7 is 11 - 4,
      partitions(7, 4, 11),
      3 is 4 - 1,
      partitions(11, 3, 16),
      27 is 11 + 16]).
step(4 =< 11, builtin, [], []).
step(7 is 11 - 4, builtin, [], []).
step(partitions(11, 3, 16),
     rule(5),
     ['N' = 11, 'K' = 3, 'Count' = 16, 'Remainder' = 8, 'Withk' = 10, 'K1' = 2, 'Withoutk' = 6],
     [11 > 0,
      3 > 0,
      3 =< 11,
      8 is 11 - 3,
      partitions(8, 3, 10),
      2 is 3 - 1,
      partitions(11, 2, 6),
      16 is 10 + 6]).
step(3 =< 11, builtin, [], []).
step(8 is 11 - 3, builtin, [], []).
step(partitions(11, 2, 6),
     rule(5),
     ['N' = 11, 'K' = 2, 'Count' = 6, 'Remainder' = 9, 'Withk' = 5, 'K1' = 1, 'Withoutk' = 1],
     [11 > 0,
      2 > 0,
      2 =< 11,
      9 is 11 - 2,
      partitions(9, 2, 5),
      1 is 2 - 1,
      partitions(11, 1, 1),
      6 is 5 + 1]).
step(2 =< 11, builtin, [], []).
step(9 is 11 - 2, builtin, [], []).
step(16 is 10 + 6, builtin, [], []).
step(27 is 11 + 16, builtin, [], []).
step(partitions(15, 3, 27),
     rule(5),
     ['N' = 15, 'K' = 3, 'Count' = 27, 'Remainder' = 12, 'Withk' = 19, 'K1' = 2, 'Withoutk' = 8],
     [15 > 0,
      3 > 0,
      3 =< 15,
      12 is 15 - 3,
      partitions(12, 3, 19),
      2 is 3 - 1,
      partitions(15, 2, 8),
      27 is 19 + 8]).
step(3 =< 15, builtin, [], []).
step(12 is 15 - 3, builtin, [], []).
step(partitions(15, 2, 8),
     rule(5),
     ['N' = 15, 'K' = 2, 'Count' = 8, 'Remainder' = 13, 'Withk' = 7, 'K1' = 1, 'Withoutk' = 1],
     [15 > 0,
      2 > 0,
      2 =< 15,
      13 is 15 - 2,
      partitions(13, 2, 7),
      1 is 2 - 1,
      partitions(15, 1, 1),
      8 is 7 + 1]).
step(2 =< 15, builtin, [], []).
step(13 is 15 - 2, builtin, [], []).
step(partitions(13, 2, 7),
     rule(5),
     ['N' = 13, 'K' = 2, 'Count' = 7, 'Remainder' = 11, 'Withk' = 6, 'K1' = 1, 'Withoutk' = 1],
     [13 > 0,
      2 > 0,
      2 =< 13,
      11 is 13 - 2,
      partitions(11, 2, 6),
      1 is 2 - 1,
      partitions(13, 1, 1),
      7 is 6 + 1]).
step(2 =< 13, builtin, [], []).
step(11 is 13 - 2, builtin, [], []).
step(partitions(13, 1, 1),
     rule(5),
     ['N' = 13, 'K' = 1, 'Count' = 1, 'Remainder' = 12, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [13 > 0,
      1 > 0,
      1 =< 13,
      12 is 13 - 1,
      partitions(12, 1, 1),
      0 is 1 - 1,
      partitions(13, 0, 0),
      1 is 1 + 0]).
step(1 =< 13, builtin, [], []).
step(partitions(13, 0, 0), rule(3), ['N' = 13], [13 > 0]).
step(partitions(15, 1, 1),
     rule(5),
     ['N' = 15, 'K' = 1, 'Count' = 1, 'Remainder' = 14, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [15 > 0,
      1 > 0,
      1 =< 15,
      14 is 15 - 1,
      partitions(14, 1, 1),
      0 is 1 - 1,
      partitions(15, 0, 0),
      1 is 1 + 0]).
step(1 =< 15, builtin, [], []).
step(partitions(14, 1, 1),
     rule(5),
     ['N' = 14, 'K' = 1, 'Count' = 1, 'Remainder' = 13, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [14 > 0,
      1 > 0,
      1 =< 14,
      13 is 14 - 1,
      partitions(13, 1, 1),
      0 is 1 - 1,
      partitions(14, 0, 0),
      1 is 1 + 0]).
step(1 =< 14, builtin, [], []).
step(partitions(14, 0, 0), rule(3), ['N' = 14], [14 > 0]).
step(partitions(15, 0, 0), rule(3), ['N' = 15], [15 > 0]).
step(8 is 7 + 1, builtin, [], []).
step(27 is 19 + 8, builtin, [], []).
step(54 is 27 + 27, builtin, [], []).
step(84 is 30 + 54, builtin, [], []).
step(110 is 26 + 84, builtin, [], []).
step(131 is 21 + 110, builtin, [], []).
step(146 is 15 + 131, builtin, [], []).
step(157 is 11 + 146, builtin, [], []).
step(164 is 7 + 157, builtin, [], []).
step(169 is 5 + 164, builtin, [], []).
step(172 is 3 + 169, builtin, [], []).
step(174 is 2 + 172, builtin, [], []).
step(175 is 1 + 174, builtin, [], []).
step(176 is 1 + 175, builtin, [], []).
step(partition_answer(p_16_using_parts_at_most_5, 101),
     rule(9),
     ['Count' = 101],
     [partitions(16, 5, 101)]).
step(partitions(16, 5, 101),
     rule(5),
     ['N' = 16,
      'K' = 5,
      'Count' = 101,
      'Remainder' = 11,
      'Withk' = 37,
      'K1' = 4,
      'Withoutk' = 64],
     [16 > 0,
      5 > 0,
      5 =< 16,
      11 is 16 - 5,
      partitions(11, 5, 37),
      4 is 5 - 1,
      partitions(16, 4, 64),
      101 is 37 + 64]).
step(16 > 0, builtin, [], []).
step(5 =< 16, builtin, [], []).
step(11 is 16 - 5, builtin, [], []).
step(partitions(11, 5, 37),
     rule(5),
     ['N' = 11, 'K' = 5, 'Count' = 37, 'Remainder' = 6, 'Withk' = 10, 'K1' = 4, 'Withoutk' = 27],
     [11 > 0,
      5 > 0,
      5 =< 11,
      6 is 11 - 5,
      partitions(6, 5, 10),
      4 is 5 - 1,
      partitions(11, 4, 27),
      37 is 10 + 27]).
step(5 =< 11, builtin, [], []).
step(6 is 11 - 5, builtin, [], []).
step(37 is 10 + 27, builtin, [], []).
step(partitions(16, 4, 64),
     rule(5),
     ['N' = 16,
      'K' = 4,
      'Count' = 64,
      'Remainder' = 12,
      'Withk' = 34,
      'K1' = 3,
      'Withoutk' = 30],
     [16 > 0,
      4 > 0,
      4 =< 16,
      12 is 16 - 4,
      partitions(12, 4, 34),
      3 is 4 - 1,
      partitions(16, 3, 30),
      64 is 34 + 30]).
step(4 =< 16, builtin, [], []).
step(12 is 16 - 4, builtin, [], []).
step(partitions(16, 3, 30),
     rule(5),
     ['N' = 16, 'K' = 3, 'Count' = 30, 'Remainder' = 13, 'Withk' = 21, 'K1' = 2, 'Withoutk' = 9],
     [16 > 0,
      3 > 0,
      3 =< 16,
      13 is 16 - 3,
      partitions(13, 3, 21),
      2 is 3 - 1,
      partitions(16, 2, 9),
      30 is 21 + 9]).
step(3 =< 16, builtin, [], []).
step(13 is 16 - 3, builtin, [], []).
step(partitions(13, 3, 21),
     rule(5),
     ['N' = 13, 'K' = 3, 'Count' = 21, 'Remainder' = 10, 'Withk' = 14, 'K1' = 2, 'Withoutk' = 7],
     [13 > 0,
      3 > 0,
      3 =< 13,
      10 is 13 - 3,
      partitions(10, 3, 14),
      2 is 3 - 1,
      partitions(13, 2, 7),
      21 is 14 + 7]).
step(3 =< 13, builtin, [], []).
step(10 is 13 - 3, builtin, [], []).
step(21 is 14 + 7, builtin, [], []).
step(partitions(16, 2, 9),
     rule(5),
     ['N' = 16, 'K' = 2, 'Count' = 9, 'Remainder' = 14, 'Withk' = 8, 'K1' = 1, 'Withoutk' = 1],
     [16 > 0,
      2 > 0,
      2 =< 16,
      14 is 16 - 2,
      partitions(14, 2, 8),
      1 is 2 - 1,
      partitions(16, 1, 1),
      9 is 8 + 1]).
step(2 =< 16, builtin, [], []).
step(14 is 16 - 2, builtin, [], []).
step(partitions(14, 2, 8),
     rule(5),
     ['N' = 14, 'K' = 2, 'Count' = 8, 'Remainder' = 12, 'Withk' = 7, 'K1' = 1, 'Withoutk' = 1],
     [14 > 0,
      2 > 0,
      2 =< 14,
      12 is 14 - 2,
      partitions(12, 2, 7),
      1 is 2 - 1,
      partitions(14, 1, 1),
      8 is 7 + 1]).
step(2 =< 14, builtin, [], []).
step(12 is 14 - 2, builtin, [], []).
step(partitions(16, 1, 1),
     rule(5),
     ['N' = 16, 'K' = 1, 'Count' = 1, 'Remainder' = 15, 'Withk' = 1, 'K1' = 0, 'Withoutk' = 0],
     [16 > 0,
      1 > 0,
      1 =< 16,
      15 is 16 - 1,
      partitions(15, 1, 1),
      0 is 1 - 1,
      partitions(16, 0, 0),
      1 is 1 + 0]).
step(1 =< 16, builtin, [], []).
step(15 is 16 - 1, builtin, [], []).
step(partitions(16, 0, 0), rule(3), ['N' = 16], [16 > 0]).
step(9 is 8 + 1, builtin, [], []).
step(30 is 21 + 9, builtin, [], []).
step(64 is 34 + 30, builtin, [], []).
step(101 is 37 + 64, builtin, [], []).
step(partition_answer(cumulative_p_1_to_8, 66),
     rule(10),
     ['Sum' = 66],
     [sumall(Expression, (between(1, 8, N), partition_count(N, Expression)), 66)]).
step(sumall(Expression, (between(1, 8, N), partition_count(N, Expression)), 66),
     builtin,
     [],
     []).
