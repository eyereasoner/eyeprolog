safeInWorld(city_errand, w1).
safeInWorld(city_errand, w2).
safeInWorld(city_errand, w0).
safeInWorld(city_errand, w3).
safeInWorld(winter_highway, w1).
safeInWorld(heavy_delivery, w1).
safeInWorld(heavy_delivery, w2).
safeInWorld(heavy_delivery, w0).
safeInWorld(cold_commute, w1).
safeInWorld(cold_commute, w2).
safeInWorld(cold_commute, w0).
safeInWorld(cold_commute, w3).
riskyInWorld(winter_highway, w2).
riskyInWorld(winter_highway, w0).
riskyInWorld(winter_highway, w3).
riskyInWorld(heavy_delivery, w3).
reason(winter_highway, "cold fast payload trip exceeds battery in physics-aware worlds").
reason(heavy_delivery, "safety buffer turns a physics-safe delivery into a cautious risk").
status(ev_range_worlds, expected_world_pattern).

clause(5, trip_data(city_errand, 40, 45, 20, 100, 30, 0.18), true).
clause(6, trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2), true).
clause(7, trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22), true).
clause(8, trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19), true).
clause(9,
       speed_factor(var('T'), 1.2),
       (trip_data(var('T'), anonymous(1), var('S'), anonymous(2), anonymous(3), anonymous(4), anonymous(5)),
        var('S') > 100)).
clause(10,
       speed_factor(var('T'), 1.0),
       (trip_data(var('T'), anonymous(1), var('S'), anonymous(2), anonymous(3), anonymous(4), anonymous(5)),
        var('S') =< 100)).
clause(11,
       temperature_factor(var('T'), 1.15),
       (trip_data(var('T'), anonymous(1), anonymous(2), var('Temp'), anonymous(3), anonymous(4), anonymous(5)),
        var('Temp') < 0)).
clause(12,
       temperature_factor(var('T'), 1.0),
       (trip_data(var('T'), anonymous(1), anonymous(2), var('Temp'), anonymous(3), anonymous(4), anonymous(5)),
        var('Temp') >= 0)).
clause(13,
       payload_factor(var('T'), 1.15),
       (trip_data(var('T'), anonymous(1), anonymous(2), anonymous(3), var('P'), anonymous(4), anonymous(5)),
        var('P') > 500)).
clause(14,
       payload_factor(var('T'), 1.08),
       (trip_data(var('T'), anonymous(1), anonymous(2), anonymous(3), var('P'), anonymous(4), anonymous(5)),
        var('P') > 250,
        var('P') =< 500)).
clause(15,
       payload_factor(var('T'), 1.0),
       (trip_data(var('T'), anonymous(1), anonymous(2), anonymous(3), var('P'), anonymous(4), anonymous(5)),
        var('P') =< 250)).
clause(16,
       base_energy(var('T'), var('E')),
       (trip_data(var('T'), var('D'), anonymous(1), anonymous(2), anonymous(3), anonymous(4), var('B')),
        var('E') is var('D') * var('B'))).
clause(17, required_energy(var('T'), w1, var('E')), base_energy(var('T'), var('E'))).
clause(18,
       required_energy(var('T'), w2, var('E')),
       (base_energy(var('T'), var('Base')),
        speed_factor(var('T'), var('Sf')),
        var('E') is var('Base') * var('Sf'))).
clause(19,
       required_energy(var('T'), w0, var('E')),
       (base_energy(var('T'), var('Base')),
        speed_factor(var('T'), var('Sf')),
        temperature_factor(var('T'), var('Tf')),
        payload_factor(var('T'), var('Pf')),
        var('A') is var('Base') * var('Sf'),
        var('B') is var('A') * var('Tf'),
        var('E') is var('B') * var('Pf'))).
clause(20,
       required_energy(var('T'), w3, var('E')),
       (required_energy(var('T'), w0, var('W0')), var('E') is var('W0') * 1.3)).
clause(21,
       safe_in_world(var('T'), var('W')),
       (trip_data(var('T'), anonymous(1), anonymous(2), anonymous(3), anonymous(4), var('Battery'), anonymous(5)),
        required_energy(var('T'), var('W'), var('Required')),
        var('Required') =< var('Battery'))).
