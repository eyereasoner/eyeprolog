# Pendulum period

## Does a one-metre pendulum swing with a two-second period?

For small swings, a pendulum's period depends only on its length and on
gravity. This example computes the period from the textbook formula, compares
it with a two-second target, and reports whether it is within tolerance,
with every arithmetic step in the proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=pendulum-period) ·
[Source](../pendulum-period.pl)

---

# The question

The period of a simple pendulum, for small oscillations, is
T = 2π √(L / g). With a length of 1 m and gravity chosen as π² m/s² (about
9.87, close to Earth's), the formula should give exactly 2 seconds. Does the
computation agree, within 0.01 s?

---

# The experiment

```prolog
constant(pi, 3.141592653589793).
experiment(pendulum1, length_m, 1.0).
experiment(pendulum1, gravity_m_s2, 9.869604401089358).
limit(pendulum1, target_period_s, 2.0).
limit(pendulum1, tolerance_s, 0.01).
```

Measured quantities, constants, and acceptance limits are separate facts,
each with its unit in its name.

---

# The physics and the policy

```prolog
period(Experiment, Period) :-
  experiment(Experiment, length_m, Length),
  experiment(Experiment, gravity_m_s2, Gravity),
  (Ratio is Length / Gravity),
  (Root is Ratio ** 0.5),
  constant(pi, Pi),
  (Twopi is 2.0 * Pi),
  (Period is Twopi * Root).

period_error(Experiment, Error) :-
  period(Experiment, Period),
  limit(Experiment, target_period_s, Target),
  (Rawerror is Period - Target),
  (Error is abs(Rawerror)).

within_period_tolerance(Experiment) :-
  period_error(Experiment, Error),
  limit(Experiment, tolerance_s, Tolerance),
  (Error < Tolerance).
```

The formula, the error against the target, and the tolerance test are three
separate rules, so a reviewer can dispute one without touching the others.

---

# The answer

```sh
eyeprolog examples/pendulum-period.pl
```

```text
period_s(pendulum1, 2.0).
periodError_s(pendulum1, 0.0).
status(pendulum1, within_period_tolerance).
reason(pendulum1, "small-angle period matches the two-second target").
```

The period comes out as exactly 2.0 in floating point, so the error is 0.0
and the experiment is within tolerance.

---

# The reason

```sh
eyeprolog --proof examples/pendulum-period.pl
```

```text
step(period(pendulum1, 2.0),
     rule(6),
     ['Experiment' = pendulum1,
      'Period' = 2.0,
      'Length' = 1.0,
      'Gravity' = 9.869604401089358,
      'Ratio' = 0.10132118364233778,
      'Root' = 0.3183098861837907,
      'Pi' = 3.141592653589793,
      'Twopi' = 6.283185307179586],
     [experiment(pendulum1, length_m, 1.0),
      experiment(pendulum1, gravity_m_s2, 9.869604401089358),
      0.10132118364233778 is 1.0 / 9.869604401089358,
      0.3183098861837907 is 0.10132118364233778 ** 0.5,
      constant(pi, 3.141592653589793),
      6.283185307179586 is 2.0 * 3.141592653589793,
      2.0 is 6.283185307179586 * 0.3183098861837907]).
```

The bindings show the whole calculation: L/g ≈ 0.1013, its square root
≈ 0.3183 (that is, 1/π), 2π ≈ 6.2832, and their product 2.0.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C5', re_decision, ok, 7).
recomputed(7).
trusted(0).
verdict(checked).
```

Twelve rule and fact steps replay, and all seven arithmetic steps are
recomputed by the checker. The verdict says the derivation is valid; it
cannot say that the small-angle formula fits a real pendulum. That is a
modelling assumption, named in the program's comment.

---

# Try it

- Make the pendulum 4 m long. The period doubles to 4.0 s, the error is 2.0,
  and the status and reason disappear.
- Use Earth's standard gravity, 9.80665 m/s², and compute the new period
  and error. Is it still within 0.01 s?
- Add a `period_for_target/3` rule that solves the formula for the length
  instead. Which goals does it need to bind first?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 14 and 29.
