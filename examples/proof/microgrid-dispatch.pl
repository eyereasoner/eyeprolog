renewablePower_kW(campus_interval_17, 270.0).
batteryDispatch_kW(campus_interval_17, 240.0).
gridImport_kW(campus_interval_17, 110.0).
reserveAfterDispatch_kW(campus_interval_17, 80.0).
status(campus_interval_17, stable_dispatch).
reason(campus_interval_17, "battery dispatch covers the deficit while preserving reserve and grid contract limits").

clause(2, load_kW(campus_interval_17, 620.0), true).
clause(3, solar_kW(campus_interval_17, 180.0), true).
clause(4, wind_kW(campus_interval_17, 90.0), true).
clause(5, battery_max_discharge_kW(campus_interval_17, 320.0), true).
clause(6, required_battery_reserve_kW(campus_interval_17, 80.0), true).
clause(7, grid_contract_limit_kW(campus_interval_17, 150.0), true).
clause(8,
       renewable_kW(var('Site'), var('Renewable')),
       (solar_kW(var('Site'), var('Solar')),
        wind_kW(var('Site'), var('Wind')),
        var('Renewable') is var('Solar') + var('Wind'))).
clause(9,
       net_deficit_kW(var('Site'), var('Deficit')),
       (load_kW(var('Site'), var('Load')),
        renewable_kW(var('Site'), var('Renewable')),
        var('Deficit') is var('Load') - var('Renewable'))).
clause(10,
       reserve_aware_battery_limit_kW(var('Site'), var('Limit')),
       (battery_max_discharge_kW(var('Site'), var('Maxdischarge')),
        required_battery_reserve_kW(var('Site'), var('Reserve')),
        var('Limit') is var('Maxdischarge') - var('Reserve'))).
clause(11,
       battery_dispatch_kW(var('Site'), var('Dispatch')),
       (net_deficit_kW(var('Site'), var('Deficit')),
        reserve_aware_battery_limit_kW(var('Site'), var('Limit')),
        (var('Deficit') =< var('Limit') -> var('Dispatch') = var('Deficit') ; var('Dispatch') = var('Limit')))).
clause(12,
       grid_import_kW(var('Site'), var('Import')),
       (net_deficit_kW(var('Site'), var('Deficit')),
        battery_dispatch_kW(var('Site'), var('Dispatch')),
        var('Import') is var('Deficit') - var('Dispatch'))).
clause(13,
       battery_reserve_after_dispatch_kW(var('Site'), var('Reserveleft')),
       (battery_max_discharge_kW(var('Site'), var('Maxdischarge')),
        battery_dispatch_kW(var('Site'), var('Dispatch')),
        var('Reserveleft') is var('Maxdischarge') - var('Dispatch'))).
clause(14,
       contract_ok(var('Site')),
       (grid_import_kW(var('Site'), var('Import')),
        grid_contract_limit_kW(var('Site'), var('Limit')),
        var('Import') =< var('Limit'))).
clause(15,
       reserve_ok(var('Site')),
       (battery_reserve_after_dispatch_kW(var('Site'), var('Reserveleft')),
        required_battery_reserve_kW(var('Site'), var('Required')),
        var('Reserveleft') >= var('Required'))).
clause(16, stable_dispatch(var('Site')), (contract_ok(var('Site')), reserve_ok(var('Site')))).
clause(17,
       renewablePower_kW(var('Site'), var('Renewable')),
       renewable_kW(var('Site'), var('Renewable'))).
clause(18,
       batteryDispatch_kW(var('Site'), var('Dispatch')),
       battery_dispatch_kW(var('Site'), var('Dispatch'))).
clause(19,
       gridImport_kW(var('Site'), var('Import')),
       grid_import_kW(var('Site'), var('Import'))).
clause(20,
       reserveAfterDispatch_kW(var('Site'), var('Reserveleft')),
       battery_reserve_after_dispatch_kW(var('Site'), var('Reserveleft'))).
clause(21, status(var('Site'), stable_dispatch), stable_dispatch(var('Site'))).
clause(22,
       reason(var('Site'), "battery dispatch covers the deficit while preserving reserve and grid contract limits"),
       stable_dispatch(var('Site'))).

step(renewablePower_kW(campus_interval_17, 270.0),
     rule(17),
     ['Site' = campus_interval_17, 'Renewable' = 270.0],
     [renewable_kW(campus_interval_17, 270.0)]).
step(renewable_kW(campus_interval_17, 270.0),
     rule(8),
     ['Site' = campus_interval_17, 'Renewable' = 270.0, 'Solar' = 180.0, 'Wind' = 90.0],
     [solar_kW(campus_interval_17, 180.0),
      wind_kW(campus_interval_17, 90.0),
      270.0 is 180.0 + 90.0]).
