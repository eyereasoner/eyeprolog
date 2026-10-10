# Ideal gas law

## Is the pressure in this gas cell close to one atmosphere?

The ideal gas law `P·V = n·R·T` relates pressure, volume, amount of gas and
temperature. This example computes the pressure of one gas cell, classifies
it against a tolerance band, and explains the result down to each
multiplication and division.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=ideal-gas-law) ·
[Source](../ideal-gas-law.pl)

---

# The question

A cell holds 1 mole of gas at 300 kelvin in 0.024 cubic metres. Using a
gas constant of 8 (rounded so the numbers come out cleanly), what is the
pressure, and does it fall between 95 000 and 105 000 pascal, roughly one
atmosphere?

---

# The facts

```prolog
gas_cell(cell1, 1.0, 8.0, 300.0, 0.024).
pressure_limit(cell1, low_Pa, 95000.0).
pressure_limit(cell1, high_Pa, 105000.0).
```

`gas_cell/5` records the amount `n`, the constant `R`, the temperature `T`
and the volume `V`. The two limits define the tolerance band.

---

# The rules

```prolog
pressure(Cell, Pressure) :-
  gas_cell(Cell, Moles, Gasconstant, Temperature, Volume),
  (Nr is Moles * Gasconstant),
  (Nrt is Nr * Temperature),
  (Pressure is Nrt / Volume).

near_atmospheric(Cell) :-
  pressure(Cell, Pressure),
  pressure_limit(Cell, low_Pa, Low),
  pressure_limit(Cell, high_Pa, High),
  (Pressure > Low),
  (Pressure < High).
```

The physics is `P = n·R·T / V`, computed in three explicit steps. The
classification is a separate rule, so a reviewer can dispute the band
without touching the physics.

---

# The answer

```sh
eyeprolog examples/ideal-gas-law.pl
```

```text
pressure_Pa(cell1, 100000.0).
status(cell1, near_atmospheric).
reason(cell1, "pressure is inside the one-atmosphere tolerance band").
```

`1 × 8 × 300 / 0.024 = 100 000` pascal, comfortably inside the band.

---

# The reason

```sh
eyeprolog --proof examples/ideal-gas-law.pl
```

```text
step(8.0 is 1.0 * 8.0, builtin, [], []).
step(2400.0 is 8.0 * 300.0, builtin, [], []).
step(100000.0 is 2400.0 / 0.024, builtin, [], []).
```

The pressure rests on the cell's recorded values and three arithmetic
steps: `n·R = 8`, `n·R·T = 2400`, and `2400 / 0.024 = 100 000`. The status
then rests on two comparisons against the limits.

---

# The check

```text
condition('C1', resolution, ok, 8).
condition('C5', re_decision, ok, 5).
condition('C7', relevance, ok, 16).
verdict(checked).
```

Eight steps replay against the program's clauses, and the five built-in
steps (three arithmetic, two comparisons) are recomputed by the checker.
The proof checks the derivation; whether the sensor readings were right is
a question for the source of the facts.

---

# Try it

- Raise the temperature to `350.0`. The pressure becomes about 116 667
  pascal, and the `status/2` and `reason/2` answers disappear.
- Add a second cell with a different volume and predict its status before
  running.
- Add a `reason/2` clause that explains *why* a cell is outside the band
  (too high or too low).

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
