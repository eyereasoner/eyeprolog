# Spacecraft battery diagnosis

## Is this battery heading for thermal runaway, and should we act?

A spacecraft battery pack is running hot. This example turns telemetry into
physical quantities, checks them against limits, requires several independent
signs before diagnosing a problem, and requires a second temperature sensor to
agree before recommending action.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=spacecraft-battery-diagnosis) ·
[Source](../spacecraft-battery-diagnosis.pl)

---

# The question

*Thermal runaway* is a battery failure in which heat causes reactions that
release more heat. Catching its precursors early matters, but so does not
reacting to one faulty sensor. When is the evidence strong enough to isolate
and cool the pack?

The values and limits in the example are illustrative, not flight rules.

---

# The telemetry

```prolog
telemetry(bp1, temperature_c, 78.0).
telemetry(bp1, temperature_rise_c_per_min, 4.2).
telemetry(bp1, current_a, 32.0).
telemetry(bp1, internal_resistance_ohm, 0.015625).
telemetry(bp1, cell_delta_v, 0.19).

redundant_telemetry(bp1, temperature_c, 76.0).

safety_limit(max_safe_temperature_c, 60.0).
cooling_capacity_w(bp1, 12.0).
```

Readings from the pack, an independent second temperature channel, and the
limits they are judged against.

---

# Physics, evidence, decision

```prolog
metric(Pack, resistive_heating_w, Heating) :-
  telemetry(Pack, current_a, Current),
  telemetry(Pack, internal_resistance_ohm, Resistance),
  (CurrentSquared is Current * Current),
  (Heating is CurrentSquared * Resistance).

diagnosis(Pack, thermal_runaway_precursor) :-
  over_temperature(Pack),
  rapid_heating(Pack),
  cell_imbalance(Pack),
  heating_exceeds_cooling(Pack).

action(Pack, isolate_and_cool) :-
  diagnosis(Pack, thermal_runaway_precursor),
  corroborated_over_temperature(Pack).
```

Heating follows P = I²R. The diagnosis needs four independent signatures, and
the action additionally needs both temperature channels above the limit. Each
layer is its own predicate, so each shows up separately in the proof.

---

# The answer

```sh
eyeprolog examples/spacecraft-battery-diagnosis.pl
```

```text
metric(bp1, thermal_margin_c, -18.0).
metric(bp1, resistive_heating_w, 16.0).
diagnosis(bp1, thermal_runaway_precursor).
action(bp1, isolate_and_cool).
```

The pack is 18 °C over its limit and generates 16 W of resistive heat
against 12 W of cooling. All four signatures are present, both sensors agree,
and the recommendation is to isolate and cool.

---

# The reason

```text
step(heating_exceeds_cooling(bp1),
     rule(16),
     ['Pack' = bp1, 'Heating' = 16.0, 'Capacity' = 12.0],
     [metric(bp1, resistive_heating_w, 16.0), cooling_capacity_w(bp1, 12.0), 16.0 > 12.0]).
step(corroborated_over_temperature(bp1),
     rule(17),
     ['Pack' = bp1, 'Primary' = 78.0, 'Redundant' = 76.0, 'Maximum' = 60.0],
     [telemetry(bp1, temperature_c, 78.0),
      redundant_telemetry(bp1, temperature_c, 76.0),
```

*(second step shortened.)* Each conclusion names the numbers it used: 16 W
against 12 W, and 78 °C and 76 °C against 60 °C. A reviewer can dispute a
limit without re-deriving the physics.

---

# The check

```text
condition('C1', resolution, ok, 19).
condition('C5', re_decision, ok, 8).
verdict(checked).
```

The 19 rule and fact steps replay against the model, and the 8 arithmetic and
comparison steps are recomputed. Nothing is trusted. What the proof cannot
vouch for is the telemetry itself: the sensors' calibration lies outside the
logic.

---

# Try it

- Set the redundant temperature to `58.0`. The diagnosis stays, but the
  action disappears: one hot sensor is not enough to act.
- Raise the cooling capacity to `20.0`. Now there is no diagnosis at all.
  Which signature failed?
- Add a `metric(Pack, heating_surplus_w, Surplus)` rule for heating minus
  cooling.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
