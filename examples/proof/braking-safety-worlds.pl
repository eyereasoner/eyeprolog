safeInWorld(city_dry, w0).
safeInWorld(city_dry, w1).
safeInWorld(city_dry, w2).
safeInWorld(city_dry, w3).
safeInWorld(highway_dry_short_gap, w1).
safeInWorld(highway_dry_short_gap, w2).
safeInWorld(city_wet, w0).
safeInWorld(city_wet, w1).
safeInWorld(city_wet, w2).
safeInWorld(city_ice, w2).
riskyInWorld(highway_dry_short_gap, w0).
riskyInWorld(highway_dry_short_gap, w3).
riskyInWorld(city_wet, w3).
riskyInWorld(city_ice, w0).
riskyInWorld(city_ice, w1).
riskyInWorld(city_ice, w3).
status(braking_safety_worlds, expected_world_pattern).
reason(braking_safety_worlds, "simplified and naive worlds can be optimistic while the cautious world tightens the reference model").

clause(1, scenario(city_dry, 13.9, 0.8, 40.0), true).
clause(2, scenario(highway_dry_short_gap, 27.8, 0.8, 60.0), true).
clause(3, scenario(city_wet, 13.9, 0.4, 40.0), true).
clause(4, scenario(city_ice, 13.9, 0.2, 30.0), true).
clause(9,
       stop_distance(var('Scenario'), w0, var('Distance')),
       (scenario(var('Scenario'), var('V'), var('Mu'), anonymous(1)),
        var('Reaction') is var('V') * 1.0,
        var('V2') is var('V') ** 2.0,
        var('M2') is var('Mu') * 2.0,
        var('Denom') is var('M2') * 9.8,
        var('Braking') is var('V2') / var('Denom'),
        var('Distance') is var('Reaction') + var('Braking'))).
clause(10,
       stop_distance(var('Scenario'), w1, var('Distance')),
       (scenario(var('Scenario'), var('V'), var('Mu'), anonymous(1)),
        var('V2') is var('V') ** 2.0,
        var('M2') is var('Mu') * 2.0,
        var('Denom') is var('M2') * 10.0,
        var('Distance') is var('V2') / var('Denom'))).
clause(11,
       stop_distance(var('Scenario'), w2, var('Distance')),
       (scenario(var('Scenario'), var('V'), anonymous(1), anonymous(2)),
        var('V2') is var('V') ** 2.0,
        var('Distance') is var('V2') / 14.0)).
clause(12,
       stop_distance(var('Scenario'), w3, var('Distance')),
       (stop_distance(var('Scenario'), w0, var('W0distance')),
        var('Distance') is var('W0distance') * 1.5)).
clause(13,
       safe_in_world(var('Scenario'), var('World')),
       (scenario(var('Scenario'), anonymous(1), anonymous(2), var('Avail')),
        stop_distance(var('Scenario'), var('World'), var('Distance')),
        var('Distance') =< var('Avail'))).
clause(14,
       risky_in_world(var('Scenario'), var('World')),
       (scenario(var('Scenario'), anonymous(1), anonymous(2), var('Avail')),
        stop_distance(var('Scenario'), var('World'), var('Distance')),
        var('Distance') > var('Avail'))).
clause(15,
       pattern_matches(report),
       (safe_in_world(city_dry, w0),
        safe_in_world(city_dry, w1),
        safe_in_world(city_dry, w2),
        safe_in_world(city_dry, w3),
        risky_in_world(highway_dry_short_gap, w0),
        risky_in_world(highway_dry_short_gap, w3),
        safe_in_world(highway_dry_short_gap, w1),
        safe_in_world(highway_dry_short_gap, w2),
        safe_in_world(city_wet, w0),
        safe_in_world(city_wet, w1),
        safe_in_world(city_wet, w2),
        risky_in_world(city_wet, w3),
        risky_in_world(city_ice, w0),
        risky_in_world(city_ice, w1),
        risky_in_world(city_ice, w3),
        safe_in_world(city_ice, w2))).
clause(16,
       safeInWorld(var('Scenario'), var('World')),
       safe_in_world(var('Scenario'), var('World'))).
clause(17,
       riskyInWorld(var('Scenario'), var('World')),
       risky_in_world(var('Scenario'), var('World'))).
clause(18, status(braking_safety_worlds, expected_world_pattern), pattern_matches(report)).
clause(19,
       reason(braking_safety_worlds, "simplified and naive worlds can be optimistic while the cautious world tightens the reference model"),
       pattern_matches(report)).

