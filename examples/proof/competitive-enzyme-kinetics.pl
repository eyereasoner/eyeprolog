effectiveKm_uM(assay1, 90.0).
uninhibitedRate_uM_s(assay1, 75.0).
inhibitedRate_uM_s(assay1, 42.857142857142854).
inhibitionFraction(assay1, 0.4285714285714286).
status(assay1, significant_inhibition).
reason(assay1, "competitive inhibitor raises effective Km and lowers reaction rate").

clause(1, assay(assay1, vmax_uM_s, 120.0), true).
clause(2, assay(assay1, substrate_uM, 50.0), true).
clause(3, assay(assay1, km_uM, 30.0), true).
clause(4, assay(assay1, inhibitor_uM, 10.0), true).
clause(5, assay(assay1, ki_uM, 5.0), true).
clause(6, threshold(assay1, significant_inhibition_fraction, 0.25), true).
clause(7,
       competitive_multiplier(var('Assay'), var('Multiplier')),
       (assay(var('Assay'), inhibitor_uM, var('Inhibitor')),
        assay(var('Assay'), ki_uM, var('Ki')),
        var('Ratio') is var('Inhibitor') / var('Ki'),
        var('Multiplier') is 1.0 + var('Ratio'))).
clause(8,
       effective_km(var('Assay'), var('Effectivekm')),
       (assay(var('Assay'), km_uM, var('Km')),
        competitive_multiplier(var('Assay'), var('Multiplier')),
        var('Effectivekm') is var('Km') * var('Multiplier'))).
clause(9,
       uninhibited_rate(var('Assay'), var('Rate')),
       (assay(var('Assay'), vmax_uM_s, var('Vmax')),
        assay(var('Assay'), substrate_uM, var('Substrate')),
        assay(var('Assay'), km_uM, var('Km')),
        var('Numerator') is var('Vmax') * var('Substrate'),
        var('Denominator') is var('Km') + var('Substrate'),
        var('Rate') is var('Numerator') / var('Denominator'))).
clause(10,
       inhibited_rate(var('Assay'), var('Rate')),
       (assay(var('Assay'), vmax_uM_s, var('Vmax')),
        assay(var('Assay'), substrate_uM, var('Substrate')),
        effective_km(var('Assay'), var('Effectivekm')),
        var('Numerator') is var('Vmax') * var('Substrate'),
        var('Denominator') is var('Effectivekm') + var('Substrate'),
        var('Rate') is var('Numerator') / var('Denominator'))).
clause(11,
       inhibition_fraction(var('Assay'), var('Fraction')),
       (uninhibited_rate(var('Assay'), var('Uninhibited')),
        inhibited_rate(var('Assay'), var('Inhibited')),
        var('Delta') is var('Uninhibited') - var('Inhibited'),
        var('Fraction') is var('Delta') / var('Uninhibited'))).
clause(12,
       significant_inhibition(var('Assay')),
       (inhibition_fraction(var('Assay'), var('Fraction')),
        threshold(var('Assay'), significant_inhibition_fraction, var('Limit')),
        var('Fraction') > var('Limit'))).
clause(13,
       effectiveKm_uM(var('Assay'), var('Effectivekm')),
       effective_km(var('Assay'), var('Effectivekm'))).
clause(14,
       uninhibitedRate_uM_s(var('Assay'), var('Rate')),
       uninhibited_rate(var('Assay'), var('Rate'))).
clause(15,
       inhibitedRate_uM_s(var('Assay'), var('Rate')),
       inhibited_rate(var('Assay'), var('Rate'))).
clause(16,
       inhibitionFraction(var('Assay'), var('Fraction')),
       inhibition_fraction(var('Assay'), var('Fraction'))).
clause(17, status(var('Assay'), significant_inhibition), significant_inhibition(var('Assay'))).
clause(18,
       reason(var('Assay'), "competitive inhibitor raises effective Km and lowers reaction rate"),
       significant_inhibition(var('Assay'))).

step(effectiveKm_uM(assay1, 90.0),
     rule(13),
     ['Assay' = assay1, 'Effectivekm' = 90.0],
     [effective_km(assay1, 90.0)]).
step(effective_km(assay1, 90.0),
     rule(8),
     ['Assay' = assay1, 'Effectivekm' = 90.0, 'Km' = 30.0, 'Multiplier' = 3.0],
     [assay(assay1, km_uM, 30.0), competitive_multiplier(assay1, 3.0), 90.0 is 30.0 * 3.0]).
