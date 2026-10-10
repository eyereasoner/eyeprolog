# Sizing an RC low-pass filter

## Which frequencies does this resistor and capacitor let through?

A resistor and a capacitor in series form a first-order low-pass filter: slow
signals pass, fast ones are damped. Two formulas describe it, the time
constant τ = R·C and the cutoff frequency f꜀ = 1 / (2πτ). This example turns
them into rules over component facts.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=electrical-rc-filter) ·
[Source](../electrical-rc-filter.pl)

---

# The question

Filter 1 uses a 10 kΩ resistor and a 1 µF capacitor. What kind of filter is
it, what is its time constant, and what is its cutoff frequency?

---

# The components

```prolog
component(filter1, resistor_ohm, 10000.0).
component(filter1, capacitor_f, 0.000001).
constant(pi, 3.141592653589793).
```

Components are stored as filter, attribute, value triples, with units in the
attribute name. More filters, or more attributes, need no change to the rules.

---

# The rules

```prolog
time_constant(Filter, Tau) :-
  component(Filter, resistor_ohm, R),
  component(Filter, capacitor_f, C),
  (Tau is R * C).

cutoff_frequency(Filter, Frequency) :-
  time_constant(Filter, Tau),
  constant(pi, Pi),
  (Twopi is 2.0 * Pi),
  (Denominator is Twopi * Tau),
  (Frequency is 1.0 / Denominator).

type(Filter, first_order_low_pass) :-
  component(Filter, resistor_ohm, _r),
  component(Filter, capacitor_f, _c).
```

Each formula is one rule, and each arithmetic step is its own goal, so the
proof shows the intermediate values.

---

# The answer

```sh
eyeprolog examples/electrical-rc-filter.pl
```

```text
type(filter1, first_order_low_pass).
timeConstant_s(filter1, 0.01).
cutoffFrequency_Hz(filter1, 15.915494309189533).
```

The time constant is 10 ms and the cutoff is about 15.9 Hz: signals well below
16 Hz pass almost unchanged, faster ones are attenuated.

---

# The reason

```sh
eyeprolog --proof examples/electrical-rc-filter.pl
```

```text
step(time_constant(filter1, 0.01),
     rule(4),
     ['Filter' = filter1, 'Tau' = 0.01, 'R' = 10000.0, 'C' = 0.000001],
     [component(filter1, resistor_ohm, 10000.0),
      component(filter1, capacitor_f, 0.000001),
```

The 10 ms time constant comes from the two component facts by clause 4,
multiplying 10000 Ω by 0.000001 F. The cutoff frequency builds on it.

---

# The check

```sh
eyeprolog --proof examples/electrical-rc-filter.pl > electrical-rc-filter.why.pl
eyeprolog --check-proof electrical-rc-filter.why.pl examples/electrical-rc-filter.pl
```

```text
condition('C1', resolution, ok, 8).
condition('C4', coverage, ok, 15).
condition('C7', relevance, ok, 15).
verdict(checked).
```

All 8 rule steps replay and the 4 arithmetic steps are recomputed. Nothing is
taken on trust. The proof certifies the arithmetic from the stated component
values; it cannot certify that the real parts have those values.

---

# Try it

- Which capacitor gives a 50 Hz cutoff with the same resistor? Add it as
  `filter2`.
- Add a rule that classifies a signal frequency as `passed` or `attenuated`
  relative to the cutoff.
- Add a tolerance attribute to the capacitor and compute the lowest and
  highest possible cutoff.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29 (numerical models).
