ppvPlanetGivenDetection(rare_wide_orbit, 0.09016393442622944).
ppvPlanetGivenDetection(mstar_short_period, 0.9611650485436893).
ppvPlanetGivenDetection(common_hot_neptune_good, 0.9134615384615384).
ppvPlanetGivenDetection(common_hot_neptune_low_spec, 0.76).
confirmsInWorld(mstar_short_period, w0).
confirmsInWorld(common_hot_neptune_good, w0).
confirmsInWorld(rare_wide_orbit, w1).
confirmsInWorld(mstar_short_period, w1).
confirmsInWorld(common_hot_neptune_good, w1).
confirmsInWorld(common_hot_neptune_low_spec, w1).
confirmsInWorld(mstar_short_period, w2).
confirmsInWorld(common_hot_neptune_good, w2).
confirmsInWorld(mstar_short_period, w3).
rejectsInWorld(rare_wide_orbit, w0).
rejectsInWorld(common_hot_neptune_low_spec, w0).
rejectsInWorld(rare_wide_orbit, w2).
rejectsInWorld(common_hot_neptune_low_spec, w2).
rejectsInWorld(rare_wide_orbit, w3).
rejectsInWorld(common_hot_neptune_good, w3).
rejectsInWorld(common_hot_neptune_low_spec, w3).
status(exoplanet_validation_worlds, expected_world_pattern).
reason(exoplanet_validation_worlds, "Bayesian worlds account for occurrence and false positives while the naive world trusts sensitivity alone").

clause(3, candidate(rare_wide_orbit, 0.001, 0.99, 0.99), true).
clause(4, candidate(mstar_short_period, 0.2, 0.99, 0.99), true).
clause(5, candidate(common_hot_neptune_good, 0.25, 0.95, 0.97), true).
clause(6, candidate(common_hot_neptune_low_spec, 0.25, 0.95, 0.9), true).
clause(11,
       ppv_planet(var('Candidate'), var('Ppv')),
       (candidate(var('Candidate'), var('Occurrence'), var('Sensitivity'), var('Specificity')),
        var('Numerator') is var('Sensitivity') * var('Occurrence'),
        var('Noplanetprior') is 1.0 - var('Occurrence'),
        var('Falsepositiverate') is 1.0 - var('Specificity'),
        var('Falsepositivemass') is var('Falsepositiverate') * var('Noplanetprior'),
        var('Denominator') is var('Numerator') + var('Falsepositivemass'),
        var('Ppv') is var('Numerator') / var('Denominator'))).
clause(12,
       confirms_in_world(var('Candidate'), w0),
       (ppv_planet(var('Candidate'), var('Ppv')), var('Ppv') >= 0.9)).
clause(13,
       rejects_in_world(var('Candidate'), w0),
       (ppv_planet(var('Candidate'), var('Ppv')), var('Ppv') < 0.9)).
clause(14,
       confirms_in_world(var('Candidate'), w1),
       (candidate(var('Candidate'), anonymous(1), var('Sensitivity'), anonymous(2)),
        var('Sensitivity') >= 0.95)).
clause(16,
       confirms_in_world(var('Candidate'), w2),
       (candidate(var('Candidate'), var('Occurrence'), var('Sensitivity'), var('Specificity')),
        var('Occurrence') >= 0.05,
        var('Sensitivity') >= 0.9,
        var('Specificity') >= 0.97)).
clause(17,
       rejects_in_world(var('Candidate'), w2),
       (candidate(var('Candidate'), var('Occurrence'), anonymous(1), anonymous(2)),
        var('Occurrence') < 0.05)).
clause(19,
       rejects_in_world(var('Candidate'), w2),
       (candidate(var('Candidate'), anonymous(1), anonymous(2), var('Specificity')),
        var('Specificity') < 0.97)).
clause(20,
       confirms_in_world(var('Candidate'), w3),
       (ppv_planet(var('Candidate'), var('Ppv')), var('Ppv') >= 0.93)).