step(safeInWorld(city_dry, w0),
     rule(16),
     ['Scenario' = city_dry, 'World' = w0],
     [safe_in_world(city_dry, w0)]).
step(safe_in_world(city_dry, w0),
     rule(13),
     ['Scenario' = city_dry, 'World' = w0, 'Avail' = 40.0, 'Distance' = 26.222066326530612],
     [scenario(city_dry, 13.9, 0.8, 40.0),
      stop_distance(city_dry, w0, 26.222066326530612),
      26.222066326530612 =< 40.0]).
step(scenario(city_dry, 13.9, 0.8, 40.0), fact(1), [], []).
step(stop_distance(city_dry, w0, 26.222066326530612),
     rule(9),
     ['Scenario' = city_dry,
      'Distance' = 26.222066326530612,
      'V' = 13.9,
      'Mu' = 0.8,
      'Reaction' = 13.9,
      'V2' = 193.21,
      'M2' = 1.6,
      'Denom' = 15.680000000000001,
      'Braking' = 12.322066326530612],
     [scenario(city_dry, 13.9, 0.8, 40.0),
      13.9 is 13.9 * 1.0,
      193.21 is 13.9 ** 2.0,
      1.6 is 0.8 * 2.0,
      15.680000000000001 is 1.6 * 9.8,
      12.322066326530612 is 193.21 / 15.680000000000001,
      26.222066326530612 is 13.9 + 12.322066326530612]).
step(13.9 is 13.9 * 1.0, builtin, [], []).
step(193.21 is 13.9 ** 2.0, builtin, [], []).
step(1.6 is 0.8 * 2.0, builtin, [], []).
step(15.680000000000001 is 1.6 * 9.8, builtin, [], []).
step(12.322066326530612 is 193.21 / 15.680000000000001, builtin, [], []).
step(26.222066326530612 is 13.9 + 12.322066326530612, builtin, [], []).
step(26.222066326530612 =< 40.0, builtin, [], []).
step(safeInWorld(city_dry, w1),
     rule(16),
     ['Scenario' = city_dry, 'World' = w1],
     [safe_in_world(city_dry, w1)]).
step(safe_in_world(city_dry, w1),
     rule(13),
     ['Scenario' = city_dry, 'World' = w1, 'Avail' = 40.0, 'Distance' = 12.075625],
     [scenario(city_dry, 13.9, 0.8, 40.0),
      stop_distance(city_dry, w1, 12.075625),
      12.075625 =< 40.0]).
step(stop_distance(city_dry, w1, 12.075625),
     rule(10),
     ['Scenario' = city_dry,
      'Distance' = 12.075625,
      'V' = 13.9,
      'Mu' = 0.8,
      'V2' = 193.21,
      'M2' = 1.6,
      'Denom' = 16.0],
     [scenario(city_dry, 13.9, 0.8, 40.0),
      193.21 is 13.9 ** 2.0,
      1.6 is 0.8 * 2.0,
      16.0 is 1.6 * 10.0,
      12.075625 is 193.21 / 16.0]).
step(16.0 is 1.6 * 10.0, builtin, [], []).
step(12.075625 is 193.21 / 16.0, builtin, [], []).
step(12.075625 =< 40.0, builtin, [], []).
step(safeInWorld(city_dry, w2),
     rule(16),
     ['Scenario' = city_dry, 'World' = w2],
     [safe_in_world(city_dry, w2)]).
step(safe_in_world(city_dry, w2),
     rule(13),
     ['Scenario' = city_dry, 'World' = w2, 'Avail' = 40.0, 'Distance' = 13.800714285714287],
     [scenario(city_dry, 13.9, 0.8, 40.0),
      stop_distance(city_dry, w2, 13.800714285714287),
      13.800714285714287 =< 40.0]).
step(stop_distance(city_dry, w2, 13.800714285714287),
     rule(11),
     ['Scenario' = city_dry, 'Distance' = 13.800714285714287, 'V' = 13.9, 'V2' = 193.21],
     [scenario(city_dry, 13.9, 0.8, 40.0),
      193.21 is 13.9 ** 2.0,
      13.800714285714287 is 193.21 / 14.0]).
step(13.800714285714287 is 193.21 / 14.0, builtin, [], []).
step(13.800714285714287 =< 40.0, builtin, [], []).
step(safeInWorld(city_dry, w3),
     rule(16),
     ['Scenario' = city_dry, 'World' = w3],
     [safe_in_world(city_dry, w3)]).
