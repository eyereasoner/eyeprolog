# Competitive enzyme inhibition

## How much does an inhibitor slow an enzyme down?

An enzyme converts a substrate at a rate that depends on how much substrate is
present. A competitive inhibitor competes for the same binding site.
EyeProlog applies the standard rate equations to one assay and decides whether
the slowdown is significant.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=competitive-enzyme-kinetics) ·
[Source](../competitive-enzyme-kinetics.pl)

---

# The question

The **Michaelis–Menten** equation gives an enzyme's rate as
`Vmax × S / (Km + S)`, where `S` is the substrate concentration, `Vmax` the top
speed, and `Km` the concentration at which the rate is half of that. A
competitive inhibitor at concentration `I` with binding constant `Ki`
effectively raises `Km` to `Km × (1 + I / Ki)`. With this assay's numbers, how
large is the slowdown, and does it exceed 25%?

---

# The measurements

```prolog
assay(assay1, vmax_uM_s, 120.0).
assay(assay1, substrate_uM, 50.0).
assay(assay1, km_uM, 30.0).
assay(assay1, inhibitor_uM, 10.0).
assay(assay1, ki_uM, 5.0).
threshold(assay1, significant_inhibition_fraction, 0.25).
```

Concentrations are in micromolar (µM) and rates in µM per second. The
threshold is part of the data, not hidden in a rule.

---

# The equations as rules

```prolog
competitive_multiplier(Assay, Multiplier) :-
  assay(Assay, inhibitor_uM, Inhibitor),
  assay(Assay, ki_uM, Ki),
  (Ratio is Inhibitor / Ki),
  (Multiplier is 1.0 + Ratio).

effective_km(Assay, Effectivekm) :-
  assay(Assay, km_uM, Km),
  competitive_multiplier(Assay, Multiplier),
  (Effectivekm is Km * Multiplier).

significant_inhibition(Assay) :-
  inhibition_fraction(Assay, Fraction),
  threshold(Assay, significant_inhibition_fraction, Limit),
  (Fraction > Limit).
```

Each named quantity is its own predicate, so each appears as its own step in
the proof. The rates and the inhibition fraction follow the same pattern.

---

# The answer

```sh
eyeprolog examples/competitive-enzyme-kinetics.pl
```

```text
effectiveKm_uM(assay1, 90.0).
uninhibitedRate_uM_s(assay1, 75.0).
inhibitedRate_uM_s(assay1, 42.857142857142854).
inhibitionFraction(assay1, 0.4285714285714286).
status(assay1, significant_inhibition).
reason(assay1, "competitive inhibitor raises effective Km and lowers reaction rate").
```

The inhibitor triples the effective `Km` from 30 to 90 µM, which cuts the rate
from 75 to about 42.9 µM/s: a 43% slowdown, well over the 25% threshold.

---

# The reason

```text
step(effective_km(assay1, 90.0),
     rule(8),
     ['Assay' = assay1, 'Effectivekm' = 90.0, 'Km' = 30.0, 'Multiplier' = 3.0],
     [assay(assay1, km_uM, 30.0), competitive_multiplier(assay1, 3.0), 90.0 is 30.0 * 3.0]).
step(competitive_multiplier(assay1, 3.0),
     rule(7),
     ['Assay' = assay1, 'Multiplier' = 3.0, 'Inhibitor' = 10.0, 'Ki' = 5.0, 'Ratio' = 2.0],
     [assay(assay1, inhibitor_uM, 10.0),
      assay(assay1, ki_uM, 5.0),
      2.0 is 10.0 / 5.0,
      3.0 is 1.0 + 2.0]).
```

The effective `Km` of 90 is 30 times a multiplier of 3, and the multiplier is
1 + 10 / 5. Every number in the conclusion traces back to a measured fact and
one arithmetic step.

---

# The check

```text
condition('C1', resolution, ok, 18).
condition('C5', re_decision, ok, 11).
steps(29).
trusted(0).
verdict(checked).
```

All 18 rule steps resolve, and the checker redoes all 11 arithmetic steps.
That confirms the calculation from the stated numbers. Whether the numbers
were measured well, and whether the model fits this enzyme, is outside the
proof.

---

# Try it

- Lower the inhibitor to 2.0 µM. The fraction drops to about 0.13, and
  `status/2` and `reason/2` disappear.
- Double the substrate to 100 µM and predict whether the inhibition fraction
  rises or falls.
- Add a second assay with its own facts. No rule needs to change.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
