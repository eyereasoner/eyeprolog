report(parsed_as, [reports, sensor_7, temperature]).
report(observations, humidity and temperature).
report(operator, operator(600, xfx)).

clause(3, sensor_7 reports temperature, true).
clause(4, sensor_7 reports humidity, true).
clause(5,
       observations(var('Sensor'), var('First') and var('Second')),
       (var('Sensor') reports var('First'),
        var('Sensor') reports var('Second'),
        var('First') @< var('Second'))).
clause(6, report(parsed_as, var('Parts')), sensor_7 reports temperature =.. var('Parts')).
clause(7, report(observations, var('Pair')), observations(sensor_7, var('Pair'))).
clause(8,
       report(operator, operator(var('Priority'), var('Specifier'))),
       current_op(var('Priority'), var('Specifier'), reports)).

step(report(parsed_as, [reports, sensor_7, temperature]),
     rule(6),
     ['Parts' = [reports, sensor_7, temperature]],
     [sensor_7 reports temperature =.. [reports, sensor_7, temperature]]).
step(sensor_7 reports temperature =.. [reports, sensor_7, temperature], builtin, [], []).
step(report(observations, humidity and temperature),
     rule(7),
     ['Pair' = humidity and temperature],
     [observations(sensor_7, humidity and temperature)]).
step(observations(sensor_7, humidity and temperature),
     rule(5),
     ['Sensor' = sensor_7, 'First' = humidity, 'Second' = temperature],
     [sensor_7 reports humidity, sensor_7 reports temperature, humidity @< temperature]).
step(sensor_7 reports humidity, fact(4), [], []).
step(sensor_7 reports temperature, fact(3), [], []).
step(humidity @< temperature, builtin, [], []).
step(report(operator, operator(600, xfx)),
     rule(8),
     ['Priority' = 600, 'Specifier' = xfx],
     [current_op(600, xfx, reports)]).
step(current_op(600, xfx, reports), builtin, [], []).
