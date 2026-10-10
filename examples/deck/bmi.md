# Body mass index

## What is this person's BMI, and which category does it fall in?

A weight and a height go in; a body mass index, its WHO adult category, and
the healthy-weight band for the same height come out. Each number is derived
by a rule, so the proof shows the full calculation, and nine independent checks
confirm it.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=bmi) ·
[Source](../bmi.pl)

For reproducibility and documentation only; not medical advice.

---

# The question

Body mass index is weight in kilograms divided by height in meters squared.
The WHO adult table maps it to a category: below 18.5 is underweight, 18.5 up
to 25 is normal, 25 up to 30 is overweight, and so on.

For 72 kg and 178 cm: what is the BMI, what is the category, and what weight
range counts as healthy at this height?

---

# The input

```prolog
unitSystem(input, metric).
weight(input, 72.0).
height(input, 178.0).
```

The program also accepts US units (pounds and inches) and converts them to
kilograms and meters before anything else is computed.

---

# The calculation

```prolog
heightSquared(case, M2) :-
  heightM(case, M),
  (M2 is M * M).

bmi(case, Bmi) :-
  weightKg(case, Kg),
  heightSquared(case, M2),
  (Bmi is Kg / M2).

category(decision, "Normal") :-
  bmi(case, Bmi),
  (Bmi >= 18.5),
  (Bmi < 25.0).
```

Each category is one rule over a half-open interval, so every BMI value falls
into exactly one category.

---

# The answer

```sh
eyeprolog examples/bmi.pl
```

```text
bmi(case, 22.724403484408533).
bmi(answer, 22.72).
category(answer, "Normal").
result(report, bmi(22.72, "Normal")).
healthyWeightRangeKg(report, range(58.6, 78.9)).
```

The full output has 41 answers, including the explanation strings and the
nine `checkPassed/2` results.

---

# The reason

```text
step(bmi(case, 22.724403484408533),
     rule(19),
     ['Bmi' = 22.724403484408533, 'Kg' = 72.0, 'M2' = 3.1684],
     [weightKg(case, 72.0), heightSquared(case, 3.1684), 22.724403484408533 is 72.0 / 3.1684]).
step(category(decision, "Normal"),
     rule(26),
     ['Bmi' = 22.724403484408533],
     [bmi(case, 22.724403484408533), 22.724403484408533 >= 18.5, 22.724403484408533 < 25.0]).
```

The BMI is 72.0 divided by 3.1684 (1.78²), and "Normal" holds because that
value is at least 18.5 and below 25.

---

# The check

```text
condition('C1', resolution, ok, 53).
condition('C5', re_decision, ok, 29).
trusted(0).
verdict(checked).
```

53 rule steps were replayed and all 29 arithmetic steps were recomputed
independently. Nothing is taken on trust.

---

# Try it

- Switch to the US alternative in the source (158.73 lb, 70.08 in). The BMI
  becomes 22.72318149286574 and still rounds to 22.72, "Normal".
- Change the weight to 90.0 kg. The category becomes "Overweight", but
  `bmi(answer, …)` and `result(report, …)` disappear. Find the rule with a
  hard-coded `2272` and make it general.
- What answer does a BMI of exactly 25.0 get, and which rule decides it?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 6 and 14.
