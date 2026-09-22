% Prolog result format 4
query(1, hitRate(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = api_cache, 'X1' = 0.86]).
query(2, averageLatency_ms(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = api_cache, 'X1' = 15.5]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = api_cache, 'X1' = cache_effective]).
query(4, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4,
       ['X0' = api_cache, 'X1' = "hit rate is above target and average latency is below limit"]).
