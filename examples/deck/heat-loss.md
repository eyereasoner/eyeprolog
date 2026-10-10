# Heat loss through a wall

## How much heat escapes through this wall on a cold day?

A worked physics calculation written as rules. The wall's properties are
facts; temperature difference, thermal resistance and heat loss are derived
one at a time, so the proof reads like the calculation on paper.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=heat-loss) ·
[Source](../heat-loss.pl)

---

# The question

Heat flows through a wall from the warm side to the cold side. For a plain wall
the flow is the temperature difference divided by the wall's **thermal
resistance**, and the resistance is thickness ÷ (conductivity × area). Is the
loss through this wall high?

---

# The wall

```prolog
wall(wall1, conductivity_W_mK, 0.8).
wall(wall1, area_m2, 12.0).
wall(wall1, thickness_m, 0.2).
wall(wall1, indoor_C, 21.0).
wall(wall1, outdoor_C, -4.0).
```

Every quantity is a fact with its unit in the key: 12 m² of wall, 20 cm
thick, 21 °C inside and −4 °C outside.

---

# The rules

```prolog
thermal_resistance(Wall, Resistance) :-
  wall(Wall, thickness_m, Thickness),
  wall(Wall, conductivity_W_mK, Conductivity),
  wall(Wall, area_m2, Area),
  (Conductance is Conductivity * Area),
  (Resistance is Thickness / Conductance).

heat_loss(Wall, Heatloss) :-
  temperature_difference(Wall, Deltat),
  thermal_resistance(Wall, Resistance),
  (Heatloss is Deltat / Resistance).

status(Wall, high_heat_loss) :-
  heat_loss(Wall, Heatloss),
  (Heatloss > 1000.0).
```

Each physical quantity gets its own relation, and the status is a threshold
on the derived heat loss.

---

# The answer

```sh
eyeprolog examples/heat-loss.pl
```

```text
type(wall1, conduction_heat_loss).
temperatureDifference_K(wall1, 25.0).
thermalResistance_K_W(wall1, 0.020833333333333332).
heatLoss_W(wall1, 1200.0).
status(wall1, high_heat_loss).
```

A 25 K difference across a resistance of about 0.021 K/W loses 1200 W, above
the 1000 W threshold.

---

# The reason

```text
step(heat_loss(wall1, 1200.0),
     rule(8),
     ['Wall' = wall1, 'Heatloss' = 1200.0, 'Deltat' = 25.0, 'Resistance' = 0.020833333333333332],
     [temperature_difference(wall1, 25.0),
      thermal_resistance(wall1, 0.020833333333333332),
      1200.0 is 25.0 / 0.020833333333333332]).
step(1200.0 is 25.0 / 0.020833333333333332, builtin, [], []).
```

The heat loss step names its two inputs and the division that combines them.
The division itself is a `builtin` step.

---

# The check

```text
condition('C1', resolution, ok, 13).
condition('C5', re_decision, ok, 5).
verdict(checked).
```

The 13 rule and fact steps replay, and the 5 arithmetic steps were recomputed
and gave the same floating-point results. Nothing is trusted. The check
confirms the calculation, not the physics: whether 0.8 W/(m·K) is the right
conductivity is a question about the wall, not the proof.

---

# Try it

- Double the wall thickness to `0.4`. The resistance doubles, the loss drops
  to 600 W, and the `high_heat_loss` status disappears.
- Add a second wall with its own facts and ask for `heatLoss_W(W, L)`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 14 and 29.
