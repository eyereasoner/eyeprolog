status(low_input, under_supplied).
status(balanced_loam, balanced).
status(sandy_high, over_supplied).
status(clay_surplus, over_supplied).
availableN_kg_ha(low_input, 58.5).
availableN_kg_ha(balanced_loam, 110.0).
availableN_kg_ha(sandy_high, 117.0).
availableN_kg_ha(clay_surplus, 147.20000000000002).
deficitN_kg_ha(low_input, 51.5).
deficitN_kg_ha(balanced_loam, 0.0).
deficitN_kg_ha(sandy_high, 0.0).
deficitN_kg_ha(clay_surplus, 0.0).
surplusN_kg_ha(sandy_high, 12.0).
surplusN_kg_ha(clay_surplus, 27.200000000000017).
surplusN_kg_ha(low_input, 0.0).
surplusN_kg_ha(balanced_loam, 0.0).
leachingIndex(sandy_high, 4.199999999999999).
leachingIndex(clay_surplus, 2.1760000000000015).
leachingIndex(low_input, 0.0).
leachingIndex(balanced_loam, 0.0).
highestLeachingRisk(field_nitrogen_balance, sandy_high).

clause(1, field(low_input, 25, 40, 0.1, 110), true).
clause(2, field(balanced_loam, 45, 80, 0.12, 110), true).
clause(3, field(sandy_high, 30, 150, 0.35, 105), true).
clause(4, field(clay_surplus, 70, 90, 0.08, 120), true).
clause(5,
       total_n(var('F'), var('Total')),
       (field(var('F'), var('Soil'), var('Fert'), anonymous(1), anonymous(2)),
        var('Total') is var('Soil') + var('Fert'))).
clause(6,
       available_n(var('F'), var('Avail')),
       (total_n(var('F'), var('Total')),
        field(var('F'), anonymous(1), anonymous(2), var('Loss'), anonymous(3)),
        var('Retained') is 1.0 - var('Loss'),
        var('Avail') is var('Total') * var('Retained'))).
clause(7,
       surplus_n(var('F'), var('Surplus')),
       (available_n(var('F'), var('Avail')),
        field(var('F'), anonymous(1), anonymous(2), anonymous(3), var('Demand')),
        var('Avail') > var('Demand'),
        var('Surplus') is var('Avail') - var('Demand'))).
clause(8,
       surplus_n(var('F'), 0.0),
       (available_n(var('F'), var('Avail')),
        field(var('F'), anonymous(1), anonymous(2), anonymous(3), var('Demand')),
        var('Avail') =< var('Demand'))).
clause(9,
       deficit_n(var('F'), var('Deficit')),
       (available_n(var('F'), var('Avail')),
        field(var('F'), anonymous(1), anonymous(2), anonymous(3), var('Demand')),
        var('Avail') < var('Demand'),
        var('Deficit') is var('Demand') - var('Avail'))).
clause(10,
       deficit_n(var('F'), 0.0),
       (available_n(var('F'), var('Avail')),
        field(var('F'), anonymous(1), anonymous(2), anonymous(3), var('Demand')),
        var('Avail') >= var('Demand'))).
clause(11,
       leaching_index(var('F'), var('Index')),
       (surplus_n(var('F'), var('Surplus')),
        field(var('F'), anonymous(1), anonymous(2), var('Loss'), anonymous(3)),
        var('Index') is var('Surplus') * var('Loss'))).
clause(12, status(var('F'), under_supplied), (deficit_n(var('F'), var('D')), var('D') > 10.0)).
clause(13,
       status(var('F'), balanced),
       (deficit_n(var('F'), var('D')),
        surplus_n(var('F'), var('S')),
        var('D') =< 10.0,
        var('S') =< 10.0)).
clause(14, status(var('F'), over_supplied), (surplus_n(var('F'), var('S')), var('S') > 10.0)).
clause(15, availableN_kg_ha(var('F'), var('A')), available_n(var('F'), var('A'))).
clause(16, deficitN_kg_ha(var('F'), var('D')), deficit_n(var('F'), var('D'))).
clause(17, surplusN_kg_ha(var('F'), var('S')), surplus_n(var('F'), var('S'))).
clause(18, leachingIndex(var('F'), var('I')), leaching_index(var('F'), var('I'))).
clause(19,
       highestLeachingRisk(field_nitrogen_balance, sandy_high),
       (leaching_index(sandy_high, var('Sandy')),
        leaching_index(clay_surplus, var('Clay')),
        var('Sandy') > var('Clay'))).

