% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = wall1, 'X1' = conduction_heat_loss]).
query(2, temperatureDifference_K(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = wall1, 'X1' = 25.0]).
query(3, thermalResistance_K_W(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = wall1, 'X1' = 0.020833333333333332]).
query(4, heatLoss_W(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = wall1, 'X1' = 1200.0]).
query(5, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = wall1, 'X1' = high_heat_loss]).
