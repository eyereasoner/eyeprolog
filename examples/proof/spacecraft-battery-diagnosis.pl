metric(bp1, thermal_margin_c, -18.0).
metric(bp1, resistive_heating_w, 16.0).
diagnosis(bp1, thermal_runaway_precursor).
action(bp1, isolate_and_cool).

clause(1, telemetry(bp1, temperature_c, 78.0), true).
clause(2, telemetry(bp1, temperature_rise_c_per_min, 4.2), true).
clause(3, telemetry(bp1, current_a, 32.0), true).
clause(4, telemetry(bp1, internal_resistance_ohm, 0.015625), true).
clause(5, telemetry(bp1, cell_delta_v, 0.19), true).
clause(6, redundant_telemetry(bp1, temperature_c, 76.0), true).
clause(7, safety_limit(max_safe_temperature_c, 60.0), true).
clause(8, safety_limit(max_temperature_rise_c_per_min, 1.5), true).
clause(9, safety_limit(max_cell_delta_v, 0.08), true).
clause(10, cooling_capacity_w(bp1, 12.0), true).
clause(11,
       metric(var('Pack'), thermal_margin_c, var('Margin')),
       (safety_limit(max_safe_temperature_c, var('Maximum')),
        telemetry(var('Pack'), temperature_c, var('Temperature')),
        var('Margin') is var('Maximum') - var('Temperature'))).
clause(12,
       metric(var('Pack'), resistive_heating_w, var('Heating')),
       (telemetry(var('Pack'), current_a, var('Current')),
        telemetry(var('Pack'), internal_resistance_ohm, var('Resistance')),
        var('CurrentSquared') is var('Current') * var('Current'),
        var('Heating') is var('CurrentSquared') * var('Resistance'))).
clause(13,
       over_temperature(var('Pack')),
       (telemetry(var('Pack'), temperature_c, var('Temperature')),
        safety_limit(max_safe_temperature_c, var('Maximum')),
        var('Temperature') > var('Maximum'))).
clause(14,
       rapid_heating(var('Pack')),
       (telemetry(var('Pack'), temperature_rise_c_per_min, var('Rate')),
        safety_limit(max_temperature_rise_c_per_min, var('Maximum')),
        var('Rate') > var('Maximum'))).
clause(15,
       cell_imbalance(var('Pack')),
       (telemetry(var('Pack'), cell_delta_v, var('Delta')),
        safety_limit(max_cell_delta_v, var('Maximum')),
        var('Delta') > var('Maximum'))).
clause(16,
       heating_exceeds_cooling(var('Pack')),
       (metric(var('Pack'), resistive_heating_w, var('Heating')),
        cooling_capacity_w(var('Pack'), var('Capacity')),
        var('Heating') > var('Capacity'))).
clause(17,
       corroborated_over_temperature(var('Pack')),
       (telemetry(var('Pack'), temperature_c, var('Primary')),
        redundant_telemetry(var('Pack'), temperature_c, var('Redundant')),
        safety_limit(max_safe_temperature_c, var('Maximum')),
        var('Primary') > var('Maximum'),
        var('Redundant') > var('Maximum'))).
clause(18,
       diagnosis(var('Pack'), thermal_runaway_precursor),
       (over_temperature(var('Pack')),
        rapid_heating(var('Pack')),
        cell_imbalance(var('Pack')),
        heating_exceeds_cooling(var('Pack')))).
clause(19,
       action(var('Pack'), isolate_and_cool),
       (diagnosis(var('Pack'), thermal_runaway_precursor),
        corroborated_over_temperature(var('Pack')))).

step(metric(bp1, thermal_margin_c, -18.0),
     rule(11),
     ['Pack' = bp1, 'Margin' = -18.0, 'Maximum' = 60.0, 'Temperature' = 78.0],
     [safety_limit(max_safe_temperature_c, 60.0),
      telemetry(bp1, temperature_c, 78.0),
      -18.0 is 60.0 - 78.0]).
