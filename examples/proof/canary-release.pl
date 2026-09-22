errorRate(canary42, 0.015).
why(
  errorRate(canary42, 0.015),
  step(
    errorRate(canary42, 0.015),
    rule("canary-release.pl", clause(8)),
    ['Release' = canary42, 'Rate' = 0.015],
    [
      step(
        error_rate(canary42, 0.015),
        rule("canary-release.pl", clause(4)),
        ['Release' = canary42, 'Rate' = 0.015, 'Requests' = 5000.0, 'Errors' = 75.0, '_p95latency' = 180.0],
        [
          step(canary(canary42, 5000.0, 75.0, 180.0), fact("canary-release.pl", clause(1)), [], []),
          step(is(0.015, /(75.0, 5000.0)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

p95Latency_ms(canary42, 180.0).
why(
  p95Latency_ms(canary42, 180.0),
  step(
    p95Latency_ms(canary42, 180.0),
    rule("canary-release.pl", clause(9)),
    ['Release' = canary42, 'P95latency' = 180.0, '_requests' = 5000.0, '_errors' = 75.0],
    [
      step(canary(canary42, 5000.0, 75.0, 180.0), fact("canary-release.pl", clause(1)), [], [])
    ]
  )
).

latencyCheck(canary42, ok).
why(
  latencyCheck(canary42, ok),
  step(
    latencyCheck(canary42, ok),
    rule("canary-release.pl", clause(10)),
    ['Release' = canary42],
    [
      step(
        latency_ok(canary42),
        rule("canary-release.pl", clause(5)),
        ['Release' = canary42, '_requests' = 5000.0, '_errors' = 75.0, 'P95latency' = 180.0, 'Maximum' = 200.0],
        [
          step(canary(canary42, 5000.0, 75.0, 180.0), fact("canary-release.pl", clause(1)), [], []),
          step(threshold(canary42, maximum_p95_latency_ms, 200.0), fact("canary-release.pl", clause(3)), [], []),
          step(<(180.0, 200.0), builtin(<, 2), [], [])
        ]
      )
    ]
  )
).

status(canary42, rollback_recommended).
why(
  status(canary42, rollback_recommended),
  step(
    status(canary42, rollback_recommended),
    rule("canary-release.pl", clause(11)),
    ['Release' = canary42],
    [
      step(
        rollback_recommended(canary42),
        rule("canary-release.pl", clause(7)),
        ['Release' = canary42],
        [
          step(
            error_budget_exceeded(canary42),
            rule("canary-release.pl", clause(6)),
            ['Release' = canary42, 'Rate' = 0.015, 'Maximum' = 0.01],
            [
              step(
                error_rate(canary42, 0.015),
                rule("canary-release.pl", clause(4)),
                ['Release' = canary42, 'Rate' = 0.015, 'Requests' = 5000.0, 'Errors' = 75.0, '_p95latency' = 180.0],
                [
                  step(canary(canary42, 5000.0, 75.0, 180.0), fact("canary-release.pl", clause(1)), [], []),
                  step(is(0.015, /(75.0, 5000.0)), builtin(is, 2), [], [])
                ]
              ),
              step(threshold(canary42, maximum_error_rate, 0.01), fact("canary-release.pl", clause(2)), [], []),
              step(>(0.015, 0.01), builtin(>, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

reason(canary42, "canary error rate exceeds the allowed budget").
why(
  reason(canary42, "canary error rate exceeds the allowed budget"),
  step(
    reason(canary42, "canary error rate exceeds the allowed budget"),
    rule("canary-release.pl", clause(12)),
    ['Release' = canary42],
    [
      step(
        rollback_recommended(canary42),
        rule("canary-release.pl", clause(7)),
        ['Release' = canary42],
        [
          step(
            error_budget_exceeded(canary42),
            rule("canary-release.pl", clause(6)),
            ['Release' = canary42, 'Rate' = 0.015, 'Maximum' = 0.01],
            [
              step(
                error_rate(canary42, 0.015),
                rule("canary-release.pl", clause(4)),
                ['Release' = canary42, 'Rate' = 0.015, 'Requests' = 5000.0, 'Errors' = 75.0, '_p95latency' = 180.0],
                [
                  step(canary(canary42, 5000.0, 75.0, 180.0), fact("canary-release.pl", clause(1)), [], []),
                  step(is(0.015, /(75.0, 5000.0)), builtin(is, 2), [], [])
                ]
              ),
              step(threshold(canary42, maximum_error_rate, 0.01), fact("canary-release.pl", clause(2)), [], []),
              step(>(0.015, 0.01), builtin(>, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

