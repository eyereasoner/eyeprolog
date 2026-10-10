# Field nitrogen balance

## Which fields get too little nitrogen, which get too much, and where is leaching worst?

Farmers balance the nitrogen a crop needs against what the soil and fertilizer
supply, minus what is lost. This example turns that budget into rules for four
fields, classifies each one, and names the field most at risk of nitrogen
leaching into groundwater.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=field-nitrogen-balance) ·
[Source](../field-nitrogen-balance.pl)

---

# The question

For each field, given soil nitrogen, fertilizer, the fraction lost, and the
crop's demand (all in kg per hectare):

- How much nitrogen is actually available to the crop?
- Is there a deficit or a surplus?
- How large is the leaching risk?
- Is the field under-supplied, balanced, or over-supplied?

---

# The facts

```prolog
field(low_input, 25, 40, 0.10, 110).
field(balanced_loam, 45, 80, 0.12, 110).
field(sandy_high, 30, 150, 0.35, 105).
field(clay_surplus, 70, 90, 0.08, 120).
```

`field(Field, SoilN, FertilizerN, LossFraction, CropDemandN)`. Sandy soil loses
a third of its nitrogen; clay holds on to most of it.

---

# The rules

```prolog
available_n(F, Avail) :-
  total_n(F, Total),
  field(F, _, _, Loss, _),
  (Retained is 1.0 - Loss),
  (Avail is Total * Retained).

leaching_index(F, Index) :-
  surplus_n(F, Surplus),
  field(F, _, _, Loss, _),
  (Index is Surplus * Loss).

status(F, under_supplied) :- deficit_n(F, D), (D > 10.0).
status(F, balanced) :- deficit_n(F, D), surplus_n(F, S), (D =< 10.0), (S =< 10.0).
status(F, over_supplied) :- surplus_n(F, S), (S > 10.0).
```

The leaching index weights the surplus by how leaky the soil is, so a small
surplus on sand can matter more than a larger one on clay.

---

# The answer

```sh
eyeprolog examples/field-nitrogen-balance.pl
```

```text
status(low_input, under_supplied).
status(balanced_loam, balanced).
status(sandy_high, over_supplied).
status(clay_surplus, over_supplied).
availableN_kg_ha(low_input, 58.5).
availableN_kg_ha(balanced_loam, 110.0).
availableN_kg_ha(sandy_high, 117.0).
availableN_kg_ha(clay_surplus, 147.20000000000002).
...
leachingIndex(sandy_high, 4.199999999999999).
leachingIndex(clay_surplus, 2.1760000000000015).
...
highestLeachingRisk(field_nitrogen_balance, sandy_high).
```

21 answers in total. Clay has the bigger surplus (27.2 against 12.0), yet sand
has the higher leaching risk. The trailing digits are ordinary floating-point
rounding.

---

# The reason

```text
step(available_n(sandy_high, 117.0),
     rule(6),
     ['F' = sandy_high, 'Avail' = 117.0, 'Total' = 180, 'Loss' = 0.35, 'Retained' = 0.65],
     [total_n(sandy_high, 180),
      field(sandy_high, 30, 150, 0.35, 105),
      0.65 is 1.0 - 0.35,
      117.0 is 180 * 0.65]).
```

The sandy field receives 180 kg, keeps 65% of it, and so has 117 kg
available. The proof shows the inputs and each arithmetic step, so the
agronomy can be audited line by line.

---

# The check

```text
condition('C1', resolution, ok, 45).
condition('C5', re_decision, ok, 32).
steps(77).
verified(45).
recomputed(32).
trusted(0).
verdict(checked).
```

45 steps are rule or fact applications, replayed against their clauses. The
other 32 are arithmetic and comparisons, which the checker recomputes itself
(C5, "re-decision"). Nothing is trusted.

---

# Try it

- Raise the fertilizer on `low_input` from 40 to 100. The field becomes
  `balanced`, with a surplus of 2.5.
- Set the loss fraction of `sandy_high` to `0.40`. Its surplus falls to 3.0,
  and `highestLeachingRisk` disappears. Why does that rule only compare two
  named fields?
- Write a general `highest_leaching_risk/1` that compares all fields using
  `aggregate_max/5`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 6 and 14.
