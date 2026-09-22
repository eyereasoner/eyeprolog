% Prolog result format 4
query(1, renewablePower_kW(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = campus_interval_17, 'X1' = 270.0]).
query(2, batteryDispatch_kW(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = campus_interval_17, 'X1' = 240.0]).
query(3, gridImport_kW(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = campus_interval_17, 'X1' = 110.0]).
query(4, reserveAfterDispatch_kW(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = campus_interval_17, 'X1' = 80.0]).
query(5, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = campus_interval_17, 'X1' = stable_dispatch]).
query(6, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6,
       ['X0' = campus_interval_17,
        'X1' = "battery dispatch covers the deficit while preserving reserve and grid contract limits"]).
