% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = wall1, 'X1' = conduction_heat_loss]).
why(1, ['X0' = wall1, 'X1' = conduction_heat_loss], [type(wall1, conduction_heat_loss)]).
query(2, temperatureDifference_K(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = wall1, 'X1' = 25.0]).
why(2, ['X0' = wall1, 'X1' = 25.0], [temperatureDifference_K(wall1, 25.0)]).
query(3, thermalResistance_K_W(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = wall1, 'X1' = 0.020833333333333332]).
why(3,
    ['X0' = wall1, 'X1' = 0.020833333333333332],
    [thermalResistance_K_W(wall1, 0.020833333333333332)]).
query(4, heatLoss_W(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = wall1, 'X1' = 1200.0]).
why(4, ['X0' = wall1, 'X1' = 1200.0], [heatLoss_W(wall1, 1200.0)]).
query(5, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = wall1, 'X1' = high_heat_loss]).
why(5, ['X0' = wall1, 'X1' = high_heat_loss], [status(wall1, high_heat_loss)]).

clause(1, wall(wall1, conductivity_W_mK, 0.8), true).
clause(2, wall(wall1, area_m2, 12.0), true).
clause(3, wall(wall1, thickness_m, 0.2), true).
clause(4, wall(wall1, indoor_C, 21.0), true).
clause(5, wall(wall1, outdoor_C, -4.0), true).
clause(6,
       temperature_difference(var('Wall'), var('Deltat')),
       (wall(var('Wall'), indoor_C, var('Indoor')),
        wall(var('Wall'), outdoor_C, var('Outdoor')),
        var('Deltat') is var('Indoor') - var('Outdoor'))).
clause(7,
       thermal_resistance(var('Wall'), var('Resistance')),
       (wall(var('Wall'), thickness_m, var('Thickness')),
        wall(var('Wall'), conductivity_W_mK, var('Conductivity')),
        wall(var('Wall'), area_m2, var('Area')),
        var('Conductance') is var('Conductivity') * var('Area'),
        var('Resistance') is var('Thickness') / var('Conductance'))).
clause(8,
       heat_loss(var('Wall'), var('Heatloss')),
       (temperature_difference(var('Wall'), var('Deltat')),
        thermal_resistance(var('Wall'), var('Resistance')),
        var('Heatloss') is var('Deltat') / var('Resistance'))).
clause(9, type(var('Wall'), conduction_heat_loss), wall(var('Wall'), thickness_m, anonymous(1))).
clause(10,
       temperatureDifference_K(var('Wall'), var('Deltat')),
       temperature_difference(var('Wall'), var('Deltat'))).
clause(11,
       thermalResistance_K_W(var('Wall'), var('Resistance')),
       thermal_resistance(var('Wall'), var('Resistance'))).
clause(12, heatLoss_W(var('Wall'), var('Heatloss')), heat_loss(var('Wall'), var('Heatloss'))).
clause(13,
       status(var('Wall'), high_heat_loss),
       (heat_loss(var('Wall'), var('Heatloss')), var('Heatloss') > 1000.0)).

step(type(wall1, conduction_heat_loss),
     rule(9),
     ['Wall' = wall1],
     [wall(wall1, thickness_m, 0.2)]).
step(wall(wall1, thickness_m, 0.2), fact(3), [], []).
step(temperatureDifference_K(wall1, 25.0),
     rule(10),
     ['Wall' = wall1, 'Deltat' = 25.0],
     [temperature_difference(wall1, 25.0)]).
step(temperature_difference(wall1, 25.0),
     rule(6),
     ['Wall' = wall1, 'Deltat' = 25.0, 'Indoor' = 21.0, 'Outdoor' = -4.0],
     [wall(wall1, indoor_C, 21.0), wall(wall1, outdoor_C, -4.0), 25.0 is 21.0 - -4.0]).
step(wall(wall1, indoor_C, 21.0), fact(4), [], []).
step(wall(wall1, outdoor_C, -4.0), fact(5), [], []).
step(25.0 is 21.0 - -4.0, builtin, [], []).
step(thermalResistance_K_W(wall1, 0.020833333333333332),
     rule(11),
     ['Wall' = wall1, 'Resistance' = 0.020833333333333332],
     [thermal_resistance(wall1, 0.020833333333333332)]).
step(thermal_resistance(wall1, 0.020833333333333332),
     rule(7),
     ['Wall' = wall1,
      'Resistance' = 0.020833333333333332,
      'Thickness' = 0.2,
      'Conductivity' = 0.8,
      'Area' = 12.0,
      'Conductance' = 9.600000000000001],
     [wall(wall1, thickness_m, 0.2),
      wall(wall1, conductivity_W_mK, 0.8),
      wall(wall1, area_m2, 12.0),
      9.600000000000001 is 0.8 * 12.0,
      0.020833333333333332 is 0.2 / 9.600000000000001]).
step(wall(wall1, conductivity_W_mK, 0.8), fact(1), [], []).
step(wall(wall1, area_m2, 12.0), fact(2), [], []).
step(9.600000000000001 is 0.8 * 12.0, builtin, [], []).
step(0.020833333333333332 is 0.2 / 9.600000000000001, builtin, [], []).
step(heatLoss_W(wall1, 1200.0),
     rule(12),
     ['Wall' = wall1, 'Heatloss' = 1200.0],
     [heat_loss(wall1, 1200.0)]).
step(heat_loss(wall1, 1200.0),
     rule(8),
     ['Wall' = wall1, 'Heatloss' = 1200.0, 'Deltat' = 25.0, 'Resistance' = 0.020833333333333332],
     [temperature_difference(wall1, 25.0),
      thermal_resistance(wall1, 0.020833333333333332),
      1200.0 is 25.0 / 0.020833333333333332]).
step(1200.0 is 25.0 / 0.020833333333333332, builtin, [], []).
step(status(wall1, high_heat_loss),
     rule(13),
     ['Wall' = wall1, 'Heatloss' = 1200.0],
     [heat_loss(wall1, 1200.0), 1200.0 > 1000.0]).
step(1200.0 > 1000.0, builtin, [], []).
