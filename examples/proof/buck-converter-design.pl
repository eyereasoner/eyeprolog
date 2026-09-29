dutyCycle(regulator1, 0.20833333333333334).
inductorRipple_A(regulator1, 0.35984848484848486).
rippleRatio(regulator1, 0.17992424242424243).
capacitorRipple_V(regulator1, 0.0019140876853642812).
status(regulator1, stable_ripple_design).
reason(regulator1, "inductor-current and output-voltage ripple are below design limits").

clause(1, converter(regulator1, inputVoltage_V, 24.0), true).
clause(2, converter(regulator1, outputVoltage_V, 5.0), true).
clause(3, converter(regulator1, loadCurrent_A, 2.0), true).
clause(4, converter(regulator1, switchingFrequency_Hz, 500000.0), true).
clause(5, converter(regulator1, inductance_H, 0.000022), true).
clause(6, converter(regulator1, capacitance_F, 0.000047), true).
clause(7, limit(regulator1, maxRippleRatio, 0.3), true).
clause(8, limit(regulator1, maxOutputRipple_V, 0.05), true).
clause(9,
       duty_cycle(var('Converter'), var('Duty')),
       (converter(var('Converter'), outputVoltage_V, var('Outputvoltage')),
        converter(var('Converter'), inputVoltage_V, var('Inputvoltage')),
        var('Duty') is var('Outputvoltage') / var('Inputvoltage'))).
clause(10,
       inductor_ripple_current(var('Converter'), var('Ripplecurrent')),
       (converter(var('Converter'), inputVoltage_V, var('Inputvoltage')),
        converter(var('Converter'), outputVoltage_V, var('Outputvoltage')),
        converter(var('Converter'), inductance_H, var('Inductance')),
        converter(var('Converter'), switchingFrequency_Hz, var('Frequency')),
        duty_cycle(var('Converter'), var('Duty')),
        var('Voltageacrossinductor') is var('Inputvoltage') - var('Outputvoltage'),
        var('Numerator') is var('Voltageacrossinductor') * var('Duty'),
        var('Denominator') is var('Inductance') * var('Frequency'),
        var('Ripplecurrent') is var('Numerator') / var('Denominator'))).
clause(11,
       ripple_ratio(var('Converter'), var('Ratio')),
       (inductor_ripple_current(var('Converter'), var('Ripplecurrent')),
        converter(var('Converter'), loadCurrent_A, var('Loadcurrent')),
        var('Ratio') is var('Ripplecurrent') / var('Loadcurrent'))).
clause(12,
       capacitor_ripple_voltage(var('Converter'), var('Ripplevoltage')),
       (inductor_ripple_current(var('Converter'), var('Ripplecurrent')),
        converter(var('Converter'), switchingFrequency_Hz, var('Frequency')),
        converter(var('Converter'), capacitance_F, var('Capacitance')),
        var('Eightf') is 8.0 * var('Frequency'),
        var('Denominator') is var('Eightf') * var('Capacitance'),
        var('Ripplevoltage') is var('Ripplecurrent') / var('Denominator'))).
clause(13,
       within_ripple_limits(var('Converter')),
       (ripple_ratio(var('Converter'), var('Ratio')),
        limit(var('Converter'), maxRippleRatio, var('Maxratio')),
        var('Ratio') < var('Maxratio'),
        capacitor_ripple_voltage(var('Converter'), var('Ripplevoltage')),
        limit(var('Converter'), maxOutputRipple_V, var('Maxripplevoltage')),
        var('Ripplevoltage') < var('Maxripplevoltage'))).
clause(14, dutyCycle(var('Converter'), var('Duty')), duty_cycle(var('Converter'), var('Duty'))).
clause(15,
       inductorRipple_A(var('Converter'), var('Ripplecurrent')),
       inductor_ripple_current(var('Converter'), var('Ripplecurrent'))).
clause(16,
       rippleRatio(var('Converter'), var('Ratio')),
       ripple_ratio(var('Converter'), var('Ratio'))).
clause(17,
       capacitorRipple_V(var('Converter'), var('Ripplevoltage')),
       capacitor_ripple_voltage(var('Converter'), var('Ripplevoltage'))).
clause(18,
       status(var('Converter'), stable_ripple_design),
       within_ripple_limits(var('Converter'))).
clause(19,
       reason(var('Converter'), "inductor-current and output-voltage ripple are below design limits"),
       within_ripple_limits(var('Converter'))).

step(dutyCycle(regulator1, 0.20833333333333334),
     rule(14),
     ['Converter' = regulator1, 'Duty' = 0.20833333333333334],
     [duty_cycle(regulator1, 0.20833333333333334)]).
step(duty_cycle(regulator1, 0.20833333333333334),
     rule(9),
     ['Converter' = regulator1,
      'Duty' = 0.20833333333333334,
      'Outputvoltage' = 5.0,
      'Inputvoltage' = 24.0],
     [converter(regulator1, outputVoltage_V, 5.0),
      converter(regulator1, inputVoltage_V, 24.0),
      0.20833333333333334 is 5.0 / 24.0]).
step(converter(regulator1, outputVoltage_V, 5.0), fact(2), [], []).
step(converter(regulator1, inputVoltage_V, 24.0), fact(1), [], []).
step(0.20833333333333334 is 5.0 / 24.0, builtin, [], []).
step(inductorRipple_A(regulator1, 0.35984848484848486),
     rule(15),
     ['Converter' = regulator1, 'Ripplecurrent' = 0.35984848484848486],
     [inductor_ripple_current(regulator1, 0.35984848484848486)]).
