type(meas47, lld_alarm).
lld_left_length_cm(meas47, 21.548900464617255).
lld_right_length_cm(meas47, 23.45713444515475).
lld_discrepancy_cm(meas47, -1.9082339805374957).
lld_threshold_cm(meas47, 1.25).
lld_reason(meas47, "discrepancy below negative threshold").

clause(2, measurement(meas47), true).
clause(3, val(meas47, p1xCm, 10.1), true).
clause(4, val(meas47, p1yCm, 7.8), true).
clause(5, val(meas47, p2xCm, 45.1), true).
clause(6, val(meas47, p2yCm, 5.6), true).
clause(7, val(meas47, p3xCm, 3.6), true).
clause(8, val(meas47, p3yCm, 29.8), true).
clause(9, val(meas47, p4xCm, 54.7), true).
clause(10, val(meas47, p4yCm, 28.5), true).
clause(11, threshold(meas47, lld_alarm_threshold_cm, 1.25), true).
clause(12,
       val(var('M'), dx12Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p1xCm, var('X')),
        val(var('M'), p2xCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(13,
       val(var('M'), dx51Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p5xCm, var('X')),
        val(var('M'), p1xCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(14,
       val(var('M'), dx53Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p5xCm, var('X')),
        val(var('M'), p3xCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(15,
       val(var('M'), dx62Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p6xCm, var('X')),
        val(var('M'), p2xCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(16,
       val(var('M'), dx64Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p6xCm, var('X')),
        val(var('M'), p4xCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(17,
       val(var('M'), dy12Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p1yCm, var('X')),
        val(var('M'), p2yCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(18,
       val(var('M'), dy13Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p1yCm, var('X')),
        val(var('M'), p3yCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(19,
       val(var('M'), dy24Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p2yCm, var('X')),
        val(var('M'), p4yCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(20,
       val(var('M'), dy53Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p5yCm, var('X')),
        val(var('M'), p3yCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(21,
       val(var('M'), dy64Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), p6yCm, var('X')),
        val(var('M'), p4yCm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(22,
       val(var('M'), cL1, var('Z')),
       (measurement(var('M')),
        val(var('M'), dy12Cm, var('Y')),
        val(var('M'), dx12Cm, var('X')),
        var('Z') is var('Y') / var('X'))).
clause(23,
       val(var('M'), dL3m, var('Z')),
       (measurement(var('M')), val(var('M'), cL1, var('X')), var('Z') is 1 / var('X'))).
clause(24,
       val(var('M'), cL3, var('Z')),
       (measurement(var('M')), val(var('M'), dL3m, var('X')), var('Z') is 0 - var('X'))).
clause(25,
       val(var('M'), pL1x1Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), cL1, var('X')),
        val(var('M'), p1xCm, var('Y')),
        var('Z') is var('X') * var('Y'))).
clause(26,
       val(var('M'), pL1x2Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), cL1, var('X')),
        val(var('M'), p2xCm, var('Y')),
        var('Z') is var('X') * var('Y'))).
clause(27,
       val(var('M'), pL3x3Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), cL3, var('X')),
        val(var('M'), p3xCm, var('Y')),
        var('Z') is var('X') * var('Y'))).
clause(28,
       val(var('M'), pL3x4Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), cL3, var('X')),
        val(var('M'), p4xCm, var('Y')),
        var('Z') is var('X') * var('Y'))).
clause(29,
       val(var('M'), dd13Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), pL1x1Cm, var('X')),
        val(var('M'), pL3x3Cm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(30,
       val(var('M'), ddy13Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), dd13Cm, var('X')),
        val(var('M'), dy13Cm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(31,
       val(var('M'), dd24Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), pL1x2Cm, var('X')),
        val(var('M'), pL3x4Cm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(32,
       val(var('M'), ddy24Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), dd24Cm, var('X')),
        val(var('M'), dy24Cm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(33,
       val(var('M'), ddL13, var('Z')),
       (measurement(var('M')),
        val(var('M'), cL1, var('X')),
        val(var('M'), cL3, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(34,
       val(var('M'), pL1dx51Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), cL1, var('X')),
        val(var('M'), dx51Cm, var('Y')),
        var('Z') is var('X') * var('Y'))).
clause(35,
       val(var('M'), pL1dx62Cm, var('Z')),
       (measurement(var('M')),
        val(var('M'), cL1, var('X')),
        val(var('M'), dx62Cm, var('Y')),
        var('Z') is var('X') * var('Y'))).
clause(36,
       val(var('M'), p5xCm, var('Z')),
       (measurement(var('M')),
        val(var('M'), ddy13Cm, var('X')),
        val(var('M'), ddL13, var('Y')),
        var('Z') is var('X') / var('Y'))).
clause(37,
       val(var('M'), p5yCm, var('Z')),
       (measurement(var('M')),
        val(var('M'), pL1dx51Cm, var('X')),
        val(var('M'), p1yCm, var('Y')),
        var('Z') is var('X') + var('Y'))).
clause(38,
       val(var('M'), p6xCm, var('Z')),
       (measurement(var('M')),
        val(var('M'), ddy24Cm, var('X')),
        val(var('M'), ddL13, var('Y')),
        var('Z') is var('X') / var('Y'))).
clause(39,
       val(var('M'), p6yCm, var('Z')),
       (measurement(var('M')),
        val(var('M'), pL1dx62Cm, var('X')),
        val(var('M'), p2yCm, var('Y')),
        var('Z') is var('X') + var('Y'))).
clause(40,
       val(var('M'), sdx53Cm2, var('Z')),
       (measurement(var('M')), val(var('M'), dx53Cm, var('X')), var('Z') is var('X') ** 2)).
clause(41,
       val(var('M'), sdx64Cm2, var('Z')),
       (measurement(var('M')), val(var('M'), dx64Cm, var('X')), var('Z') is var('X') ** 2)).
clause(42,
       val(var('M'), sdy53Cm2, var('Z')),
       (measurement(var('M')), val(var('M'), dy53Cm, var('X')), var('Z') is var('X') ** 2)).
clause(43,
       val(var('M'), sdy64Cm2, var('Z')),
       (measurement(var('M')), val(var('M'), dy64Cm, var('X')), var('Z') is var('X') ** 2)).
clause(44,
       val(var('M'), ssd53Cm2, var('Z')),
       (measurement(var('M')),
        val(var('M'), sdx53Cm2, var('X')),
        val(var('M'), sdy53Cm2, var('Y')),
        var('Z') is var('X') + var('Y'))).
clause(45,
       val(var('M'), ssd64Cm2, var('Z')),
       (measurement(var('M')),
        val(var('M'), sdx64Cm2, var('X')),
        val(var('M'), sdy64Cm2, var('Y')),
        var('Z') is var('X') + var('Y'))).
clause(46,
       val(var('M'), d53Cm, var('Z')),
       (measurement(var('M')), val(var('M'), ssd53Cm2, var('X')), var('Z') is var('X') ** 0.5)).
clause(47,
       val(var('M'), d64Cm, var('Z')),
       (measurement(var('M')), val(var('M'), ssd64Cm2, var('X')), var('Z') is var('X') ** 0.5)).
clause(48,
       val(var('M'), dCm, var('Z')),
       (measurement(var('M')),
        val(var('M'), d53Cm, var('X')),
        val(var('M'), d64Cm, var('Y')),
        var('Z') is var('X') - var('Y'))).
clause(49,
       type(var('M'), lld_alarm),
       (measurement(var('M')),
        val(var('M'), dCm, var('D')),
        threshold(var('M'), lld_alarm_threshold_cm, var('T')),
        var('Negt') is 0 - var('T'),
        var('D') < var('Negt'))).
clause(51,
       lld_left_length_cm(var('M'), var('L')),
       (type(var('M'), lld_alarm), val(var('M'), d53Cm, var('L')))).
clause(52,
       lld_right_length_cm(var('M'), var('R')),
       (type(var('M'), lld_alarm), val(var('M'), d64Cm, var('R')))).
clause(53,
       lld_discrepancy_cm(var('M'), var('D')),
       (type(var('M'), lld_alarm), val(var('M'), dCm, var('D')))).
clause(54,
       lld_threshold_cm(var('M'), var('T')),
       (type(var('M'), lld_alarm), threshold(var('M'), lld_alarm_threshold_cm, var('T')))).
clause(55,
       lld_reason(var('M'), "discrepancy below negative threshold"),
       type(var('M'), lld_alarm)).

step(type(meas47, lld_alarm),
     rule(49),
     ['M' = meas47, 'D' = -1.9082339805374957, 'T' = 1.25, 'Negt' = -1.25],
     [measurement(meas47),
      val(meas47, dCm, -1.9082339805374957),
      threshold(meas47, lld_alarm_threshold_cm, 1.25),
      -1.25 is 0 - 1.25,
      -1.9082339805374957 < -1.25]).
step(measurement(meas47), fact(2), [], []).
step(val(meas47, dCm, -1.9082339805374957),
     rule(48),
     ['M' = meas47,
      'Z' = -1.9082339805374957,
      'X' = 21.548900464617255,
      'Y' = 23.45713444515475],
     [measurement(meas47),
      val(meas47, d53Cm, 21.548900464617255),
      val(meas47, d64Cm, 23.45713444515475),
      -1.9082339805374957 is 21.548900464617255 - 23.45713444515475]).
step(val(meas47, d53Cm, 21.548900464617255),
     rule(46),
     ['M' = meas47, 'Z' = 21.548900464617255, 'X' = 464.35511123398175],
     [measurement(meas47),
      val(meas47, ssd53Cm2, 464.35511123398175),
      21.548900464617255 is 464.35511123398175 ** 0.5]).
step(val(meas47, ssd53Cm2, 464.35511123398175),
     rule(44),
     ['M' = meas47,
      'Z' = 464.35511123398175,
      'X' = 1.8274562043619251,
      'Y' = 462.52765502961984],
     [measurement(meas47),
      val(meas47, sdx53Cm2, 1.8274562043619251),
      val(meas47, sdy53Cm2, 462.52765502961984),
      464.35511123398175 is 1.8274562043619251 + 462.52765502961984]).
step(val(meas47, sdx53Cm2, 1.8274562043619251),
     rule(40),
     ['M' = meas47, 'Z' = 1.8274562043619251, 'X' = -1.351834384960645],
     [measurement(meas47),
      val(meas47, dx53Cm, -1.351834384960645),
      1.8274562043619251 is -1.351834384960645 ** 2]).
step(val(meas47, dx53Cm, -1.351834384960645),
     rule(14),
     ['M' = meas47, 'Z' = -1.351834384960645, 'X' = 2.248165615039355, 'Y' = 3.6],
     [measurement(meas47),
      val(meas47, p5xCm, 2.248165615039355),
      val(meas47, p3xCm, 3.6),
      -1.351834384960645 is 2.248165615039355 - 3.6]).
step(val(meas47, p5xCm, 2.248165615039355),
     rule(36),
     ['M' = meas47, 'Z' = 2.248165615039355, 'X' = -35.90758441558442, 'Y' = -15.97194805194805],
     [measurement(meas47),
      val(meas47, ddy13Cm, -35.90758441558442),
      val(meas47, ddL13, -15.97194805194805),
      2.248165615039355 is -35.90758441558442 / -15.97194805194805]).
step(val(meas47, ddy13Cm, -35.90758441558442),
     rule(30),
     ['M' = meas47, 'Z' = -35.90758441558442, 'X' = -57.90758441558442, 'Y' = -22.0],
     [measurement(meas47),
      val(meas47, dd13Cm, -57.90758441558442),
      val(meas47, dy13Cm, -22.0),
      -35.90758441558442 is -57.90758441558442 - -22.0]).
step(val(meas47, dd13Cm, -57.90758441558442),
     rule(29),
     ['M' = meas47,
      'Z' = -57.90758441558442,
      'X' = -0.6348571428571429,
      'Y' = 57.27272727272727],
     [measurement(meas47),
      val(meas47, pL1x1Cm, -0.6348571428571429),
      val(meas47, pL3x3Cm, 57.27272727272727),
      -57.90758441558442 is -0.6348571428571429 - 57.27272727272727]).
step(val(meas47, pL1x1Cm, -0.6348571428571429),
     rule(25),
     ['M' = meas47, 'Z' = -0.6348571428571429, 'X' = -0.06285714285714286, 'Y' = 10.1],
     [measurement(meas47),
      val(meas47, cL1, -0.06285714285714286),
      val(meas47, p1xCm, 10.1),
      -0.6348571428571429 is -0.06285714285714286 * 10.1]).
step(val(meas47, cL1, -0.06285714285714286),
     rule(22),
     ['M' = meas47, 'Z' = -0.06285714285714286, 'Y' = 2.2, 'X' = -35.0],
     [measurement(meas47),
      val(meas47, dy12Cm, 2.2),
      val(meas47, dx12Cm, -35.0),
      -0.06285714285714286 is 2.2 / -35.0]).
step(val(meas47, dy12Cm, 2.2),
     rule(17),
     ['M' = meas47, 'Z' = 2.2, 'X' = 7.8, 'Y' = 5.6],
     [measurement(meas47), val(meas47, p1yCm, 7.8), val(meas47, p2yCm, 5.6), 2.2 is 7.8 - 5.6]).
step(val(meas47, p1yCm, 7.8), fact(4), [], []).
step(val(meas47, p2yCm, 5.6), fact(6), [], []).
step(2.2 is 7.8 - 5.6, builtin, [], []).
step(val(meas47, dx12Cm, -35.0),
     rule(12),
     ['M' = meas47, 'Z' = -35.0, 'X' = 10.1, 'Y' = 45.1],
     [measurement(meas47),
      val(meas47, p1xCm, 10.1),
      val(meas47, p2xCm, 45.1),
      -35.0 is 10.1 - 45.1]).
step(val(meas47, p1xCm, 10.1), fact(3), [], []).
step(val(meas47, p2xCm, 45.1), fact(5), [], []).
step(-35.0 is 10.1 - 45.1, builtin, [], []).
step(-0.06285714285714286 is 2.2 / -35.0, builtin, [], []).
step(-0.6348571428571429 is -0.06285714285714286 * 10.1, builtin, [], []).
step(val(meas47, pL3x3Cm, 57.27272727272727),
     rule(27),
     ['M' = meas47, 'Z' = 57.27272727272727, 'X' = 15.909090909090908, 'Y' = 3.6],
     [measurement(meas47),
      val(meas47, cL3, 15.909090909090908),
      val(meas47, p3xCm, 3.6),
      57.27272727272727 is 15.909090909090908 * 3.6]).
step(val(meas47, cL3, 15.909090909090908),
     rule(24),
     ['M' = meas47, 'Z' = 15.909090909090908, 'X' = -15.909090909090908],
     [measurement(meas47),
      val(meas47, dL3m, -15.909090909090908),
      15.909090909090908 is 0 - -15.909090909090908]).
step(val(meas47, dL3m, -15.909090909090908),
     rule(23),
     ['M' = meas47, 'Z' = -15.909090909090908, 'X' = -0.06285714285714286],
     [measurement(meas47),
      val(meas47, cL1, -0.06285714285714286),
      -15.909090909090908 is 1 / -0.06285714285714286]).
step(-15.909090909090908 is 1 / -0.06285714285714286, builtin, [], []).
step(15.909090909090908 is 0 - -15.909090909090908, builtin, [], []).
step(val(meas47, p3xCm, 3.6), fact(7), [], []).
step(57.27272727272727 is 15.909090909090908 * 3.6, builtin, [], []).
step(-57.90758441558442 is -0.6348571428571429 - 57.27272727272727, builtin, [], []).
step(val(meas47, dy13Cm, -22.0),
     rule(18),
     ['M' = meas47, 'Z' = -22.0, 'X' = 7.8, 'Y' = 29.8],
     [measurement(meas47),
      val(meas47, p1yCm, 7.8),
      val(meas47, p3yCm, 29.8),
      -22.0 is 7.8 - 29.8]).
step(val(meas47, p3yCm, 29.8), fact(8), [], []).
step(-22.0 is 7.8 - 29.8, builtin, [], []).
step(-35.90758441558442 is -57.90758441558442 - -22.0, builtin, [], []).
step(val(meas47, ddL13, -15.97194805194805),
     rule(33),
     ['M' = meas47,
      'Z' = -15.97194805194805,
      'X' = -0.06285714285714286,
      'Y' = 15.909090909090908],
     [measurement(meas47),
      val(meas47, cL1, -0.06285714285714286),
      val(meas47, cL3, 15.909090909090908),
      -15.97194805194805 is -0.06285714285714286 - 15.909090909090908]).
step(-15.97194805194805 is -0.06285714285714286 - 15.909090909090908, builtin, [], []).
step(2.248165615039355 is -35.90758441558442 / -15.97194805194805, builtin, [], []).
step(-1.351834384960645 is 2.248165615039355 - 3.6, builtin, [], []).
step(1.8274562043619251 is -1.351834384960645 ** 2, builtin, [], []).
step(val(meas47, sdy53Cm2, 462.52765502961984),
     rule(42),
     ['M' = meas47, 'Z' = 462.52765502961984, 'X' = -21.506456124373905],
     [measurement(meas47),
      val(meas47, dy53Cm, -21.506456124373905),
      462.52765502961984 is -21.506456124373905 ** 2]).
step(val(meas47, dy53Cm, -21.506456124373905),
     rule(20),
     ['M' = meas47, 'Z' = -21.506456124373905, 'X' = 8.293543875626098, 'Y' = 29.8],
     [measurement(meas47),
      val(meas47, p5yCm, 8.293543875626098),
      val(meas47, p3yCm, 29.8),
      -21.506456124373905 is 8.293543875626098 - 29.8]).
step(val(meas47, p5yCm, 8.293543875626098),
     rule(37),
     ['M' = meas47, 'Z' = 8.293543875626098, 'X' = 0.4935438756260977, 'Y' = 7.8],
     [measurement(meas47),
      val(meas47, pL1dx51Cm, 0.4935438756260977),
      val(meas47, p1yCm, 7.8),
      8.293543875626098 is 0.4935438756260977 + 7.8]).
step(val(meas47, pL1dx51Cm, 0.4935438756260977),
     rule(34),
     ['M' = meas47,
      'Z' = 0.4935438756260977,
      'X' = -0.06285714285714286,
      'Y' = -7.851834384960645],
     [measurement(meas47),
      val(meas47, cL1, -0.06285714285714286),
      val(meas47, dx51Cm, -7.851834384960645),
      0.4935438756260977 is -0.06285714285714286 * -7.851834384960645]).
step(val(meas47, dx51Cm, -7.851834384960645),
     rule(13),
     ['M' = meas47, 'Z' = -7.851834384960645, 'X' = 2.248165615039355, 'Y' = 10.1],
     [measurement(meas47),
      val(meas47, p5xCm, 2.248165615039355),
      val(meas47, p1xCm, 10.1),
      -7.851834384960645 is 2.248165615039355 - 10.1]).
step(-7.851834384960645 is 2.248165615039355 - 10.1, builtin, [], []).
step(0.4935438756260977 is -0.06285714285714286 * -7.851834384960645, builtin, [], []).
step(8.293543875626098 is 0.4935438756260977 + 7.8, builtin, [], []).
step(-21.506456124373905 is 8.293543875626098 - 29.8, builtin, [], []).
step(462.52765502961984 is -21.506456124373905 ** 2, builtin, [], []).
step(464.35511123398175 is 1.8274562043619251 + 462.52765502961984, builtin, [], []).
step(21.548900464617255 is 464.35511123398175 ** 0.5, builtin, [], []).
step(val(meas47, d64Cm, 23.45713444515475),
     rule(47),
     ['M' = meas47, 'Z' = 23.45713444515475, 'X' = 550.2371563780655],
     [measurement(meas47),
      val(meas47, ssd64Cm2, 550.2371563780655),
      23.45713444515475 is 550.2371563780655 ** 0.5]).
step(val(meas47, ssd64Cm2, 550.2371563780655),
     rule(45),
     ['M' = meas47, 'Z' = 550.2371563780655, 'X' = 2.1654425265642967, 'Y' = 548.0717138515012],
     [measurement(meas47),
      val(meas47, sdx64Cm2, 2.1654425265642967),
      val(meas47, sdy64Cm2, 548.0717138515012),
      550.2371563780655 is 2.1654425265642967 + 548.0717138515012]).
step(val(meas47, sdx64Cm2, 2.1654425265642967),
     rule(41),
     ['M' = meas47, 'Z' = 2.1654425265642967, 'X' = -1.4715442659207696],
     [measurement(meas47),
      val(meas47, dx64Cm, -1.4715442659207696),
      2.1654425265642967 is -1.4715442659207696 ** 2]).
step(val(meas47, dx64Cm, -1.4715442659207696),
     rule(16),
     ['M' = meas47, 'Z' = -1.4715442659207696, 'X' = 53.22845573407923, 'Y' = 54.7],
     [measurement(meas47),
      val(meas47, p6xCm, 53.22845573407923),
      val(meas47, p4xCm, 54.7),
      -1.4715442659207696 is 53.22845573407923 - 54.7]).
step(val(meas47, p6xCm, 53.22845573407923),
     rule(38),
     ['M' = meas47, 'Z' = 53.22845573407923, 'X' = -850.1621298701299, 'Y' = -15.97194805194805],
     [measurement(meas47),
      val(meas47, ddy24Cm, -850.1621298701299),
      val(meas47, ddL13, -15.97194805194805),
      53.22845573407923 is -850.1621298701299 / -15.97194805194805]).
step(val(meas47, ddy24Cm, -850.1621298701299),
     rule(32),
     ['M' = meas47, 'Z' = -850.1621298701299, 'X' = -873.0621298701299, 'Y' = -22.9],
     [measurement(meas47),
      val(meas47, dd24Cm, -873.0621298701299),
      val(meas47, dy24Cm, -22.9),
      -850.1621298701299 is -873.0621298701299 - -22.9]).
step(val(meas47, dd24Cm, -873.0621298701299),
     rule(31),
     ['M' = meas47, 'Z' = -873.0621298701299, 'X' = -2.834857142857143, 'Y' = 870.2272727272727],
     [measurement(meas47),
      val(meas47, pL1x2Cm, -2.834857142857143),
      val(meas47, pL3x4Cm, 870.2272727272727),
      -873.0621298701299 is -2.834857142857143 - 870.2272727272727]).
step(val(meas47, pL1x2Cm, -2.834857142857143),
     rule(26),
     ['M' = meas47, 'Z' = -2.834857142857143, 'X' = -0.06285714285714286, 'Y' = 45.1],
     [measurement(meas47),
      val(meas47, cL1, -0.06285714285714286),
      val(meas47, p2xCm, 45.1),
      -2.834857142857143 is -0.06285714285714286 * 45.1]).
step(-2.834857142857143 is -0.06285714285714286 * 45.1, builtin, [], []).
step(val(meas47, pL3x4Cm, 870.2272727272727),
     rule(28),
     ['M' = meas47, 'Z' = 870.2272727272727, 'X' = 15.909090909090908, 'Y' = 54.7],
     [measurement(meas47),
      val(meas47, cL3, 15.909090909090908),
      val(meas47, p4xCm, 54.7),
      870.2272727272727 is 15.909090909090908 * 54.7]).
step(val(meas47, p4xCm, 54.7), fact(9), [], []).
step(870.2272727272727 is 15.909090909090908 * 54.7, builtin, [], []).
step(-873.0621298701299 is -2.834857142857143 - 870.2272727272727, builtin, [], []).
step(val(meas47, dy24Cm, -22.9),
     rule(19),
     ['M' = meas47, 'Z' = -22.9, 'X' = 5.6, 'Y' = 28.5],
     [measurement(meas47),
      val(meas47, p2yCm, 5.6),
      val(meas47, p4yCm, 28.5),
      -22.9 is 5.6 - 28.5]).
step(val(meas47, p4yCm, 28.5), fact(10), [], []).
step(-22.9 is 5.6 - 28.5, builtin, [], []).
step(-850.1621298701299 is -873.0621298701299 - -22.9, builtin, [], []).
step(53.22845573407923 is -850.1621298701299 / -15.97194805194805, builtin, [], []).
step(-1.4715442659207696 is 53.22845573407923 - 54.7, builtin, [], []).
step(2.1654425265642967 is -1.4715442659207696 ** 2, builtin, [], []).
step(val(meas47, sdy64Cm2, 548.0717138515012),
     rule(43),
     ['M' = meas47, 'Z' = 548.0717138515012, 'X' = -23.41093150328498],
     [measurement(meas47),
      val(meas47, dy64Cm, -23.41093150328498),
      548.0717138515012 is -23.41093150328498 ** 2]).
step(val(meas47, dy64Cm, -23.41093150328498),
     rule(21),
     ['M' = meas47, 'Z' = -23.41093150328498, 'X' = 5.0890684967150195, 'Y' = 28.5],
     [measurement(meas47),
      val(meas47, p6yCm, 5.0890684967150195),
      val(meas47, p4yCm, 28.5),
      -23.41093150328498 is 5.0890684967150195 - 28.5]).
step(val(meas47, p6yCm, 5.0890684967150195),
     rule(39),
     ['M' = meas47, 'Z' = 5.0890684967150195, 'X' = -0.5109315032849803, 'Y' = 5.6],
     [measurement(meas47),
      val(meas47, pL1dx62Cm, -0.5109315032849803),
      val(meas47, p2yCm, 5.6),
      5.0890684967150195 is -0.5109315032849803 + 5.6]).
step(val(meas47, pL1dx62Cm, -0.5109315032849803),
     rule(35),
     ['M' = meas47,
      'Z' = -0.5109315032849803,
      'X' = -0.06285714285714286,
      'Y' = 8.128455734079232],
     [measurement(meas47),
      val(meas47, cL1, -0.06285714285714286),
      val(meas47, dx62Cm, 8.128455734079232),
      -0.5109315032849803 is -0.06285714285714286 * 8.128455734079232]).
step(val(meas47, dx62Cm, 8.128455734079232),
     rule(15),
     ['M' = meas47, 'Z' = 8.128455734079232, 'X' = 53.22845573407923, 'Y' = 45.1],
     [measurement(meas47),
      val(meas47, p6xCm, 53.22845573407923),
      val(meas47, p2xCm, 45.1),
      8.128455734079232 is 53.22845573407923 - 45.1]).
step(8.128455734079232 is 53.22845573407923 - 45.1, builtin, [], []).
step(-0.5109315032849803 is -0.06285714285714286 * 8.128455734079232, builtin, [], []).
step(5.0890684967150195 is -0.5109315032849803 + 5.6, builtin, [], []).
step(-23.41093150328498 is 5.0890684967150195 - 28.5, builtin, [], []).
step(548.0717138515012 is -23.41093150328498 ** 2, builtin, [], []).
step(550.2371563780655 is 2.1654425265642967 + 548.0717138515012, builtin, [], []).
step(23.45713444515475 is 550.2371563780655 ** 0.5, builtin, [], []).
step(-1.9082339805374957 is 21.548900464617255 - 23.45713444515475, builtin, [], []).
step(threshold(meas47, lld_alarm_threshold_cm, 1.25), fact(11), [], []).
step(-1.25 is 0 - 1.25, builtin, [], []).
step(-1.9082339805374957 < -1.25, builtin, [], []).
step(lld_left_length_cm(meas47, 21.548900464617255),
     rule(51),
     ['M' = meas47, 'L' = 21.548900464617255],
     [type(meas47, lld_alarm), val(meas47, d53Cm, 21.548900464617255)]).
step(lld_right_length_cm(meas47, 23.45713444515475),
     rule(52),
     ['M' = meas47, 'R' = 23.45713444515475],
     [type(meas47, lld_alarm), val(meas47, d64Cm, 23.45713444515475)]).
step(lld_discrepancy_cm(meas47, -1.9082339805374957),
     rule(53),
     ['M' = meas47, 'D' = -1.9082339805374957],
     [type(meas47, lld_alarm), val(meas47, dCm, -1.9082339805374957)]).
step(lld_threshold_cm(meas47, 1.25),
     rule(54),
     ['M' = meas47, 'T' = 1.25],
     [type(meas47, lld_alarm), threshold(meas47, lld_alarm_threshold_cm, 1.25)]).
step(lld_reason(meas47, "discrepancy below negative threshold"),
     rule(55),
     ['M' = meas47],
     [type(meas47, lld_alarm)]).