step(solar_kW(campus_interval_17, 180.0), fact(3), [], []).
step(wind_kW(campus_interval_17, 90.0), fact(4), [], []).
step(270.0 is 180.0 + 90.0, builtin, [], []).
step(batteryDispatch_kW(campus_interval_17, 240.0),
     rule(18),
     ['Site' = campus_interval_17, 'Dispatch' = 240.0],
     [battery_dispatch_kW(campus_interval_17, 240.0)]).
step(battery_dispatch_kW(campus_interval_17, 240.0),
     rule(11),
     ['Site' = campus_interval_17, 'Dispatch' = 240.0, 'Deficit' = 350.0, 'Limit' = 240.0],
     [net_deficit_kW(campus_interval_17, 350.0),
      reserve_aware_battery_limit_kW(campus_interval_17, 240.0),
      (350.0 =< 240.0 -> 240.0 = 350.0 ; 240.0 = 240.0)]).
step(net_deficit_kW(campus_interval_17, 350.0),
     rule(9),
     ['Site' = campus_interval_17, 'Deficit' = 350.0, 'Load' = 620.0, 'Renewable' = 270.0],
     [load_kW(campus_interval_17, 620.0),
      renewable_kW(campus_interval_17, 270.0),
      350.0 is 620.0 - 270.0]).
step(load_kW(campus_interval_17, 620.0), fact(2), [], []).
step(350.0 is 620.0 - 270.0, builtin, [], []).
step(reserve_aware_battery_limit_kW(campus_interval_17, 240.0),
     rule(10),
     ['Site' = campus_interval_17, 'Limit' = 240.0, 'Maxdischarge' = 320.0, 'Reserve' = 80.0],
     [battery_max_discharge_kW(campus_interval_17, 320.0),
      required_battery_reserve_kW(campus_interval_17, 80.0),
      240.0 is 320.0 - 80.0]).
step(battery_max_discharge_kW(campus_interval_17, 320.0), fact(5), [], []).
step(required_battery_reserve_kW(campus_interval_17, 80.0), fact(6), [], []).
step(240.0 is 320.0 - 80.0, builtin, [], []).
step((350.0 =< 240.0 -> 240.0 = 350.0 ; 240.0 = 240.0), builtin, [], []).
step(gridImport_kW(campus_interval_17, 110.0),
     rule(19),
     ['Site' = campus_interval_17, 'Import' = 110.0],
     [grid_import_kW(campus_interval_17, 110.0)]).
step(grid_import_kW(campus_interval_17, 110.0),
     rule(12),
     ['Site' = campus_interval_17, 'Import' = 110.0, 'Deficit' = 350.0, 'Dispatch' = 240.0],
     [net_deficit_kW(campus_interval_17, 350.0),
      battery_dispatch_kW(campus_interval_17, 240.0),
      110.0 is 350.0 - 240.0]).
step(110.0 is 350.0 - 240.0, builtin, [], []).
step(reserveAfterDispatch_kW(campus_interval_17, 80.0),
     rule(20),
     ['Site' = campus_interval_17, 'Reserveleft' = 80.0],
     [battery_reserve_after_dispatch_kW(campus_interval_17, 80.0)]).
step(battery_reserve_after_dispatch_kW(campus_interval_17, 80.0),
     rule(13),
     ['Site' = campus_interval_17,
      'Reserveleft' = 80.0,
      'Maxdischarge' = 320.0,
      'Dispatch' = 240.0],
     [battery_max_discharge_kW(campus_interval_17, 320.0),
      battery_dispatch_kW(campus_interval_17, 240.0),
      80.0 is 320.0 - 240.0]).
step(80.0 is 320.0 - 240.0, builtin, [], []).
step(status(campus_interval_17, stable_dispatch),
     rule(21),
     ['Site' = campus_interval_17],
     [stable_dispatch(campus_interval_17)]).
step(stable_dispatch(campus_interval_17),
     rule(16),
     ['Site' = campus_interval_17],
     [contract_ok(campus_interval_17), reserve_ok(campus_interval_17)]).
step(contract_ok(campus_interval_17),
     rule(14),
     ['Site' = campus_interval_17, 'Import' = 110.0, 'Limit' = 150.0],
     [grid_import_kW(campus_interval_17, 110.0),
      grid_contract_limit_kW(campus_interval_17, 150.0),
      110.0 =< 150.0]).
step(grid_contract_limit_kW(campus_interval_17, 150.0), fact(7), [], []).
step(110.0 =< 150.0, builtin, [], []).
step(reserve_ok(campus_interval_17),
     rule(15),
     ['Site' = campus_interval_17, 'Reserveleft' = 80.0, 'Required' = 80.0],
     [battery_reserve_after_dispatch_kW(campus_interval_17, 80.0),
      required_battery_reserve_kW(campus_interval_17, 80.0),
      80.0 >= 80.0]).
step(80.0 >= 80.0, builtin, [], []).
step(reason(campus_interval_17, "battery dispatch covers the deficit while preserving reserve and grid contract limits"),
     rule(22),
     ['Site' = campus_interval_17],
     [stable_dispatch(campus_interval_17)]).