clause(22,
       risky_in_world(var('T'), var('W')),
       (trip_data(var('T'), anonymous(1), anonymous(2), anonymous(3), anonymous(4), var('Battery'), anonymous(5)),
        required_energy(var('T'), var('W'), var('Required')),
        var('Required') > var('Battery'))).
clause(23, safeInWorld(var('T'), var('W')), safe_in_world(var('T'), var('W'))).
clause(24, riskyInWorld(var('T'), var('W')), risky_in_world(var('T'), var('W'))).
clause(25,
       reason(winter_highway, "cold fast payload trip exceeds battery in physics-aware worlds"),
       (risky_in_world(winter_highway, w0),
        risky_in_world(winter_highway, w2),
        risky_in_world(winter_highway, w3),
        safe_in_world(winter_highway, w1))).
clause(26,
       reason(heavy_delivery, "safety buffer turns a physics-safe delivery into a cautious risk"),
       (safe_in_world(heavy_delivery, w0), risky_in_world(heavy_delivery, w3))).
clause(27,
       status(ev_range_worlds, expected_world_pattern),
       (safe_in_world(city_errand, w3),
        risky_in_world(winter_highway, w0),
        risky_in_world(heavy_delivery, w3),
        safe_in_world(cold_commute, w3))).

step(safeInWorld(city_errand, w1),
     rule(23),
     ['T' = city_errand, 'W' = w1],
     [safe_in_world(city_errand, w1)]).
step(safe_in_world(city_errand, w1),
     rule(21),
     ['T' = city_errand, 'W' = w1, 'Battery' = 30, 'Required' = 7.199999999999999],
     [trip_data(city_errand, 40, 45, 20, 100, 30, 0.18),
      required_energy(city_errand, w1, 7.199999999999999),
      7.199999999999999 =< 30]).
step(trip_data(city_errand, 40, 45, 20, 100, 30, 0.18), fact(5), [], []).
step(required_energy(city_errand, w1, 7.199999999999999),
     rule(17),
     ['T' = city_errand, 'E' = 7.199999999999999],
     [base_energy(city_errand, 7.199999999999999)]).
step(base_energy(city_errand, 7.199999999999999),
     rule(16),
     ['T' = city_errand, 'E' = 7.199999999999999, 'D' = 40, 'B' = 0.18],
     [trip_data(city_errand, 40, 45, 20, 100, 30, 0.18), 7.199999999999999 is 40 * 0.18]).
step(7.199999999999999 is 40 * 0.18, builtin, [], []).
step(7.199999999999999 =< 30, builtin, [], []).
step(safeInWorld(city_errand, w2),
     rule(23),
     ['T' = city_errand, 'W' = w2],
     [safe_in_world(city_errand, w2)]).
step(safe_in_world(city_errand, w2),
     rule(21),
     ['T' = city_errand, 'W' = w2, 'Battery' = 30, 'Required' = 7.199999999999999],
     [trip_data(city_errand, 40, 45, 20, 100, 30, 0.18),
      required_energy(city_errand, w2, 7.199999999999999),
      7.199999999999999 =< 30]).
step(required_energy(city_errand, w2, 7.199999999999999),
     rule(18),
     ['T' = city_errand, 'E' = 7.199999999999999, 'Base' = 7.199999999999999, 'Sf' = 1.0],
     [base_energy(city_errand, 7.199999999999999),
      speed_factor(city_errand, 1.0),
      7.199999999999999 is 7.199999999999999 * 1.0]).
step(speed_factor(city_errand, 1.0),
     rule(10),
     ['T' = city_errand, 'S' = 45],
     [trip_data(city_errand, 40, 45, 20, 100, 30, 0.18), 45 =< 100]).
step(45 =< 100, builtin, [], []).
step(7.199999999999999 is 7.199999999999999 * 1.0, builtin, [], []).
step(safeInWorld(city_errand, w0),
     rule(23),
     ['T' = city_errand, 'W' = w0],
     [safe_in_world(city_errand, w0)]).
step(safe_in_world(city_errand, w0),
     rule(21),
     ['T' = city_errand, 'W' = w0, 'Battery' = 30, 'Required' = 7.199999999999999],
     [trip_data(city_errand, 40, 45, 20, 100, 30, 0.18),
      required_energy(city_errand, w0, 7.199999999999999),
      7.199999999999999 =< 30]).
