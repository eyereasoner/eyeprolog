# Leg length discrepancy measurement

## Are this patient's legs measurably different in length?

Four landmarks are marked on an X-ray. From their coordinates, a chain of
geometric rules projects the knee points, computes each leg's length, and
raises an alarm when the difference exceeds a clinical threshold. The proof
shows every arithmetic step from coordinates to alarm.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=lldm) ·
[Source](../lldm.pl)

---

# The question

A leg length discrepancy (LLD) is a difference between the lengths of the two
legs. Small differences are normal; larger ones can call for treatment. Given
measured landmark positions for measurement `meas47`, are the legs different
by more than 1.25 cm, and if so, by how much?

---

# The measurement

```prolog
measurement(meas47).

% measured landmark coordinates, in centimetres
val(meas47, p1xCm, 10.1).
val(meas47, p1yCm, 7.8).
val(meas47, p2xCm, 45.1).
val(meas47, p2yCm, 5.6).
val(meas47, p3xCm, 3.6).
val(meas47, p3yCm, 29.8).
val(meas47, p4xCm, 54.7).
val(meas47, p4yCm, 28.5).

% threshold used by the alarm rule, in centimetres
threshold(meas47, lld_alarm_threshold_cm, 1.25).
```

All raw values and every derived quantity live in one relation,
`val(Measurement, Name, Value)`.

---

# The geometry

```prolog
val(M, d53Cm, Z) :- measurement(M), val(M, ssd53Cm2, X), (Z is X ** 0.5).
val(M, d64Cm, Z) :- measurement(M), val(M, ssd64Cm2, X), (Z is X ** 0.5).
val(M, dCm, Z) :- measurement(M), val(M, d53Cm, X), val(M, d64Cm, Y), (Z is X - Y).

type(M, lld_alarm) :- measurement(M), val(M, dCm, D), threshold(M, lld_alarm_threshold_cm, T), (Negt is 0 - T), (D < Negt).
type(M, lld_alarm) :- measurement(M), val(M, dCm, D), threshold(M, lld_alarm_threshold_cm, T), (D > T).
```

About thirty `val/3` rules build up from coordinate differences to projected
knee points (`p5`, `p6`) and then to the two leg lengths as Euclidean
distances. The alarm fires when the difference is below minus the threshold
or above it.

---

# The answer

```sh
eyeprolog examples/lldm.pl
```

```text
type(meas47, lld_alarm).
lld_left_length_cm(meas47, 21.548900464617255).
lld_right_length_cm(meas47, 23.45713444515475).
lld_discrepancy_cm(meas47, -1.9082339805374957).
lld_threshold_cm(meas47, 1.25).
lld_reason(meas47, "discrepancy below negative threshold").
```

The left leg measures about 21.55 cm and the right about 23.46 cm in this
image. The difference, -1.91 cm, is beyond the 1.25 cm threshold, so the
alarm fires.

---

# The reason

```sh
eyeprolog --proof examples/lldm.pl
```

```text
step(type(meas47, lld_alarm),
     rule(49),
     ['M' = meas47, 'D' = -1.9082339805374957, 'T' = 1.25, 'Negt' = -1.25],
     [measurement(meas47),
      val(meas47, dCm, -1.9082339805374957),
      threshold(meas47, lld_alarm_threshold_cm, 1.25),
      -1.25 is 0 - 1.25,
      -1.9082339805374957 < -1.25]).
```

The alarm holds by the first alarm rule: the discrepancy, -1.908…, is less
than the negated threshold, -1.25. The step for `dCm` in turn cites the two
leg lengths and their subtraction, and so on down to the measured
coordinates.

---

# The check

```text
condition('C1', resolution, ok, 53).
condition('C5', re_decision, ok, 39).
condition('C7', relevance, ok, 98).
recomputed(39).
trusted(0).
verdict(checked).
```

The proof has 92 steps. Fifty-three rule and fact steps replay against the
program, and all 39 arithmetic steps (subtractions, products, squares, square
roots, comparisons) are recomputed by the checker. Nothing is trusted: every
number in the alarm can be traced back to a measured coordinate.

---

# Try it

- Raise the threshold to 2.0. The alarm no longer fires, and because every
  output relation depends on the alarm, the run prints nothing at all.
- Swap the left and right landmarks (`p1`↔`p2`, `p3`↔`p4`, `p5`↔`p6`). The
  discrepancy becomes +1.91 cm, the alarm fires through the second rule, and
  the reason changes to "discrepancy above positive threshold".
- Move one landmark by a millimetre and see how far the discrepancy moves.
  How sensitive is the alarm to measurement error?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 14 and 29.
