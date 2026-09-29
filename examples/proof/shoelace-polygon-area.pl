polygon_area(sample, 7.5).

clause(1, sample_polygon([[3, 2], [6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]]), true).
clause(2, area([anonymous(1)], 0), true).
clause(3,
       area([[var('A'), var('B')], [var('C'), var('D')] | var('Rest')], var('Total')),
       (area([[var('C'), var('D')] | var('Rest')], var('Subtotal')),
        var('Ad') is var('A') * var('D'),
        var('Bc') is var('B') * var('C'),
        var('Cross') is var('Ad') - var('Bc'),
        var('Half') is var('Cross') / 2.0,
        var('Total') is var('Half') + var('Subtotal'))).
clause(4,
       polygon_area(sample, var('Area')),
       (sample_polygon(var('Points')), area(var('Points'), var('Area')))).

step(polygon_area(sample, 7.5),
     rule(4),
     ['Area' = 7.5, 'Points' = [[3, 2], [6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]]],
     [sample_polygon([[3, 2], [6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]]),
      area([[3, 2], [6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]], 7.5)]).
step(sample_polygon([[3, 2], [6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]]), fact(1), [], []).
step(area([[3, 2], [6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]], 7.5),
     rule(3),
     ['A' = 3,
      'B' = 2,
      'C' = 6,
      'D' = 2,
      'Rest' = [[7, 6], [4, 6], [5, 5], [5, 3], [3, 2]],
      'Total' = 7.5,
      'Subtotal' = 10.5,
      'Ad' = 6,
      'Bc' = 12,
      'Cross' = -6,
      'Half' = -3.0],
     [area([[6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]], 10.5),
      6 is 3 * 2,
      12 is 2 * 6,
      -6 is 6 - 12,
      -3.0 is -6 / 2.0,
      7.5 is -3.0 + 10.5]).
step(area([[6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]], 10.5),
     rule(3),
     ['A' = 6,
      'B' = 2,
      'C' = 7,
      'D' = 6,
      'Rest' = [[4, 6], [5, 5], [5, 3], [3, 2]],
      'Total' = 10.5,
      'Subtotal' = -0.5,
      'Ad' = 36,
      'Bc' = 14,
      'Cross' = 22,
      'Half' = 11.0],
     [area([[7, 6], [4, 6], [5, 5], [5, 3], [3, 2]], -0.5),
      36 is 6 * 6,
      14 is 2 * 7,
      22 is 36 - 14,
      11.0 is 22 / 2.0,
      10.5 is 11.0 + -0.5]).
step(area([[7, 6], [4, 6], [5, 5], [5, 3], [3, 2]], -0.5),
     rule(3),
     ['A' = 7,
      'B' = 6,
      'C' = 4,
      'D' = 6,
      'Rest' = [[5, 5], [5, 3], [3, 2]],
      'Total' = -0.5,
      'Subtotal' = -9.5,
      'Ad' = 42,
      'Bc' = 24,
      'Cross' = 18,
      'Half' = 9.0],
     [area([[4, 6], [5, 5], [5, 3], [3, 2]], -9.5),
      42 is 7 * 6,
      24 is 6 * 4,
      18 is 42 - 24,
      9.0 is 18 / 2.0,
      -0.5 is 9.0 + -9.5]).
step(area([[4, 6], [5, 5], [5, 3], [3, 2]], -9.5),
     rule(3),
     ['A' = 4,
      'B' = 6,
      'C' = 5,
      'D' = 5,
      'Rest' = [[5, 3], [3, 2]],
      'Total' = -9.5,
      'Subtotal' = -4.5,
      'Ad' = 20,
      'Bc' = 30,
      'Cross' = -10,
      'Half' = -5.0],
     [area([[5, 5], [5, 3], [3, 2]], -4.5),
      20 is 4 * 5,
      30 is 6 * 5,
      -10 is 20 - 30,
      -5.0 is -10 / 2.0,
      -9.5 is -5.0 + -4.5]).
step(area([[5, 5], [5, 3], [3, 2]], -4.5),
     rule(3),
     ['A' = 5,
      'B' = 5,
      'C' = 5,
      'D' = 3,
      'Rest' = [[3, 2]],
      'Total' = -4.5,
      'Subtotal' = 0.5,
      'Ad' = 15,
      'Bc' = 25,
      'Cross' = -10,
      'Half' = -5.0],
     [area([[5, 3], [3, 2]], 0.5),
      15 is 5 * 3,
      25 is 5 * 5,
      -10 is 15 - 25,
      -5.0 is -10 / 2.0,
      -4.5 is -5.0 + 0.5]).
step(area([[5, 3], [3, 2]], 0.5),
     rule(3),
     ['A' = 5,
      'B' = 3,
      'C' = 3,
      'D' = 2,
      'Rest' = [],
      'Total' = 0.5,
      'Subtotal' = 0,
      'Ad' = 10,
      'Bc' = 9,
      'Cross' = 1,
      'Half' = 0.5],
     [area([[3, 2]], 0), 10 is 5 * 2, 9 is 3 * 3, 1 is 10 - 9, 0.5 is 1 / 2.0, 0.5 is 0.5 + 0]).
step(area([[3, 2]], 0), fact(2), [], []).
step(10 is 5 * 2, builtin, [], []).
step(9 is 3 * 3, builtin, [], []).
step(1 is 10 - 9, builtin, [], []).
step(0.5 is 1 / 2.0, builtin, [], []).
step(0.5 is 0.5 + 0, builtin, [], []).
step(15 is 5 * 3, builtin, [], []).
step(25 is 5 * 5, builtin, [], []).
step(-10 is 15 - 25, builtin, [], []).
step(-5.0 is -10 / 2.0, builtin, [], []).
step(-4.5 is -5.0 + 0.5, builtin, [], []).
step(20 is 4 * 5, builtin, [], []).
step(30 is 6 * 5, builtin, [], []).
step(-10 is 20 - 30, builtin, [], []).
step(-9.5 is -5.0 + -4.5, builtin, [], []).
step(42 is 7 * 6, builtin, [], []).
step(24 is 6 * 4, builtin, [], []).
step(18 is 42 - 24, builtin, [], []).
step(9.0 is 18 / 2.0, builtin, [], []).
step(-0.5 is 9.0 + -9.5, builtin, [], []).
step(36 is 6 * 6, builtin, [], []).
step(14 is 2 * 7, builtin, [], []).
step(22 is 36 - 14, builtin, [], []).
step(11.0 is 22 / 2.0, builtin, [], []).
step(10.5 is 11.0 + -0.5, builtin, [], []).
step(6 is 3 * 2, builtin, [], []).
step(12 is 2 * 6, builtin, [], []).
step(-6 is 6 - 12, builtin, [], []).
step(-3.0 is -6 / 2.0, builtin, [], []).
step(7.5 is -3.0 + 10.5, builtin, [], []).