step(status(low_input, under_supplied),
     rule(12),
     ['F' = low_input, 'D' = 51.5],
     [deficit_n(low_input, 51.5), 51.5 > 10.0]).
step(deficit_n(low_input, 51.5),
     rule(9),
     ['F' = low_input, 'Deficit' = 51.5, 'Avail' = 58.5, 'Demand' = 110],
     [available_n(low_input, 58.5),
      field(low_input, 25, 40, 0.1, 110),
      58.5 < 110,
      51.5 is 110 - 58.5]).
step(available_n(low_input, 58.5),
     rule(6),
     ['F' = low_input, 'Avail' = 58.5, 'Total' = 65, 'Loss' = 0.1, 'Retained' = 0.9],
     [total_n(low_input, 65),
      field(low_input, 25, 40, 0.1, 110),
      0.9 is 1.0 - 0.1,
      58.5 is 65 * 0.9]).
step(total_n(low_input, 65),
     rule(5),
     ['F' = low_input, 'Total' = 65, 'Soil' = 25, 'Fert' = 40],
     [field(low_input, 25, 40, 0.1, 110), 65 is 25 + 40]).
step(field(low_input, 25, 40, 0.1, 110), fact(1), [], []).
step(65 is 25 + 40, builtin, [], []).
step(0.9 is 1.0 - 0.1, builtin, [], []).
step(58.5 is 65 * 0.9, builtin, [], []).
step(58.5 < 110, builtin, [], []).
step(51.5 is 110 - 58.5, builtin, [], []).
step(51.5 > 10.0, builtin, [], []).
step(status(balanced_loam, balanced),
     rule(13),
     ['F' = balanced_loam, 'D' = 0.0, 'S' = 0.0],
     [deficit_n(balanced_loam, 0.0), surplus_n(balanced_loam, 0.0), 0.0 =< 10.0, 0.0 =< 10.0]).
step(deficit_n(balanced_loam, 0.0),
     rule(10),
     ['F' = balanced_loam, 'Avail' = 110.0, 'Demand' = 110],
     [available_n(balanced_loam, 110.0), field(balanced_loam, 45, 80, 0.12, 110), 110.0 >= 110]).
step(available_n(balanced_loam, 110.0),
     rule(6),
     ['F' = balanced_loam, 'Avail' = 110.0, 'Total' = 125, 'Loss' = 0.12, 'Retained' = 0.88],
     [total_n(balanced_loam, 125),
      field(balanced_loam, 45, 80, 0.12, 110),
      0.88 is 1.0 - 0.12,
      110.0 is 125 * 0.88]).
step(total_n(balanced_loam, 125),
     rule(5),
     ['F' = balanced_loam, 'Total' = 125, 'Soil' = 45, 'Fert' = 80],
     [field(balanced_loam, 45, 80, 0.12, 110), 125 is 45 + 80]).
step(field(balanced_loam, 45, 80, 0.12, 110), fact(2), [], []).
step(125 is 45 + 80, builtin, [], []).
step(0.88 is 1.0 - 0.12, builtin, [], []).
step(110.0 is 125 * 0.88, builtin, [], []).
step(110.0 >= 110, builtin, [], []).
step(surplus_n(balanced_loam, 0.0),
     rule(8),
     ['F' = balanced_loam, 'Avail' = 110.0, 'Demand' = 110],
     [available_n(balanced_loam, 110.0), field(balanced_loam, 45, 80, 0.12, 110), 110.0 =< 110]).
step(110.0 =< 110, builtin, [], []).
step(0.0 =< 10.0, builtin, [], []).
step(status(sandy_high, over_supplied),
     rule(14),
     ['F' = sandy_high, 'S' = 12.0],
     [surplus_n(sandy_high, 12.0), 12.0 > 10.0]).
step(surplus_n(sandy_high, 12.0),
     rule(7),
     ['F' = sandy_high, 'Surplus' = 12.0, 'Avail' = 117.0, 'Demand' = 105],
     [available_n(sandy_high, 117.0),
      field(sandy_high, 30, 150, 0.35, 105),
      117.0 > 105,
      12.0 is 117.0 - 105]).
step(available_n(sandy_high, 117.0),
     rule(6),
     ['F' = sandy_high, 'Avail' = 117.0, 'Total' = 180, 'Loss' = 0.35, 'Retained' = 0.65],
     [total_n(sandy_high, 180),
      field(sandy_high, 30, 150, 0.35, 105),
      0.65 is 1.0 - 0.35,
      117.0 is 180 * 0.65]).
