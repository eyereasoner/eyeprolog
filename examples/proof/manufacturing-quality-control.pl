cpk(line7_shift_a, 0.6666666666666673).
cpk(line8_shift_b, 1.6666666666666607).
status(line8_shift_b, capable_process).
status(line7_shift_a, needs_process_adjustment).
reason(line8_shift_b, "Cpk meets the production capability threshold").
reason(line7_shift_a, "Cpk is below the production capability threshold").

clause(3, spec(line7_shift_a, lower_mm, 10.0), true).
clause(4, spec(line7_shift_a, upper_mm, 10.2), true).
clause(5, summary(line7_shift_a, mean_mm, 10.12), true).
clause(6, summary(line7_shift_a, sigma_mm, 0.04), true).
clause(7, spec(line8_shift_b, lower_mm, 10.0), true).
clause(8, spec(line8_shift_b, upper_mm, 10.2), true).
clause(9, summary(line8_shift_b, mean_mm, 10.1), true).
clause(10, summary(line8_shift_b, sigma_mm, 0.02), true).
clause(11, capability_threshold(cpk, 1.33), true).
clause(12,
       upper_margin_mm(var('Run'), var('Margin')),
       (spec(var('Run'), upper_mm, var('Upper')),
        summary(var('Run'), mean_mm, var('Mean')),
        var('Margin') is var('Upper') - var('Mean'))).
clause(13,
       lower_margin_mm(var('Run'), var('Margin')),
       (summary(var('Run'), mean_mm, var('Mean')),
        spec(var('Run'), lower_mm, var('Lower')),
        var('Margin') is var('Mean') - var('Lower'))).
clause(14,
       nearest_spec_margin_mm(var('Run'), var('Margin')),
       (upper_margin_mm(var('Run'), var('Uppermargin')),
        lower_margin_mm(var('Run'), var('Lowermargin')),
        (var('Uppermargin') =< var('Lowermargin') -> var('Margin') = var('Uppermargin') ; var('Margin') = var('Lowermargin')))).
clause(15,
       three_sigma_mm(var('Run'), var('Threesigma')),
       (summary(var('Run'), sigma_mm, var('Sigma')), var('Threesigma') is 3.0 * var('Sigma'))).
clause(16,
       cpk(var('Run'), var('Cpk')),
       (nearest_spec_margin_mm(var('Run'), var('Margin')),
        three_sigma_mm(var('Run'), var('Threesigma')),
        var('Cpk') is var('Margin') / var('Threesigma'))).
clause(17,
       capable(var('Run')),
       (cpk(var('Run'), var('Cpk')),
        capability_threshold(cpk, var('Threshold')),
        var('Cpk') >= var('Threshold'))).
clause(18,
       needs_adjustment(var('Run')),
       (cpk(var('Run'), var('Cpk')),
        capability_threshold(cpk, var('Threshold')),
        var('Cpk') < var('Threshold'))).
clause(19, status(var('Run'), capable_process), capable(var('Run'))).
clause(20, status(var('Run'), needs_process_adjustment), needs_adjustment(var('Run'))).
clause(21,
       reason(var('Run'), "Cpk meets the production capability threshold"),
       capable(var('Run'))).
clause(22,
       reason(var('Run'), "Cpk is below the production capability threshold"),
       needs_adjustment(var('Run'))).

step(cpk(line7_shift_a, 0.6666666666666673),
     rule(16),
     ['Run' = line7_shift_a,
      'Cpk' = 0.6666666666666673,
      'Margin' = 0.08000000000000007,
      'Threesigma' = 0.12],
     [nearest_spec_margin_mm(line7_shift_a, 0.08000000000000007),
      three_sigma_mm(line7_shift_a, 0.12),
      0.6666666666666673 is 0.08000000000000007 / 0.12]).
step(nearest_spec_margin_mm(line7_shift_a, 0.08000000000000007),
     rule(14),
     ['Run' = line7_shift_a,
      'Margin' = 0.08000000000000007,
      'Uppermargin' = 0.08000000000000007,
      'Lowermargin' = 0.11999999999999922],
     [upper_margin_mm(line7_shift_a, 0.08000000000000007),
      lower_margin_mm(line7_shift_a, 0.11999999999999922),
      (0.08000000000000007 =< 0.11999999999999922 -> 0.08000000000000007 = 0.08000000000000007 ; 0.08000000000000007 = 0.11999999999999922)]).
step(upper_margin_mm(line7_shift_a, 0.08000000000000007),
     rule(12),
     ['Run' = line7_shift_a, 'Margin' = 0.08000000000000007, 'Upper' = 10.2, 'Mean' = 10.12],
     [spec(line7_shift_a, upper_mm, 10.2),
      summary(line7_shift_a, mean_mm, 10.12),
      0.08000000000000007 is 10.2 - 10.12]).
step(spec(line7_shift_a, upper_mm, 10.2), fact(4), [], []).
step(summary(line7_shift_a, mean_mm, 10.12), fact(5), [], []).
step(0.08000000000000007 is 10.2 - 10.12, builtin, [], []).
step(lower_margin_mm(line7_shift_a, 0.11999999999999922),
     rule(13),
     ['Run' = line7_shift_a, 'Margin' = 0.11999999999999922, 'Mean' = 10.12, 'Lower' = 10.0],
     [summary(line7_shift_a, mean_mm, 10.12),
      spec(line7_shift_a, lower_mm, 10.0),
      0.11999999999999922 is 10.12 - 10.0]).
