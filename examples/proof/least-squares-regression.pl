slope(regression1, 0.8).
intercept(regression1, 1.5).
rSquared(regression1, 0.64).
status(regression1, accepted_linear_fit).
reason(regression1, "R squared meets the minimum explanatory-power threshold").

clause(1,
       dataset(regression1, [point(1.0, 2.0), point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)]),
       true).
clause(2, threshold(regression1, minimum_r_squared, 0.6), true).
clause(3, stats([], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), true).
clause(4,
       stats([point(var('X'), var('Y')) | var('Rest')], var('N'), var('Sumx'), var('Sumy'), var('Sumxx'), var('Sumxy'), var('Sumyy')),
       (stats(var('Rest'), var('N0'), var('Sumx0'), var('Sumy0'), var('Sumxx0'), var('Sumxy0'), var('Sumyy0')),
        var('N') is var('N0') + 1.0,
        var('Sumx') is var('Sumx0') + var('X'),
        var('Sumy') is var('Sumy0') + var('Y'),
        var('Xx') is var('X') * var('X'),
        var('Sumxx') is var('Sumxx0') + var('Xx'),
        var('Xy') is var('X') * var('Y'),
        var('Sumxy') is var('Sumxy0') + var('Xy'),
        var('Yy') is var('Y') * var('Y'),
        var('Sumyy') is var('Sumyy0') + var('Yy'))).
clause(5,
       sufficient_statistics(var('Data'), var('N'), var('Sumx'), var('Sumy'), var('Sumxx'), var('Sumxy'), var('Sumyy')),
       (dataset(var('Data'), var('Points')),
        stats(var('Points'), var('N'), var('Sumx'), var('Sumy'), var('Sumxx'), var('Sumxy'), var('Sumyy')))).
clause(6,
       slope(var('Data'), var('Slope')),
       (sufficient_statistics(var('Data'), var('N'), var('Sumx'), var('Sumy'), var('Sumxx'), var('Sumxy'), anonymous(1)),
        var('Nsumxy') is var('N') * var('Sumxy'),
        var('Sumxsumy') is var('Sumx') * var('Sumy'),
        var('Numerator') is var('Nsumxy') - var('Sumxsumy'),
        var('Nsumxx') is var('N') * var('Sumxx'),
        var('Sumxsquared') is var('Sumx') * var('Sumx'),
        var('Denominator') is var('Nsumxx') - var('Sumxsquared'),
        var('Slope') is var('Numerator') / var('Denominator'))).
clause(7,
       intercept(var('Data'), var('Intercept')),
       (sufficient_statistics(var('Data'), var('N'), var('Sumx'), var('Sumy'), anonymous(1), anonymous(2), anonymous(3)),
        slope(var('Data'), var('Slope')),
        var('Slopesumx') is var('Slope') * var('Sumx'),
        var('Numerator') is var('Sumy') - var('Slopesumx'),
        var('Intercept') is var('Numerator') / var('N'))).
clause(8,
       r_squared(var('Data'), var('R2')),
       (sufficient_statistics(var('Data'), var('N'), var('Sumx'), var('Sumy'), var('Sumxx'), var('Sumxy'), var('Sumyy')),
        var('Nsumxy') is var('N') * var('Sumxy'),
        var('Sumxsumy') is var('Sumx') * var('Sumy'),
        var('Numeratorbase') is var('Nsumxy') - var('Sumxsumy'),
        var('Numerator') is var('Numeratorbase') ** 2.0,
        var('Nsumxx') is var('N') * var('Sumxx'),
        var('Sumxsquared') is var('Sumx') * var('Sumx'),
        var('Xspread') is var('Nsumxx') - var('Sumxsquared'),
        var('Nsumyy') is var('N') * var('Sumyy'),
        var('Sumysquared') is var('Sumy') * var('Sumy'),
        var('Yspread') is var('Nsumyy') - var('Sumysquared'),
        var('Denominator') is var('Xspread') * var('Yspread'),
        var('R2') is var('Numerator') / var('Denominator'))).
clause(9,
       accepted_fit(var('Data')),
       (r_squared(var('Data'), var('R2')),
        threshold(var('Data'), minimum_r_squared, var('Minimum')),
        var('R2') >= var('Minimum'))).
