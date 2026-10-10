# Control system

## What signal should each actuator receive?

A small controller combines sensor measurements, a target value, and three
classic ingredients of control engineering: proportional gain, feedforward
compensation, and nonlinear feedback. Each intermediate quantity is its own
named step, so the proof shows how every signal was computed.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=control-system) ·
[Source](../control-system.pl)

---

# The question

Two actuators need a control signal.

- Actuator 1 is driven by a normalized input, corrected for a measured
  disturbance (feedforward).
- Actuator 2 is driven by the gap between an output and its target (feedback),
  with a nonlinear term.

What are the two signals, and can we see exactly how each was derived?

---

# Measurements, observations, targets

```prolog
measurement(input1, [6, 11]).
measurement(input2, true).
measurement(disturbance1, 35766).
measurement(output2, 24).

observation(state3, 22).

target(output2, 29).
```

Plain facts: a two-reading input, a switch, a disturbance, an output and its
target of 29.

---

# Normalizing and compensating

```prolog
measurement_normalized(I, M) :-
  measurement(I, [M1, M2]),
  (M1 < M2),
  (Delta is M2 - M1),
  (M is Delta ** 0.5).

control(actuator1, C) :-
  measurement_normalized(input1, M1),
  measurement(input2, true),
  measurement(disturbance1, D1),
  (Proportional is M1 * 19.6),
  numeric_log10(D1, Compensation),
  (C is Proportional - Compensation).
```

The input pair is normalized to √(11 − 6) = √5. Actuator 1 multiplies that by a
gain of 19.6 and subtracts log₁₀ of the disturbance as compensation.

---

# Feedback with a nonlinear term

```prolog
control(actuator2, C) :-
  observation(state3, P3),
  measurement(output2, M4),
  target(output2, T2),
  (Error is T2 - M4),
  (Differentialerror is P3 - M4),
  (Proportional is 5.8 * Error),
  (Nonlinearfactor is 7.3 / Error),
  (Differential is Nonlinearfactor * Differentialerror),
  (C is Proportional + Differential).
```

The error is target minus output, 29 − 24 = 5. The proportional part scales
it, and a nonlinear factor 7.3 / error weights the difference between an
observed state and the output.

---

# The answer

```sh
eyeprolog examples/control-system.pl
```

```text
controlSignal(actuator1, 39.27346198678276).
controlSignal(actuator2, 26.08).
status(actuator1, active).
status(actuator2, active).
normalizedMeasurement(input1, 2.23606797749979).
log10(disturbance1, 4.553470372213121).
```

The two signals, the status of each actuator, and two intermediate quantities
are all reported.

---

# The reason

```sh
eyeprolog --proof examples/control-system.pl
```

```text
step(control(actuator2, 26.08),
     rule(15),
     ['C' = 26.08,
      'P3' = 22,
      'M4' = 24,
      'T2' = 29,
      'Error' = 5,
      'Differentialerror' = -2,
      'Proportional' = 29.0,
      'Nonlinearfactor' = 1.46,
      'Differential' = -2.92],
```

The bindings read like a worked calculation: an error of 5 gives a
proportional part of 29.0, the nonlinear factor is 7.3 / 5 = 1.46, and the
differential term is 1.46 × (22 − 24) = −2.92. So 29.0 − 2.92 = 26.08.

---

# The check

```sh
eyeprolog --proof examples/control-system.pl > control-system.why.pl
eyeprolog --check-proof control-system.why.pl examples/control-system.pl
```

```text
condition('C1', resolution, ok, 16).
condition('C5', re_decision, ok, 14).
steps(30).
trusted(0).
verdict(checked).
```

Of the 30 steps, 16 replay program clauses and 14 are arithmetic the checker
recomputes itself. Nothing is taken on trust.

---

# Try it

- Set the target to `target(output2, 24).` The error becomes 0, and the run
  stops with `evaluation_error(zero_divisor)` from the nonlinear term. What
  should a real controller do at zero error?
- Swap the input readings to `measurement(input1, [11, 6]).` The second
  normalization clause now applies, the normalized value becomes 11, and
  actuator 1 gets a much larger signal (about 211).
- Change the gain 19.6 and predict the new actuator 1 signal before running.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 6 and 14.
