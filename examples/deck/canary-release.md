# Canary release

## Should this release be rolled back?

A new release first goes to a small slice of traffic: the canary. Its latency
looks fine, but its error rate is over budget. EyeProlog derives the rollback
decision and shows the exact comparison that triggered it.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=canary-release) ·
[Source](../canary-release.pl)

---

# The question

A canary release is judged against an error budget (at most 1% failed
requests) and a latency target (95th-percentile response time below 200 ms).
Good latency does not excuse too many errors. Should `canary42` be rolled
back?

---

# The data

```prolog
canary(canary42, 5000.0, 75.0, 180.0).
threshold(canary42, maximum_error_rate, 0.01).
threshold(canary42, maximum_p95_latency_ms, 200.0).
```

5000 requests, 75 errors, and a p95 latency of 180 ms.

---

# The rules

```prolog
error_rate(Release, Rate) :-
  canary(Release, Requests, Errors, _p95latency),
  (Rate is Errors / Requests).

error_budget_exceeded(Release) :-
  error_rate(Release, Rate),
  threshold(Release, maximum_error_rate, Maximum),
  (Rate > Maximum).

rollback_recommended(Release) :-
  error_budget_exceeded(Release).
```

Latency and errors are checked by separate rules, so the reason for a
rollback can name the guard that failed.

---

# The answer

```sh
eyeprolog examples/canary-release.pl
```

```text
errorRate(canary42, 0.015).
p95Latency_ms(canary42, 180.0).
latencyCheck(canary42, ok).
status(canary42, rollback_recommended).
reason(canary42, "canary error rate exceeds the allowed budget").
```

---

# The reason

```text
step(error_budget_exceeded(canary42),
     rule(6),
     ['Release' = canary42, 'Rate' = 0.015, 'Maximum' = 0.01],
     [error_rate(canary42, 0.015), threshold(canary42, maximum_error_rate, 0.01), 0.015 > 0.01]).
step(error_rate(canary42, 0.015),
     rule(4),
     ['Release' = canary42, 'Rate' = 0.015, 'Requests' = 5000.0, 'Errors' = 75.0],
     [canary(canary42, 5000.0, 75.0, 180.0), 0.015 is 75.0 / 5000.0]).
```

75 errors in 5000 requests is 1.5%, and 1.5% exceeds the 1% budget. That one
comparison is the whole case for rolling back.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C5', re_decision, ok, 3).
trusted(0).
verdict(checked).
```

The 12 rule steps and 3 arithmetic steps were all replayed; nothing is
trusted.

---

# Try it

- Set the canary to 40 errors and a p95 latency of 230 ms. The error rate
  drops to 0.008, the latency check disappears, and no rollback is recommended:
  this policy never rolls back on latency alone. Is that what you want?
- Add a `rollback_recommended/1` clause for latency and give it its own
  `reason/2`.
- At exactly 50 errors the rate is 0.01. Should the budget comparison be `>`
  or `>=`?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 12 and 14.
