# EV range worlds

## Will the battery last the trip, and under which assumptions?

Four electric-vehicle trips are judged under four modelling worlds, from a
naive per-kilometre estimate to physics plus a safety reserve. The answer is
not one verdict but a pattern: which trips are safe in which worlds, and why
the verdict changes.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=ev-range-worlds) ·
[Source](../ev-range-worlds.pl)

---

# The question

A range estimate depends on its model. Driving fast, cold weather, and heavy
payloads all raise consumption, and a careful planner adds a reserve on top.
Instead of picking one model, the example evaluates every trip in four
**worlds**:

- `w1`: base consumption only;
- `w2`: base adjusted for speed;
- `w0`: speed, temperature, and payload factors;
- `w3`: the `w0` estimate plus a 30% safety reserve.

---

# The data

```prolog
% trip_data(Trip, DistanceKm, SpeedKmh, TemperatureC, PayloadKg, BatteryKWh, BaseKWhPerKm).
trip_data(city_errand, 40, 45, 20, 100, 30, 0.18).
trip_data(winter_highway, 260, 115, -5, 400, 60, 0.20).
trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22).
trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19).

speed_factor(T, 1.20) :- trip_data(T, _, S, _, _, _, _), (S > 100).
speed_factor(T, 1.00) :- trip_data(T, _, S, _, _, _, _), (S =< 100).
```

Each factor is a small rule over the trip's own data, so adding a trip means
adding one fact.

---

# The worlds

```prolog
required_energy(T, w0, E) :-
  base_energy(T, Base),
  speed_factor(T, Sf),
  temperature_factor(T, Tf),
  payload_factor(T, Pf),
  (A is Base * Sf),
  (B is A * Tf),
  (E is B * Pf).

required_energy(T, w3, E) :-
  required_energy(T, w0, W0),
  (E is W0 * 1.30).

risky_in_world(T, W) :-
  trip_data(T, _, _, _, _, Battery, _),
  required_energy(T, W, Required),
  (Required > Battery).
```

One `required_energy/3` clause per world; the safe/risky test is shared.

---

# The answer

```sh
eyeprolog examples/ev-range-worlds.pl
```

```text
riskyInWorld(winter_highway, w2).
riskyInWorld(winter_highway, w0).
riskyInWorld(winter_highway, w3).
riskyInWorld(heavy_delivery, w3).
reason(winter_highway, "cold fast payload trip exceeds battery in physics-aware worlds").
reason(heavy_delivery, "safety buffer turns a physics-safe delivery into a cautious risk").
status(ev_range_worlds, expected_world_pattern).
```

The full output has 19 answers, including 12 `safeInWorld/2` facts. The city
errand and the cold commute are safe everywhere. The winter highway trip is
safe only under the naive model, and the heavy delivery fails only once the
reserve is added.

---

# The reason

```text
step(risky_in_world(winter_highway, w0),
     rule(22),
     ['T' = winter_highway, 'W' = w0, 'Battery' = 60, 'Required' = 77.5008],
     [trip_data(winter_highway, 260, 115, -5, 400, 60, 0.2),
      required_energy(winter_highway, w0, 77.5008),
      77.5008 > 60]).
```

The proof shows the numbers: the physics-aware world needs about 77.5 kWh, and
the battery holds 60. The comparison itself is a recorded built-in step.

---

# The check

```text
condition('C1', resolution, ok, 71).
condition('C5', re_decision, ok, 41).
condition('C7', relevance, ok, 131).
verdict(checked).
```

The checker replays 71 rule steps and recomputes all 41 arithmetic and
comparison steps itself. Every number in the proof is re-derived, so nothing
is taken on trust.

---

# Try it

- Raise the winter highway battery from 60 to 80 kWh. In which worlds does the
  trip become safe?
- Add a fifth world with a 10% reserve instead of 30%. Does the heavy delivery
  survive it?
- Add a trip of your own and predict its pattern across the four worlds before
  running it.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 14 and 29.
