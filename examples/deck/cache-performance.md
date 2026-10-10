# Cache performance

## Is the cache actually earning its keep?

A service cache answers most requests quickly and sends the rest to a slower
backend. From the hit and miss counts and their latencies, EyeProlog computes
the hit rate and the average response time, and decides whether the cache
meets its operational targets.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=cache-performance) ·
[Source](../cache-performance.pl)

---

# The question

A cache **hit** is served from memory in 5 ms; a **miss** goes to the backend
and takes 80 ms. The cache counts as effective when more than 80% of requests
hit *and* the average latency stays below 20 ms.

---

# The data

```prolog
cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0).
threshold(api_cache, minimum_hit_rate, 0.80).
threshold(api_cache, maximum_average_latency_ms, 20.0).
```

8600 hits and 1400 misses, with the targets stored as data rather than buried
in the rules.

---

# The rules

```prolog
average_latency(Cache, Average) :-
  cache_sample(Cache, Hits, Misses, Hitlatency, Misslatency),
  (Hitcost is Hits * Hitlatency),
  (Misscost is Misses * Misslatency),
  (Totalcost is Hitcost + Misscost),
  total_requests(Cache, Total),
  (Average is Totalcost / Total).

cache_effective(Cache) :-
  hit_rate(Cache, Rate),
  threshold(Cache, minimum_hit_rate, Minimumrate),
  (Rate > Minimumrate),
  average_latency(Cache, Average),
  threshold(Cache, maximum_average_latency_ms, Maximumlatency),
  (Average < Maximumlatency).
```

The average is weighted: total time spent on hits and misses, divided by the
number of requests. Both targets must hold for the cache to count as
effective.

---

# The answer

```sh
eyeprolog examples/cache-performance.pl
```

```text
hitRate(api_cache, 0.86).
averageLatency_ms(api_cache, 15.5).
status(api_cache, cache_effective).
reason(api_cache, "hit rate is above target and average latency is below limit").
```

---

# The reason

```text
step(average_latency(api_cache, 15.5),
     rule(6),
     ['Cache' = api_cache,
      'Average' = 15.5,
      'Hits' = 8600.0,
      'Misses' = 1400.0,
      'Hitlatency' = 5.0,
      'Misslatency' = 80.0,
      'Hitcost' = 43000.0,
      'Misscost' = 112000.0,
      'Totalcost' = 155000.0,
      'Total' = 10000.0],
     [cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0),
      43000.0 is 8600.0 * 5.0,
      112000.0 is 1400.0 * 80.0,
      155000.0 is 43000.0 + 112000.0,
      total_requests(api_cache, 10000.0),
      15.5 is 155000.0 / 10000.0]).
```

Hits cost 43 seconds in total, misses 112 seconds: 155 seconds over 10,000
requests is 15.5 ms each. The few misses dominate the total.

---

# The check

```text
condition('C1', resolution, ok, 11).
condition('C5', re_decision, ok, 8).
trusted(0).
verdict(checked).
```

All 11 rule steps were replayed and all 8 calculations recomputed.

---

# Try it

- Change the sample to 8000 hits and 2000 misses. The hit rate is exactly 0.8
  and the average exactly 20.0 ms, so both strict comparisons fail and no
  status is derived.
- Make the miss latency 120 ms. Which target fails first?
- Add a rule that reports which target was missed.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
