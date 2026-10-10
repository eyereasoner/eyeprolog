# Orbital transfer design

## Can a spacecraft get from Earth's orbit to Mars's orbit within its fuel budget?

A Hohmann transfer is the classic two-burn route between two circular orbits.
This example derives the transfer orbit, both burns, the total change in
velocity, and the flight time from a handful of physical constants, and then
decides whether the mission fits its budget.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=orbital-transfer-design) ·
[Source](../orbital-transfer-design.pl)

---

# The question

A spacecraft circling the Sun at Earth's distance fires its engine once to
enter an elliptical transfer orbit that touches Mars's orbit, then fires again
to match Mars's circular orbit. Each burn costs **delta-v**, the change in
velocity the engine must provide.

Is the total delta-v within a 6.0 km/s budget, and how long does the trip take?

---

# The mission facts

```prolog
mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0).
mission(mars_hohmann, departureOrbitRadius_km, 149597870.7).
mission(mars_hohmann, arrivalOrbitRadius_km, 227939200.0).
mission(mars_hohmann, deltaVBudget_km_s, 6.0).
```

`centralBodyMu` is the Sun's gravitational parameter; the radii are the
average orbits of Earth and Mars in kilometres.

---

# The physics as rules

```prolog
semi_major_axis(Mission, Axis) :-
  mission(Mission, departureOrbitRadius_km, R1),
  mission(Mission, arrivalOrbitRadius_km, R2),
  (Sum is R1 + R2),
  (Axis is Sum / 2.0).

total_delta_v(Mission, Total) :-
  departure_delta_v(Mission, Depart),
  arrival_delta_v(Mission, Arrive),
  (Total is Depart + Arrive).

within_delta_v_budget(Mission) :-
  total_delta_v(Mission, Total),
  mission(Mission, deltaVBudget_km_s, Budget),
  (Total =< Budget).
```

Each formula is its own named relation: transfer-orbit size, circular and
transfer speeds at each end, the two burns, their sum, and the budget test. The
proof will follow the same structure.

---

# The answer

```sh
eyeprolog examples/orbital-transfer-design.pl
```

```text
transferSemiMajorAxis_km(mars_hohmann, 188768535.35).
departureDeltaV_km_s(mars_hohmann, 2.9446911328430403).
arrivalDeltaV_km_s(mars_hohmann, 2.6488967223855973).
totalDeltaV_km_s(mars_hohmann, 5.5935878552286376).
transferTime_days(mars_hohmann, 258.865826767963).
status(mars_hohmann, feasible_reference_transfer).
reason(mars_hohmann, "total Hohmann transfer delta-v is within the mission budget").
```

About 2.94 km/s to leave, 2.65 km/s to arrive, 5.59 km/s in total, and a trip
of almost 259 days: the transfer fits the budget.

---

# The reason

```text
step(within_delta_v_budget(mars_hohmann),
     rule(16),
     ['Mission' = mars_hohmann, 'Total' = 5.5935878552286376, 'Budget' = 6.0],
     [total_delta_v(mars_hohmann, 5.5935878552286376),
      mission(mars_hohmann, deltaVBudget_km_s, 6.0),
      5.5935878552286376 =< 6.0]).
step(5.5935878552286376 =< 6.0, builtin, [], []).
```

The feasibility verdict rests on three things: the computed total, the budget
fact, and the comparison. The comparison is a built-in step that the checker
recomputes on its own.

---

# The check

```text
condition('C1', resolution, ok, 23).
condition('C5', re_decision, ok, 24).
condition('C7', relevance, ok, 54).
steps(47).
verified(23).
recomputed(24).
trusted(0).
verdict(checked).
```

23 rule and fact steps replay against the program, and all 24 arithmetic
steps are recomputed and agree. The check confirms the derivation under
floating-point arithmetic. It cannot confirm that the constants are right or
that a Hohmann estimate is good enough for a real mission.

---

# Try it

- Lower `deltaVBudget_km_s` to `5.5`. Which answers remain, and which
  disappear?
- Replace the arrival radius with Venus's orbit (`108208000.0` km). Both burns
  come out negative (the spacecraft must slow down), the total is about
  -5.2 km/s, and the mission is still called feasible. Fix the model so that
  it budgets the *magnitude* of each burn.
- Add a rule that reports the margin `Budget - Total`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
