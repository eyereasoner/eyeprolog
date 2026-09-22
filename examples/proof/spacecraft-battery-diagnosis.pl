metric(bp1, thermal_margin_c, -18.0).
why(
  metric(bp1, thermal_margin_c, -18.0),
  step(
    metric(bp1, thermal_margin_c, -18.0),
    rule("spacecraft-battery-diagnosis.pl", clause(11)),
    ['Pack' = bp1, 'Margin' = -18.0, 'Maximum' = 60.0, 'Temperature' = 78.0],
    [
      step(safety_limit(max_safe_temperature_c, 60.0), fact("spacecraft-battery-diagnosis.pl", clause(7)), [], []),
      step(telemetry(bp1, temperature_c, 78.0), fact("spacecraft-battery-diagnosis.pl", clause(1)), [], []),
      step(is(-18.0, '-'(60.0, 78.0)), builtin(is, 2), [], [])
    ]
  )
).

metric(bp1, resistive_heating_w, 16.0).
why(
  metric(bp1, resistive_heating_w, 16.0),
  step(
    metric(bp1, resistive_heating_w, 16.0),
    rule("spacecraft-battery-diagnosis.pl", clause(12)),
    ['Pack' = bp1, 'Heating' = 16.0, 'Current' = 32.0, 'Resistance' = 0.015625, 'CurrentSquared' = 1024.0],
    [
      step(telemetry(bp1, current_a, 32.0), fact("spacecraft-battery-diagnosis.pl", clause(3)), [], []),
      step(telemetry(bp1, internal_resistance_ohm, 0.015625), fact("spacecraft-battery-diagnosis.pl", clause(4)), [], []),
      step(is(1024.0, *(32.0, 32.0)), builtin(is, 2), [], []),
      step(is(16.0, *(1024.0, 0.015625)), builtin(is, 2), [], [])
    ]
  )
).

diagnosis(bp1, thermal_runaway_precursor).
why(
  diagnosis(bp1, thermal_runaway_precursor),
  step(
    diagnosis(bp1, thermal_runaway_precursor),
    rule("spacecraft-battery-diagnosis.pl", clause(18)),
    ['Pack' = bp1],
    [
      step(
        over_temperature(bp1),
        rule("spacecraft-battery-diagnosis.pl", clause(13)),
        ['Pack' = bp1, 'Temperature' = 78.0, 'Maximum' = 60.0],
        [
          step(telemetry(bp1, temperature_c, 78.0), fact("spacecraft-battery-diagnosis.pl", clause(1)), [], []),
          step(safety_limit(max_safe_temperature_c, 60.0), fact("spacecraft-battery-diagnosis.pl", clause(7)), [], []),
          step(>(78.0, 60.0), builtin(>, 2), [], [])
        ]
      ),
      step(
        rapid_heating(bp1),
        rule("spacecraft-battery-diagnosis.pl", clause(14)),
        ['Pack' = bp1, 'Rate' = 4.2, 'Maximum' = 1.5],
        [
          step(telemetry(bp1, temperature_rise_c_per_min, 4.2), fact("spacecraft-battery-diagnosis.pl", clause(2)), [], []),
          step(safety_limit(max_temperature_rise_c_per_min, 1.5), fact("spacecraft-battery-diagnosis.pl", clause(8)), [], []),
          step(>(4.2, 1.5), builtin(>, 2), [], [])
        ]
      ),
      step(
        cell_imbalance(bp1),
        rule("spacecraft-battery-diagnosis.pl", clause(15)),
        ['Pack' = bp1, 'Delta' = 0.19, 'Maximum' = 0.08],
        [
          step(telemetry(bp1, cell_delta_v, 0.19), fact("spacecraft-battery-diagnosis.pl", clause(5)), [], []),
          step(safety_limit(max_cell_delta_v, 0.08), fact("spacecraft-battery-diagnosis.pl", clause(9)), [], []),
          step(>(0.19, 0.08), builtin(>, 2), [], [])
        ]
      ),
      step(
        heating_exceeds_cooling(bp1),
        rule("spacecraft-battery-diagnosis.pl", clause(16)),
        ['Pack' = bp1, 'Heating' = 16.0, 'Capacity' = 12.0],
        [
          step(
            metric(bp1, resistive_heating_w, 16.0),
            rule("spacecraft-battery-diagnosis.pl", clause(12)),
            ['Pack' = bp1, 'Heating' = 16.0, 'Current' = 32.0, 'Resistance' = 0.015625, 'CurrentSquared' = 1024.0],
            [
              step(telemetry(bp1, current_a, 32.0), fact("spacecraft-battery-diagnosis.pl", clause(3)), [], []),
              step(telemetry(bp1, internal_resistance_ohm, 0.015625), fact("spacecraft-battery-diagnosis.pl", clause(4)), [], []),
              step(is(1024.0, *(32.0, 32.0)), builtin(is, 2), [], []),
              step(is(16.0, *(1024.0, 0.015625)), builtin(is, 2), [], [])
            ]
          ),
          step(cooling_capacity_w(bp1, 12.0), fact("spacecraft-battery-diagnosis.pl", clause(10)), [], []),
          step(>(16.0, 12.0), builtin(>, 2), [], [])
        ]
      )
    ]
  )
).

