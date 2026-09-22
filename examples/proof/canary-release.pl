% Prolog result format 4
query(1, errorRate(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = canary42, 'X1' = 0.015]).
why(1, ['X0' = canary42, 'X1' = 0.015], [errorRate(canary42, 0.015)]).
query(2, p95Latency_ms(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = canary42, 'X1' = 180.0]).
why(2, ['X0' = canary42, 'X1' = 180.0], [p95Latency_ms(canary42, 180.0)]).
query(3, latencyCheck(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = canary42, 'X1' = ok]).
why(3, ['X0' = canary42, 'X1' = ok], [latencyCheck(canary42, ok)]).
query(4, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = canary42, 'X1' = rollback_recommended]).
why(4, ['X0' = canary42, 'X1' = rollback_recommended], [status(canary42, rollback_recommended)]).
query(5, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = canary42, 'X1' = "canary error rate exceeds the allowed budget"]).
why(5,
    ['X0' = canary42, 'X1' = "canary error rate exceeds the allowed budget"],
    [reason(canary42, "canary error rate exceeds the allowed budget")]).

clause(1, canary(canary42, 5000.0, 75.0, 180.0), true).
clause(2, threshold(canary42, maximum_error_rate, 0.01), true).
clause(3, threshold(canary42, maximum_p95_latency_ms, 200.0), true).
clause(4,
       error_rate(var('Release'), var('Rate')),
       (canary(var('Release'), var('Requests'), var('Errors'), anonymous(1)),
        var('Rate') is var('Errors') / var('Requests'))).
clause(5,
       latency_ok(var('Release')),
       (canary(var('Release'), anonymous(1), anonymous(2), var('P95latency')),
        threshold(var('Release'), maximum_p95_latency_ms, var('Maximum')),
        var('P95latency') < var('Maximum'))).
clause(6,
       error_budget_exceeded(var('Release')),
       (error_rate(var('Release'), var('Rate')),
        threshold(var('Release'), maximum_error_rate, var('Maximum')),
        var('Rate') > var('Maximum'))).
clause(7, rollback_recommended(var('Release')), error_budget_exceeded(var('Release'))).
clause(8, errorRate(var('Release'), var('Rate')), error_rate(var('Release'), var('Rate'))).
clause(9,
       p95Latency_ms(var('Release'), var('P95latency')),
       canary(var('Release'), anonymous(1), anonymous(2), var('P95latency'))).
clause(10, latencyCheck(var('Release'), ok), latency_ok(var('Release'))).
clause(11, status(var('Release'), rollback_recommended), rollback_recommended(var('Release'))).
clause(12,
       reason(var('Release'), "canary error rate exceeds the allowed budget"),
       rollback_recommended(var('Release'))).

step(errorRate(canary42, 0.015),
     rule(8),
     ['Release' = canary42, 'Rate' = 0.015],
     [error_rate(canary42, 0.015)]).
step(error_rate(canary42, 0.015),
     rule(4),
     ['Release' = canary42, 'Rate' = 0.015, 'Requests' = 5000.0, 'Errors' = 75.0],
     [canary(canary42, 5000.0, 75.0, 180.0), 0.015 is 75.0 / 5000.0]).
step(canary(canary42, 5000.0, 75.0, 180.0), fact(1), [], []).
step(0.015 is 75.0 / 5000.0, builtin, [], []).
step(p95Latency_ms(canary42, 180.0),
     rule(9),
     ['Release' = canary42, 'P95latency' = 180.0],
     [canary(canary42, 5000.0, 75.0, 180.0)]).
step(latencyCheck(canary42, ok), rule(10), ['Release' = canary42], [latency_ok(canary42)]).
step(latency_ok(canary42),
     rule(5),
     ['Release' = canary42, 'P95latency' = 180.0, 'Maximum' = 200.0],
     [canary(canary42, 5000.0, 75.0, 180.0),
      threshold(canary42, maximum_p95_latency_ms, 200.0),
      180.0 < 200.0]).
step(threshold(canary42, maximum_p95_latency_ms, 200.0), fact(3), [], []).
step(180.0 < 200.0, builtin, [], []).
step(status(canary42, rollback_recommended),
     rule(11),
     ['Release' = canary42],
     [rollback_recommended(canary42)]).
step(rollback_recommended(canary42),
     rule(7),
     ['Release' = canary42],
     [error_budget_exceeded(canary42)]).
step(error_budget_exceeded(canary42),
     rule(6),
     ['Release' = canary42, 'Rate' = 0.015, 'Maximum' = 0.01],
     [error_rate(canary42, 0.015), threshold(canary42, maximum_error_rate, 0.01), 0.015 > 0.01]).
step(threshold(canary42, maximum_error_rate, 0.01), fact(2), [], []).
step(0.015 > 0.01, builtin, [], []).
step(reason(canary42, "canary error rate exceeds the allowed budget"),
     rule(12),
     ['Release' = canary42],
     [rollback_recommended(canary42)]).
