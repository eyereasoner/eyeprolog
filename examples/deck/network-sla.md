# Network SLA check

## Does this network path meet its latency promise?

A service-level agreement (SLA) promises that traffic crosses a network path
within 50 ms. EyeProlog adds up the delays of the links on the path, includes
jitter, and decides whether the promise is kept, with every addition in the
proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=network-sla) ·
[Source](../network-sla.pl)

---

# The question

A path runs over three links. Each link adds a known delay, and the path as a
whole adds some jitter (variation in delay). Is the end-to-end latency below
the 50 ms SLA limit?

---

# The facts

```prolog
path(edge_path, [link_a, link_b, link_c]).
link_latency(link_a, 12.0).
link_latency(link_b, 18.0).
link_latency(link_c, 9.0).
jitter(edge_path, 8.0).
sla(edge_path, maximum_latency_ms, 50.0).
```

The path is a list of links, so the same rules work for a path of any length.

---

# The rules

```prolog
latency_sum([], 0.0).
latency_sum([Link|Links], Total) :-
  link_latency(Link, Linklatency),
  latency_sum(Links, Rest),
  (Total is Linklatency + Rest).

end_to_end_latency(Path, Latency) :-
  path(Path, Links),
  latency_sum(Links, Linklatency),
  jitter(Path, Jitter),
  (Latency is Linklatency + Jitter).

sla_compliant(Path) :-
  end_to_end_latency(Path, Latency),
  sla(Path, maximum_latency_ms, Maximum),
  (Latency < Maximum).
```

`latency_sum/2` walks the list of links; the SLA check compares the total with
the limit.

---

# The answer

```sh
eyeprolog examples/network-sla.pl
```

```text
endToEndLatency_ms(edge_path, 47.0).
slaLimit_ms(edge_path, 50.0).
status(edge_path, sla_compliant).
reason(edge_path, "path latency including jitter is below the SLA limit").
```

12 + 18 + 9 = 39 ms of link delay plus 8 ms of jitter gives 47 ms, inside the
50 ms limit.

---

# The reason

```text
step(sla_compliant(edge_path),
     rule(10),
     ['Path' = edge_path, 'Latency' = 47.0, 'Maximum' = 50.0],
     [end_to_end_latency(edge_path, 47.0),
      sla(edge_path, maximum_latency_ms, 50.0),
      47.0 < 50.0]).
```

Compliance rests on three things: the computed latency, the SLA fact, and the
comparison 47.0 < 50.0. Each has its own step.

---

# The check

```text
condition('C1', resolution, ok, 16).
condition('C5', re_decision, ok, 5).
steps(21).
verified(16).
recomputed(5).
trusted(0).
verdict(checked).
```

All rule steps replay, and the four additions and the final comparison are
recomputed. Nothing is trusted.

---

# Try it

- Raise `link_b` to 22.0 ms. What does the program say now, and what *should*
  it say about a violated SLA?
- Add a `status(Path, sla_violated)` rule with its own reason, and test it.
- Add a second path that shares `link_a` and compare the two.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6.
