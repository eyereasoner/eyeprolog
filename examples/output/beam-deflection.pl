% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = beam1, 'X1' = cantilever_beam]).
query(2, tipDeflection_m(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = beam1, 'X1' = 0.00390625]).
query(3, tipDeflection_mm(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = beam1, 'X1' = 3.90625]).
query(4, limit_mm(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = beam1, 'X1' = 5.0]).
query(5, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = beam1, 'X1' = within_deflection_limit]).