action(bp1, isolate_and_cool).
why(
  action(bp1, isolate_and_cool),
  step(
    action(bp1, isolate_and_cool),
    rule("spacecraft-battery-diagnosis.pl", clause(19)),
    ['Pack' = bp1],
    [
      step(
        diagnosis(bp1, thermal_runaway_precursor),
        rule("spacecraft-battery-diagnosis.pl", clause(18)),
        ['Pack' = bp1],
        [
          step(
            over_temperature(bp1),
            rule("spacecraft-battery-diagnosis.pl", clause(13)),
            ['Pack' = bp1, 'Temperature' = 78.0, 'Maximum' = 60.0],
            [
              step(telemetry(bp1, temperature_c, 78.0), fact("spacecraft-battery-diagnosis.pl", clause(1)), [], []),
              step(safety_limit(max_safe_temperature_c, 60.0), fact("spacecraft-battery-diagnosis.pl", clause(7)), [], []),
              step(>(78.0, 60.0), builtin(>, 2), [], [])
            ]
          ),
          step(
            rapid_heating(bp1),
            rule("spacecraft-battery-diagnosis.pl", clause(14)),
            ['Pack' = bp1, 'Rate' = 4.2, 'Maximum' = 1.5],
            [
              step(telemetry(bp1, temperature_rise_c_per_min, 4.2), fact("spacecraft-battery-diagnosis.pl", clause(2)), [], []),
              step(safety_limit(max_temperature_rise_c_per_min, 1.5), fact("spacecraft-battery-diagnosis.pl", clause(8)), [], []),
              step(>(4.2, 1.5), builtin(>, 2), [], [])
            ]
          ),
          step(
            cell_imbalance(bp1),
            rule("spacecraft-battery-diagnosis.pl", clause(15)),
            ['Pack' = bp1, 'Delta' = 0.19, 'Maximum' = 0.08],
            [
              step(telemetry(bp1, cell_delta_v, 0.19), fact("spacecraft-battery-diagnosis.pl", clause(5)), [], []),
              step(safety_limit(max_cell_delta_v, 0.08), fact("spacecraft-battery-diagnosis.pl", clause(9)), [], []),
              step(>(0.19, 0.08), builtin(>, 2), [], [])
            ]
          ),
          step(
            heating_exceeds_cooling(bp1),
            rule("spacecraft-battery-diagnosis.pl", clause(16)),
            ['Pack' = bp1, 'Heating' = 16.0, 'Capacity' = 12.0],
            [
              step(
                metric(bp1, resistive_heating_w, 16.0),
                rule("spacecraft-battery-diagnosis.pl", clause(12)),
                ['Pack' = bp1, 'Heating' = 16.0, 'Current' = 32.0, 'Resistance' = 0.015625, 'CurrentSquared' = 1024.0],
                [
                  step(telemetry(bp1, current_a, 32.0), fact("spacecraft-battery-diagnosis.pl", clause(3)), [], []),
                  step(telemetry(bp1, internal_resistance_ohm, 0.015625), fact("spacecraft-battery-diagnosis.pl", clause(4)), [], []),
                  step(is(1024.0, *(32.0, 32.0)), builtin(is, 2), [], []),
                  step(is(16.0, *(1024.0, 0.015625)), builtin(is, 2), [], [])
                ]
              ),
              step(cooling_capacity_w(bp1, 12.0), fact("spacecraft-battery-diagnosis.pl", clause(10)), [], []),
              step(>(16.0, 12.0), builtin(>, 2), [], [])
            ]
          )
        ]
      ),
      step(
        corroborated_over_temperature(bp1),
        rule("spacecraft-battery-diagnosis.pl", clause(17)),
        ['Pack' = bp1, 'Primary' = 78.0, 'Redundant' = 76.0, 'Maximum' = 60.0],
        [
          step(telemetry(bp1, temperature_c, 78.0), fact("spacecraft-battery-diagnosis.pl", clause(1)), [], []),
          step(redundant_telemetry(bp1, temperature_c, 76.0), fact("spacecraft-battery-diagnosis.pl", clause(6)), [], []),
          step(safety_limit(max_safe_temperature_c, 60.0), fact("spacecraft-battery-diagnosis.pl", clause(7)), [], []),
          step(>(78.0, 60.0), builtin(>, 2), [], []),
          step(>(76.0, 60.0), builtin(>, 2), [], [])
        ]
      )
    ]
  )
).