step(safe_in_world(city_dry, w3),
     rule(13),
     ['Scenario' = city_dry, 'World' = w3, 'Avail' = 40.0, 'Distance' = 39.33309948979592],
     [scenario(city_dry, 13.9, 0.8, 40.0),
      stop_distance(city_dry, w3, 39.33309948979592),
      39.33309948979592 =< 40.0]).
step(stop_distance(city_dry, w3, 39.33309948979592),
     rule(12),
     ['Scenario' = city_dry, 'Distance' = 39.33309948979592, 'W0distance' = 26.222066326530612],
     [stop_distance(city_dry, w0, 26.222066326530612),
      39.33309948979592 is 26.222066326530612 * 1.5]).
step(39.33309948979592 is 26.222066326530612 * 1.5, builtin, [], []).
step(39.33309948979592 =< 40.0, builtin, [], []).
step(safeInWorld(highway_dry_short_gap, w1),
     rule(16),
     ['Scenario' = highway_dry_short_gap, 'World' = w1],
     [safe_in_world(highway_dry_short_gap, w1)]).
step(safe_in_world(highway_dry_short_gap, w1),
     rule(13),
     ['Scenario' = highway_dry_short_gap, 'World' = w1, 'Avail' = 60.0, 'Distance' = 48.3025],
     [scenario(highway_dry_short_gap, 27.8, 0.8, 60.0),
      stop_distance(highway_dry_short_gap, w1, 48.3025),
      48.3025 =< 60.0]).
step(scenario(highway_dry_short_gap, 27.8, 0.8, 60.0), fact(2), [], []).
step(stop_distance(highway_dry_short_gap, w1, 48.3025),
     rule(10),
     ['Scenario' = highway_dry_short_gap,
      'Distance' = 48.3025,
      'V' = 27.8,
      'Mu' = 0.8,
      'V2' = 772.84,
      'M2' = 1.6,
      'Denom' = 16.0],
     [scenario(highway_dry_short_gap, 27.8, 0.8, 60.0),
      772.84 is 27.8 ** 2.0,
      1.6 is 0.8 * 2.0,
      16.0 is 1.6 * 10.0,
      48.3025 is 772.84 / 16.0]).
step(772.84 is 27.8 ** 2.0, builtin, [], []).
step(48.3025 is 772.84 / 16.0, builtin, [], []).
step(48.3025 =< 60.0, builtin, [], []).
step(safeInWorld(highway_dry_short_gap, w2),
     rule(16),
     ['Scenario' = highway_dry_short_gap, 'World' = w2],
     [safe_in_world(highway_dry_short_gap, w2)]).
step(safe_in_world(highway_dry_short_gap, w2),
     rule(13),
     ['Scenario' = highway_dry_short_gap,
      'World' = w2,
      'Avail' = 60.0,
      'Distance' = 55.20285714285715],
     [scenario(highway_dry_short_gap, 27.8, 0.8, 60.0),
      stop_distance(highway_dry_short_gap, w2, 55.20285714285715),
      55.20285714285715 =< 60.0]).
step(stop_distance(highway_dry_short_gap, w2, 55.20285714285715),
     rule(11),
     ['Scenario' = highway_dry_short_gap,
      'Distance' = 55.20285714285715,
      'V' = 27.8,
      'V2' = 772.84],
     [scenario(highway_dry_short_gap, 27.8, 0.8, 60.0),
      772.84 is 27.8 ** 2.0,
      55.20285714285715 is 772.84 / 14.0]).
step(55.20285714285715 is 772.84 / 14.0, builtin, [], []).
step(55.20285714285715 =< 60.0, builtin, [], []).
step(safeInWorld(city_wet, w0),
     rule(16),
     ['Scenario' = city_wet, 'World' = w0],
     [safe_in_world(city_wet, w0)]).
step(safe_in_world(city_wet, w0),
     rule(13),
     ['Scenario' = city_wet, 'World' = w0, 'Avail' = 40.0, 'Distance' = 38.544132653061226],
     [scenario(city_wet, 13.9, 0.4, 40.0),
      stop_distance(city_wet, w0, 38.544132653061226),
      38.544132653061226 =< 40.0]).
