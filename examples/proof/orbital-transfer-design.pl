transferSemiMajorAxis_km(mars_hohmann, 188768535.35).
departureDeltaV_km_s(mars_hohmann, 2.9446911328430403).
arrivalDeltaV_km_s(mars_hohmann, 2.6488967223855973).
totalDeltaV_km_s(mars_hohmann, 5.5935878552286376).
transferTime_days(mars_hohmann, 258.865826767963).
status(mars_hohmann, feasible_reference_transfer).
reason(mars_hohmann, "total Hohmann transfer delta-v is within the mission budget").

clause(1, mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0), true).
clause(2, mission(mars_hohmann, departureOrbitRadius_km, 149597870.7), true).
clause(3, mission(mars_hohmann, arrivalOrbitRadius_km, 227939200.0), true).
clause(4, mission(mars_hohmann, deltaVBudget_km_s, 6.0), true).
clause(5, mission(mars_hohmann, pi, 3.141592653589793), true).
clause(6, mission(mars_hohmann, secondsPerDay, 86400.0), true).
clause(7,
       semi_major_axis(var('Mission'), var('Axis')),
       (mission(var('Mission'), departureOrbitRadius_km, var('R1')),
        mission(var('Mission'), arrivalOrbitRadius_km, var('R2')),
        var('Sum') is var('R1') + var('R2'),
        var('Axis') is var('Sum') / 2.0)).
clause(8,
       circular_speed_at_departure(var('Mission'), var('Speed')),
       (mission(var('Mission'), centralBodyMu_km3_s2, var('Mu')),
        mission(var('Mission'), departureOrbitRadius_km, var('Radius')),
        var('Speedsquared') is var('Mu') / var('Radius'),
        var('Speed') is var('Speedsquared') ** 0.5)).
clause(9,
       circular_speed_at_arrival(var('Mission'), var('Speed')),
       (mission(var('Mission'), centralBodyMu_km3_s2, var('Mu')),
        mission(var('Mission'), arrivalOrbitRadius_km, var('Radius')),
        var('Speedsquared') is var('Mu') / var('Radius'),
        var('Speed') is var('Speedsquared') ** 0.5)).
clause(10,
       transfer_speed_at_departure(var('Mission'), var('Speed')),
       (mission(var('Mission'), centralBodyMu_km3_s2, var('Mu')),
        mission(var('Mission'), departureOrbitRadius_km, var('Radius')),
        semi_major_axis(var('Mission'), var('Axis')),
        var('Twiceoverradius') is 2.0 / var('Radius'),
        var('Oneoveraxis') is 1.0 / var('Axis'),
        var('Bracket') is var('Twiceoverradius') - var('Oneoveraxis'),
        var('Speedsquared') is var('Mu') * var('Bracket'),
        var('Speed') is var('Speedsquared') ** 0.5)).
clause(11,
       transfer_speed_at_arrival(var('Mission'), var('Speed')),
       (mission(var('Mission'), centralBodyMu_km3_s2, var('Mu')),
        mission(var('Mission'), arrivalOrbitRadius_km, var('Radius')),
        semi_major_axis(var('Mission'), var('Axis')),
        var('Twiceoverradius') is 2.0 / var('Radius'),
        var('Oneoveraxis') is 1.0 / var('Axis'),
        var('Bracket') is var('Twiceoverradius') - var('Oneoveraxis'),
        var('Speedsquared') is var('Mu') * var('Bracket'),
        var('Speed') is var('Speedsquared') ** 0.5)).
clause(12,
       departure_delta_v(var('Mission'), var('Deltav')),
       (transfer_speed_at_departure(var('Mission'), var('Transferspeed')),
        circular_speed_at_departure(var('Mission'), var('Circularspeed')),
        var('Deltav') is var('Transferspeed') - var('Circularspeed'))).
clause(13,
       arrival_delta_v(var('Mission'), var('Deltav')),
       (circular_speed_at_arrival(var('Mission'), var('Circularspeed')),
        transfer_speed_at_arrival(var('Mission'), var('Transferspeed')),
        var('Deltav') is var('Circularspeed') - var('Transferspeed'))).
clause(14,
       total_delta_v(var('Mission'), var('Total')),
       (departure_delta_v(var('Mission'), var('Depart')),
        arrival_delta_v(var('Mission'), var('Arrive')),
        var('Total') is var('Depart') + var('Arrive'))).
