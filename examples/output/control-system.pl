% Prolog result format 4
query(1, controlSignal(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = actuator1, 'X1' = 39.27346198678276]).
answer(1, ['X0' = actuator2, 'X1' = 26.08]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = actuator1, 'X1' = active]).
answer(2, ['X0' = actuator2, 'X1' = active]).
query(3, normalizedMeasurement(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = input1, 'X1' = 2.23606797749979]).
query(4, log10(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = disturbance1, 'X1' = 4.553470372213121]).