step(scenario(city_wet, 13.9, 0.4, 40.0), fact(3), [], []).
step(stop_distance(city_wet, w0, 38.544132653061226),
     rule(9),
     ['Scenario' = city_wet,
      'Distance' = 38.544132653061226,
      'V' = 13.9,
      'Mu' = 0.4,
      'Reaction' = 13.9,
      'V2' = 193.21,
      'M2' = 0.8,
      'Denom' = 7.840000000000001,
      'Braking' = 24.644132653061224],
     [scenario(city_wet, 13.9, 0.4, 40.0),
      13.9 is 13.9 * 1.0,
      193.21 is 13.9 ** 2.0,
      0.8 is 0.4 * 2.0,
      7.840000000000001 is 0.8 * 9.8,
      24.644132653061224 is 193.21 / 7.840000000000001,
      38.544132653061226 is 13.9 + 24.644132653061224]).
step(0.8 is 0.4 * 2.0, builtin, [], []).
step(7.840000000000001 is 0.8 * 9.8, builtin, [], []).
step(24.644132653061224 is 193.21 / 7.840000000000001, builtin, [], []).
step(38.544132653061226 is 13.9 + 24.644132653061224, builtin, [], []).
step(38.544132653061226 =< 40.0, builtin, [], []).
step(safeInWorld(city_wet, w1),
     rule(16),
     ['Scenario' = city_wet, 'World' = w1],
     [safe_in_world(city_wet, w1)]).
step(safe_in_world(city_wet, w1),
     rule(13),
     ['Scenario' = city_wet, 'World' = w1, 'Avail' = 40.0, 'Distance' = 24.15125],
     [scenario(city_wet, 13.9, 0.4, 40.0),
      stop_distance(city_wet, w1, 24.15125),
      24.15125 =< 40.0]).
step(stop_distance(city_wet, w1, 24.15125),
     rule(10),
     ['Scenario' = city_wet,
      'Distance' = 24.15125,
      'V' = 13.9,
      'Mu' = 0.4,
      'V2' = 193.21,
      'M2' = 0.8,
      'Denom' = 8.0],
     [scenario(city_wet, 13.9, 0.4, 40.0),
      193.21 is 13.9 ** 2.0,
      0.8 is 0.4 * 2.0,
      8.0 is 0.8 * 10.0,
      24.15125 is 193.21 / 8.0]).
step(8.0 is 0.8 * 10.0, builtin, [], []).
step(24.15125 is 193.21 / 8.0, builtin, [], []).
step(24.15125 =< 40.0, builtin, [], []).
step(safeInWorld(city_wet, w2),
     rule(16),
     ['Scenario' = city_wet, 'World' = w2],
     [safe_in_world(city_wet, w2)]).
step(safe_in_world(city_wet, w2),
     rule(13),
     ['Scenario' = city_wet, 'World' = w2, 'Avail' = 40.0, 'Distance' = 13.800714285714287],
     [scenario(city_wet, 13.9, 0.4, 40.0),
      stop_distance(city_wet, w2, 13.800714285714287),
      13.800714285714287 =< 40.0]).
step(stop_distance(city_wet, w2, 13.800714285714287),
     rule(11),
     ['Scenario' = city_wet, 'Distance' = 13.800714285714287, 'V' = 13.9, 'V2' = 193.21],
     [scenario(city_wet, 13.9, 0.4, 40.0),
      193.21 is 13.9 ** 2.0,
      13.800714285714287 is 193.21 / 14.0]).
step(safeInWorld(city_ice, w2),
     rule(16),
     ['Scenario' = city_ice, 'World' = w2],
     [safe_in_world(city_ice, w2)]).
step(safe_in_world(city_ice, w2),
     rule(13),
     ['Scenario' = city_ice, 'World' = w2, 'Avail' = 30.0, 'Distance' = 13.800714285714287],
     [scenario(city_ice, 13.9, 0.2, 30.0),
      stop_distance(city_ice, w2, 13.800714285714287),
      13.800714285714287 =< 30.0]).
step(scenario(city_ice, 13.9, 0.2, 30.0), fact(4), [], []).
step(stop_distance(city_ice, w2, 13.800714285714287),
     rule(11),
     ['Scenario' = city_ice, 'Distance' = 13.800714285714287, 'V' = 13.9, 'V2' = 193.21],
     [scenario(city_ice, 13.9, 0.2, 30.0),
      193.21 is 13.9 ** 2.0,
      13.800714285714287 is 193.21 / 14.0]).
step(13.800714285714287 =< 30.0, builtin, [], []).
step(riskyInWorld(highway_dry_short_gap, w0),
     rule(17),
     ['Scenario' = highway_dry_short_gap, 'World' = w0],
     [risky_in_world(highway_dry_short_gap, w0)]).
