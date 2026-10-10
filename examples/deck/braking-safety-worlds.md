# Braking safety in alternative worlds

## Can the car stop in time, and does the answer depend on the model?

Four road scenarios are judged by four different stopping-distance models. The
same rules classify each scenario as safe or risky in each model, so you can
see exactly where a simplified model is optimistic. This is a demonstration of
model comparison, not a real safety calculator.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=braking-safety-worlds) ·
[Source](../braking-safety-worlds.pl)

---

# The question

A car at speed *v* on a road with friction *μ* has a certain distance
available before an obstacle. Does it stop in time?

The answer depends on how stopping distance is modelled. Each model is a
**world**:

- `w0`: physics, including one second of reaction time;
- `w1`: braking only, no reaction time;
- `w2`: a naive rule that assumes a dry road;
- `w3`: the physics model with a 1.5 safety factor.

---

# Scenarios and the physics world

```prolog
scenario(city_dry, 13.9, 0.8, 40.0).
scenario(highway_dry_short_gap, 27.8, 0.8, 60.0).
scenario(city_wet, 13.9, 0.4, 40.0).
scenario(city_ice, 13.9, 0.2, 30.0).

stop_distance(Scenario, w0, Distance) :-
  scenario(Scenario, V, Mu, _Avail),
  (Reaction is V * 1.0),
  (V2 is V ** 2.0),
  (M2 is Mu * 2.0),
  (Denom is M2 * 9.8),
  (Braking is V2 / Denom),
  (Distance is Reaction + Braking).
```

Each scenario gives speed in m/s, friction, and the available distance in
meters. In `w0`, stopping distance is reaction distance plus *v²/(2μg)*.

---

# Safe and risky

```prolog
safe_in_world(Scenario, World) :-
  scenario(Scenario, _V, _Mu, Avail),
  stop_distance(Scenario, World, Distance),
  (Distance =< Avail).

risky_in_world(Scenario, World) :-
  scenario(Scenario, _V, _Mu, Avail),
  stop_distance(Scenario, World, Distance),
  (Distance > Avail).
```

The classification rules don't know which world they are in. Only
`stop_distance/3` differs, so every disagreement between worlds traces back
to one modelling choice.

---

# The answer

```sh
eyeprolog examples/braking-safety-worlds.pl
```

```text
safeInWorld(highway_dry_short_gap, w1).
safeInWorld(highway_dry_short_gap, w2).
riskyInWorld(highway_dry_short_gap, w0).
riskyInWorld(highway_dry_short_gap, w3).
safeInWorld(city_ice, w2).
riskyInWorld(city_ice, w0).
status(braking_safety_worlds, expected_world_pattern).
```

The full output has 18 answers. On the highway with a short gap, the two
simplified worlds say "safe" and the physics world says "risky". On ice, only
the naive dry-road world is fooled.

---

# The reason

```text
step(risky_in_world(highway_dry_short_gap, w0),
     rule(14),
     ['Scenario' = highway_dry_short_gap,
      'World' = w0,
      'Avail' = 60.0,
      'Distance' = 77.08826530612245],
     [scenario(highway_dry_short_gap, 27.8, 0.8, 60.0),
      stop_distance(highway_dry_short_gap, w0, 77.08826530612245),
      77.08826530612245 > 60.0]).
```

At 27.8 m/s (about 100 km/h) the physics model needs 77.1 m to stop, but only
60 m are available. Leaving out the reaction time (`w1`) shrinks the distance
to 48.3 m and hides the danger.

---

# The check

```text
condition('C1', resolution, ok, 55).
condition('C5', re_decision, ok, 46).
trusted(0).
verdict(checked).
```

All 55 rule steps were replayed and all 46 arithmetic steps were recomputed.
Every stopping distance in the proof is checked, not trusted.

---

# Try it

- Give `city_wet` 60 m of room instead of 40. It becomes safe in every world,
  including the cautious `w3`, and `status/2` no longer reports the expected
  pattern.
- Add a fifth world with two seconds of reaction time. Which scenarios change?
- Which single scenario shows that `w2` is the most optimistic world?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 14 and 29.