step(spec(line7_shift_a, lower_mm, 10.0), fact(3), [], []).
step(0.11999999999999922 is 10.12 - 10.0, builtin, [], []).
step((0.08000000000000007 =< 0.11999999999999922 -> 0.08000000000000007 = 0.08000000000000007 ; 0.08000000000000007 = 0.11999999999999922),
     builtin,
     [],
     []).
step(three_sigma_mm(line7_shift_a, 0.12),
     rule(15),
     ['Run' = line7_shift_a, 'Threesigma' = 0.12, 'Sigma' = 0.04],
     [summary(line7_shift_a, sigma_mm, 0.04), 0.12 is 3.0 * 0.04]).
step(summary(line7_shift_a, sigma_mm, 0.04), fact(6), [], []).
step(0.12 is 3.0 * 0.04, builtin, [], []).
step(0.6666666666666673 is 0.08000000000000007 / 0.12, builtin, [], []).
step(cpk(line8_shift_b, 1.6666666666666607),
     rule(16),
     ['Run' = line8_shift_b,
      'Cpk' = 1.6666666666666607,
      'Margin' = 0.09999999999999964,
      'Threesigma' = 0.06],
     [nearest_spec_margin_mm(line8_shift_b, 0.09999999999999964),
      three_sigma_mm(line8_shift_b, 0.06),
      1.6666666666666607 is 0.09999999999999964 / 0.06]).
step(nearest_spec_margin_mm(line8_shift_b, 0.09999999999999964),
     rule(14),
     ['Run' = line8_shift_b,
      'Margin' = 0.09999999999999964,
      'Uppermargin' = 0.09999999999999964,
      'Lowermargin' = 0.09999999999999964],
     [upper_margin_mm(line8_shift_b, 0.09999999999999964),
      lower_margin_mm(line8_shift_b, 0.09999999999999964),
      (0.09999999999999964 =< 0.09999999999999964 -> 0.09999999999999964 = 0.09999999999999964 ; 0.09999999999999964 = 0.09999999999999964)]).
step(upper_margin_mm(line8_shift_b, 0.09999999999999964),
     rule(12),
     ['Run' = line8_shift_b, 'Margin' = 0.09999999999999964, 'Upper' = 10.2, 'Mean' = 10.1],
     [spec(line8_shift_b, upper_mm, 10.2),
      summary(line8_shift_b, mean_mm, 10.1),
      0.09999999999999964 is 10.2 - 10.1]).
step(spec(line8_shift_b, upper_mm, 10.2), fact(8), [], []).
step(summary(line8_shift_b, mean_mm, 10.1), fact(9), [], []).
step(0.09999999999999964 is 10.2 - 10.1, builtin, [], []).
step(lower_margin_mm(line8_shift_b, 0.09999999999999964),
     rule(13),
     ['Run' = line8_shift_b, 'Margin' = 0.09999999999999964, 'Mean' = 10.1, 'Lower' = 10.0],
     [summary(line8_shift_b, mean_mm, 10.1),
      spec(line8_shift_b, lower_mm, 10.0),
      0.09999999999999964 is 10.1 - 10.0]).
step(spec(line8_shift_b, lower_mm, 10.0), fact(7), [], []).
step(0.09999999999999964 is 10.1 - 10.0, builtin, [], []).
step((0.09999999999999964 =< 0.09999999999999964 -> 0.09999999999999964 = 0.09999999999999964 ; 0.09999999999999964 = 0.09999999999999964),
     builtin,
     [],
     []).
step(three_sigma_mm(line8_shift_b, 0.06),
     rule(15),
     ['Run' = line8_shift_b, 'Threesigma' = 0.06, 'Sigma' = 0.02],
     [summary(line8_shift_b, sigma_mm, 0.02), 0.06 is 3.0 * 0.02]).
step(summary(line8_shift_b, sigma_mm, 0.02), fact(10), [], []).
step(0.06 is 3.0 * 0.02, builtin, [], []).
step(1.6666666666666607 is 0.09999999999999964 / 0.06, builtin, [], []).
step(status(line8_shift_b, capable_process),
     rule(19),
     ['Run' = line8_shift_b],
     [capable(line8_shift_b)]).
step(capable(line8_shift_b),
     rule(17),
     ['Run' = line8_shift_b, 'Cpk' = 1.6666666666666607, 'Threshold' = 1.33],
     [cpk(line8_shift_b, 1.6666666666666607),
      capability_threshold(cpk, 1.33),
      1.6666666666666607 >= 1.33]).
step(capability_threshold(cpk, 1.33), fact(11), [], []).
step(1.6666666666666607 >= 1.33, builtin, [], []).
step(status(line7_shift_a, needs_process_adjustment),
     rule(20),
     ['Run' = line7_shift_a],
     [needs_adjustment(line7_shift_a)]).
step(needs_adjustment(line7_shift_a),
     rule(18),
     ['Run' = line7_shift_a, 'Cpk' = 0.6666666666666673, 'Threshold' = 1.33],
     [cpk(line7_shift_a, 0.6666666666666673),
      capability_threshold(cpk, 1.33),
      0.6666666666666673 < 1.33]).
step(0.6666666666666673 < 1.33, builtin, [], []).
step(reason(line8_shift_b, "Cpk meets the production capability threshold"),
     rule(21),
     ['Run' = line8_shift_b],
     [capable(line8_shift_b)]).
step(reason(line7_shift_a, "Cpk is below the production capability threshold"),
     rule(22),
     ['Run' = line7_shift_a],
     [needs_adjustment(line7_shift_a)]).
