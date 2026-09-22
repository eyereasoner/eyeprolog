% Prolog result format 4
query(1, context_shape(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 10).
answer(1, ['X0' = msg_ok, 'X1' = heartbeat, 'X2' = 0]).
answer(1, ['X0' = msg_ok, 'X1' = source, 'X2' = 1]).
answer(1, ['X0' = msg_ok, 'X1' = temperature, 'X2' = 2]).
answer(1, ['X0' = msg_ok, 'X1' = gps, 'X2' = 3]).
answer(1, ['X0' = msg_ok, 'X1' = signature, 'X2' = 4]).
answer(1, ['X0' = msg_bad, 'X1' = heartbeat, 'X2' = 0]).
answer(1, ['X0' = msg_bad, 'X1' = source, 'X2' = 1]).
answer(1, ['X0' = msg_bad, 'X1' = temperature, 'X2' = 2]).
answer(1, ['X0' = msg_bad, 'X1' = gps, 'X2' = 2]).
answer(1, ['X0' = msg_bad, 'X1' = tampered, 'X2' = 1]).
query(2, schema_violation(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 2).
answer(2, ['X0' = msg_bad, 'X1' = gps, 'X2' = 2]).
answer(2, ['X0' = msg_bad, 'X1' = tampered, 'X2' = 1]).
