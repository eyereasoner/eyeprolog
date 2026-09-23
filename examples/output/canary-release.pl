errorRate(canary42, 0.015).
p95Latency_ms(canary42, 180.0).
latencyCheck(canary42, ok).
status(canary42, rollback_recommended).
reason(canary42, "canary error rate exceeds the allowed budget").