step(total_n(sandy_high, 180),
     rule(5),
     ['F' = sandy_high, 'Total' = 180, 'Soil' = 30, 'Fert' = 150],
     [field(sandy_high, 30, 150, 0.35, 105), 180 is 30 + 150]).
step(field(sandy_high, 30, 150, 0.35, 105), fact(3), [], []).
step(180 is 30 + 150, builtin, [], []).
step(0.65 is 1.0 - 0.35, builtin, [], []).
step(117.0 is 180 * 0.65, builtin, [], []).
step(117.0 > 105, builtin, [], []).
step(12.0 is 117.0 - 105, builtin, [], []).
step(12.0 > 10.0, builtin, [], []).
step(status(clay_surplus, over_supplied),
     rule(14),
     ['F' = clay_surplus, 'S' = 27.200000000000017],
     [surplus_n(clay_surplus, 27.200000000000017), 27.200000000000017 > 10.0]).
step(surplus_n(clay_surplus, 27.200000000000017),
     rule(7),
     ['F' = clay_surplus,
      'Surplus' = 27.200000000000017,
      'Avail' = 147.20000000000002,
      'Demand' = 120],
     [available_n(clay_surplus, 147.20000000000002),
      field(clay_surplus, 70, 90, 0.08, 120),
      147.20000000000002 > 120,
      27.200000000000017 is 147.20000000000002 - 120]).
step(available_n(clay_surplus, 147.20000000000002),
     rule(6),
     ['F' = clay_surplus,
      'Avail' = 147.20000000000002,
      'Total' = 160,
      'Loss' = 0.08,
      'Retained' = 0.92],
     [total_n(clay_surplus, 160),
      field(clay_surplus, 70, 90, 0.08, 120),
      0.92 is 1.0 - 0.08,
      147.20000000000002 is 160 * 0.92]).
step(total_n(clay_surplus, 160),
     rule(5),
     ['F' = clay_surplus, 'Total' = 160, 'Soil' = 70, 'Fert' = 90],
     [field(clay_surplus, 70, 90, 0.08, 120), 160 is 70 + 90]).
step(field(clay_surplus, 70, 90, 0.08, 120), fact(4), [], []).
step(160 is 70 + 90, builtin, [], []).
step(0.92 is 1.0 - 0.08, builtin, [], []).
step(147.20000000000002 is 160 * 0.92, builtin, [], []).
step(147.20000000000002 > 120, builtin, [], []).
step(27.200000000000017 is 147.20000000000002 - 120, builtin, [], []).
step(27.200000000000017 > 10.0, builtin, [], []).
step(availableN_kg_ha(low_input, 58.5),
     rule(15),
     ['F' = low_input, 'A' = 58.5],
     [available_n(low_input, 58.5)]).
step(availableN_kg_ha(balanced_loam, 110.0),
     rule(15),
     ['F' = balanced_loam, 'A' = 110.0],
     [available_n(balanced_loam, 110.0)]).
step(availableN_kg_ha(sandy_high, 117.0),
     rule(15),
     ['F' = sandy_high, 'A' = 117.0],
     [available_n(sandy_high, 117.0)]).
step(availableN_kg_ha(clay_surplus, 147.20000000000002),
     rule(15),
     ['F' = clay_surplus, 'A' = 147.20000000000002],
     [available_n(clay_surplus, 147.20000000000002)]).
step(deficitN_kg_ha(low_input, 51.5),
     rule(16),
     ['F' = low_input, 'D' = 51.5],
     [deficit_n(low_input, 51.5)]).
step(deficitN_kg_ha(balanced_loam, 0.0),
     rule(16),
     ['F' = balanced_loam, 'D' = 0.0],
     [deficit_n(balanced_loam, 0.0)]).
step(deficitN_kg_ha(sandy_high, 0.0),
     rule(16),
     ['F' = sandy_high, 'D' = 0.0],
     [deficit_n(sandy_high, 0.0)]).
step(deficit_n(sandy_high, 0.0),
     rule(10),
     ['F' = sandy_high, 'Avail' = 117.0, 'Demand' = 105],
     [available_n(sandy_high, 117.0), field(sandy_high, 30, 150, 0.35, 105), 117.0 >= 105]).
step(117.0 >= 105, builtin, [], []).
step(deficitN_kg_ha(clay_surplus, 0.0),
     rule(16),
     ['F' = clay_surplus, 'D' = 0.0],
     [deficit_n(clay_surplus, 0.0)]).
