report(parsed_as, [reports, sensor_7, temperature]).
why(
  report(parsed_as, [reports, sensor_7, temperature]),
  step(
    report(parsed_as, [reports, sensor_7, temperature]),
    rule("iso-operators.pl", clause(6)),
    ['Parts' = [reports, sensor_7, temperature]],
    [
      step('=..'(reports(sensor_7, temperature), [reports, sensor_7, temperature]), builtin('=..', 2), [], [])
    ]
  )
).

report(observations, humidity and temperature).
why(
  report(observations, and(humidity, temperature)),
  step(
    report(observations, and(humidity, temperature)),
    rule("iso-operators.pl", clause(7)),
    ['Pair' = and(humidity, temperature)],
    [
      step(
        observations(sensor_7, and(humidity, temperature)),
        rule("iso-operators.pl", clause(5)),
        ['Sensor' = sensor_7, 'First' = humidity, 'Second' = temperature],
        [
          step(reports(sensor_7, humidity), fact("iso-operators.pl", clause(4)), [], []),
          step(reports(sensor_7, temperature), fact("iso-operators.pl", clause(3)), [], []),
          step(@<(humidity, temperature), builtin(@<, 2), [], [])
        ]
      )
    ]
  )
).

report(operator, operator(600, xfx)).
why(
  report(operator, operator(600, xfx)),
  step(
    report(operator, operator(600, xfx)),
    rule("iso-operators.pl", clause(8)),
    ['Priority' = 600, 'Specifier' = xfx],
    [
      step(current_op(600, xfx, reports), builtin(current_op, 3), [], [])
    ]
  )
).

