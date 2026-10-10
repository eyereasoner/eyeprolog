# Buck converter design

## Does this voltage regulator keep its ripple within limits?

A buck converter steps 24 V down to 5 V by switching rapidly and smoothing the
result with an inductor and a capacitor. The example computes the design's
ripple from its component values and decides whether it meets two design
limits, with each engineering equation as its own rule.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=buck-converter-design) ·
[Source](../buck-converter-design.pl)

---

# The question

Switching makes the inductor current and the output voltage wobble slightly,
which engineers call **ripple**. A good design keeps the current ripple below
30% of the load current and the output voltage ripple below 50 mV.

Does regulator 1 meet both limits?

---

# The design

```prolog
converter(regulator1, inputVoltage_V, 24.0).
converter(regulator1, outputVoltage_V, 5.0).
converter(regulator1, loadCurrent_A, 2.0).
converter(regulator1, switchingFrequency_Hz, 500000.0).
converter(regulator1, inductance_H, 0.000022).
converter(regulator1, capacitance_F, 0.000047).
limit(regulator1, maxRippleRatio, 0.30).
limit(regulator1, maxOutputRipple_V, 0.05).
```

A 22 µH inductor, a 47 µF capacitor, switching at 500 kHz. The units are in
the property names.

---

# The equations

```prolog
duty_cycle(Converter, Duty) :-
  converter(Converter, outputVoltage_V, Outputvoltage),
  converter(Converter, inputVoltage_V, Inputvoltage),
  (Duty is Outputvoltage / Inputvoltage).

within_ripple_limits(Converter) :-
  ripple_ratio(Converter, Ratio),
  limit(Converter, maxRippleRatio, Maxratio),
  (Ratio < Maxratio),
  capacitor_ripple_voltage(Converter, Ripplevoltage),
  limit(Converter, maxOutputRipple_V, Maxripplevoltage),
  (Ripplevoltage < Maxripplevoltage).
```

The duty cycle is the fraction of time the switch is on. From it follow the
inductor ripple current ΔI = (Vin − Vout)·D / (L·f) and the capacitor ripple
voltage ΔI / (8·f·C), each in a rule of its own.

---

# The answer

```sh
eyeprolog examples/buck-converter-design.pl
```

```text
dutyCycle(regulator1, 0.20833333333333334).
inductorRipple_A(regulator1, 0.35984848484848486).
rippleRatio(regulator1, 0.17992424242424243).
capacitorRipple_V(regulator1, 0.0019140876853642812).
status(regulator1, stable_ripple_design).
reason(regulator1, "inductor-current and output-voltage ripple are below design limits").
```

The current ripple is 0.36 A, 18% of the 2 A load, and the output ripple is
about 1.9 mV. Both are well inside their limits.

---

# The reason

```text
step(within_ripple_limits(regulator1),
     rule(13),
     ['Converter' = regulator1,
      'Ratio' = 0.17992424242424243,
      'Maxratio' = 0.3,
      'Ripplevoltage' = 0.0019140876853642812,
      'Maxripplevoltage' = 0.05],
     [ripple_ratio(regulator1, 0.17992424242424243),
      limit(regulator1, maxRippleRatio, 0.3),
      0.17992424242424243 < 0.3,
      capacitor_ripple_voltage(regulator1, 0.0019140876853642812),
      limit(regulator1, maxOutputRipple_V, 0.05),
      0.0019140876853642812 < 0.05]).
```

The design passes because two comparisons hold: 0.18 < 0.3 and
0.0019 < 0.05. Each value has its own step, back to the component facts.

---

# The check

```text
condition('C1', resolution, ok, 19).
condition('C5', re_decision, ok, 11).
trusted(0).
verdict(checked).
```

19 rule steps were replayed and all 11 arithmetic steps were recomputed, so a
reviewer can trust every number without rerunning the design.

---

# Try it

- Replace the inductor with a 4.7 µH part (`0.0000047`). The ripple ratio
  rises to 0.84, and `status/2` and `reason/2` are no longer derived.
- Which limit is closer to failing, and by how much?
- Add a rule that reports *which* limit failed, so a failing design gets a
  diagnosis instead of silence.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 14 and 29.
