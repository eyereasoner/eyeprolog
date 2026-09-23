pressure_Pa(cell1, 100000.0).
status(cell1, near_atmospheric).
reason(cell1, "pressure is inside the one-atmosphere tolerance band").

clause(1, gas_cell(cell1, 1.0, 8.0, 300.0, 0.024), true).
clause(2, pressure_limit(cell1, low_Pa, 95000.0), true).
clause(3, pressure_limit(cell1, high_Pa, 105000.0), true).
clause(4,
       pressure(var('Cell'), var('Pressure')),
       (gas_cell(var('Cell'), var('Moles'), var('Gasconstant'), var('Temperature'), var('Volume')),
        var('Nr') is var('Moles') * var('Gasconstant'),
        var('Nrt') is var('Nr') * var('Temperature'),
        var('Pressure') is var('Nrt') / var('Volume'))).
clause(5,
       near_atmospheric(var('Cell')),
       (pressure(var('Cell'), var('Pressure')),
        pressure_limit(var('Cell'), low_Pa, var('Low')),
        pressure_limit(var('Cell'), high_Pa, var('High')),
        var('Pressure') > var('Low'),
        var('Pressure') < var('High'))).
clause(6, pressure_Pa(var('Cell'), var('Pressure')), pressure(var('Cell'), var('Pressure'))).
clause(7, status(var('Cell'), near_atmospheric), near_atmospheric(var('Cell'))).
clause(8,
       reason(var('Cell'), "pressure is inside the one-atmosphere tolerance band"),
       near_atmospheric(var('Cell'))).

step(pressure_Pa(cell1, 100000.0),
     rule(6),
     ['Cell' = cell1, 'Pressure' = 100000.0],
     [pressure(cell1, 100000.0)]).
step(pressure(cell1, 100000.0),
     rule(4),
     ['Cell' = cell1,
      'Pressure' = 100000.0,
      'Moles' = 1.0,
      'Gasconstant' = 8.0,
      'Temperature' = 300.0,
      'Volume' = 0.024,
      'Nr' = 8.0,
      'Nrt' = 2400.0],
     [gas_cell(cell1, 1.0, 8.0, 300.0, 0.024),
      8.0 is 1.0 * 8.0,
      2400.0 is 8.0 * 300.0,
      100000.0 is 2400.0 / 0.024]).
step(gas_cell(cell1, 1.0, 8.0, 300.0, 0.024), fact(1), [], []).
step(8.0 is 1.0 * 8.0, builtin, [], []).
step(2400.0 is 8.0 * 300.0, builtin, [], []).
step(100000.0 is 2400.0 / 0.024, builtin, [], []).
step(status(cell1, near_atmospheric), rule(7), ['Cell' = cell1], [near_atmospheric(cell1)]).
step(near_atmospheric(cell1),
     rule(5),
     ['Cell' = cell1, 'Pressure' = 100000.0, 'Low' = 95000.0, 'High' = 105000.0],
     [pressure(cell1, 100000.0),
      pressure_limit(cell1, low_Pa, 95000.0),
      pressure_limit(cell1, high_Pa, 105000.0),
      100000.0 > 95000.0,
      100000.0 < 105000.0]).
step(pressure_limit(cell1, low_Pa, 95000.0), fact(2), [], []).
step(pressure_limit(cell1, high_Pa, 105000.0), fact(3), [], []).
step(100000.0 > 95000.0, builtin, [], []).
step(100000.0 < 105000.0, builtin, [], []).
step(reason(cell1, "pressure is inside the one-atmosphere tolerance band"),
     rule(8),
     ['Cell' = cell1],
     [near_atmospheric(cell1)]).