step(risky_in_world(highway_dry_short_gap, w0),
     rule(14),
     ['Scenario' = highway_dry_short_gap,
      'World' = w0,
      'Avail' = 60.0,
      'Distance' = 77.08826530612245],
     [scenario(highway_dry_short_gap, 27.8, 0.8, 60.0),
      stop_distance(highway_dry_short_gap, w0, 77.08826530612245),
      77.08826530612245 > 60.0]).
step(stop_distance(highway_dry_short_gap, w0, 77.08826530612245),
     rule(9),
     ['Scenario' = highway_dry_short_gap,
      'Distance' = 77.08826530612245,
      'V' = 27.8,
      'Mu' = 0.8,
      'Reaction' = 27.8,
      'V2' = 772.84,
      'M2' = 1.6,
      'Denom' = 15.680000000000001,
      'Braking' = 49.28826530612245],
     [scenario(highway_dry_short_gap, 27.8, 0.8, 60.0),
      27.8 is 27.8 * 1.0,
      772.84 is 27.8 ** 2.0,
      1.6 is 0.8 * 2.0,
      15.680000000000001 is 1.6 * 9.8,
      49.28826530612245 is 772.84 / 15.680000000000001,
      77.08826530612245 is 27.8 + 49.28826530612245]).
step(27.8 is 27.8 * 1.0, builtin, [], []).
step(49.28826530612245 is 772.84 / 15.680000000000001, builtin, [], []).
step(77.08826530612245 is 27.8 + 49.28826530612245, builtin, [], []).
step(77.08826530612245 > 60.0, builtin, [], []).
step(riskyInWorld(highway_dry_short_gap, w3),
     rule(17),
     ['Scenario' = highway_dry_short_gap, 'World' = w3],
     [risky_in_world(highway_dry_short_gap, w3)]).
step(risky_in_world(highway_dry_short_gap, w3),
     rule(14),
     ['Scenario' = highway_dry_short_gap,
      'World' = w3,
      'Avail' = 60.0,
      'Distance' = 115.63239795918368],
     [scenario(highway_dry_short_gap, 27.8, 0.8, 60.0),
      stop_distance(highway_dry_short_gap, w3, 115.63239795918368),
      115.63239795918368 > 60.0]).
step(stop_distance(highway_dry_short_gap, w3, 115.63239795918368),
     rule(12),
     ['Scenario' = highway_dry_short_gap,
      'Distance' = 115.63239795918368,
      'W0distance' = 77.08826530612245],
     [stop_distance(highway_dry_short_gap, w0, 77.08826530612245),
      115.63239795918368 is 77.08826530612245 * 1.5]).
step(115.63239795918368 is 77.08826530612245 * 1.5, builtin, [], []).
step(115.63239795918368 > 60.0, builtin, [], []).
step(riskyInWorld(city_wet, w3),
     rule(17),
     ['Scenario' = city_wet, 'World' = w3],
     [risky_in_world(city_wet, w3)]).
step(risky_in_world(city_wet, w3),
     rule(14),
     ['Scenario' = city_wet, 'World' = w3, 'Avail' = 40.0, 'Distance' = 57.81619897959184],
     [scenario(city_wet, 13.9, 0.4, 40.0),
      stop_distance(city_wet, w3, 57.81619897959184),
      57.81619897959184 > 40.0]).
step(stop_distance(city_wet, w3, 57.81619897959184),
     rule(12),
     ['Scenario' = city_wet, 'Distance' = 57.81619897959184, 'W0distance' = 38.544132653061226],
     [stop_distance(city_wet, w0, 38.544132653061226),
      57.81619897959184 is 38.544132653061226 * 1.5]).
step(57.81619897959184 is 38.544132653061226 * 1.5, builtin, [], []).
step(57.81619897959184 > 40.0, builtin, [], []).
step(riskyInWorld(city_ice, w0),
     rule(17),
     ['Scenario' = city_ice, 'World' = w0],
     [risky_in_world(city_ice, w0)]).
step(risky_in_world(city_ice, w0),
     rule(14),
     ['Scenario' = city_ice, 'World' = w0, 'Avail' = 30.0, 'Distance' = 63.188265306122446],
     [scenario(city_ice, 13.9, 0.2, 30.0),
      stop_distance(city_ice, w0, 63.188265306122446),
      63.188265306122446 > 30.0]).
