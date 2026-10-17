# Manufacturing quality control

## Is this production line capable of staying inside its tolerances?

Two production runs make the same 10.0–10.2 mm part. EyeProlog computes each
run's process capability index (Cpk) from its measurement summary, compares it
with a 1.33 threshold, and explains which run needs adjustment.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=manufacturing-quality-control) ·
[Source](../manufacturing-quality-control.pl)

---

# The question

A part is in specification when it measures between a lower and an upper
limit. A process is *capable* when its spread is small compared with the room
it has before hitting the nearest limit.

Cpk measures exactly that: the distance from the mean to the nearest
specification limit, divided by three standard deviations. A common
production rule asks for Cpk ≥ 1.33.

---

# The facts

```prolog
spec(line7_shift_a, lower_mm, 10.0).
spec(line7_shift_a, upper_mm, 10.2).
summary(line7_shift_a, mean_mm, 10.12).
summary(line7_shift_a, sigma_mm, 0.04).

spec(line8_shift_b, lower_mm, 10.0).
spec(line8_shift_b, upper_mm, 10.2).
summary(line8_shift_b, mean_mm, 10.1).
summary(line8_shift_b, sigma_mm, 0.02).

capability_threshold(cpk, 1.33).
```

Line 7 is off-centre and noisier; line 8 is centred and tighter.

---

# The rules

```prolog
nearest_spec_margin_mm(Run, Margin) :-
  upper_margin_mm(Run, Uppermargin),
  lower_margin_mm(Run, Lowermargin),
  (Uppermargin =< Lowermargin -> Margin = Uppermargin ; Margin = Lowermargin).

cpk(Run, Cpk) :-
  nearest_spec_margin_mm(Run, Margin),
  three_sigma_mm(Run, Threesigma),
  (Cpk is Margin / Threesigma).

needs_adjustment(Run) :-
  cpk(Run, Cpk),
  capability_threshold(cpk, Threshold),
  (Cpk < Threshold).
```

Each engineering quantity (margins, three sigma, Cpk) is its own predicate, so
each becomes its own step in the proof.

---

# The answer

```sh
eyeprolog examples/manufacturing-quality-control.pl
```

```text
cpk(line7_shift_a, 0.6666666666666673).
cpk(line8_shift_b, 1.6666666666666607).
status(line8_shift_b, capable_process).
status(line7_shift_a, needs_process_adjustment).
reason(line8_shift_b, "Cpk meets the production capability threshold").
reason(line7_shift_a, "Cpk is below the production capability threshold").
```

Line 8 is capable (Cpk ≈ 1.67); line 7 is not (Cpk ≈ 0.67). The long decimals
are ordinary floating-point arithmetic, shown as computed.

---

# The reason

```text
step(cpk(line7_shift_a, 0.6666666666666673),
     rule(16),
     ['Run' = line7_shift_a,
      'Cpk' = 0.6666666666666673,
      'Margin' = 0.08000000000000007,
      'Threesigma' = 0.12],
     [nearest_spec_margin_mm(line7_shift_a, 0.08000000000000007),
      three_sigma_mm(line7_shift_a, 0.12),
      0.6666666666666673 is 0.08000000000000007 / 0.12]).
```

Line 7's mean sits 0.08 mm below the upper limit, its three-sigma spread is
0.12 mm, and 0.08 / 0.12 gives the Cpk. A later step compares that value with
the 1.33 threshold and concludes `needs_adjustment(line7_shift_a)`.

---

# The check

```text
condition('C1', resolution, ok, 25).
condition('C2', well_founded, ok, 41).
condition('C3', justification, ok, 41).
condition('C4', coverage, ok, 48).
condition('C5', re_decision, ok, 16).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 47).
verdict(checked).
```

25 steps were replayed against the clauses they cite, and 14 arithmetic steps
were recomputed independently. The 2 if-then-else decisions are recorded as the
branch each took and composed from its goals. Nothing is taken on trust.

---

# Try it

- Halve line 7's `sigma_mm` to `0.02`. Predict its new Cpk and whether it
  clears the threshold.
- Move line 7's mean to the centre (`10.1`) and compare the effect with
  reducing its spread.
- Add a third run whose mean lies outside the specification. What Cpk does the
  model give, and should a separate integrity rule catch it first?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