clause(21,
       rejects_in_world(var('Candidate'), w3),
       (ppv_planet(var('Candidate'), var('Ppv')), var('Ppv') < 0.93)).
clause(22,
       pattern_matches(report),
       (confirms_in_world(rare_wide_orbit, w1),
        rejects_in_world(rare_wide_orbit, w0),
        rejects_in_world(rare_wide_orbit, w2),
        rejects_in_world(rare_wide_orbit, w3),
        confirms_in_world(mstar_short_period, w0),
        confirms_in_world(mstar_short_period, w1),
        confirms_in_world(mstar_short_period, w2),
        confirms_in_world(mstar_short_period, w3),
        confirms_in_world(common_hot_neptune_good, w0),
        confirms_in_world(common_hot_neptune_good, w1),
        confirms_in_world(common_hot_neptune_good, w2),
        rejects_in_world(common_hot_neptune_good, w3),
        confirms_in_world(common_hot_neptune_low_spec, w1),
        rejects_in_world(common_hot_neptune_low_spec, w0),
        rejects_in_world(common_hot_neptune_low_spec, w2),
        rejects_in_world(common_hot_neptune_low_spec, w3))).
clause(23,
       ppvPlanetGivenDetection(var('Candidate'), var('Ppv')),
       ppv_planet(var('Candidate'), var('Ppv'))).
clause(24,
       confirmsInWorld(var('Candidate'), var('World')),
       confirms_in_world(var('Candidate'), var('World'))).
clause(25,
       rejectsInWorld(var('Candidate'), var('World')),
       rejects_in_world(var('Candidate'), var('World'))).
clause(26, status(exoplanet_validation_worlds, expected_world_pattern), pattern_matches(report)).
clause(27,
       reason(exoplanet_validation_worlds, "Bayesian worlds account for occurrence and false positives while the naive world trusts sensitivity alone"),
       pattern_matches(report)).

step(ppvPlanetGivenDetection(rare_wide_orbit, 0.09016393442622944),
     rule(23),
     ['Candidate' = rare_wide_orbit, 'Ppv' = 0.09016393442622944],
     [ppv_planet(rare_wide_orbit, 0.09016393442622944)]).
step(ppv_planet(rare_wide_orbit, 0.09016393442622944),
     rule(11),
     ['Candidate' = rare_wide_orbit,
      'Ppv' = 0.09016393442622944,
      'Occurrence' = 0.001,
      'Sensitivity' = 0.99,
      'Specificity' = 0.99,
      'Numerator' = 0.00099,
      'Noplanetprior' = 0.999,
      'Falsepositiverate' = 0.010000000000000009,
      'Falsepositivemass' = 0.00999000000000001,
      'Denominator' = 0.010980000000000009],
     [candidate(rare_wide_orbit, 0.001, 0.99, 0.99),
      0.00099 is 0.99 * 0.001,
      0.999 is 1.0 - 0.001,
      0.010000000000000009 is 1.0 - 0.99,
      0.00999000000000001 is 0.010000000000000009 * 0.999,
      0.010980000000000009 is 0.00099 + 0.00999000000000001,
      0.09016393442622944 is 0.00099 / 0.010980000000000009]).
step(candidate(rare_wide_orbit, 0.001, 0.99, 0.99), fact(3), [], []).
step(0.00099 is 0.99 * 0.001, builtin, [], []).
step(0.999 is 1.0 - 0.001, builtin, [], []).
step(0.010000000000000009 is 1.0 - 0.99, builtin, [], []).
step(0.00999000000000001 is 0.010000000000000009 * 0.999, builtin, [], []).
step(0.010980000000000009 is 0.00099 + 0.00999000000000001, builtin, [], []).
step(0.09016393442622944 is 0.00099 / 0.010980000000000009, builtin, [], []).
step(ppvPlanetGivenDetection(mstar_short_period, 0.9611650485436893),
     rule(23),
     ['Candidate' = mstar_short_period, 'Ppv' = 0.9611650485436893],
     [ppv_planet(mstar_short_period, 0.9611650485436893)]).
