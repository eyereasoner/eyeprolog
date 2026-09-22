% Prolog result format 4
query(1, errorRate(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = canary42, 'X1' = 0.015]).
query(2, p95Latency_ms(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = canary42, 'X1' = 180.0]).
query(3, latencyCheck(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = canary42, 'X1' = ok]).
query(4, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = canary42, 'X1' = rollback_recommended]).
query(5, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = canary42, 'X1' = "canary error rate exceeds the allowed budget"]).
