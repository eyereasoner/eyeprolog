mean(scores, 5.0).
count(scores, 8).
populationVariance(scores, 4.0).
populationStddev(scores, 2.0).

clause(1, sample(scores, [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]), true).
clause(2, sum([], 0.0), true).
clause(3,
       sum([var('X') | var('Xs')], var('Total')),
       (sum(var('Xs'), var('Rest')), var('Total') is var('X') + var('Rest'))).
clause(4,
       mean(var('Name'), var('Mean')),
       (sample(var('Name'), var('Values')),
        sum(var('Values'), var('Total')),
        length(var('Values'), var('Count')),
        var('Mean') is var('Total') / var('Count'))).
clause(5, squared_error_sum([], anonymous(1), 0.0), true).
clause(6,
       squared_error_sum([var('X') | var('Xs')], var('Mean'), var('Total')),
       (var('Delta') is var('X') - var('Mean'),
        var('Squared') is var('Delta') ** 2.0,
        squared_error_sum(var('Xs'), var('Mean'), var('Rest')),
        var('Total') is var('Squared') + var('Rest'))).
clause(7,
       population_variance(var('Name'), var('Variance')),
       (sample(var('Name'), var('Values')),
        mean(var('Name'), var('Mean')),
        squared_error_sum(var('Values'), var('Mean'), var('Sumsquarederrors')),
        length(var('Values'), var('Count')),
        var('Variance') is var('Sumsquarederrors') / var('Count'))).
clause(8,
       population_stddev(var('Name'), var('Stddev')),
       (population_variance(var('Name'), var('Variance')),
        var('Stddev') is var('Variance') ** 0.5)).
clause(9,
       count(var('Name'), var('Count')),
       (sample(var('Name'), var('Values')), length(var('Values'), var('Count')))).
clause(10,
       populationVariance(var('Name'), var('Variance')),
       population_variance(var('Name'), var('Variance'))).
clause(11,
       populationStddev(var('Name'), var('Stddev')),
       population_stddev(var('Name'), var('Stddev'))).