step(ppv_planet(mstar_short_period, 0.9611650485436893),
     rule(11),
     ['Candidate' = mstar_short_period,
      'Ppv' = 0.9611650485436893,
      'Occurrence' = 0.2,
      'Sensitivity' = 0.99,
      'Specificity' = 0.99,
      'Numerator' = 0.198,
      'Noplanetprior' = 0.8,
      'Falsepositiverate' = 0.010000000000000009,
      'Falsepositivemass' = 0.008000000000000007,
      'Denominator' = 0.20600000000000002],
     [candidate(mstar_short_period, 0.2, 0.99, 0.99),
      0.198 is 0.99 * 0.2,
      0.8 is 1.0 - 0.2,
      0.010000000000000009 is 1.0 - 0.99,
      0.008000000000000007 is 0.010000000000000009 * 0.8,
      0.20600000000000002 is 0.198 + 0.008000000000000007,
      0.9611650485436893 is 0.198 / 0.20600000000000002]).
step(candidate(mstar_short_period, 0.2, 0.99, 0.99), fact(4), [], []).
step(0.198 is 0.99 * 0.2, builtin, [], []).
step(0.8 is 1.0 - 0.2, builtin, [], []).
step(0.008000000000000007 is 0.010000000000000009 * 0.8, builtin, [], []).
step(0.20600000000000002 is 0.198 + 0.008000000000000007, builtin, [], []).
step(0.9611650485436893 is 0.198 / 0.20600000000000002, builtin, [], []).
step(ppvPlanetGivenDetection(common_hot_neptune_good, 0.9134615384615384),
     rule(23),
     ['Candidate' = common_hot_neptune_good, 'Ppv' = 0.9134615384615384],
     [ppv_planet(common_hot_neptune_good, 0.9134615384615384)]).
step(ppv_planet(common_hot_neptune_good, 0.9134615384615384),
     rule(11),
     ['Candidate' = common_hot_neptune_good,
      'Ppv' = 0.9134615384615384,
      'Occurrence' = 0.25,
      'Sensitivity' = 0.95,
      'Specificity' = 0.97,
      'Numerator' = 0.2375,
      'Noplanetprior' = 0.75,
      'Falsepositiverate' = 0.030000000000000027,
      'Falsepositivemass' = 0.02250000000000002,
      'Denominator' = 0.26],
     [candidate(common_hot_neptune_good, 0.25, 0.95, 0.97),
      0.2375 is 0.95 * 0.25,
      0.75 is 1.0 - 0.25,
      0.030000000000000027 is 1.0 - 0.97,
      0.02250000000000002 is 0.030000000000000027 * 0.75,
      0.26 is 0.2375 + 0.02250000000000002,
      0.9134615384615384 is 0.2375 / 0.26]).
step(candidate(common_hot_neptune_good, 0.25, 0.95, 0.97), fact(5), [], []).
step(0.2375 is 0.95 * 0.25, builtin, [], []).
step(0.75 is 1.0 - 0.25, builtin, [], []).
step(0.030000000000000027 is 1.0 - 0.97, builtin, [], []).
step(0.02250000000000002 is 0.030000000000000027 * 0.75, builtin, [], []).
step(0.26 is 0.2375 + 0.02250000000000002, builtin, [], []).
step(0.9134615384615384 is 0.2375 / 0.26, builtin, [], []).
step(ppvPlanetGivenDetection(common_hot_neptune_low_spec, 0.76),
     rule(23),
     ['Candidate' = common_hot_neptune_low_spec, 'Ppv' = 0.76],
     [ppv_planet(common_hot_neptune_low_spec, 0.76)]).