step(inductor_ripple_current(regulator1, 0.35984848484848486),
     rule(10),
     ['Converter' = regulator1,
      'Ripplecurrent' = 0.35984848484848486,
      'Inputvoltage' = 24.0,
      'Outputvoltage' = 5.0,
      'Inductance' = 0.000022,
      'Frequency' = 500000.0,
      'Duty' = 0.20833333333333334,
      'Voltageacrossinductor' = 19.0,
      'Numerator' = 3.9583333333333335,
      'Denominator' = 11.0],
     [converter(regulator1, inputVoltage_V, 24.0),
      converter(regulator1, outputVoltage_V, 5.0),
      converter(regulator1, inductance_H, 0.000022),
      converter(regulator1, switchingFrequency_Hz, 500000.0),
      duty_cycle(regulator1, 0.20833333333333334),
      19.0 is 24.0 - 5.0,
      3.9583333333333335 is 19.0 * 0.20833333333333334,
      11.0 is 0.000022 * 500000.0,
      0.35984848484848486 is 3.9583333333333335 / 11.0]).
step(converter(regulator1, inductance_H, 0.000022), fact(5), [], []).
step(converter(regulator1, switchingFrequency_Hz, 500000.0), fact(4), [], []).
step(19.0 is 24.0 - 5.0, builtin, [], []).
step(3.9583333333333335 is 19.0 * 0.20833333333333334, builtin, [], []).
step(11.0 is 0.000022 * 500000.0, builtin, [], []).
step(0.35984848484848486 is 3.9583333333333335 / 11.0, builtin, [], []).
step(rippleRatio(regulator1, 0.17992424242424243),
     rule(16),
     ['Converter' = regulator1, 'Ratio' = 0.17992424242424243],
     [ripple_ratio(regulator1, 0.17992424242424243)]).
step(ripple_ratio(regulator1, 0.17992424242424243),
     rule(11),
     ['Converter' = regulator1,
      'Ratio' = 0.17992424242424243,
      'Ripplecurrent' = 0.35984848484848486,
      'Loadcurrent' = 2.0],
     [inductor_ripple_current(regulator1, 0.35984848484848486),
      converter(regulator1, loadCurrent_A, 2.0),
      0.17992424242424243 is 0.35984848484848486 / 2.0]).
step(converter(regulator1, loadCurrent_A, 2.0), fact(3), [], []).
step(0.17992424242424243 is 0.35984848484848486 / 2.0, builtin, [], []).
step(capacitorRipple_V(regulator1, 0.0019140876853642812),
     rule(17),
     ['Converter' = regulator1, 'Ripplevoltage' = 0.0019140876853642812],
     [capacitor_ripple_voltage(regulator1, 0.0019140876853642812)]).
step(capacitor_ripple_voltage(regulator1, 0.0019140876853642812),
     rule(12),
     ['Converter' = regulator1,
      'Ripplevoltage' = 0.0019140876853642812,
      'Ripplecurrent' = 0.35984848484848486,
      'Frequency' = 500000.0,
      'Capacitance' = 0.000047,
      'Eightf' = 4000000.0,
      'Denominator' = 188.0],
     [inductor_ripple_current(regulator1, 0.35984848484848486),
      converter(regulator1, switchingFrequency_Hz, 500000.0),
      converter(regulator1, capacitance_F, 0.000047),
      4000000.0 is 8.0 * 500000.0,
      188.0 is 4000000.0 * 0.000047,
      0.0019140876853642812 is 0.35984848484848486 / 188.0]).
step(converter(regulator1, capacitance_F, 0.000047), fact(6), [], []).
step(4000000.0 is 8.0 * 500000.0, builtin, [], []).
step(188.0 is 4000000.0 * 0.000047, builtin, [], []).
step(0.0019140876853642812 is 0.35984848484848486 / 188.0, builtin, [], []).
step(status(regulator1, stable_ripple_design),
     rule(18),
     ['Converter' = regulator1],
     [within_ripple_limits(regulator1)]).
step(within_ripple_limits(regulator1),
     rule(13),
     ['Converter' = regulator1,
      'Ratio' = 0.17992424242424243,
      'Maxratio' = 0.3,
      'Ripplevoltage' = 0.0019140876853642812,
      'Maxripplevoltage' = 0.05],
     [ripple_ratio(regulator1, 0.17992424242424243),
      limit(regulator1, maxRippleRatio, 0.3),
      0.17992424242424243 < 0.3,
      capacitor_ripple_voltage(regulator1, 0.0019140876853642812),
      limit(regulator1, maxOutputRipple_V, 0.05),
      0.0019140876853642812 < 0.05]).
step(limit(regulator1, maxRippleRatio, 0.3), fact(7), [], []).
step(0.17992424242424243 < 0.3, builtin, [], []).
step(limit(regulator1, maxOutputRipple_V, 0.05), fact(8), [], []).
step(0.0019140876853642812 < 0.05, builtin, [], []).
step(reason(regulator1, "inductor-current and output-voltage ripple are below design limits"),
     rule(19),
     ['Converter' = regulator1],
     [within_ripple_limits(regulator1)]).