clause(15,
       transfer_time_days(var('Mission'), var('Days')),
       (semi_major_axis(var('Mission'), var('Axis')),
        mission(var('Mission'), centralBodyMu_km3_s2, var('Mu')),
        mission(var('Mission'), pi, var('Pi')),
        mission(var('Mission'), secondsPerDay, var('Secondsperday')),
        var('Axiscubed') is var('Axis') ** 3.0,
        var('Timefactor') is var('Axiscubed') / var('Mu'),
        var('Halfperiodbase') is var('Timefactor') ** 0.5,
        var('Seconds') is var('Pi') * var('Halfperiodbase'),
        var('Days') is var('Seconds') / var('Secondsperday'))).
clause(16,
       within_delta_v_budget(var('Mission')),
       (total_delta_v(var('Mission'), var('Total')),
        mission(var('Mission'), deltaVBudget_km_s, var('Budget')),
        var('Total') =< var('Budget'))).
clause(17,
       transferSemiMajorAxis_km(var('Mission'), var('Axis')),
       semi_major_axis(var('Mission'), var('Axis'))).
clause(18,
       departureDeltaV_km_s(var('Mission'), var('Deltav')),
       departure_delta_v(var('Mission'), var('Deltav'))).
clause(19,
       arrivalDeltaV_km_s(var('Mission'), var('Deltav')),
       arrival_delta_v(var('Mission'), var('Deltav'))).
clause(20,
       totalDeltaV_km_s(var('Mission'), var('Total')),
       total_delta_v(var('Mission'), var('Total'))).
clause(21,
       transferTime_days(var('Mission'), var('Days')),
       transfer_time_days(var('Mission'), var('Days'))).
clause(22,
       status(var('Mission'), feasible_reference_transfer),
       within_delta_v_budget(var('Mission'))).
clause(23,
       reason(var('Mission'), "total Hohmann transfer delta-v is within the mission budget"),
       within_delta_v_budget(var('Mission'))).

step(transferSemiMajorAxis_km(mars_hohmann, 188768535.35),
     rule(17),
     ['Mission' = mars_hohmann, 'Axis' = 188768535.35],
     [semi_major_axis(mars_hohmann, 188768535.35)]).
step(semi_major_axis(mars_hohmann, 188768535.35),
     rule(7),
     ['Mission' = mars_hohmann,
      'Axis' = 188768535.35,
      'R1' = 149597870.7,
      'R2' = 227939200.0,
      'Sum' = 377537070.7],
     [mission(mars_hohmann, departureOrbitRadius_km, 149597870.7),
      mission(mars_hohmann, arrivalOrbitRadius_km, 227939200.0),
      377537070.7 is 149597870.7 + 227939200.0,
      188768535.35 is 377537070.7 / 2.0]).
step(mission(mars_hohmann, departureOrbitRadius_km, 149597870.7), fact(2), [], []).
step(mission(mars_hohmann, arrivalOrbitRadius_km, 227939200.0), fact(3), [], []).
step(377537070.7 is 149597870.7 + 227939200.0, builtin, [], []).
step(188768535.35 is 377537070.7 / 2.0, builtin, [], []).
step(departureDeltaV_km_s(mars_hohmann, 2.9446911328430403),
     rule(18),
     ['Mission' = mars_hohmann, 'Deltav' = 2.9446911328430403],
     [departure_delta_v(mars_hohmann, 2.9446911328430403)]).
step(departure_delta_v(mars_hohmann, 2.9446911328430403),
     rule(12),
     ['Mission' = mars_hohmann,
      'Deltav' = 2.9446911328430403,
      'Transferspeed' = 32.729382964539845,
      'Circularspeed' = 29.784691831696804],
     [transfer_speed_at_departure(mars_hohmann, 32.729382964539845),
      circular_speed_at_departure(mars_hohmann, 29.784691831696804),
      2.9446911328430403 is 32.729382964539845 - 29.784691831696804]).