clause(10, rSquared(var('Data'), var('R2')), r_squared(var('Data'), var('R2'))).
clause(11, status(var('Data'), accepted_linear_fit), accepted_fit(var('Data'))).
clause(12,
       reason(var('Data'), "R squared meets the minimum explanatory-power threshold"),
       accepted_fit(var('Data'))).

step(slope(regression1, 0.8),
     rule(6),
     ['Data' = regression1,
      'Slope' = 0.8,
      'N' = 4.0,
      'Sumx' = 10.0,
      'Sumy' = 14.0,
      'Sumxx' = 30.0,
      'Sumxy' = 39.0,
      'Nsumxy' = 156.0,
      'Sumxsumy' = 140.0,
      'Numerator' = 16.0,
      'Nsumxx' = 120.0,
      'Sumxsquared' = 100.0,
      'Denominator' = 20.0],
     [sufficient_statistics(regression1, 4.0, 10.0, 14.0, 30.0, 39.0, 54.0),
      156.0 is 4.0 * 39.0,
      140.0 is 10.0 * 14.0,
      16.0 is 156.0 - 140.0,
      120.0 is 4.0 * 30.0,
      100.0 is 10.0 * 10.0,
      20.0 is 120.0 - 100.0,
      0.8 is 16.0 / 20.0]).
step(sufficient_statistics(regression1, 4.0, 10.0, 14.0, 30.0, 39.0, 54.0),
     rule(5),
     ['Data' = regression1,
      'N' = 4.0,
      'Sumx' = 10.0,
      'Sumy' = 14.0,
      'Sumxx' = 30.0,
      'Sumxy' = 39.0,
      'Sumyy' = 54.0,
      'Points' = [point(1.0, 2.0), point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)]],
     [dataset(regression1, [point(1.0, 2.0), point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)]),
      stats([point(1.0, 2.0), point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)], 4.0, 10.0, 14.0, 30.0, 39.0, 54.0)]).
step(dataset(regression1, [point(1.0, 2.0), point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)]),
     fact(1),
     [],
     []).
step(stats([point(1.0, 2.0), point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)], 4.0, 10.0, 14.0, 30.0, 39.0, 54.0),
     rule(4),
     ['X' = 1.0,
      'Y' = 2.0,
      'Rest' = [point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)],
      'N' = 4.0,
      'Sumx' = 10.0,
      'Sumy' = 14.0,
      'Sumxx' = 30.0,
      'Sumxy' = 39.0,
      'Sumyy' = 54.0,
      'N0' = 3.0,
      'Sumx0' = 9.0,
      'Sumy0' = 12.0,
      'Sumxx0' = 29.0,
      'Sumxy0' = 37.0,
      'Sumyy0' = 50.0,
      'Xx' = 1.0,
      'Xy' = 2.0,
      'Yy' = 4.0],
     [stats([point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)], 3.0, 9.0, 12.0, 29.0, 37.0, 50.0),
      4.0 is 3.0 + 1.0,
      10.0 is 9.0 + 1.0,
      14.0 is 12.0 + 2.0,
      1.0 is 1.0 * 1.0,
      30.0 is 29.0 + 1.0,
      2.0 is 1.0 * 2.0,
      39.0 is 37.0 + 2.0,
      4.0 is 2.0 * 2.0,
      54.0 is 50.0 + 4.0]).
step(stats([point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)], 3.0, 9.0, 12.0, 29.0, 37.0, 50.0),
     rule(4),
     ['X' = 2.0,
      'Y' = 3.0,
      'Rest' = [point(3.0, 5.0), point(4.0, 4.0)],
      'N' = 3.0,
      'Sumx' = 9.0,
      'Sumy' = 12.0,
      'Sumxx' = 29.0,
      'Sumxy' = 37.0,
      'Sumyy' = 50.0,
      'N0' = 2.0,
      'Sumx0' = 7.0,
      'Sumy0' = 9.0,
      'Sumxx0' = 25.0,
      'Sumxy0' = 31.0,
      'Sumyy0' = 41.0,
      'Xx' = 4.0,
      'Xy' = 6.0,
      'Yy' = 9.0],
     [stats([point(3.0, 5.0), point(4.0, 4.0)], 2.0, 7.0, 9.0, 25.0, 31.0, 41.0),
      3.0 is 2.0 + 1.0,
      9.0 is 7.0 + 2.0,
      12.0 is 9.0 + 3.0,
      4.0 is 2.0 * 2.0,
      29.0 is 25.0 + 4.0,
      6.0 is 2.0 * 3.0,
      37.0 is 31.0 + 6.0,
      9.0 is 3.0 * 3.0,
      50.0 is 41.0 + 9.0]).