step(required_energy(city_errand, w0, 7.199999999999999),
     rule(19),
     ['T' = city_errand,
      'E' = 7.199999999999999,
      'Base' = 7.199999999999999,
      'Sf' = 1.0,
      'Tf' = 1.0,
      'Pf' = 1.0,
      'A' = 7.199999999999999,
      'B' = 7.199999999999999],
     [base_energy(city_errand, 7.199999999999999),
      speed_factor(city_errand, 1.0),
      temperature_factor(city_errand, 1.0),
      payload_factor(city_errand, 1.0),
      7.199999999999999 is 7.199999999999999 * 1.0,
      7.199999999999999 is 7.199999999999999 * 1.0,
      7.199999999999999 is 7.199999999999999 * 1.0]).
step(temperature_factor(city_errand, 1.0),
     rule(12),
     ['T' = city_errand, 'Temp' = 20],
     [trip_data(city_errand, 40, 45, 20, 100, 30, 0.18), 20 >= 0]).
step(20 >= 0, builtin, [], []).
step(payload_factor(city_errand, 1.0),
     rule(15),
     ['T' = city_errand, 'P' = 100],
     [trip_data(city_errand, 40, 45, 20, 100, 30, 0.18), 100 =< 250]).
step(100 =< 250, builtin, [], []).
step(safeInWorld(city_errand, w3),
     rule(23),
     ['T' = city_errand, 'W' = w3],
     [safe_in_world(city_errand, w3)]).
step(safe_in_world(city_errand, w3),
     rule(21),
     ['T' = city_errand, 'W' = w3, 'Battery' = 30, 'Required' = 9.36],
     [trip_data(city_errand, 40, 45, 20, 100, 30, 0.18),
      required_energy(city_errand, w3, 9.36),
      9.36 =< 30]).
step(required_energy(city_errand, w3, 9.36),
     rule(20),
     ['T' = city_errand, 'E' = 9.36, 'W0' = 7.199999999999999],
     [required_energy(city_errand, w0, 7.199999999999999), 9.36 is 7.199999999999999 * 1.3]).
step(9.36 is 7.199999999999999 * 1.3, builtin, [], []).
step(9.36 =< 30, builtin, [], []).
step(safeInWorld(winter_highway, w1),
     rule(23),
     ['T' = winter_highway, 'W' = w1],
     [safe_in_world(winter_highway, w1)]).
step(safe_in_world(winter_highway, w1),
     rule(21),
     ['T' = winter_highway, 'W' = w1, 'Battery' = 60, 'Required' = 52.0],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2),
      required_energy(winter_highway, w1, 52.0),
      52.0 =< 60]).
step(trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2), fact(6), [], []).
step(required_energy(winter_highway, w1, 52.0),
     rule(17),
     ['T' = winter_highway, 'E' = 52.0],
     [base_energy(winter_highway, 52.0)]).
step(base_energy(winter_highway, 52.0),
     rule(16),
     ['T' = winter_highway, 'E' = 52.0, 'D' = 260, 'B' = 0.2],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2), 52.0 is 260 * 0.2]).
step(52.0 is 260 * 0.2, builtin, [], []).
step(52.0 =< 60, builtin, [], []).
step(safeInWorld(heavy_delivery, w1),
     rule(23),
     ['T' = heavy_delivery, 'W' = w1],
     [safe_in_world(heavy_delivery, w1)]).
step(safe_in_world(heavy_delivery, w1),
     rule(21),
     ['T' = heavy_delivery, 'W' = w1, 'Battery' = 55, 'Required' = 39.6],
     [trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22),
      required_energy(heavy_delivery, w1, 39.6),
      39.6 =< 55]).
step(trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22), fact(7), [], []).
step(required_energy(heavy_delivery, w1, 39.6),
     rule(17),
     ['T' = heavy_delivery, 'E' = 39.6],
     [base_energy(heavy_delivery, 39.6)]).
step(base_energy(heavy_delivery, 39.6),
     rule(16),
     ['T' = heavy_delivery, 'E' = 39.6, 'D' = 180, 'B' = 0.22],
     [trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22), 39.6 is 180 * 0.22]).