step(transfer_speed_at_departure(mars_hohmann, 32.729382964539845),
     rule(10),
     ['Mission' = mars_hohmann,
      'Speed' = 32.729382964539845,
      'Mu' = 132712440018.0,
      'Radius' = 149597870.7,
      'Axis' = 188768535.35,
      'Twiceoverradius' = 1.3369174244536893e-8,
      'Oneoveraxis' = 5.297493028411104e-9,
      'Bracket' = 8.071681216125789e-9,
      'Speedsquared' = 1071.212509239511],
     [mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0),
      mission(mars_hohmann, departureOrbitRadius_km, 149597870.7),
      semi_major_axis(mars_hohmann, 188768535.35),
      1.3369174244536893e-8 is 2.0 / 149597870.7,
      5.297493028411104e-9 is 1.0 / 188768535.35,
      8.071681216125789e-9 is 1.3369174244536893e-8 - 5.297493028411104e-9,
      1071.212509239511 is 132712440018.0 * 8.071681216125789e-9,
      32.729382964539845 is 1071.212509239511 ** 0.5]).
step(mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0), fact(1), [], []).
step(1.3369174244536893e-8 is 2.0 / 149597870.7, builtin, [], []).
step(5.297493028411104e-9 is 1.0 / 188768535.35, builtin, [], []).
step(8.071681216125789e-9 is 1.3369174244536893e-8 - 5.297493028411104e-9, builtin, [], []).
step(1071.212509239511 is 132712440018.0 * 8.071681216125789e-9, builtin, [], []).
step(32.729382964539845 is 1071.212509239511 ** 0.5, builtin, [], []).
step(circular_speed_at_departure(mars_hohmann, 29.784691831696804),
     rule(8),
     ['Mission' = mars_hohmann,
      'Speed' = 29.784691831696804,
      'Mu' = 132712440018.0,
      'Radius' = 149597870.7,
      'Speedsquared' = 887.1278675091464],
     [mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0),
      mission(mars_hohmann, departureOrbitRadius_km, 149597870.7),
      887.1278675091464 is 132712440018.0 / 149597870.7,
      29.784691831696804 is 887.1278675091464 ** 0.5]).
step(887.1278675091464 is 132712440018.0 / 149597870.7, builtin, [], []).
step(29.784691831696804 is 887.1278675091464 ** 0.5, builtin, [], []).
step(2.9446911328430403 is 32.729382964539845 - 29.784691831696804, builtin, [], []).
step(arrivalDeltaV_km_s(mars_hohmann, 2.6488967223855973),
     rule(19),
     ['Mission' = mars_hohmann, 'Deltav' = 2.6488967223855973],
     [arrival_delta_v(mars_hohmann, 2.6488967223855973)]).
step(arrival_delta_v(mars_hohmann, 2.6488967223855973),
     rule(13),
     ['Mission' = mars_hohmann,
      'Deltav' = 2.6488967223855973,
      'Circularspeed' = 24.12938801488822,
      'Transferspeed' = 21.480491292502624],
     [circular_speed_at_arrival(mars_hohmann, 24.12938801488822),
      transfer_speed_at_arrival(mars_hohmann, 21.480491292502624),
      2.6488967223855973 is 24.12938801488822 - 21.480491292502624]).
step(circular_speed_at_arrival(mars_hohmann, 24.12938801488822),
     rule(9),
     ['Mission' = mars_hohmann,
      'Speed' = 24.12938801488822,
      'Mu' = 132712440018.0,
      'Radius' = 227939200.0,
      'Speedsquared' = 582.2273659730314],
     [mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0),
      mission(mars_hohmann, arrivalOrbitRadius_km, 227939200.0),
      582.2273659730314 is 132712440018.0 / 227939200.0,
      24.12938801488822 is 582.2273659730314 ** 0.5]).
step(582.2273659730314 is 132712440018.0 / 227939200.0, builtin, [], []).
step(24.12938801488822 is 582.2273659730314 ** 0.5, builtin, [], []).
step(transfer_speed_at_arrival(mars_hohmann, 21.480491292502624),
     rule(11),
     ['Mission' = mars_hohmann,
      'Speed' = 21.480491292502624,
      'Mu' = 132712440018.0,
      'Radius' = 227939200.0,
      'Axis' = 188768535.35,
      'Twiceoverradius' = 8.774269629796016e-9,
      'Oneoveraxis' = 5.297493028411104e-9,
      'Bracket' = 3.4767766013849123e-9,
      'Speedsquared' = 461.41150616728106],
     [mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0),
      mission(mars_hohmann, arrivalOrbitRadius_km, 227939200.0),
      semi_major_axis(mars_hohmann, 188768535.35),
      8.774269629796016e-9 is 2.0 / 227939200.0,
      5.297493028411104e-9 is 1.0 / 188768535.35,
      3.4767766013849123e-9 is 8.774269629796016e-9 - 5.297493028411104e-9,
      461.41150616728106 is 132712440018.0 * 3.4767766013849123e-9,
      21.480491292502624 is 461.41150616728106 ** 0.5]).
