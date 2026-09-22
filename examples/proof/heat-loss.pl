type(wall1, conduction_heat_loss).
why(
  type(wall1, conduction_heat_loss),
  step(
    type(wall1, conduction_heat_loss),
    rule("heat-loss.pl", clause(9)),
    ['Wall' = wall1, '_thickness' = 0.2],
    [
      step(wall(wall1, thickness_m, 0.2), fact("heat-loss.pl", clause(3)), [], [])
    ]
  )
).

temperatureDifference_K(wall1, 25.0).
why(
  temperatureDifference_K(wall1, 25.0),
  step(
    temperatureDifference_K(wall1, 25.0),
    rule("heat-loss.pl", clause(10)),
    ['Wall' = wall1, 'Deltat' = 25.0],
    [
      step(
        temperature_difference(wall1, 25.0),
        rule("heat-loss.pl", clause(6)),
        ['Wall' = wall1, 'Deltat' = 25.0, 'Indoor' = 21.0, 'Outdoor' = -4.0],
        [
          step(wall(wall1, indoor_C, 21.0), fact("heat-loss.pl", clause(4)), [], []),
          step(wall(wall1, outdoor_C, -4.0), fact("heat-loss.pl", clause(5)), [], []),
          step(is(25.0, '-'(21.0, -4.0)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

thermalResistance_K_W(wall1, 0.020833333333333332).
why(
  thermalResistance_K_W(wall1, 0.020833333333333332),
  step(
    thermalResistance_K_W(wall1, 0.020833333333333332),
    rule("heat-loss.pl", clause(11)),
    ['Wall' = wall1, 'Resistance' = 0.020833333333333332],
    [
      step(
        thermal_resistance(wall1, 0.020833333333333332),
        rule("heat-loss.pl", clause(7)),
        ['Wall' = wall1, 'Resistance' = 0.020833333333333332, 'Thickness' = 0.2, 'Conductivity' = 0.8, 'Area' = 12.0, 'Conductance' = 9.600000000000001],
        [
          step(wall(wall1, thickness_m, 0.2), fact("heat-loss.pl", clause(3)), [], []),
          step(wall(wall1, conductivity_W_mK, 0.8), fact("heat-loss.pl", clause(1)), [], []),
          step(wall(wall1, area_m2, 12.0), fact("heat-loss.pl", clause(2)), [], []),
          step(is(9.600000000000001, *(0.8, 12.0)), builtin(is, 2), [], []),
          step(is(0.020833333333333332, /(0.2, 9.600000000000001)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

heatLoss_W(wall1, 1200.0).
why(
  heatLoss_W(wall1, 1200.0),
  step(
    heatLoss_W(wall1, 1200.0),
    rule("heat-loss.pl", clause(12)),
    ['Wall' = wall1, 'Heatloss' = 1200.0],
    [
      step(
        heat_loss(wall1, 1200.0),
        rule("heat-loss.pl", clause(8)),
        ['Wall' = wall1, 'Heatloss' = 1200.0, 'Deltat' = 25.0, 'Resistance' = 0.020833333333333332],
        [
          step(
            temperature_difference(wall1, 25.0),
            rule("heat-loss.pl", clause(6)),
            ['Wall' = wall1, 'Deltat' = 25.0, 'Indoor' = 21.0, 'Outdoor' = -4.0],
            [
              step(wall(wall1, indoor_C, 21.0), fact("heat-loss.pl", clause(4)), [], []),
              step(wall(wall1, outdoor_C, -4.0), fact("heat-loss.pl", clause(5)), [], []),
              step(is(25.0, '-'(21.0, -4.0)), builtin(is, 2), [], [])
            ]
          ),
          step(
            thermal_resistance(wall1, 0.020833333333333332),
            rule("heat-loss.pl", clause(7)),
            ['Wall' = wall1, 'Resistance' = 0.020833333333333332, 'Thickness' = 0.2, 'Conductivity' = 0.8, 'Area' = 12.0, 'Conductance' = 9.600000000000001],
            [
              step(wall(wall1, thickness_m, 0.2), fact("heat-loss.pl", clause(3)), [], []),
              step(wall(wall1, conductivity_W_mK, 0.8), fact("heat-loss.pl", clause(1)), [], []),
              step(wall(wall1, area_m2, 12.0), fact("heat-loss.pl", clause(2)), [], []),
              step(is(9.600000000000001, *(0.8, 12.0)), builtin(is, 2), [], []),
              step(is(0.020833333333333332, /(0.2, 9.600000000000001)), builtin(is, 2), [], [])
            ]
          ),
          step(is(1200.0, /(25.0, 0.020833333333333332)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

status(wall1, high_heat_loss).
why(
  status(wall1, high_heat_loss),
  step(
    status(wall1, high_heat_loss),
    rule("heat-loss.pl", clause(13)),
    ['Wall' = wall1, 'Heatloss' = 1200.0],
    [
      step(
        heat_loss(wall1, 1200.0),
        rule("heat-loss.pl", clause(8)),
        ['Wall' = wall1, 'Heatloss' = 1200.0, 'Deltat' = 25.0, 'Resistance' = 0.020833333333333332],
        [
          step(
            temperature_difference(wall1, 25.0),
            rule("heat-loss.pl", clause(6)),
            ['Wall' = wall1, 'Deltat' = 25.0, 'Indoor' = 21.0, 'Outdoor' = -4.0],
            [
              step(wall(wall1, indoor_C, 21.0), fact("heat-loss.pl", clause(4)), [], []),
              step(wall(wall1, outdoor_C, -4.0), fact("heat-loss.pl", clause(5)), [], []),
              step(is(25.0, '-'(21.0, -4.0)), builtin(is, 2), [], [])
            ]
          ),
          step(
            thermal_resistance(wall1, 0.020833333333333332),
            rule("heat-loss.pl", clause(7)),
            ['Wall' = wall1, 'Resistance' = 0.020833333333333332, 'Thickness' = 0.2, 'Conductivity' = 0.8, 'Area' = 12.0, 'Conductance' = 9.600000000000001],
            [
              step(wall(wall1, thickness_m, 0.2), fact("heat-loss.pl", clause(3)), [], []),
              step(wall(wall1, conductivity_W_mK, 0.8), fact("heat-loss.pl", clause(1)), [], []),
              step(wall(wall1, area_m2, 12.0), fact("heat-loss.pl", clause(2)), [], []),
              step(is(9.600000000000001, *(0.8, 12.0)), builtin(is, 2), [], []),
              step(is(0.020833333333333332, /(0.2, 9.600000000000001)), builtin(is, 2), [], [])
            ]
          ),
          step(is(1200.0, /(25.0, 0.020833333333333332)), builtin(is, 2), [], [])
        ]
      ),
      step(>(1200.0, 1000.0), builtin(>, 2), [], [])
    ]
  )
).

