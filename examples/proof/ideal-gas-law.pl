pressure_Pa(cell1, 100000.0).
why(
  pressure_Pa(cell1, 100000.0),
  step(
    pressure_Pa(cell1, 100000.0),
    rule("ideal-gas-law.pl", clause(6)),
    ['Cell' = cell1, 'Pressure' = 100000.0],
    [
      step(
        pressure(cell1, 100000.0),
        rule("ideal-gas-law.pl", clause(4)),
        ['Cell' = cell1, 'Pressure' = 100000.0, 'Moles' = 1.0, 'Gasconstant' = 8.0, 'Temperature' = 300.0, 'Volume' = 0.024, 'Nr' = 8.0, 'Nrt' = 2400.0],
        [
          step(gas_cell(cell1, 1.0, 8.0, 300.0, 0.024), fact("ideal-gas-law.pl", clause(1)), [], []),
          step(is(8.0, *(1.0, 8.0)), builtin(is, 2), [], []),
          step(is(2400.0, *(8.0, 300.0)), builtin(is, 2), [], []),
          step(is(100000.0, /(2400.0, 0.024)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

status(cell1, near_atmospheric).
why(
  status(cell1, near_atmospheric),
  step(
    status(cell1, near_atmospheric),
    rule("ideal-gas-law.pl", clause(7)),
    ['Cell' = cell1],
    [
      step(
        near_atmospheric(cell1),
        rule("ideal-gas-law.pl", clause(5)),
        ['Cell' = cell1, 'Pressure' = 100000.0, 'Low' = 95000.0, 'High' = 105000.0],
        [
          step(
            pressure(cell1, 100000.0),
            rule("ideal-gas-law.pl", clause(4)),
            ['Cell' = cell1, 'Pressure' = 100000.0, 'Moles' = 1.0, 'Gasconstant' = 8.0, 'Temperature' = 300.0, 'Volume' = 0.024, 'Nr' = 8.0, 'Nrt' = 2400.0],
            [
              step(gas_cell(cell1, 1.0, 8.0, 300.0, 0.024), fact("ideal-gas-law.pl", clause(1)), [], []),
              step(is(8.0, *(1.0, 8.0)), builtin(is, 2), [], []),
              step(is(2400.0, *(8.0, 300.0)), builtin(is, 2), [], []),
              step(is(100000.0, /(2400.0, 0.024)), builtin(is, 2), [], [])
            ]
          ),
          step(pressure_limit(cell1, low_Pa, 95000.0), fact("ideal-gas-law.pl", clause(2)), [], []),
          step(pressure_limit(cell1, high_Pa, 105000.0), fact("ideal-gas-law.pl", clause(3)), [], []),
          step(>(100000.0, 95000.0), builtin(>, 2), [], []),
          step(<(100000.0, 105000.0), builtin(<, 2), [], [])
        ]
      )
    ]
  )
).

reason(cell1, "pressure is inside the one-atmosphere tolerance band").
why(
  reason(cell1, "pressure is inside the one-atmosphere tolerance band"),
  step(
    reason(cell1, "pressure is inside the one-atmosphere tolerance band"),
    rule("ideal-gas-law.pl", clause(8)),
    ['Cell' = cell1],
    [
      step(
        near_atmospheric(cell1),
        rule("ideal-gas-law.pl", clause(5)),
        ['Cell' = cell1, 'Pressure' = 100000.0, 'Low' = 95000.0, 'High' = 105000.0],
        [
          step(
            pressure(cell1, 100000.0),
            rule("ideal-gas-law.pl", clause(4)),
            ['Cell' = cell1, 'Pressure' = 100000.0, 'Moles' = 1.0, 'Gasconstant' = 8.0, 'Temperature' = 300.0, 'Volume' = 0.024, 'Nr' = 8.0, 'Nrt' = 2400.0],
            [
              step(gas_cell(cell1, 1.0, 8.0, 300.0, 0.024), fact("ideal-gas-law.pl", clause(1)), [], []),
              step(is(8.0, *(1.0, 8.0)), builtin(is, 2), [], []),
              step(is(2400.0, *(8.0, 300.0)), builtin(is, 2), [], []),
              step(is(100000.0, /(2400.0, 0.024)), builtin(is, 2), [], [])
            ]
          ),
          step(pressure_limit(cell1, low_Pa, 95000.0), fact("ideal-gas-law.pl", clause(2)), [], []),
          step(pressure_limit(cell1, high_Pa, 105000.0), fact("ideal-gas-law.pl", clause(3)), [], []),
          step(>(100000.0, 95000.0), builtin(>, 2), [], []),
          step(<(100000.0, 105000.0), builtin(<, 2), [], [])
        ]
      )
    ]
  )
).

