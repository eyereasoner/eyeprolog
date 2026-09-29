status(early_lactation, negative_energy_balance).
status(grazing, negative_energy_balance).
status(mid_lactation, near_neutral_energy_balance).
status(late_lactation, positive_energy_balance).
energyBalance_Mcal(early_lactation, -101.19999999999999).
energyBalance_Mcal(mid_lactation, 0.19999999999998863).
energyBalance_Mcal(late_lactation, 41.099999999999994).
energyBalance_Mcal(grazing, -11.399999999999991).
rationSupportedMilk_kg(early_lactation, 17.76).
rationSupportedMilk_kg(mid_lactation, 24.04).
rationSupportedMilk_kg(late_lactation, 24.22).
rationSupportedMilk_kg(grazing, 15.719999999999999).
strongestDeficit(dairy_energy_balance, early_lactation).

clause(1, cow(early_lactation, 650, 38, 6.4, 22), true).
clause(2, cow(mid_lactation, 610, 24, 6.5, 26), true).
clause(3, cow(late_lactation, 580, 16, 6.7, 25), true).
clause(4, cow(grazing, 540, 18, 5.8, 21), true).
clause(5,
       maintenance(var('C'), var('M')),
       (cow(var('C'), var('Weight'), anonymous(1), anonymous(2), anonymous(3)),
        var('M') is var('Weight') * 0.08)).
clause(6,
       milk_requirement(var('C'), var('R')),
       (cow(var('C'), anonymous(1), var('Milk'), anonymous(2), anonymous(3)),
        var('R') is var('Milk') * 5.0)).
clause(7,
       ration_supply(var('C'), var('S')),
       (cow(var('C'), anonymous(1), anonymous(2), var('Density'), var('Intake')),
        var('S') is var('Density') * var('Intake'))).
clause(8,
       total_requirement(var('C'), var('R')),
       (maintenance(var('C'), var('M')),
        milk_requirement(var('C'), var('Milkr')),
        var('R') is var('M') + var('Milkr'))).
clause(9,
       energy_balance(var('C'), var('B')),
       (ration_supply(var('C'), var('S')),
        total_requirement(var('C'), var('R')),
        var('B') is var('S') - var('R'))).
clause(10,
       ration_supported_milk(var('C'), var('Milk')),
       (ration_supply(var('C'), var('S')),
        maintenance(var('C'), var('M')),
        var('Availableformilk') is var('S') - var('M'),
        var('Milk') is var('Availableformilk') / 5.0)).
clause(11,
       status(var('C'), negative_energy_balance),
       (energy_balance(var('C'), var('B')), var('B') < -5.0)).
clause(12,
       status(var('C'), near_neutral_energy_balance),
       (energy_balance(var('C'), var('B')), var('B') >= -5.0, var('B') =< 5.0)).
clause(13,
       status(var('C'), positive_energy_balance),
       (energy_balance(var('C'), var('B')), var('B') > 5.0)).
clause(14, energyBalance_Mcal(var('C'), var('B')), energy_balance(var('C'), var('B'))).
clause(15,
       rationSupportedMilk_kg(var('C'), var('M')),
       ration_supported_milk(var('C'), var('M'))).
clause(17,
       strongestDeficit(dairy_energy_balance, early_lactation),
       (status(early_lactation, negative_energy_balance),
        status(late_lactation, positive_energy_balance))).

step(status(early_lactation, negative_energy_balance),
     rule(11),
     ['C' = early_lactation, 'B' = -101.19999999999999],
     [energy_balance(early_lactation, -101.19999999999999), -101.19999999999999 < -5.0]).
step(energy_balance(early_lactation, -101.19999999999999),
     rule(9),
     ['C' = early_lactation, 'B' = -101.19999999999999, 'S' = 140.8, 'R' = 242.0],
     [ration_supply(early_lactation, 140.8),
      total_requirement(early_lactation, 242.0),
      -101.19999999999999 is 140.8 - 242.0]).
step(ration_supply(early_lactation, 140.8),
     rule(7),
     ['C' = early_lactation, 'S' = 140.8, 'Density' = 6.4, 'Intake' = 22],
     [cow(early_lactation, 650, 38, 6.4, 22), 140.8 is 6.4 * 22]).