step(ppv_planet(common_hot_neptune_low_spec, 0.76),
     rule(11),
     ['Candidate' = common_hot_neptune_low_spec,
      'Ppv' = 0.76,
      'Occurrence' = 0.25,
      'Sensitivity' = 0.95,
      'Specificity' = 0.9,
      'Numerator' = 0.2375,
      'Noplanetprior' = 0.75,
      'Falsepositiverate' = 0.09999999999999998,
      'Falsepositivemass' = 0.07499999999999998,
      'Denominator' = 0.3125],
     [candidate(common_hot_neptune_low_spec, 0.25, 0.95, 0.9),
      0.2375 is 0.95 * 0.25,
      0.75 is 1.0 - 0.25,
      0.09999999999999998 is 1.0 - 0.9,
      0.07499999999999998 is 0.09999999999999998 * 0.75,
      0.3125 is 0.2375 + 0.07499999999999998,
      0.76 is 0.2375 / 0.3125]).
step(candidate(common_hot_neptune_low_spec, 0.25, 0.95, 0.9), fact(6), [], []).
step(0.09999999999999998 is 1.0 - 0.9, builtin, [], []).
step(0.07499999999999998 is 0.09999999999999998 * 0.75, builtin, [], []).
step(0.3125 is 0.2375 + 0.07499999999999998, builtin, [], []).
step(0.76 is 0.2375 / 0.3125, builtin, [], []).
step(confirmsInWorld(mstar_short_period, w0),
     rule(24),
     ['Candidate' = mstar_short_period, 'World' = w0],
     [confirms_in_world(mstar_short_period, w0)]).
step(confirms_in_world(mstar_short_period, w0),
     rule(12),
     ['Candidate' = mstar_short_period, 'Ppv' = 0.9611650485436893],
     [ppv_planet(mstar_short_period, 0.9611650485436893), 0.9611650485436893 >= 0.9]).
step(0.9611650485436893 >= 0.9, builtin, [], []).
step(confirmsInWorld(common_hot_neptune_good, w0),
     rule(24),
     ['Candidate' = common_hot_neptune_good, 'World' = w0],
     [confirms_in_world(common_hot_neptune_good, w0)]).
step(confirms_in_world(common_hot_neptune_good, w0),
     rule(12),
     ['Candidate' = common_hot_neptune_good, 'Ppv' = 0.9134615384615384],
     [ppv_planet(common_hot_neptune_good, 0.9134615384615384), 0.9134615384615384 >= 0.9]).
step(0.9134615384615384 >= 0.9, builtin, [], []).
step(confirmsInWorld(rare_wide_orbit, w1),
     rule(24),
     ['Candidate' = rare_wide_orbit, 'World' = w1],
     [confirms_in_world(rare_wide_orbit, w1)]).
step(confirms_in_world(rare_wide_orbit, w1),
     rule(14),
     ['Candidate' = rare_wide_orbit, 'Sensitivity' = 0.99],
     [candidate(rare_wide_orbit, 0.001, 0.99, 0.99), 0.99 >= 0.95]).
step(0.99 >= 0.95, builtin, [], []).
step(confirmsInWorld(mstar_short_period, w1),
     rule(24),
     ['Candidate' = mstar_short_period, 'World' = w1],
     [confirms_in_world(mstar_short_period, w1)]).
step(confirms_in_world(mstar_short_period, w1),
     rule(14),
     ['Candidate' = mstar_short_period, 'Sensitivity' = 0.99],
     [candidate(mstar_short_period, 0.2, 0.99, 0.99), 0.99 >= 0.95]).
step(confirmsInWorld(common_hot_neptune_good, w1),
     rule(24),
     ['Candidate' = common_hot_neptune_good, 'World' = w1],
     [confirms_in_world(common_hot_neptune_good, w1)]).
step(confirms_in_world(common_hot_neptune_good, w1),
     rule(14),
     ['Candidate' = common_hot_neptune_good, 'Sensitivity' = 0.95],
     [candidate(common_hot_neptune_good, 0.25, 0.95, 0.97), 0.95 >= 0.95]).
step(0.95 >= 0.95, builtin, [], []).
step(confirmsInWorld(common_hot_neptune_low_spec, w1),
     rule(24),
     ['Candidate' = common_hot_neptune_low_spec, 'World' = w1],
     [confirms_in_world(common_hot_neptune_low_spec, w1)]).
