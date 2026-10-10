# Numeric 8-point FFT

## Which frequencies are hidden in eight samples?

A Fourier transform turns a signal into its frequency content. This example
computes an 8-point FFT on complex numbers written as plain terms, with every
butterfly, twiddle factor, and multiplication visible in the proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=fft8-numeric) ·
[Source](../fft8-numeric.pl)

---

# The question

The **discrete Fourier transform** of eight samples gives eight complex
**bins**. Bin 0, the **DC component**, is the sum of the samples. Higher bins
measure how strongly the signal oscillates at each frequency. The **FFT**
computes them by splitting the samples into even and odd halves, transforming
each, and recombining with **twiddle factors** (powers of an eighth root of
unity). The recombination step is called a **butterfly**.

---

# Complex numbers as terms

```prolog
w8(1, c(0.7071067811865476, -0.7071067811865476)).
w8(2, c(0.0, -1.0)).

c_mul(c(Ar, Ai), c(Br, Bi), c(Cr, Ci)) :-
  (Ac is Ar * Br),
  (Bd is Ai * Bi),
  (Cr is Ac - Bd),
  (Ad is Ar * Bi),
  (Bc is Ai * Br),
  (Ci is Ad + Bc).
```

A complex number is `c(Real, Imag)`. Twiddle factors are facts, and complex
multiplication is spelled out with ordinary arithmetic.

---

# Butterflies

```prolog
fft4([X0, X1, X2, X3], [Y0, Y1, Y2, Y3]) :-
  fft2([X0, X2], [E0, E1]),
  fft2([X1, X3], [O0, O1]),
  w8(2, W1),
  c_mul(W1, O1, T1),
  c_add(E0, O0, Y0),
  c_add(E1, T1, Y1),
  c_sub(E0, O0, Y2),
  c_sub(E1, T1, Y3).
```

A 4-point transform is two 2-point transforms of the even and odd samples,
combined by adding and subtracting. `fft8/2` builds the same way on two
`fft4/2` calls with three twiddle factors.

---

# The answer

```sh
eyeprolog examples/fft8-numeric.pl
```

```text
fft(ramp8, [c(28, 0.0), c(-4.0, 9.65685424949238), c(-4.0, 4.0), c(-4.0, 1.6568542494923806), c(-4, 0.0), c(-4.0, -1.6568542494923806), c(-4.0, -4.0), c(-4.0, -9.65685424949238)]).
fft(alternating8, [c(0, 0.0), c(0.0, 0.0), c(0.0, 0.0), c(0.0, 0.0), c(8, 0.0), c(0.0, 0.0), c(0.0, 0.0), c(0.0, 0.0)]).
dcComponent(ramp8, c(28, 0.0)).
dcComponent(alternating8, c(0, 0.0)).
```

The ramp `0 … 7` has DC component 28, the sum of its samples. The alternating
signal `1, -1, 1, …` has all its energy in bin 4, the highest frequency eight
samples can represent.

---

# The reason

```text
step(c_add(c(12, 0.0), c(16, 0.0), c(28, 0.0)),
     rule(9),
     ['Ar' = 12, 'Ai' = 0.0, 'Br' = 16, 'Bi' = 0.0, 'Cr' = 28, 'Ci' = 0.0],
     [28 is 12 + 16, 0.0 is 0.0 + 0.0]).
step(28 is 12 + 16, builtin, [], []).
```

The DC bin of the ramp is the sum of two halves: 12 from the even samples
`0 + 2 + 4 + 6` and 16 from the odd samples `1 + 3 + 5 + 7`.

---

# The check

```text
condition('C1', resolution, ok, 70).
condition('C5', re_decision, ok, 53).
condition('C7', relevance, ok, 127).
verdict(checked).
```

The checker replays 70 rule steps and recomputes all 53 floating-point and
integer arithmetic steps. Nothing is trusted, but note what that means: the
proof certifies the computation under IEEE double arithmetic, not exact real
arithmetic.

---

# Try it

- Add `wave(constant8, [1, 1, 1, 1, 1, 1, 1, 1]).` and predict the spectrum
  before running it.
- Why do bins 1 and 7 of the ramp have the same real part and opposite
  imaginary parts?
- Compare this with the [symbolic FFT](fast-fourier-transform.md), which builds
  the computation graph instead of the numbers.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