step(assay(assay1, km_uM, 30.0), fact(3), [], []).
step(competitive_multiplier(assay1, 3.0),
     rule(7),
     ['Assay' = assay1, 'Multiplier' = 3.0, 'Inhibitor' = 10.0, 'Ki' = 5.0, 'Ratio' = 2.0],
     [assay(assay1, inhibitor_uM, 10.0),
      assay(assay1, ki_uM, 5.0),
      2.0 is 10.0 / 5.0,
      3.0 is 1.0 + 2.0]).
step(assay(assay1, inhibitor_uM, 10.0), fact(4), [], []).
step(assay(assay1, ki_uM, 5.0), fact(5), [], []).
step(2.0 is 10.0 / 5.0, builtin, [], []).
step(3.0 is 1.0 + 2.0, builtin, [], []).
step(90.0 is 30.0 * 3.0, builtin, [], []).
step(uninhibitedRate_uM_s(assay1, 75.0),
     rule(14),
     ['Assay' = assay1, 'Rate' = 75.0],
     [uninhibited_rate(assay1, 75.0)]).
step(uninhibited_rate(assay1, 75.0),
     rule(9),
     ['Assay' = assay1,
      'Rate' = 75.0,
      'Vmax' = 120.0,
      'Substrate' = 50.0,
      'Km' = 30.0,
      'Numerator' = 6000.0,
      'Denominator' = 80.0],
     [assay(assay1, vmax_uM_s, 120.0),
      assay(assay1, substrate_uM, 50.0),
      assay(assay1, km_uM, 30.0),
      6000.0 is 120.0 * 50.0,
      80.0 is 30.0 + 50.0,
      75.0 is 6000.0 / 80.0]).
step(assay(assay1, vmax_uM_s, 120.0), fact(1), [], []).
step(assay(assay1, substrate_uM, 50.0), fact(2), [], []).
step(6000.0 is 120.0 * 50.0, builtin, [], []).
step(80.0 is 30.0 + 50.0, builtin, [], []).
step(75.0 is 6000.0 / 80.0, builtin, [], []).
step(inhibitedRate_uM_s(assay1, 42.857142857142854),
     rule(15),
     ['Assay' = assay1, 'Rate' = 42.857142857142854],
     [inhibited_rate(assay1, 42.857142857142854)]).
step(inhibited_rate(assay1, 42.857142857142854),
     rule(10),
     ['Assay' = assay1,
      'Rate' = 42.857142857142854,
      'Vmax' = 120.0,
      'Substrate' = 50.0,
      'Effectivekm' = 90.0,
      'Numerator' = 6000.0,
      'Denominator' = 140.0],
     [assay(assay1, vmax_uM_s, 120.0),
      assay(assay1, substrate_uM, 50.0),
      effective_km(assay1, 90.0),
      6000.0 is 120.0 * 50.0,
      140.0 is 90.0 + 50.0,
      42.857142857142854 is 6000.0 / 140.0]).
step(140.0 is 90.0 + 50.0, builtin, [], []).
step(42.857142857142854 is 6000.0 / 140.0, builtin, [], []).
step(inhibitionFraction(assay1, 0.4285714285714286),
     rule(16),
     ['Assay' = assay1, 'Fraction' = 0.4285714285714286],
     [inhibition_fraction(assay1, 0.4285714285714286)]).
step(inhibition_fraction(assay1, 0.4285714285714286),
     rule(11),
     ['Assay' = assay1,
      'Fraction' = 0.4285714285714286,
      'Uninhibited' = 75.0,
      'Inhibited' = 42.857142857142854,
      'Delta' = 32.142857142857146],
     [uninhibited_rate(assay1, 75.0),
      inhibited_rate(assay1, 42.857142857142854),
      32.142857142857146 is 75.0 - 42.857142857142854,
      0.4285714285714286 is 32.142857142857146 / 75.0]).
step(32.142857142857146 is 75.0 - 42.857142857142854, builtin, [], []).
step(0.4285714285714286 is 32.142857142857146 / 75.0, builtin, [], []).
step(status(assay1, significant_inhibition),
     rule(17),
     ['Assay' = assay1],
     [significant_inhibition(assay1)]).
step(significant_inhibition(assay1),
     rule(12),
     ['Assay' = assay1, 'Fraction' = 0.4285714285714286, 'Limit' = 0.25],
     [inhibition_fraction(assay1, 0.4285714285714286),
      threshold(assay1, significant_inhibition_fraction, 0.25),
      0.4285714285714286 > 0.25]).
step(threshold(assay1, significant_inhibition_fraction, 0.25), fact(6), [], []).
step(0.4285714285714286 > 0.25, builtin, [], []).
step(reason(assay1, "competitive inhibitor raises effective Km and lowers reaction rate"),
     rule(18),
     ['Assay' = assay1],
     [significant_inhibition(assay1)]).