step(cow(early_lactation, 650, 38, 6.4, 22), fact(1), [], []).
step(140.8 is 6.4 * 22, builtin, [], []).
step(total_requirement(early_lactation, 242.0),
     rule(8),
     ['C' = early_lactation, 'R' = 242.0, 'M' = 52.0, 'Milkr' = 190.0],
     [maintenance(early_lactation, 52.0),
      milk_requirement(early_lactation, 190.0),
      242.0 is 52.0 + 190.0]).
step(maintenance(early_lactation, 52.0),
     rule(5),
     ['C' = early_lactation, 'M' = 52.0, 'Weight' = 650],
     [cow(early_lactation, 650, 38, 6.4, 22), 52.0 is 650 * 0.08]).
step(52.0 is 650 * 0.08, builtin, [], []).
step(milk_requirement(early_lactation, 190.0),
     rule(6),
     ['C' = early_lactation, 'R' = 190.0, 'Milk' = 38],
     [cow(early_lactation, 650, 38, 6.4, 22), 190.0 is 38 * 5.0]).
step(190.0 is 38 * 5.0, builtin, [], []).
step(242.0 is 52.0 + 190.0, builtin, [], []).
step(-101.19999999999999 is 140.8 - 242.0, builtin, [], []).
step(-101.19999999999999 < -5.0, builtin, [], []).
step(status(grazing, negative_energy_balance),
     rule(11),
     ['C' = grazing, 'B' = -11.399999999999991],
     [energy_balance(grazing, -11.399999999999991), -11.399999999999991 < -5.0]).
step(energy_balance(grazing, -11.399999999999991),
     rule(9),
     ['C' = grazing, 'B' = -11.399999999999991, 'S' = 121.8, 'R' = 133.2],
     [ration_supply(grazing, 121.8),
      total_requirement(grazing, 133.2),
      -11.399999999999991 is 121.8 - 133.2]).
step(ration_supply(grazing, 121.8),
     rule(7),
     ['C' = grazing, 'S' = 121.8, 'Density' = 5.8, 'Intake' = 21],
     [cow(grazing, 540, 18, 5.8, 21), 121.8 is 5.8 * 21]).
step(cow(grazing, 540, 18, 5.8, 21), fact(4), [], []).
step(121.8 is 5.8 * 21, builtin, [], []).
step(total_requirement(grazing, 133.2),
     rule(8),
     ['C' = grazing, 'R' = 133.2, 'M' = 43.2, 'Milkr' = 90.0],
     [maintenance(grazing, 43.2), milk_requirement(grazing, 90.0), 133.2 is 43.2 + 90.0]).
step(maintenance(grazing, 43.2),
     rule(5),
     ['C' = grazing, 'M' = 43.2, 'Weight' = 540],
     [cow(grazing, 540, 18, 5.8, 21), 43.2 is 540 * 0.08]).
step(43.2 is 540 * 0.08, builtin, [], []).
step(milk_requirement(grazing, 90.0),
     rule(6),
     ['C' = grazing, 'R' = 90.0, 'Milk' = 18],
     [cow(grazing, 540, 18, 5.8, 21), 90.0 is 18 * 5.0]).
step(90.0 is 18 * 5.0, builtin, [], []).
step(133.2 is 43.2 + 90.0, builtin, [], []).
step(-11.399999999999991 is 121.8 - 133.2, builtin, [], []).
step(-11.399999999999991 < -5.0, builtin, [], []).
step(status(mid_lactation, near_neutral_energy_balance),
     rule(12),
     ['C' = mid_lactation, 'B' = 0.19999999999998863],
     [energy_balance(mid_lactation, 0.19999999999998863),
      0.19999999999998863 >= -5.0,
      0.19999999999998863 =< 5.0]).
step(energy_balance(mid_lactation, 0.19999999999998863),
     rule(9),
     ['C' = mid_lactation, 'B' = 0.19999999999998863, 'S' = 169.0, 'R' = 168.8],
     [ration_supply(mid_lactation, 169.0),
      total_requirement(mid_lactation, 168.8),
      0.19999999999998863 is 169.0 - 168.8]).
