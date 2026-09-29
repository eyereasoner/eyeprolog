controlSignal(actuator1, 39.27346198678276).
controlSignal(actuator2, 26.08).
status(actuator1, active).
status(actuator2, active).
normalizedMeasurement(input1, 2.23606797749979).
log10(disturbance1, 4.553470372213121).

clause(1, measurement(input1, [6, 11]), true).
clause(3, measurement(input2, true), true).
clause(5, measurement(disturbance1, 35766), true).
clause(6, measurement(output2, 24), true).
clause(9, observation(state3, 22), true).
clause(10, target(output2, 29), true).
clause(11,
       measurement_normalized(var('I'), var('M')),
       (measurement(var('I'), [var('M1'), var('M2')]),
        var('M1') < var('M2'),
        var('Delta') is var('M2') - var('M1'),
        var('M') is var('Delta') ** 0.5)).
clause(13,
       numeric_log10(var('Value'), var('Result')),
       (var('Naturallog') is log(var('Value')),
        var('Naturallog10') is log(10),
        var('Result') is var('Naturallog') / var('Naturallog10'))).
clause(14,
       control(actuator1, var('C')),
       (measurement_normalized(input1, var('M1')),
        measurement(input2, true),
        measurement(disturbance1, var('D1')),
        var('Proportional') is var('M1') * 19.6,
        numeric_log10(var('D1'), var('Compensation')),
        var('C') is var('Proportional') - var('Compensation'))).
clause(15,
       control(actuator2, var('C')),
       (observation(state3, var('P3')),
        measurement(output2, var('M4')),
        target(output2, var('T2')),
        var('Error') is var('T2') - var('M4'),
        var('Differentialerror') is var('P3') - var('M4'),
        var('Proportional') is 5.8 * var('Error'),
        var('Nonlinearfactor') is 7.3 / var('Error'),
        var('Differential') is var('Nonlinearfactor') * var('Differentialerror'),
        var('C') is var('Proportional') + var('Differential'))).
clause(16, controlSignal(var('Actuator'), var('C')), control(var('Actuator'), var('C'))).
clause(17, status(var('Actuator'), active), control(var('Actuator'), anonymous(1))).
clause(18, normalizedMeasurement(input1, var('M')), measurement_normalized(input1, var('M'))).
clause(19,
       log10(disturbance1, var('C')),
       (measurement(disturbance1, var('D')), numeric_log10(var('D'), var('C')))).

step(controlSignal(actuator1, 39.27346198678276),
     rule(16),
     ['Actuator' = actuator1, 'C' = 39.27346198678276],
     [control(actuator1, 39.27346198678276)]).
step(control(actuator1, 39.27346198678276),
     rule(14),
     ['C' = 39.27346198678276,
      'M1' = 2.23606797749979,
      'D1' = 35766,
      'Proportional' = 43.82693235899588,
      'Compensation' = 4.553470372213121],
     [measurement_normalized(input1, 2.23606797749979),
      measurement(input2, true),
      measurement(disturbance1, 35766),
      43.82693235899588 is 2.23606797749979 * 19.6,
      numeric_log10(35766, 4.553470372213121),
      39.27346198678276 is 43.82693235899588 - 4.553470372213121]).
step(measurement_normalized(input1, 2.23606797749979),
     rule(11),
     ['I' = input1, 'M' = 2.23606797749979, 'M1' = 6, 'M2' = 11, 'Delta' = 5],
     [measurement(input1, [6, 11]), 6 < 11, 5 is 11 - 6, 2.23606797749979 is 5 ** 0.5]).
step(measurement(input1, [6, 11]), fact(1), [], []).
step(6 < 11, builtin, [], []).
step(5 is 11 - 6, builtin, [], []).
step(2.23606797749979 is 5 ** 0.5, builtin, [], []).
step(measurement(input2, true), fact(3), [], []).
step(measurement(disturbance1, 35766), fact(5), [], []).
step(43.82693235899588 is 2.23606797749979 * 19.6, builtin, [], []).
step(numeric_log10(35766, 4.553470372213121),
     rule(13),
     ['Value' = 35766,
      'Result' = 4.553470372213121,
      'Naturallog' = 10.48475300044798,
      'Naturallog10' = 2.302585092994046],
     [10.48475300044798 is log(35766),
      2.302585092994046 is log(10),
      4.553470372213121 is 10.48475300044798 / 2.302585092994046]).
step(10.48475300044798 is log(35766), builtin, [], []).
step(2.302585092994046 is log(10), builtin, [], []).
step(4.553470372213121 is 10.48475300044798 / 2.302585092994046, builtin, [], []).
step(39.27346198678276 is 43.82693235899588 - 4.553470372213121, builtin, [], []).
step(controlSignal(actuator2, 26.08),
     rule(16),
     ['Actuator' = actuator2, 'C' = 26.08],
     [control(actuator2, 26.08)]).
step(control(actuator2, 26.08),
     rule(15),
     ['C' = 26.08,
      'P3' = 22,
      'M4' = 24,
      'T2' = 29,
      'Error' = 5,
      'Differentialerror' = -2,
      'Proportional' = 29.0,
      'Nonlinearfactor' = 1.46,
      'Differential' = -2.92],
     [observation(state3, 22),
      measurement(output2, 24),
      target(output2, 29),
      5 is 29 - 24,
      -2 is 22 - 24,
      29.0 is 5.8 * 5,
      1.46 is 7.3 / 5,
      -2.92 is 1.46 * -2,
      26.08 is 29.0 + -2.92]).
step(observation(state3, 22), fact(9), [], []).
step(measurement(output2, 24), fact(6), [], []).
step(target(output2, 29), fact(10), [], []).
step(5 is 29 - 24, builtin, [], []).
step(-2 is 22 - 24, builtin, [], []).
step(29.0 is 5.8 * 5, builtin, [], []).
step(1.46 is 7.3 / 5, builtin, [], []).
step(-2.92 is 1.46 * -2, builtin, [], []).
step(26.08 is 29.0 + -2.92, builtin, [], []).
step(status(actuator1, active),
     rule(17),
     ['Actuator' = actuator1],
     [control(actuator1, 39.27346198678276)]).
step(status(actuator2, active), rule(17), ['Actuator' = actuator2], [control(actuator2, 26.08)]).
step(normalizedMeasurement(input1, 2.23606797749979),
     rule(18),
     ['M' = 2.23606797749979],
     [measurement_normalized(input1, 2.23606797749979)]).
step(log10(disturbance1, 4.553470372213121),
     rule(19),
     ['C' = 4.553470372213121, 'D' = 35766],
     [measurement(disturbance1, 35766), numeric_log10(35766, 4.553470372213121)]).
