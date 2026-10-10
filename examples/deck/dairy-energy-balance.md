# Dairy energy balance

## Is each cow eating enough energy for her body and her milk?

A dairy cow needs energy to maintain her body and more to produce milk. When
the ration supplies less than both together, she draws on body reserves. Four
cows at different stages of lactation are classified from a few arithmetic
rules, with every number traceable in the proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dairy-energy-balance) ·
[Source](../dairy-energy-balance.pl)

---

# The question

Energy balance is supply minus demand. Supply is the energy density of the
ration times the dry matter the cow eats. Demand is maintenance, which grows
with body weight, plus the cost of the milk she gives.

A strongly negative balance early in lactation is common and worth watching; a
large positive balance late in lactation means the ration could be cut back.

---

# The herd

```prolog
cow(early_lactation, 650, 38, 6.4, 22).
cow(mid_lactation, 610, 24, 6.5, 26).
cow(late_lactation, 580, 16, 6.7, 25).
cow(grazing, 540, 18, 5.8, 21).
```

`cow(Cow, BodyWeightKg, MilkKgPerDay, RationEnergyMcalPerKgDM, IntakeKgDM)`:
body weight in kilograms, milk in kilograms a day, ration energy in megacalories
(Mcal) per kilogram of dry matter, and daily dry-matter intake.

---

# The rules

```prolog
maintenance(C, M) :-
  cow(C, Weight, _, _, _),
  (M is Weight * 0.08).

milk_requirement(C, R) :-
  cow(C, _, Milk, _, _),
  (R is Milk * 5.0).

energy_balance(C, B) :-
  ration_supply(C, S),
  total_requirement(C, R),
  (B is S - R).

status(C, near_neutral_energy_balance) :-
  energy_balance(C, B),
  (B >= -5.0),
  (B =< 5.0).
```

Each quantity has its own named relation, so each becomes its own step in the
proof. The status rules cut the balance into three bands: below −5 Mcal,
between −5 and +5, and above +5.

---

# The answer

```sh
eyeprolog examples/dairy-energy-balance.pl
```

```text
status(early_lactation, negative_energy_balance).
status(grazing, negative_energy_balance).
status(mid_lactation, near_neutral_energy_balance).
status(late_lactation, positive_energy_balance).
energyBalance_Mcal(early_lactation, -101.19999999999999).
energyBalance_Mcal(mid_lactation, 0.19999999999998863).
energyBalance_Mcal(late_lactation, 41.099999999999994).
energyBalance_Mcal(grazing, -11.399999999999991).
```

Thirteen answers in all; the rest give the milk each ration could support and
name the strongest deficit. The early-lactation cow is about 101 Mcal a day
short: her ration supports only 17.76 kg of her 38 kg of milk. The long
decimals are ordinary floating-point rounding, shown exactly as computed.

---

# The reason

```text
step(energy_balance(mid_lactation, 0.19999999999998863),
     rule(9),
     ['C' = mid_lactation, 'B' = 0.19999999999998863, 'S' = 169.0, 'R' = 168.8],
     [ration_supply(mid_lactation, 169.0),
      total_requirement(mid_lactation, 168.8),
      0.19999999999998863 is 169.0 - 168.8]).
```

The mid-lactation cow is near neutral because her ration supplies 169.0 Mcal
and she needs 168.8. The proof carries the arithmetic itself, so a reviewer
can see exactly which numbers produced the classification.

---

# The check

```text
condition('C1', resolution, ok, 41).
condition('C5', re_decision, ok, 33).
condition('C7', relevance, ok, 87).
steps(74).
recomputed(33).
trusted(0).
verdict(checked).
```

The checker replays 41 rule and fact steps and recomputes all 33 arithmetic
steps independently, such as `140.8 is 6.4 * 22`. Nothing is left on trust:
every number in every answer is re-derived.

---

# Try it

- Let the grazing cow eat 23 kg of dry matter instead of 21. Her status
  becomes `near_neutral_energy_balance`, with a balance of about 0.2 Mcal.
- Add a fifth cow of your own and predict her band before running.
- `strongestDeficit/2` only checks that two particular statuses hold. Rewrite
  it with `aggregate_min/5` so it really finds the most negative balance.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14 (knowledge engineering) and Chapter 29 (numerical models).
