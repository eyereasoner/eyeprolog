# Beam deflection

## Does this cantilever beam bend too far?

A beam fixed at one end and loaded at the other bends. Engineers compute the
tip deflection from the load, the span, the material stiffness, and the
cross-section, then compare it with a design limit. This example does exactly
that, and its proof shows every intermediate number.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=beam-deflection) ·
[Source](../beam-deflection.pl)

---

# The question

A 2.5 m steel cantilever carries 1200 N at its tip. The design allows at most
5 mm of deflection. Is the beam within the limit?

For a cantilever with a point load at the tip, the deflection is
**F·L³ / (3·E·I)**: force times length cubed, divided by three times the
elastic modulus `E` and the second moment of area `I`, which measures how well
the cross-section resists bending.

---

# The facts

```prolog
beam(beam1, force_N, 1200.0).
beam(beam1, length_m, 2.5).
beam(beam1, elasticModulus_Pa, 200000000000.0).
beam(beam1, secondMoment_m4, 0.000008).
limit(beam1, maxDeflection_mm, 5.0).
```

Every quantity carries its unit in its name: newtons, meters, pascals, meters
to the fourth power, millimeters.

---

# The rules

```prolog
tip_deflection_m(Beam, Deflection) :-
  beam(Beam, force_N, Force),
  beam(Beam, length_m, Length),
  beam(Beam, elasticModulus_Pa, Elasticmodulus),
  beam(Beam, secondMoment_m4, Secondmoment),
  (Lengthcubed is Length ** 3.0),
  (Numerator is Force * Lengthcubed),
  (Threee is 3.0 * Elasticmodulus),
  (Denominator is Threee * Secondmoment),
  (Deflection is Numerator / Denominator).

tip_deflection_mm(Beam, Deflectionmm) :-
  tip_deflection_m(Beam, Deflectionm),
  (Deflectionmm is Deflectionm * 1000.0).

status(Beam, within_deflection_limit) :-
  tip_deflection_mm(Beam, Deflectionmm),
  limit(Beam, maxDeflection_mm, Limit),
  (Deflectionmm =< Limit).
```

The formula is split into named steps, so each partial result appears in the
proof. The unit conversion is its own rule.

---

# The answer

```sh
eyeprolog examples/beam-deflection.pl
```

```text
type(beam1, cantilever_beam).
tipDeflection_m(beam1, 0.00390625).
tipDeflection_mm(beam1, 3.90625).
limit_mm(beam1, 5.0).
status(beam1, within_deflection_limit).
```

The tip moves 3.90625 mm, under the 5 mm limit.

---

# The reason

```sh
eyeprolog --proof examples/beam-deflection.pl
```

```text
step(15.625 is 2.5 ** 3.0, builtin, [], []).
step(18750.0 is 1200.0 * 15.625, builtin, [], []).
step(600000000000.0 is 3.0 * 200000000000.0, builtin, [], []).
step(4800000.0 is 600000000000.0 * 0.000008, builtin, [], []).
step(0.00390625 is 18750.0 / 4800000.0, builtin, [], []).
```

The proof is the hand calculation: L³ = 15.625, F·L³ = 18750, 3E = 6·10¹¹,
3EI = 4.8·10⁶, and the quotient is 0.00390625 m. A reviewer can audit each line
without rerunning anything.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C5', re_decision, ok, 7).
recomputed(7).
trusted(0).
verdict(checked).
```

The 12 rule and fact steps check, and the checker recomputes all 7 arithmetic
steps. The proof establishes the arithmetic; whether the inputs describe the
real beam, and whether the formula applies to it, remain engineering
judgments outside the logic.

---

# Try it

- Increase the span to 3.0 m. Since deflection grows with L³, predict the new
  value before running it, and the new status.
- Add a `status(Beam, exceeds_deflection_limit)` rule for the other case.
- Add a second beam with a stiffer section (larger `I`) and query both.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