step(confirms_in_world(common_hot_neptune_low_spec, w1),
     rule(14),
     ['Candidate' = common_hot_neptune_low_spec, 'Sensitivity' = 0.95],
     [candidate(common_hot_neptune_low_spec, 0.25, 0.95, 0.9), 0.95 >= 0.95]).
step(confirmsInWorld(mstar_short_period, w2),
     rule(24),
     ['Candidate' = mstar_short_period, 'World' = w2],
     [confirms_in_world(mstar_short_period, w2)]).
step(confirms_in_world(mstar_short_period, w2),
     rule(16),
     ['Candidate' = mstar_short_period,
      'Occurrence' = 0.2,
      'Sensitivity' = 0.99,
      'Specificity' = 0.99],
     [candidate(mstar_short_period, 0.2, 0.99, 0.99), 0.2 >= 0.05, 0.99 >= 0.9, 0.99 >= 0.97]).
step(0.2 >= 0.05, builtin, [], []).
step(0.99 >= 0.9, builtin, [], []).
step(0.99 >= 0.97, builtin, [], []).
step(confirmsInWorld(common_hot_neptune_good, w2),
     rule(24),
     ['Candidate' = common_hot_neptune_good, 'World' = w2],
     [confirms_in_world(common_hot_neptune_good, w2)]).
step(confirms_in_world(common_hot_neptune_good, w2),
     rule(16),
     ['Candidate' = common_hot_neptune_good,
      'Occurrence' = 0.25,
      'Sensitivity' = 0.95,
      'Specificity' = 0.97],
     [candidate(common_hot_neptune_good, 0.25, 0.95, 0.97),
      0.25 >= 0.05,
      0.95 >= 0.9,
      0.97 >= 0.97]).
step(0.25 >= 0.05, builtin, [], []).
step(0.95 >= 0.9, builtin, [], []).
step(0.97 >= 0.97, builtin, [], []).
step(confirmsInWorld(mstar_short_period, w3),
     rule(24),
     ['Candidate' = mstar_short_period, 'World' = w3],
     [confirms_in_world(mstar_short_period, w3)]).
step(confirms_in_world(mstar_short_period, w3),
     rule(20),
     ['Candidate' = mstar_short_period, 'Ppv' = 0.9611650485436893],
     [ppv_planet(mstar_short_period, 0.9611650485436893), 0.9611650485436893 >= 0.93]).
step(0.9611650485436893 >= 0.93, builtin, [], []).
step(rejectsInWorld(rare_wide_orbit, w0),
     rule(25),
     ['Candidate' = rare_wide_orbit, 'World' = w0],
     [rejects_in_world(rare_wide_orbit, w0)]).
step(rejects_in_world(rare_wide_orbit, w0),
     rule(13),
     ['Candidate' = rare_wide_orbit, 'Ppv' = 0.09016393442622944],
     [ppv_planet(rare_wide_orbit, 0.09016393442622944), 0.09016393442622944 < 0.9]).
step(0.09016393442622944 < 0.9, builtin, [], []).
step(rejectsInWorld(common_hot_neptune_low_spec, w0),
     rule(25),
     ['Candidate' = common_hot_neptune_low_spec, 'World' = w0],
     [rejects_in_world(common_hot_neptune_low_spec, w0)]).
step(rejects_in_world(common_hot_neptune_low_spec, w0),
     rule(13),
     ['Candidate' = common_hot_neptune_low_spec, 'Ppv' = 0.76],
     [ppv_planet(common_hot_neptune_low_spec, 0.76), 0.76 < 0.9]).
step(0.76 < 0.9, builtin, [], []).
step(rejectsInWorld(rare_wide_orbit, w2),
     rule(25),
     ['Candidate' = rare_wide_orbit, 'World' = w2],
     [rejects_in_world(rare_wide_orbit, w2)]).
