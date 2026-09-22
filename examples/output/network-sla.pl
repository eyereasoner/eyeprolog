% Prolog result format 4
query(1, endToEndLatency_ms(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = edge_path, 'X1' = 47.0]).
query(2, slaLimit_ms(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = edge_path, 'X1' = 50.0]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = edge_path, 'X1' = sla_compliant]).
query(4, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = edge_path, 'X1' = "path latency including jitter is below the SLA limit"]).