step(8.774269629796016e-9 is 2.0 / 227939200.0, builtin, [], []).
step(3.4767766013849123e-9 is 8.774269629796016e-9 - 5.297493028411104e-9, builtin, [], []).
step(461.41150616728106 is 132712440018.0 * 3.4767766013849123e-9, builtin, [], []).
step(21.480491292502624 is 461.41150616728106 ** 0.5, builtin, [], []).
step(2.6488967223855973 is 24.12938801488822 - 21.480491292502624, builtin, [], []).
step(totalDeltaV_km_s(mars_hohmann, 5.5935878552286376),
     rule(20),
     ['Mission' = mars_hohmann, 'Total' = 5.5935878552286376],
     [total_delta_v(mars_hohmann, 5.5935878552286376)]).
step(total_delta_v(mars_hohmann, 5.5935878552286376),
     rule(14),
     ['Mission' = mars_hohmann,
      'Total' = 5.5935878552286376,
      'Depart' = 2.9446911328430403,
      'Arrive' = 2.6488967223855973],
     [departure_delta_v(mars_hohmann, 2.9446911328430403),
      arrival_delta_v(mars_hohmann, 2.6488967223855973),
      5.5935878552286376 is 2.9446911328430403 + 2.6488967223855973]).
step(5.5935878552286376 is 2.9446911328430403 + 2.6488967223855973, builtin, [], []).
step(transferTime_days(mars_hohmann, 258.865826767963),
     rule(21),
     ['Mission' = mars_hohmann, 'Days' = 258.865826767963],
     [transfer_time_days(mars_hohmann, 258.865826767963)]).
step(transfer_time_days(mars_hohmann, 258.865826767963),
     rule(15),
     ['Mission' = mars_hohmann,
      'Days' = 258.865826767963,
      'Axis' = 188768535.35,
      'Mu' = 132712440018.0,
      'Pi' = 3.141592653589793,
      'Secondsperday' = 86400.0,
      'Axiscubed' = 6.726494918837467e+24,
      'Timefactor' = 50684735492205.12,
      'Halfperiodbase' = 7119321.280305105,
      'Seconds' = 22366007.432752],
     [semi_major_axis(mars_hohmann, 188768535.35),
      mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0),
      mission(mars_hohmann, pi, 3.141592653589793),
      mission(mars_hohmann, secondsPerDay, 86400.0),
      6.726494918837467e+24 is 188768535.35 ** 3.0,
      50684735492205.12 is 6.726494918837467e+24 / 132712440018.0,
      7119321.280305105 is 50684735492205.12 ** 0.5,
      22366007.432752 is 3.141592653589793 * 7119321.280305105,
      258.865826767963 is 22366007.432752 / 86400.0]).
step(mission(mars_hohmann, pi, 3.141592653589793), fact(5), [], []).
step(mission(mars_hohmann, secondsPerDay, 86400.0), fact(6), [], []).
step(6.726494918837467e+24 is 188768535.35 ** 3.0, builtin, [], []).
step(50684735492205.12 is 6.726494918837467e+24 / 132712440018.0, builtin, [], []).
step(7119321.280305105 is 50684735492205.12 ** 0.5, builtin, [], []).
step(22366007.432752 is 3.141592653589793 * 7119321.280305105, builtin, [], []).
step(258.865826767963 is 22366007.432752 / 86400.0, builtin, [], []).
step(status(mars_hohmann, feasible_reference_transfer),
     rule(22),
     ['Mission' = mars_hohmann],
     [within_delta_v_budget(mars_hohmann)]).
step(within_delta_v_budget(mars_hohmann),
     rule(16),
     ['Mission' = mars_hohmann, 'Total' = 5.5935878552286376, 'Budget' = 6.0],
     [total_delta_v(mars_hohmann, 5.5935878552286376),
      mission(mars_hohmann, deltaVBudget_km_s, 6.0),
      5.5935878552286376 =< 6.0]).
step(mission(mars_hohmann, deltaVBudget_km_s, 6.0), fact(4), [], []).
step(5.5935878552286376 =< 6.0, builtin, [], []).
step(reason(mars_hohmann, "total Hohmann transfer delta-v is within the mission budget"),
     rule(23),
     ['Mission' = mars_hohmann],
     [within_delta_v_budget(mars_hohmann)]).