step(rejects_in_world(rare_wide_orbit, w2),
     rule(17),
     ['Candidate' = rare_wide_orbit, 'Occurrence' = 0.001],
     [candidate(rare_wide_orbit, 0.001, 0.99, 0.99), 0.001 < 0.05]).
step(0.001 < 0.05, builtin, [], []).
step(rejectsInWorld(common_hot_neptune_low_spec, w2),
     rule(25),
     ['Candidate' = common_hot_neptune_low_spec, 'World' = w2],
     [rejects_in_world(common_hot_neptune_low_spec, w2)]).
step(rejects_in_world(common_hot_neptune_low_spec, w2),
     rule(19),
     ['Candidate' = common_hot_neptune_low_spec, 'Specificity' = 0.9],
     [candidate(common_hot_neptune_low_spec, 0.25, 0.95, 0.9), 0.9 < 0.97]).
step(0.9 < 0.97, builtin, [], []).
step(rejectsInWorld(rare_wide_orbit, w3),
     rule(25),
     ['Candidate' = rare_wide_orbit, 'World' = w3],
     [rejects_in_world(rare_wide_orbit, w3)]).
step(rejects_in_world(rare_wide_orbit, w3),
     rule(21),
     ['Candidate' = rare_wide_orbit, 'Ppv' = 0.09016393442622944],
     [ppv_planet(rare_wide_orbit, 0.09016393442622944), 0.09016393442622944 < 0.93]).
step(0.09016393442622944 < 0.93, builtin, [], []).
step(rejectsInWorld(common_hot_neptune_good, w3),
     rule(25),
     ['Candidate' = common_hot_neptune_good, 'World' = w3],
     [rejects_in_world(common_hot_neptune_good, w3)]).
step(rejects_in_world(common_hot_neptune_good, w3),
     rule(21),
     ['Candidate' = common_hot_neptune_good, 'Ppv' = 0.9134615384615384],
     [ppv_planet(common_hot_neptune_good, 0.9134615384615384), 0.9134615384615384 < 0.93]).
step(0.9134615384615384 < 0.93, builtin, [], []).
step(rejectsInWorld(common_hot_neptune_low_spec, w3),
     rule(25),
     ['Candidate' = common_hot_neptune_low_spec, 'World' = w3],
     [rejects_in_world(common_hot_neptune_low_spec, w3)]).
step(rejects_in_world(common_hot_neptune_low_spec, w3),
     rule(21),
     ['Candidate' = common_hot_neptune_low_spec, 'Ppv' = 0.76],
     [ppv_planet(common_hot_neptune_low_spec, 0.76), 0.76 < 0.93]).
step(0.76 < 0.93, builtin, [], []).
step(status(exoplanet_validation_worlds, expected_world_pattern),
     rule(26),
     [],
     [pattern_matches(report)]).
step(pattern_matches(report),
     rule(22),
     [],
     [confirms_in_world(rare_wide_orbit, w1),
      rejects_in_world(rare_wide_orbit, w0),
      rejects_in_world(rare_wide_orbit, w2),
      rejects_in_world(rare_wide_orbit, w3),
      confirms_in_world(mstar_short_period, w0),
      confirms_in_world(mstar_short_period, w1),
      confirms_in_world(mstar_short_period, w2),
      confirms_in_world(mstar_short_period, w3),
      confirms_in_world(common_hot_neptune_good, w0),
      confirms_in_world(common_hot_neptune_good, w1),
      confirms_in_world(common_hot_neptune_good, w2),
      rejects_in_world(common_hot_neptune_good, w3),
      confirms_in_world(common_hot_neptune_low_spec, w1),
      rejects_in_world(common_hot_neptune_low_spec, w0),
      rejects_in_world(common_hot_neptune_low_spec, w2),
      rejects_in_world(common_hot_neptune_low_spec, w3)]).
step(reason(exoplanet_validation_worlds, "Bayesian worlds account for occurrence and false positives while the naive world trusts sensitivity alone"),
     rule(27),
     [],
     [pattern_matches(report)]).