step(39.6 is 180 * 0.22, builtin, [], []).
step(39.6 =< 55, builtin, [], []).
step(safeInWorld(heavy_delivery, w2),
     rule(23),
     ['T' = heavy_delivery, 'W' = w2],
     [safe_in_world(heavy_delivery, w2)]).
step(safe_in_world(heavy_delivery, w2),
     rule(21),
     ['T' = heavy_delivery, 'W' = w2, 'Battery' = 55, 'Required' = 39.6],
     [trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22),
      required_energy(heavy_delivery, w2, 39.6),
      39.6 =< 55]).
step(required_energy(heavy_delivery, w2, 39.6),
     rule(18),
     ['T' = heavy_delivery, 'E' = 39.6, 'Base' = 39.6, 'Sf' = 1.0],
     [base_energy(heavy_delivery, 39.6), speed_factor(heavy_delivery, 1.0), 39.6 is 39.6 * 1.0]).
step(speed_factor(heavy_delivery, 1.0),
     rule(10),
     ['T' = heavy_delivery, 'S' = 80],
     [trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22), 80 =< 100]).
step(80 =< 100, builtin, [], []).
step(39.6 is 39.6 * 1.0, builtin, [], []).
step(safeInWorld(heavy_delivery, w0),
     rule(23),
     ['T' = heavy_delivery, 'W' = w0],
     [safe_in_world(heavy_delivery, w0)]).
step(safe_in_world(heavy_delivery, w0),
     rule(21),
     ['T' = heavy_delivery, 'W' = w0, 'Battery' = 55, 'Required' = 45.54],
     [trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22),
      required_energy(heavy_delivery, w0, 45.54),
      45.54 =< 55]).
step(required_energy(heavy_delivery, w0, 45.54),
     rule(19),
     ['T' = heavy_delivery,
      'E' = 45.54,
      'Base' = 39.6,
      'Sf' = 1.0,
      'Tf' = 1.0,
      'Pf' = 1.15,
      'A' = 39.6,
      'B' = 39.6],
     [base_energy(heavy_delivery, 39.6),
      speed_factor(heavy_delivery, 1.0),
      temperature_factor(heavy_delivery, 1.0),
      payload_factor(heavy_delivery, 1.15),
      39.6 is 39.6 * 1.0,
      39.6 is 39.6 * 1.0,
      45.54 is 39.6 * 1.15]).
step(temperature_factor(heavy_delivery, 1.0),
     rule(12),
     ['T' = heavy_delivery, 'Temp' = 15],
     [trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22), 15 >= 0]).
step(15 >= 0, builtin, [], []).
step(payload_factor(heavy_delivery, 1.15),
     rule(13),
     ['T' = heavy_delivery, 'P' = 700],
     [trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22), 700 > 500]).
step(700 > 500, builtin, [], []).
step(45.54 is 39.6 * 1.15, builtin, [], []).
step(45.54 =< 55, builtin, [], []).
step(safeInWorld(cold_commute, w1),
     rule(23),
     ['T' = cold_commute, 'W' = w1],
     [safe_in_world(cold_commute, w1)]).
step(safe_in_world(cold_commute, w1),
     rule(21),
     ['T' = cold_commute, 'W' = w1, 'Battery' = 35, 'Required' = 22.8],
     [trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19),
      required_energy(cold_commute, w1, 22.8),
      22.8 =< 35]).
step(trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19), fact(8), [], []).
step(required_energy(cold_commute, w1, 22.8),
     rule(17),
     ['T' = cold_commute, 'E' = 22.8],
     [base_energy(cold_commute, 22.8)]).
step(base_energy(cold_commute, 22.8),
     rule(16),
     ['T' = cold_commute, 'E' = 22.8, 'D' = 120, 'B' = 0.19],
     [trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19), 22.8 is 120 * 0.19]).
step(22.8 is 120 * 0.19, builtin, [], []).
step(22.8 =< 35, builtin, [], []).
step(safeInWorld(cold_commute, w2),
     rule(23),
     ['T' = cold_commute, 'W' = w2],
     [safe_in_world(cold_commute, w2)]).
step(safe_in_world(cold_commute, w2),
     rule(21),
     ['T' = cold_commute, 'W' = w2, 'Battery' = 35, 'Required' = 22.8],
     [trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19),
      required_energy(cold_commute, w2, 22.8),
      22.8 =< 35]).