step(deficit_n(clay_surplus, 0.0),
     rule(10),
     ['F' = clay_surplus, 'Avail' = 147.20000000000002, 'Demand' = 120],
     [available_n(clay_surplus, 147.20000000000002),
      field(clay_surplus, 70, 90, 0.08, 120),
      147.20000000000002 >= 120]).
step(147.20000000000002 >= 120, builtin, [], []).
step(surplusN_kg_ha(sandy_high, 12.0),
     rule(17),
     ['F' = sandy_high, 'S' = 12.0],
     [surplus_n(sandy_high, 12.0)]).
step(surplusN_kg_ha(clay_surplus, 27.200000000000017),
     rule(17),
     ['F' = clay_surplus, 'S' = 27.200000000000017],
     [surplus_n(clay_surplus, 27.200000000000017)]).
step(surplusN_kg_ha(low_input, 0.0),
     rule(17),
     ['F' = low_input, 'S' = 0.0],
     [surplus_n(low_input, 0.0)]).
step(surplus_n(low_input, 0.0),
     rule(8),
     ['F' = low_input, 'Avail' = 58.5, 'Demand' = 110],
     [available_n(low_input, 58.5), field(low_input, 25, 40, 0.1, 110), 58.5 =< 110]).
step(58.5 =< 110, builtin, [], []).
step(surplusN_kg_ha(balanced_loam, 0.0),
     rule(17),
     ['F' = balanced_loam, 'S' = 0.0],
     [surplus_n(balanced_loam, 0.0)]).
step(leachingIndex(sandy_high, 4.199999999999999),
     rule(18),
     ['F' = sandy_high, 'I' = 4.199999999999999],
     [leaching_index(sandy_high, 4.199999999999999)]).
step(leaching_index(sandy_high, 4.199999999999999),
     rule(11),
     ['F' = sandy_high, 'Index' = 4.199999999999999, 'Surplus' = 12.0, 'Loss' = 0.35],
     [surplus_n(sandy_high, 12.0),
      field(sandy_high, 30, 150, 0.35, 105),
      4.199999999999999 is 12.0 * 0.35]).
step(4.199999999999999 is 12.0 * 0.35, builtin, [], []).
step(leachingIndex(clay_surplus, 2.1760000000000015),
     rule(18),
     ['F' = clay_surplus, 'I' = 2.1760000000000015],
     [leaching_index(clay_surplus, 2.1760000000000015)]).
step(leaching_index(clay_surplus, 2.1760000000000015),
     rule(11),
     ['F' = clay_surplus,
      'Index' = 2.1760000000000015,
      'Surplus' = 27.200000000000017,
      'Loss' = 0.08],
     [surplus_n(clay_surplus, 27.200000000000017),
      field(clay_surplus, 70, 90, 0.08, 120),
      2.1760000000000015 is 27.200000000000017 * 0.08]).
step(2.1760000000000015 is 27.200000000000017 * 0.08, builtin, [], []).
step(leachingIndex(low_input, 0.0),
     rule(18),
     ['F' = low_input, 'I' = 0.0],
     [leaching_index(low_input, 0.0)]).
step(leaching_index(low_input, 0.0),
     rule(11),
     ['F' = low_input, 'Index' = 0.0, 'Surplus' = 0.0, 'Loss' = 0.1],
     [surplus_n(low_input, 0.0), field(low_input, 25, 40, 0.1, 110), 0.0 is 0.0 * 0.1]).
step(0.0 is 0.0 * 0.1, builtin, [], []).
step(leachingIndex(balanced_loam, 0.0),
     rule(18),
     ['F' = balanced_loam, 'I' = 0.0],
     [leaching_index(balanced_loam, 0.0)]).
step(leaching_index(balanced_loam, 0.0),
     rule(11),
     ['F' = balanced_loam, 'Index' = 0.0, 'Surplus' = 0.0, 'Loss' = 0.12],
     [surplus_n(balanced_loam, 0.0), field(balanced_loam, 45, 80, 0.12, 110), 0.0 is 0.0 * 0.12]).
step(0.0 is 0.0 * 0.12, builtin, [], []).
step(highestLeachingRisk(field_nitrogen_balance, sandy_high),
     rule(19),
     ['Sandy' = 4.199999999999999, 'Clay' = 2.1760000000000015],
     [leaching_index(sandy_high, 4.199999999999999),
      leaching_index(clay_surplus, 2.1760000000000015),
      4.199999999999999 > 2.1760000000000015]).
step(4.199999999999999 > 2.1760000000000015, builtin, [], []).