step(mean(scores, 5.0),
     rule(4),
     ['Name' = scores,
      'Mean' = 5.0,
      'Values' = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0],
      'Total' = 40.0,
      'Count' = 8],
     [sample(scores, [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]),
      sum([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 40.0),
      length([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 8),
      5.0 is 40.0 / 8]).
step(sample(scores, [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]), fact(1), [], []).
step(sum([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 40.0),
     rule(3),
     ['X' = 2.0, 'Xs' = [4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 'Total' = 40.0, 'Rest' = 38.0],
     [sum([4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 38.0), 40.0 is 2.0 + 38.0]).
step(sum([4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 38.0),
     rule(3),
     ['X' = 4.0, 'Xs' = [4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 'Total' = 38.0, 'Rest' = 34.0],
     [sum([4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 34.0), 38.0 is 4.0 + 34.0]).
step(sum([4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 34.0),
     rule(3),
     ['X' = 4.0, 'Xs' = [4.0, 5.0, 5.0, 7.0, 9.0], 'Total' = 34.0, 'Rest' = 30.0],
     [sum([4.0, 5.0, 5.0, 7.0, 9.0], 30.0), 34.0 is 4.0 + 30.0]).
step(sum([4.0, 5.0, 5.0, 7.0, 9.0], 30.0),
     rule(3),
     ['X' = 4.0, 'Xs' = [5.0, 5.0, 7.0, 9.0], 'Total' = 30.0, 'Rest' = 26.0],
     [sum([5.0, 5.0, 7.0, 9.0], 26.0), 30.0 is 4.0 + 26.0]).
step(sum([5.0, 5.0, 7.0, 9.0], 26.0),
     rule(3),
     ['X' = 5.0, 'Xs' = [5.0, 7.0, 9.0], 'Total' = 26.0, 'Rest' = 21.0],
     [sum([5.0, 7.0, 9.0], 21.0), 26.0 is 5.0 + 21.0]).
step(sum([5.0, 7.0, 9.0], 21.0),
     rule(3),
     ['X' = 5.0, 'Xs' = [7.0, 9.0], 'Total' = 21.0, 'Rest' = 16.0],
     [sum([7.0, 9.0], 16.0), 21.0 is 5.0 + 16.0]).
step(sum([7.0, 9.0], 16.0),
     rule(3),
     ['X' = 7.0, 'Xs' = [9.0], 'Total' = 16.0, 'Rest' = 9.0],
     [sum([9.0], 9.0), 16.0 is 7.0 + 9.0]).
step(sum([9.0], 9.0),
     rule(3),
     ['X' = 9.0, 'Xs' = [], 'Total' = 9.0, 'Rest' = 0.0],
     [sum([], 0.0), 9.0 is 9.0 + 0.0]).
step(sum([], 0.0), fact(2), [], []).
step(9.0 is 9.0 + 0.0, builtin, [], []).
step(16.0 is 7.0 + 9.0, builtin, [], []).
step(21.0 is 5.0 + 16.0, builtin, [], []).
step(26.0 is 5.0 + 21.0, builtin, [], []).
step(30.0 is 4.0 + 26.0, builtin, [], []).
step(34.0 is 4.0 + 30.0, builtin, [], []).
step(38.0 is 4.0 + 34.0, builtin, [], []).
step(40.0 is 2.0 + 38.0, builtin, [], []).
step(length([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 8), builtin, [], []).
step(5.0 is 40.0 / 8, builtin, [], []).
step(count(scores, 8),
     rule(9),
     ['Name' = scores, 'Count' = 8, 'Values' = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]],
     [sample(scores, [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]),
      length([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 8)]).
step(populationVariance(scores, 4.0),
     rule(10),
     ['Name' = scores, 'Variance' = 4.0],
     [population_variance(scores, 4.0)]).
step(population_variance(scores, 4.0),
     rule(7),
     ['Name' = scores,
      'Variance' = 4.0,
      'Values' = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0],
      'Mean' = 5.0,
      'Sumsquarederrors' = 32.0,
      'Count' = 8],
     [sample(scores, [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]),
      mean(scores, 5.0),
      squared_error_sum([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 32.0),
      length([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 8),
      4.0 is 32.0 / 8]).
step(squared_error_sum([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 32.0),
     rule(6),
     ['X' = 2.0,
      'Xs' = [4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0],
      'Mean' = 5.0,
      'Total' = 32.0,
      'Delta' = -3.0,
      'Squared' = 9.0,
      'Rest' = 23.0],
     [-3.0 is 2.0 - 5.0,
      9.0 is -3.0 ** 2.0,
      squared_error_sum([4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 23.0),
      32.0 is 9.0 + 23.0]).
step(-3.0 is 2.0 - 5.0, builtin, [], []).
step(9.0 is -3.0 ** 2.0, builtin, [], []).
step(squared_error_sum([4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 23.0),
     rule(6),
     ['X' = 4.0,
      'Xs' = [4.0, 4.0, 5.0, 5.0, 7.0, 9.0],
      'Mean' = 5.0,
      'Total' = 23.0,
      'Delta' = -1.0,
      'Squared' = 1.0,
      'Rest' = 22.0],
     [-1.0 is 4.0 - 5.0,
      1.0 is -1.0 ** 2.0,
      squared_error_sum([4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 22.0),
      23.0 is 1.0 + 22.0]).
step(-1.0 is 4.0 - 5.0, builtin, [], []).
step(1.0 is -1.0 ** 2.0, builtin, [], []).
step(squared_error_sum([4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 22.0),
     rule(6),
     ['X' = 4.0,
      'Xs' = [4.0, 5.0, 5.0, 7.0, 9.0],
      'Mean' = 5.0,
      'Total' = 22.0,
      'Delta' = -1.0,
      'Squared' = 1.0,
      'Rest' = 21.0],
     [-1.0 is 4.0 - 5.0,
      1.0 is -1.0 ** 2.0,
      squared_error_sum([4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 21.0),
      22.0 is 1.0 + 21.0]).
step(squared_error_sum([4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 21.0),
     rule(6),
     ['X' = 4.0,
      'Xs' = [5.0, 5.0, 7.0, 9.0],
      'Mean' = 5.0,
      'Total' = 21.0,
      'Delta' = -1.0,
      'Squared' = 1.0,
      'Rest' = 20.0],
     [-1.0 is 4.0 - 5.0,
      1.0 is -1.0 ** 2.0,
      squared_error_sum([5.0, 5.0, 7.0, 9.0], 5.0, 20.0),
      21.0 is 1.0 + 20.0]).
step(squared_error_sum([5.0, 5.0, 7.0, 9.0], 5.0, 20.0),
     rule(6),
     ['X' = 5.0,
      'Xs' = [5.0, 7.0, 9.0],
      'Mean' = 5.0,
      'Total' = 20.0,
      'Delta' = 0.0,
      'Squared' = 0.0,
      'Rest' = 20.0],
     [0.0 is 5.0 - 5.0,
      0.0 is 0.0 ** 2.0,
      squared_error_sum([5.0, 7.0, 9.0], 5.0, 20.0),
      20.0 is 0.0 + 20.0]).
step(0.0 is 5.0 - 5.0, builtin, [], []).
step(0.0 is 0.0 ** 2.0, builtin, [], []).
step(squared_error_sum([5.0, 7.0, 9.0], 5.0, 20.0),
     rule(6),
     ['X' = 5.0,
      'Xs' = [7.0, 9.0],
      'Mean' = 5.0,
      'Total' = 20.0,
      'Delta' = 0.0,
      'Squared' = 0.0,
      'Rest' = 20.0],
     [0.0 is 5.0 - 5.0,
      0.0 is 0.0 ** 2.0,
      squared_error_sum([7.0, 9.0], 5.0, 20.0),
      20.0 is 0.0 + 20.0]).
step(squared_error_sum([7.0, 9.0], 5.0, 20.0),
     rule(6),
     ['X' = 7.0,
      'Xs' = [9.0],
      'Mean' = 5.0,
      'Total' = 20.0,
      'Delta' = 2.0,
      'Squared' = 4.0,
      'Rest' = 16.0],
     [2.0 is 7.0 - 5.0,
      4.0 is 2.0 ** 2.0,
      squared_error_sum([9.0], 5.0, 16.0),
      20.0 is 4.0 + 16.0]).
step(2.0 is 7.0 - 5.0, builtin, [], []).
step(4.0 is 2.0 ** 2.0, builtin, [], []).
step(squared_error_sum([9.0], 5.0, 16.0),
     rule(6),
     ['X' = 9.0,
      'Xs' = [],
      'Mean' = 5.0,
      'Total' = 16.0,
      'Delta' = 4.0,
      'Squared' = 16.0,
      'Rest' = 0.0],
     [4.0 is 9.0 - 5.0, 16.0 is 4.0 ** 2.0, squared_error_sum([], 5.0, 0.0), 16.0 is 16.0 + 0.0]).
step(4.0 is 9.0 - 5.0, builtin, [], []).
step(16.0 is 4.0 ** 2.0, builtin, [], []).
step(squared_error_sum([], 5.0, 0.0), fact(5), [], []).
step(16.0 is 16.0 + 0.0, builtin, [], []).
step(20.0 is 4.0 + 16.0, builtin, [], []).
step(20.0 is 0.0 + 20.0, builtin, [], []).
step(21.0 is 1.0 + 20.0, builtin, [], []).
step(22.0 is 1.0 + 21.0, builtin, [], []).
step(23.0 is 1.0 + 22.0, builtin, [], []).
step(32.0 is 9.0 + 23.0, builtin, [], []).
step(4.0 is 32.0 / 8, builtin, [], []).
step(populationStddev(scores, 2.0),
     rule(11),
     ['Name' = scores, 'Stddev' = 2.0],
     [population_stddev(scores, 2.0)]).
step(population_stddev(scores, 2.0),
     rule(8),
     ['Name' = scores, 'Stddev' = 2.0, 'Variance' = 4.0],
     [population_variance(scores, 4.0), 2.0 is 4.0 ** 0.5]).
step(2.0 is 4.0 ** 0.5, builtin, [], []).
