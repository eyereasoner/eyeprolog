% Prolog result format 4
query(1, pressure_Pa(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = cell1, 'X1' = 100000.0]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = cell1, 'X1' = near_atmospheric]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = cell1, 'X1' = "pressure is inside the one-atmosphere tolerance band"]).
