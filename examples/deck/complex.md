# Complex numbers

## What is i to the power i?

Complex numbers are written as two-item lists `[Real, Imaginary]`, and a small
toolkit of rules computes powers, polar form, and inverse trigonometric
functions. The answers include Euler's identity and the surprising fact that
i^i is a real number.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=complex) ·
[Source](../complex.pl)

---

# The question

What do four classic complex powers evaluate to, √−1, e^(iπ), i^i and
e^(−π/2), and what are asin(2) and acos(2), which have no real value?

Each result row names the operation, gives its inputs, and carries the computed
complex value, so the output reads like a table of identities.

---

# Polar form

```prolog
complex_polar([X, Y], [R, Tp]) :-
  (Z1 is X ** 2),
  (Z2 is Y ** 2),
  (Z3 is Z1 + Z2),
  (R is Z3 ** 0.5),
  (Z4 is abs(X)),
  (Z5 is Z4 / R),
  (T is acos(Z5)),
  complex_dial(X, Y, T, Tp).
```

A complex number becomes a radius `R` and an angle. `acos` only gives an angle
in the first quadrant, so `complex_dial/4` has one clause per quadrant to turn
it into the full angle, using `pi/1`.

---

# Powers through logarithms

```prolog
complex_power(i_to_i, [0, 1], [0, 1], Result) :-
  complex_exponentiation([0, 1], [0, 1], Result).
```

`complex_exponentiation/3` computes z^w through the polar form: the radius is
raised to the real part of `w`, and the angle and logarithm of the radius
combine into a new angle, which `cos` and `sin` turn back into real and
imaginary parts. Every intermediate value is a named variable, so each one
appears in the proof.

---

# The answer

```sh
eyeprolog examples/complex.pl
```

```text
complex_power(sqrt_minus_one, [-1, 0], [0.5, 0], [6.123233995736766e-17, 1.0]).
complex_power(e_to_i_pi, [2.718281828459045, 0], [0, 3.141592653589793], [-1.0, 1.2246467991473532e-16]).
complex_power(i_to_i, [0, 1], [0, 1], [0.20787957635076193, 0.0]).
complex_power(e_to_minus_pi_over_two, [2.718281828459045, 0], [-1.57079632679, 0], [0.20787957635177984, 0.0]).
complex_function(asin, two, [2, 0], [1.5707963267948966, 1.3169578969248166]).
complex_function(acos, two, [2, 0], [0.0, -1.3169578969248166]).
```

√−1 is i, e^(iπ) is −1 (Euler's identity), and i^i ≈ 0.2079 is real and
equal to e^(−π/2), as the fourth row confirms. Tiny values such as
`6.123233995736766e-17` are floating-point rounding where the exact answer is 0.

---

# The reason

```sh
eyeprolog --proof examples/complex.pl
```

```text
step(complex_power(i_to_i, [0, 1], [0, 1], [0.20787957635076193, 0.0]),
     rule(13),
     ['Result' = [0.20787957635076193, 0.0]],
     [complex_exponentiation([0, 1], [0, 1], [0.20787957635076193, 0.0])]).
```

The named row holds by clause 13, which hands the computation to
`complex_exponentiation/3`. That step, in turn, lists every `is/2` evaluation
it used, down to the polar form of i.

---

# The check

```text
condition('C1', resolution, ok, 20).
condition('C5', re_decision, ok, 78).
verdict(checked).
```

The proof has 98 steps: 20 rule steps that the checker replays against the
program, and 78 arithmetic steps that it recomputes independently and finds
equal. Nothing is taken on trust.

---

# Try it

- Compute (1 + i)²: `--goal 'complex_exponentiation([1,1],[2,0],R)'`. The
  exact answer is 2i; how close does floating point get?
- Ask for the polar form of −i with `complex_polar([0,-1], P)`. Which clause of
  `complex_dial/4` places its angle, and why is it 3π/2 rather than −π/2?
- Add a row for e^(iπ/2) and predict its value before running it.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6 and Chapter 29.