step(ration_supply(mid_lactation, 169.0),
     rule(7),
     ['C' = mid_lactation, 'S' = 169.0, 'Density' = 6.5, 'Intake' = 26],
     [cow(mid_lactation, 610, 24, 6.5, 26), 169.0 is 6.5 * 26]).
step(cow(mid_lactation, 610, 24, 6.5, 26), fact(2), [], []).
step(169.0 is 6.5 * 26, builtin, [], []).
step(total_requirement(mid_lactation, 168.8),
     rule(8),
     ['C' = mid_lactation, 'R' = 168.8, 'M' = 48.800000000000004, 'Milkr' = 120.0],
     [maintenance(mid_lactation, 48.800000000000004),
      milk_requirement(mid_lactation, 120.0),
      168.8 is 48.800000000000004 + 120.0]).
step(maintenance(mid_lactation, 48.800000000000004),
     rule(5),
     ['C' = mid_lactation, 'M' = 48.800000000000004, 'Weight' = 610],
     [cow(mid_lactation, 610, 24, 6.5, 26), 48.800000000000004 is 610 * 0.08]).
step(48.800000000000004 is 610 * 0.08, builtin, [], []).
step(milk_requirement(mid_lactation, 120.0),
     rule(6),
     ['C' = mid_lactation, 'R' = 120.0, 'Milk' = 24],
     [cow(mid_lactation, 610, 24, 6.5, 26), 120.0 is 24 * 5.0]).
step(120.0 is 24 * 5.0, builtin, [], []).
step(168.8 is 48.800000000000004 + 120.0, builtin, [], []).
step(0.19999999999998863 is 169.0 - 168.8, builtin, [], []).
step(0.19999999999998863 >= -5.0, builtin, [], []).
step(0.19999999999998863 =< 5.0, builtin, [], []).
step(status(late_lactation, positive_energy_balance),
     rule(13),
     ['C' = late_lactation, 'B' = 41.099999999999994],
     [energy_balance(late_lactation, 41.099999999999994), 41.099999999999994 > 5.0]).
step(energy_balance(late_lactation, 41.099999999999994),
     rule(9),
     ['C' = late_lactation, 'B' = 41.099999999999994, 'S' = 167.5, 'R' = 126.4],
     [ration_supply(late_lactation, 167.5),
      total_requirement(late_lactation, 126.4),
      41.099999999999994 is 167.5 - 126.4]).
step(ration_supply(late_lactation, 167.5),
     rule(7),
     ['C' = late_lactation, 'S' = 167.5, 'Density' = 6.7, 'Intake' = 25],
     [cow(late_lactation, 580, 16, 6.7, 25), 167.5 is 6.7 * 25]).
step(cow(late_lactation, 580, 16, 6.7, 25), fact(3), [], []).
step(167.5 is 6.7 * 25, builtin, [], []).
step(total_requirement(late_lactation, 126.4),
     rule(8),
     ['C' = late_lactation, 'R' = 126.4, 'M' = 46.4, 'Milkr' = 80.0],
     [maintenance(late_lactation, 46.4),
      milk_requirement(late_lactation, 80.0),
      126.4 is 46.4 + 80.0]).
step(maintenance(late_lactation, 46.4),
     rule(5),
     ['C' = late_lactation, 'M' = 46.4, 'Weight' = 580],
     [cow(late_lactation, 580, 16, 6.7, 25), 46.4 is 580 * 0.08]).
step(46.4 is 580 * 0.08, builtin, [], []).
step(milk_requirement(late_lactation, 80.0),
     rule(6),
     ['C' = late_lactation, 'R' = 80.0, 'Milk' = 16],
     [cow(late_lactation, 580, 16, 6.7, 25), 80.0 is 16 * 5.0]).
step(80.0 is 16 * 5.0, builtin, [], []).
step(126.4 is 46.4 + 80.0, builtin, [], []).
step(41.099999999999994 is 167.5 - 126.4, builtin, [], []).
step(41.099999999999994 > 5.0, builtin, [], []).
step(energyBalance_Mcal(early_lactation, -101.19999999999999),
     rule(14),
     ['C' = early_lactation, 'B' = -101.19999999999999],
     [energy_balance(early_lactation, -101.19999999999999)]).