step(stop_distance(city_ice, w0, 63.188265306122446),
     rule(9),
     ['Scenario' = city_ice,
      'Distance' = 63.188265306122446,
      'V' = 13.9,
      'Mu' = 0.2,
      'Reaction' = 13.9,
      'V2' = 193.21,
      'M2' = 0.4,
      'Denom' = 3.9200000000000004,
      'Braking' = 49.28826530612245],
     [scenario(city_ice, 13.9, 0.2, 30.0),
      13.9 is 13.9 * 1.0,
      193.21 is 13.9 ** 2.0,
      0.4 is 0.2 * 2.0,
      3.9200000000000004 is 0.4 * 9.8,
      49.28826530612245 is 193.21 / 3.9200000000000004,
      63.188265306122446 is 13.9 + 49.28826530612245]).
step(0.4 is 0.2 * 2.0, builtin, [], []).
step(3.9200000000000004 is 0.4 * 9.8, builtin, [], []).
step(49.28826530612245 is 193.21 / 3.9200000000000004, builtin, [], []).
step(63.188265306122446 is 13.9 + 49.28826530612245, builtin, [], []).
step(63.188265306122446 > 30.0, builtin, [], []).
step(riskyInWorld(city_ice, w1),
     rule(17),
     ['Scenario' = city_ice, 'World' = w1],
     [risky_in_world(city_ice, w1)]).
step(risky_in_world(city_ice, w1),
     rule(14),
     ['Scenario' = city_ice, 'World' = w1, 'Avail' = 30.0, 'Distance' = 48.3025],
     [scenario(city_ice, 13.9, 0.2, 30.0), stop_distance(city_ice, w1, 48.3025), 48.3025 > 30.0]).
step(stop_distance(city_ice, w1, 48.3025),
     rule(10),
     ['Scenario' = city_ice,
      'Distance' = 48.3025,
      'V' = 13.9,
      'Mu' = 0.2,
      'V2' = 193.21,
      'M2' = 0.4,
      'Denom' = 4.0],
     [scenario(city_ice, 13.9, 0.2, 30.0),
      193.21 is 13.9 ** 2.0,
      0.4 is 0.2 * 2.0,
      4.0 is 0.4 * 10.0,
      48.3025 is 193.21 / 4.0]).
step(4.0 is 0.4 * 10.0, builtin, [], []).
step(48.3025 is 193.21 / 4.0, builtin, [], []).
step(48.3025 > 30.0, builtin, [], []).
step(riskyInWorld(city_ice, w3),
     rule(17),
     ['Scenario' = city_ice, 'World' = w3],
     [risky_in_world(city_ice, w3)]).
step(risky_in_world(city_ice, w3),
     rule(14),
     ['Scenario' = city_ice, 'World' = w3, 'Avail' = 30.0, 'Distance' = 94.78239795918367],
     [scenario(city_ice, 13.9, 0.2, 30.0),
      stop_distance(city_ice, w3, 94.78239795918367),
      94.78239795918367 > 30.0]).
step(stop_distance(city_ice, w3, 94.78239795918367),
     rule(12),
     ['Scenario' = city_ice, 'Distance' = 94.78239795918367, 'W0distance' = 63.188265306122446],
     [stop_distance(city_ice, w0, 63.188265306122446),
      94.78239795918367 is 63.188265306122446 * 1.5]).
step(94.78239795918367 is 63.188265306122446 * 1.5, builtin, [], []).
step(94.78239795918367 > 30.0, builtin, [], []).
step(status(braking_safety_worlds, expected_world_pattern),
     rule(18),
     [],
     [pattern_matches(report)]).
step(pattern_matches(report),
     rule(15),
     [],
     [safe_in_world(city_dry, w0),
      safe_in_world(city_dry, w1),
      safe_in_world(city_dry, w2),
      safe_in_world(city_dry, w3),
      risky_in_world(highway_dry_short_gap, w0),
      risky_in_world(highway_dry_short_gap, w3),
      safe_in_world(highway_dry_short_gap, w1),
      safe_in_world(highway_dry_short_gap, w2),
      safe_in_world(city_wet, w0),
      safe_in_world(city_wet, w1),
      safe_in_world(city_wet, w2),
      risky_in_world(city_wet, w3),
      risky_in_world(city_ice, w0),
      risky_in_world(city_ice, w1),
      risky_in_world(city_ice, w3),
      safe_in_world(city_ice, w2)]).
step(reason(braking_safety_worlds, "simplified and naive worlds can be optimistic while the cautious world tightens the reference model"),
     rule(19),
     [],
     [pattern_matches(report)]).