step(required_energy(cold_commute, w2, 22.8),
     rule(18),
     ['T' = cold_commute, 'E' = 22.8, 'Base' = 22.8, 'Sf' = 1.0],
     [base_energy(cold_commute, 22.8), speed_factor(cold_commute, 1.0), 22.8 is 22.8 * 1.0]).
step(speed_factor(cold_commute, 1.0),
     rule(10),
     ['T' = cold_commute, 'S' = 90],
     [trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19), 90 =< 100]).
step(90 =< 100, builtin, [], []).
step(22.8 is 22.8 * 1.0, builtin, [], []).
step(safeInWorld(cold_commute, w0),
     rule(23),
     ['T' = cold_commute, 'W' = w0],
     [safe_in_world(cold_commute, w0)]).
step(safe_in_world(cold_commute, w0),
     rule(21),
     ['T' = cold_commute, 'W' = w0, 'Battery' = 35, 'Required' = 26.22],
     [trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19),
      required_energy(cold_commute, w0, 26.22),
      26.22 =< 35]).
step(required_energy(cold_commute, w0, 26.22),
     rule(19),
     ['T' = cold_commute,
      'E' = 26.22,
      'Base' = 22.8,
      'Sf' = 1.0,
      'Tf' = 1.15,
      'Pf' = 1.0,
      'A' = 22.8,
      'B' = 26.22],
     [base_energy(cold_commute, 22.8),
      speed_factor(cold_commute, 1.0),
      temperature_factor(cold_commute, 1.15),
      payload_factor(cold_commute, 1.0),
      22.8 is 22.8 * 1.0,
      26.22 is 22.8 * 1.15,
      26.22 is 26.22 * 1.0]).
step(temperature_factor(cold_commute, 1.15),
     rule(11),
     ['T' = cold_commute, 'Temp' = -8],
     [trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19), -8 < 0]).
step(-8 < 0, builtin, [], []).
step(payload_factor(cold_commute, 1.0),
     rule(15),
     ['T' = cold_commute, 'P' = 100],
     [trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19), 100 =< 250]).
step(26.22 is 22.8 * 1.15, builtin, [], []).
step(26.22 is 26.22 * 1.0, builtin, [], []).
step(26.22 =< 35, builtin, [], []).
step(safeInWorld(cold_commute, w3),
     rule(23),
     ['T' = cold_commute, 'W' = w3],
     [safe_in_world(cold_commute, w3)]).
step(safe_in_world(cold_commute, w3),
     rule(21),
     ['T' = cold_commute, 'W' = w3, 'Battery' = 35, 'Required' = 34.086],
     [trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19),
      required_energy(cold_commute, w3, 34.086),
      34.086 =< 35]).
step(required_energy(cold_commute, w3, 34.086),
     rule(20),
     ['T' = cold_commute, 'E' = 34.086, 'W0' = 26.22],
     [required_energy(cold_commute, w0, 26.22), 34.086 is 26.22 * 1.3]).
step(34.086 is 26.22 * 1.3, builtin, [], []).
step(34.086 =< 35, builtin, [], []).
step(riskyInWorld(winter_highway, w2),
     rule(24),
     ['T' = winter_highway, 'W' = w2],
     [risky_in_world(winter_highway, w2)]).
step(risky_in_world(winter_highway, w2),
     rule(22),
     ['T' = winter_highway, 'W' = w2, 'Battery' = 60, 'Required' = 62.4],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2),
      required_energy(winter_highway, w2, 62.4),
      62.4 > 60]).
step(required_energy(winter_highway, w2, 62.4),
     rule(18),
     ['T' = winter_highway, 'E' = 62.4, 'Base' = 52.0, 'Sf' = 1.2],
     [base_energy(winter_highway, 52.0), speed_factor(winter_highway, 1.2), 62.4 is 52.0 * 1.2]).
step(speed_factor(winter_highway, 1.2),
     rule(9),
     ['T' = winter_highway, 'S' = 115],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2), 115 > 100]).
step(115 > 100, builtin, [], []).
step(62.4 is 52.0 * 1.2, builtin, [], []).
step(62.4 > 60, builtin, [], []).
step(riskyInWorld(winter_highway, w0),
     rule(24),
     ['T' = winter_highway, 'W' = w0],
     [risky_in_world(winter_highway, w0)]).