step(energyBalance_Mcal(mid_lactation, 0.19999999999998863),
     rule(14),
     ['C' = mid_lactation, 'B' = 0.19999999999998863],
     [energy_balance(mid_lactation, 0.19999999999998863)]).
step(energyBalance_Mcal(late_lactation, 41.099999999999994),
     rule(14),
     ['C' = late_lactation, 'B' = 41.099999999999994],
     [energy_balance(late_lactation, 41.099999999999994)]).
step(energyBalance_Mcal(grazing, -11.399999999999991),
     rule(14),
     ['C' = grazing, 'B' = -11.399999999999991],
     [energy_balance(grazing, -11.399999999999991)]).
step(rationSupportedMilk_kg(early_lactation, 17.76),
     rule(15),
     ['C' = early_lactation, 'M' = 17.76],
     [ration_supported_milk(early_lactation, 17.76)]).
step(ration_supported_milk(early_lactation, 17.76),
     rule(10),
     ['C' = early_lactation,
      'Milk' = 17.76,
      'S' = 140.8,
      'M' = 52.0,
      'Availableformilk' = 88.80000000000001],
     [ration_supply(early_lactation, 140.8),
      maintenance(early_lactation, 52.0),
      88.80000000000001 is 140.8 - 52.0,
      17.76 is 88.80000000000001 / 5.0]).
step(88.80000000000001 is 140.8 - 52.0, builtin, [], []).
step(17.76 is 88.80000000000001 / 5.0, builtin, [], []).
step(rationSupportedMilk_kg(mid_lactation, 24.04),
     rule(15),
     ['C' = mid_lactation, 'M' = 24.04],
     [ration_supported_milk(mid_lactation, 24.04)]).
step(ration_supported_milk(mid_lactation, 24.04),
     rule(10),
     ['C' = mid_lactation,
      'Milk' = 24.04,
      'S' = 169.0,
      'M' = 48.800000000000004,
      'Availableformilk' = 120.19999999999999],
     [ration_supply(mid_lactation, 169.0),
      maintenance(mid_lactation, 48.800000000000004),
      120.19999999999999 is 169.0 - 48.800000000000004,
      24.04 is 120.19999999999999 / 5.0]).
step(120.19999999999999 is 169.0 - 48.800000000000004, builtin, [], []).
step(24.04 is 120.19999999999999 / 5.0, builtin, [], []).
step(rationSupportedMilk_kg(late_lactation, 24.22),
     rule(15),
     ['C' = late_lactation, 'M' = 24.22],
     [ration_supported_milk(late_lactation, 24.22)]).
step(ration_supported_milk(late_lactation, 24.22),
     rule(10),
     ['C' = late_lactation, 'Milk' = 24.22, 'S' = 167.5, 'M' = 46.4, 'Availableformilk' = 121.1],
     [ration_supply(late_lactation, 167.5),
      maintenance(late_lactation, 46.4),
      121.1 is 167.5 - 46.4,
      24.22 is 121.1 / 5.0]).
step(121.1 is 167.5 - 46.4, builtin, [], []).
step(24.22 is 121.1 / 5.0, builtin, [], []).
step(rationSupportedMilk_kg(grazing, 15.719999999999999),
     rule(15),
     ['C' = grazing, 'M' = 15.719999999999999],
     [ration_supported_milk(grazing, 15.719999999999999)]).
step(ration_supported_milk(grazing, 15.719999999999999),
     rule(10),
     ['C' = grazing,
      'Milk' = 15.719999999999999,
      'S' = 121.8,
      'M' = 43.2,
      'Availableformilk' = 78.6],
     [ration_supply(grazing, 121.8),
      maintenance(grazing, 43.2),
      78.6 is 121.8 - 43.2,
      15.719999999999999 is 78.6 / 5.0]).
step(78.6 is 121.8 - 43.2, builtin, [], []).
step(15.719999999999999 is 78.6 / 5.0, builtin, [], []).
step(strongestDeficit(dairy_energy_balance, early_lactation),
     rule(17),
     [],
     [status(early_lactation, negative_energy_balance),
      status(late_lactation, positive_energy_balance)]).