step(stats([point(3.0, 5.0), point(4.0, 4.0)], 2.0, 7.0, 9.0, 25.0, 31.0, 41.0),
     rule(4),
     ['X' = 3.0,
      'Y' = 5.0,
      'Rest' = [point(4.0, 4.0)],
      'N' = 2.0,
      'Sumx' = 7.0,
      'Sumy' = 9.0,
      'Sumxx' = 25.0,
      'Sumxy' = 31.0,
      'Sumyy' = 41.0,
      'N0' = 1.0,
      'Sumx0' = 4.0,
      'Sumy0' = 4.0,
      'Sumxx0' = 16.0,
      'Sumxy0' = 16.0,
      'Sumyy0' = 16.0,
      'Xx' = 9.0,
      'Xy' = 15.0,
      'Yy' = 25.0],
     [stats([point(4.0, 4.0)], 1.0, 4.0, 4.0, 16.0, 16.0, 16.0),
      2.0 is 1.0 + 1.0,
      7.0 is 4.0 + 3.0,
      9.0 is 4.0 + 5.0,
      9.0 is 3.0 * 3.0,
      25.0 is 16.0 + 9.0,
      15.0 is 3.0 * 5.0,
      31.0 is 16.0 + 15.0,
      25.0 is 5.0 * 5.0,
      41.0 is 16.0 + 25.0]).