step(risky_in_world(winter_highway, w0),
     rule(22),
     ['T' = winter_highway, 'W' = w0, 'Battery' = 60, 'Required' = 77.5008],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2),
      required_energy(winter_highway, w0, 77.5008),
      77.5008 > 60]).
step(required_energy(winter_highway, w0, 77.5008),
     rule(19),
     ['T' = winter_highway,
      'E' = 77.5008,
      'Base' = 52.0,
      'Sf' = 1.2,
      'Tf' = 1.15,
      'Pf' = 1.08,
      'A' = 62.4,
      'B' = 71.75999999999999],
     [base_energy(winter_highway, 52.0),
      speed_factor(winter_highway, 1.2),
      temperature_factor(winter_highway, 1.15),
      payload_factor(winter_highway, 1.08),
      62.4 is 52.0 * 1.2,
      71.75999999999999 is 62.4 * 1.15,
      77.5008 is 71.75999999999999 * 1.08]).
step(temperature_factor(winter_highway, 1.15),
     rule(11),
     ['T' = winter_highway, 'Temp' = -5],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2), -5 < 0]).
step(-5 < 0, builtin, [], []).
step(payload_factor(winter_highway, 1.08),
     rule(14),
     ['T' = winter_highway, 'P' = 400],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2), 400 > 250, 400 =< 500]).
step(400 > 250, builtin, [], []).
step(400 =< 500, builtin, [], []).
step(71.75999999999999 is 62.4 * 1.15, builtin, [], []).
step(77.5008 is 71.75999999999999 * 1.08, builtin, [], []).
step(77.5008 > 60, builtin, [], []).
step(riskyInWorld(winter_highway, w3),
     rule(24),
     ['T' = winter_highway, 'W' = w3],
     [risky_in_world(winter_highway, w3)]).
step(risky_in_world(winter_highway, w3),
     rule(22),
     ['T' = winter_highway, 'W' = w3, 'Battery' = 60, 'Required' = 100.75104],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2),
      required_energy(winter_highway, w3, 100.75104),
      100.75104 > 60]).
step(required_energy(winter_highway, w3, 100.75104),
     rule(20),
     ['T' = winter_highway, 'E' = 100.75104, 'W0' = 77.5008],
     [required_energy(winter_highway, w0, 77.5008), 100.75104 is 77.5008 * 1.3]).
step(100.75104 is 77.5008 * 1.3, builtin, [], []).
step(100.75104 > 60, builtin, [], []).
step(riskyInWorld(heavy_delivery, w3),
     rule(24),
     ['T' = heavy_delivery, 'W' = w3],
     [risky_in_world(heavy_delivery, w3)]).
step(risky_in_world(heavy_delivery, w3),
     rule(22),
     ['T' = heavy_delivery, 'W' = w3, 'Battery' = 55, 'Required' = 59.202],
     [trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22),
      required_energy(heavy_delivery, w3, 59.202),
      59.202 > 55]).
step(required_energy(heavy_delivery, w3, 59.202),
     rule(20),
     ['T' = heavy_delivery, 'E' = 59.202, 'W0' = 45.54],
     [required_energy(heavy_delivery, w0, 45.54), 59.202 is 45.54 * 1.3]).
step(59.202 is 45.54 * 1.3, builtin, [], []).
step(59.202 > 55, builtin, [], []).
step(reason(winter_highway, "cold fast payload trip exceeds battery in physics-aware worlds"),
     rule(25),
     [],
     [risky_in_world(winter_highway, w0),
      risky_in_world(winter_highway, w2),
      risky_in_world(winter_highway, w3),
      safe_in_world(winter_highway, w1)]).
step(reason(heavy_delivery, "safety buffer turns a physics-safe delivery into a cautious risk"),
     rule(26),
     [],
     [safe_in_world(heavy_delivery, w0), risky_in_world(heavy_delivery, w3)]).
step(status(ev_range_worlds, expected_world_pattern),
     rule(27),
     [],
     [safe_in_world(city_errand, w3),
      risky_in_world(winter_highway, w0),
      risky_in_world(heavy_delivery, w3),
      safe_in_world(cold_commute, w3)]).
