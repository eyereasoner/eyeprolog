# Correlating service logs

## Which failures in unstructured logs belong to the same user journey?

Production logs are lines of text. This example parses them with named
captures, turns each line into structured fields, and correlates a failed
login with a denied payment because they share a W3C trace id, user, and IP
address.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=observability-log-correlation) ·
[Source](../observability-log-correlation.pl)

---

# The question

A login fails, and three seconds later a payment is denied. Are these the
same session? Distributed tracing gives each request a *trace id*, carried in
the `traceparent` header. If both events carry the same trace id, user, and
IP, they belong together, and that is worth an alert.

---

# The data

```prolog
log_pattern('^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$').

raw_log(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01').
raw_log(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01').
raw_log(noise, 'healthcheck ok').
```

Three structured lines (two shown) and one noisy health-check line that
should not parse.

---

# The rules

```prolog
parsed_logs([raw(Log, Text)|_], Log, Context) :-
  log_pattern(Pattern),
  matches(Text, Pattern, Context).

captured_field(Log, Name, Value) :-
  parsed(Log, Context),
  context_member(Context, Field),
  (Field =.. [Name, Value]).

trace_alert(User, Traceid, Ip) :-
  parsed_event(Loginlog, 'login_failed', User, Ip, Traceid),
  parsed_event(Paymentlog, 'payment_denied', User, Ip, Traceid),
  Loginlog \= Paymentlog.
```

`matches/3` from `library(strings)` returns the named captures as a comma
term such as `(ts(...), level(warn), ...)`. From then on the rules work on
structure, not text.

---

# The answer

```sh
eyeprolog examples/observability-log-correlation.pl
```

```text
parsed_event(l1, login_failed, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736').
parsed_event(l2, payment_denied, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736').
parsed_event(l3, login_success, bob, '198.51.100.4', aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa).
trace_alert(alice, '4bf92f3577b34da6a3ce929d0e0e4736', '203.0.113.9').
```

These are the last 4 of 28 answers; the first 24 list each captured field of
each parsed line. The health-check line produces nothing, and Alice's two
events raise one trace alert.

---

# The reason

```text
step(trace_alert(alice, '4bf92f3577b34da6a3ce929d0e0e4736', '203.0.113.9'),
     rule(14),
     ['User' = alice,
      'Traceid' = '4bf92f3577b34da6a3ce929d0e0e4736',
      'Ip' = '203.0.113.9',
      'Loginlog' = l1,
      'Paymentlog' = l2],
     [parsed_event(l1, login_failed, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736'),
      parsed_event(l2, payment_denied, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736'),
      l1 \= l2]).
```

The alert names the two log lines it joins. Each `parsed_event/5` in turn
traces back to a pattern match on the raw text.

---

# The check

```text
condition('C1', resolution, ok, 162).
condition('C5', re_decision, ok, 42).
condition('C6', boundary_consistency, ok, 1).
steps(205).
verified(162).
recomputed(42).
trusted(1).
verdict(checked_with_obligations).
```

The regex matches and field decompositions are recomputed (C5). The one
trusted step is the `findall/3` that gathers the batch of raw log lines: the
answer assumes that batch is complete. The checker tested that collection
against the `raw_log/2` facts and found it consistent (C6).

---

# Try it

- Add a `payment_denied` line for Bob with a different trace id. Does an
  alert appear?
- Break the format of `l2` (for example, drop the `ip=` field) and see which
  answers disappear.
- Add a rule that alerts when the two events are less than 10 seconds apart,
  using the captured `ts` field.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 9.