step(stats([point(4.0, 4.0)], 1.0, 4.0, 4.0, 16.0, 16.0, 16.0),
     rule(4),
     ['X' = 4.0,
      'Y' = 4.0,
      'Rest' = [],
      'N' = 1.0,
      'Sumx' = 4.0,
      'Sumy' = 4.0,
      'Sumxx' = 16.0,
      'Sumxy' = 16.0,
      'Sumyy' = 16.0,
      'N0' = 0.0,
      'Sumx0' = 0.0,
      'Sumy0' = 0.0,
      'Sumxx0' = 0.0,
      'Sumxy0' = 0.0,
      'Sumyy0' = 0.0,
      'Xx' = 16.0,
      'Xy' = 16.0,
      'Yy' = 16.0],
     [stats([], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
      1.0 is 0.0 + 1.0,
      4.0 is 0.0 + 4.0,
      4.0 is 0.0 + 4.0,
      16.0 is 4.0 * 4.0,
      16.0 is 0.0 + 16.0,
      16.0 is 4.0 * 4.0,
      16.0 is 0.0 + 16.0,
      16.0 is 4.0 * 4.0,
      16.0 is 0.0 + 16.0]).
step(stats([], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), fact(3), [], []).
step(1.0 is 0.0 + 1.0, builtin, [], []).
step(4.0 is 0.0 + 4.0, builtin, [], []).
step(16.0 is 4.0 * 4.0, builtin, [], []).
step(16.0 is 0.0 + 16.0, builtin, [], []).
step(2.0 is 1.0 + 1.0, builtin, [], []).
step(7.0 is 4.0 + 3.0, builtin, [], []).
step(9.0 is 4.0 + 5.0, builtin, [], []).
step(9.0 is 3.0 * 3.0, builtin, [], []).
step(25.0 is 16.0 + 9.0, builtin, [], []).
step(15.0 is 3.0 * 5.0, builtin, [], []).
step(31.0 is 16.0 + 15.0, builtin, [], []).
step(25.0 is 5.0 * 5.0, builtin, [], []).
step(41.0 is 16.0 + 25.0, builtin, [], []).
step(3.0 is 2.0 + 1.0, builtin, [], []).
step(9.0 is 7.0 + 2.0, builtin, [], []).
step(12.0 is 9.0 + 3.0, builtin, [], []).
step(4.0 is 2.0 * 2.0, builtin, [], []).
step(29.0 is 25.0 + 4.0, builtin, [], []).
step(6.0 is 2.0 * 3.0, builtin, [], []).
step(37.0 is 31.0 + 6.0, builtin, [], []).
step(50.0 is 41.0 + 9.0, builtin, [], []).
step(4.0 is 3.0 + 1.0, builtin, [], []).
step(10.0 is 9.0 + 1.0, builtin, [], []).
step(14.0 is 12.0 + 2.0, builtin, [], []).
step(1.0 is 1.0 * 1.0, builtin, [], []).
step(30.0 is 29.0 + 1.0, builtin, [], []).
step(2.0 is 1.0 * 2.0, builtin, [], []).
step(39.0 is 37.0 + 2.0, builtin, [], []).
step(54.0 is 50.0 + 4.0, builtin, [], []).
step(156.0 is 4.0 * 39.0, builtin, [], []).
step(140.0 is 10.0 * 14.0, builtin, [], []).
step(16.0 is 156.0 - 140.0, builtin, [], []).
step(120.0 is 4.0 * 30.0, builtin, [], []).
step(100.0 is 10.0 * 10.0, builtin, [], []).
step(20.0 is 120.0 - 100.0, builtin, [], []).
step(0.8 is 16.0 / 20.0, builtin, [], []).
step(intercept(regression1, 1.5),
     rule(7),
     ['Data' = regression1,
      'Intercept' = 1.5,
      'N' = 4.0,
      'Sumx' = 10.0,
      'Sumy' = 14.0,
      'Slope' = 0.8,
      'Slopesumx' = 8.0,
      'Numerator' = 6.0],
     [sufficient_statistics(regression1, 4.0, 10.0, 14.0, 30.0, 39.0, 54.0),
      slope(regression1, 0.8),
      8.0 is 0.8 * 10.0,
      6.0 is 14.0 - 8.0,
      1.5 is 6.0 / 4.0]).
step(8.0 is 0.8 * 10.0, builtin, [], []).
step(6.0 is 14.0 - 8.0, builtin, [], []).
step(1.5 is 6.0 / 4.0, builtin, [], []).
step(rSquared(regression1, 0.64),
     rule(10),
     ['Data' = regression1, 'R2' = 0.64],
     [r_squared(regression1, 0.64)]).
step(r_squared(regression1, 0.64),
     rule(8),
     ['Data' = regression1,
      'R2' = 0.64,
      'N' = 4.0,
      'Sumx' = 10.0,
      'Sumy' = 14.0,
      'Sumxx' = 30.0,
      'Sumxy' = 39.0,
      'Sumyy' = 54.0,
      'Nsumxy' = 156.0,
      'Sumxsumy' = 140.0,
      'Numeratorbase' = 16.0,
      'Numerator' = 256.0,
      'Nsumxx' = 120.0,
      'Sumxsquared' = 100.0,
      'Xspread' = 20.0,
      'Nsumyy' = 216.0,
      'Sumysquared' = 196.0,
      'Yspread' = 20.0,
      'Denominator' = 400.0],
     [sufficient_statistics(regression1, 4.0, 10.0, 14.0, 30.0, 39.0, 54.0),
      156.0 is 4.0 * 39.0,
      140.0 is 10.0 * 14.0,
      16.0 is 156.0 - 140.0,
      256.0 is 16.0 ** 2.0,
      120.0 is 4.0 * 30.0,
      100.0 is 10.0 * 10.0,
      20.0 is 120.0 - 100.0,
      216.0 is 4.0 * 54.0,
      196.0 is 14.0 * 14.0,
      20.0 is 216.0 - 196.0,
      400.0 is 20.0 * 20.0,
      0.64 is 256.0 / 400.0]).
step(256.0 is 16.0 ** 2.0, builtin, [], []).
step(216.0 is 4.0 * 54.0, builtin, [], []).
step(196.0 is 14.0 * 14.0, builtin, [], []).
step(20.0 is 216.0 - 196.0, builtin, [], []).
step(400.0 is 20.0 * 20.0, builtin, [], []).
step(0.64 is 256.0 / 400.0, builtin, [], []).
step(status(regression1, accepted_linear_fit),
     rule(11),
     ['Data' = regression1],
     [accepted_fit(regression1)]).
step(accepted_fit(regression1),
     rule(9),
     ['Data' = regression1, 'R2' = 0.64, 'Minimum' = 0.6],
     [r_squared(regression1, 0.64), threshold(regression1, minimum_r_squared, 0.6), 0.64 >= 0.6]).
step(threshold(regression1, minimum_r_squared, 0.6), fact(2), [], []).
step(0.64 >= 0.6, builtin, [], []).
step(reason(regression1, "R squared meets the minimum explanatory-power threshold"),
     rule(12),
     ['Data' = regression1],
     [accepted_fit(regression1)]).