step(safety_limit(max_safe_temperature_c, 60.0), fact(7), [], []).
step(telemetry(bp1, temperature_c, 78.0), fact(1), [], []).
step(-18.0 is 60.0 - 78.0, builtin, [], []).
step(metric(bp1, resistive_heating_w, 16.0),
     rule(12),
     ['Pack' = bp1,
      'Heating' = 16.0,
      'Current' = 32.0,
      'Resistance' = 0.015625,
      'CurrentSquared' = 1024.0],
     [telemetry(bp1, current_a, 32.0),
      telemetry(bp1, internal_resistance_ohm, 0.015625),
      1024.0 is 32.0 * 32.0,
      16.0 is 1024.0 * 0.015625]).
step(telemetry(bp1, current_a, 32.0), fact(3), [], []).
step(telemetry(bp1, internal_resistance_ohm, 0.015625), fact(4), [], []).
step(1024.0 is 32.0 * 32.0, builtin, [], []).
step(16.0 is 1024.0 * 0.015625, builtin, [], []).
step(diagnosis(bp1, thermal_runaway_precursor),
     rule(18),
     ['Pack' = bp1],
     [over_temperature(bp1),
      rapid_heating(bp1),
      cell_imbalance(bp1),
      heating_exceeds_cooling(bp1)]).
step(over_temperature(bp1),
     rule(13),
     ['Pack' = bp1, 'Temperature' = 78.0, 'Maximum' = 60.0],
     [telemetry(bp1, temperature_c, 78.0),
      safety_limit(max_safe_temperature_c, 60.0),
      78.0 > 60.0]).
step(78.0 > 60.0, builtin, [], []).
step(rapid_heating(bp1),
     rule(14),
     ['Pack' = bp1, 'Rate' = 4.2, 'Maximum' = 1.5],
     [telemetry(bp1, temperature_rise_c_per_min, 4.2),
      safety_limit(max_temperature_rise_c_per_min, 1.5),
      4.2 > 1.5]).
step(telemetry(bp1, temperature_rise_c_per_min, 4.2), fact(2), [], []).
step(safety_limit(max_temperature_rise_c_per_min, 1.5), fact(8), [], []).
step(4.2 > 1.5, builtin, [], []).
step(cell_imbalance(bp1),
     rule(15),
     ['Pack' = bp1, 'Delta' = 0.19, 'Maximum' = 0.08],
     [telemetry(bp1, cell_delta_v, 0.19), safety_limit(max_cell_delta_v, 0.08), 0.19 > 0.08]).
step(telemetry(bp1, cell_delta_v, 0.19), fact(5), [], []).
step(safety_limit(max_cell_delta_v, 0.08), fact(9), [], []).
step(0.19 > 0.08, builtin, [], []).
step(heating_exceeds_cooling(bp1),
     rule(16),
     ['Pack' = bp1, 'Heating' = 16.0, 'Capacity' = 12.0],
     [metric(bp1, resistive_heating_w, 16.0), cooling_capacity_w(bp1, 12.0), 16.0 > 12.0]).
step(cooling_capacity_w(bp1, 12.0), fact(10), [], []).
step(16.0 > 12.0, builtin, [], []).
step(action(bp1, isolate_and_cool),
     rule(19),
     ['Pack' = bp1],
     [diagnosis(bp1, thermal_runaway_precursor), corroborated_over_temperature(bp1)]).
step(corroborated_over_temperature(bp1),
     rule(17),
     ['Pack' = bp1, 'Primary' = 78.0, 'Redundant' = 76.0, 'Maximum' = 60.0],
     [telemetry(bp1, temperature_c, 78.0),
      redundant_telemetry(bp1, temperature_c, 76.0),
      safety_limit(max_safe_temperature_c, 60.0),
      78.0 > 60.0,
      76.0 > 60.0]).
step(redundant_telemetry(bp1, temperature_c, 76.0), fact(6), [], []).
step(76.0 > 60.0, builtin, [], []).
