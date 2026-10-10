# Modular exponentiation

## What is 7⁵⁶⁰ mod 561, without ever computing 7⁵⁶⁰?

7⁵⁶⁰ has more than 470 digits, but its remainder modulo 561 can be found with
a handful of small multiplications. This example computes modular powers by
repeated squaring and uses them for Fermat's primality test, including the
case where that test is fooled.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=modular-exponentiation) ·
[Source](../modular-exponentiation.pl)

---

# The question

Fermat's little theorem says that if *p* is prime, then *a*^(p−1) mod *p* = 1
for any *a* not divisible by *p*. So computing *a*^(p−1) mod *p* is a cheap
test that can expose a composite number. How do you compute such a power
efficiently, and how far can the test be trusted?

---

# The rules

```prolog
pow_mod(_base, 0, Mod, Result) :- (Result is 1 mod Mod).
pow_mod(Base, Exp, Modulus, Result) :-
  (Exp > 0),
  (0 is Exp mod 2),
  (Half is Exp // 2),
  pow_mod(Base, Half, Modulus, Halfpower),
  (Square is Halfpower * Halfpower),
  (Result is Square mod Modulus).
pow_mod(Base, Exp, Modulus, Result) :-
  (Exp > 0),
  (1 is Exp mod 2),
  (Evenexp is Exp - 1),
  pow_mod(Base, Evenexp, Modulus, Evenpower),
  (Product is Base * Evenpower),
  (Result is Product mod Modulus).
```

An even exponent halves and squares; an odd exponent peels off one factor.
Reducing modulo *m* at every step keeps every number small, and the recursion
depth grows with the number of bits in the exponent, not with the exponent
itself.

---

# The queries

```prolog
fermat_witness(Base, Primecandidate) :-
  (Exponent is Primecandidate - 1),
  pow_mod(Base, Exponent, Primecandidate, 1).

modular_answer(pow_7_560_mod_561, R) :- pow_mod(7, 560, 561, R).
modular_answer(pow_2_1000_mod_1009, R) :- pow_mod(2, 1000, 1009, R).
modular_answer(fermat_2_101, true) :- fermat_witness(2, 101).
modular_answer(fermat_3_101, true) :- fermat_witness(3, 101).
```

`fermat_witness/2` succeeds when the Fermat congruence holds. That is
evidence of primality, not a proof.

---

# The answer

```sh
eyeprolog examples/modular-exponentiation.pl
```

```text
modular_answer(pow_7_560_mod_561, 1).
modular_answer(pow_2_1000_mod_1009, 942).
modular_answer(fermat_2_101, true).
modular_answer(fermat_3_101, true).
```

101 is prime, and both Fermat checks pass. But 7⁵⁶⁰ mod 561 is also 1, even
though 561 = 3 · 11 · 17. 561 is a *Carmichael number*: a composite that
passes the Fermat test for every base coprime to it. This is why the source
calls the check "not a full primality proof".

---

# The reason

```text
step(pow_mod(7, 560, 561, 1),
     rule(3),
     ['Base' = 7,
      'Exp' = 560,
      'Modulus' = 561,
      'Result' = 1,
      'Half' = 280,
      'Halfpower' = 67,
      'Square' = 4489],
     [560 > 0,
      0 is 560 mod 2,
      280 is 560 // 2,
      pow_mod(7, 280, 561, 67),
      4489 is 67 * 67,
      1 is 4489 mod 561]).
```

7⁵⁶⁰ is (7²⁸⁰)². Since 7²⁸⁰ mod 561 = 67, the answer is 67² = 4489, and
4489 mod 561 = 1. The proof continues down the chain of halvings to
exponent 0.

---

# The check

```text
condition('C1', resolution, ok, 55).
condition('C5', re_decision, ok, 176).
steps(231).
verified(55).
recomputed(176).
trusted(0).
verdict(checked).
```

All 55 rule steps replay, and all 176 arithmetic steps are recomputed by the
checker. Every multiplication and remainder in the chain is confirmed
independently.

---

# Try it

- Compute `pow_mod(2, 560, 561, R)` and `pow_mod(5, 560, 561, R)`. Do they also
  give 1? Then try base 3, which shares a factor with 561.
- Run with `--stats` and compare the number of `pow_mod/4` calls with the
  exponent 560.
- Write `fermat_composite(N)` that searches for a base below N that proves N
  composite, and test it on 561 and 563.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 27.
