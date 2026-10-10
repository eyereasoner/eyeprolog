# Fast exponentiation

## How do you compute 3 to the power 10000 without 10000 multiplications?

Exponentiation by squaring halves the exponent at every even step, so a power
needs only a few dozen multiplications. With a modulus applied at each step,
even huge powers stay small enough to print and to explain.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=fastpow) ·
[Source](../fastpow.pl)

---

# The question

Computing `b^n` by repeated multiplication takes `n` steps. **Exponentiation
by squaring** uses two identities: for even `n`, `b^n = (b^(n/2))^2`; for odd
`n`, `b^n = b · b^(n-1)`. Each even step halves the exponent, so the number of
steps grows with the number of binary digits of `n`, not with `n` itself.
**Modular exponentiation** applies the same idea while reducing every
intermediate result modulo `m`, as cryptography does.

---

# The rules

```prolog
fast_power(_Base, 0, 1).
fast_power(Base, Exp, Value) :-
  (Exp > 0),
  (0 is Exp mod 2),
  (Half is Exp // 2),
  fast_power(Base, Half, Halfvalue),
  (Value is Halfvalue * Halfvalue).
fast_power(Base, Exp, Value) :-
  (Exp > 0),
  (1 is Exp mod 2),
  (Evenexp is Exp - 1),
  fast_power(Base, Evenexp, Evenvalue),
  (Value is Base * Evenvalue).
```

One base case and one clause per parity. `pow_mod/4` has the same three
clauses, with `mod Mod` after every multiplication.

---

# The answer

```sh
eyeprolog examples/fastpow.pl
```

```text
pow([2, 10], 1024.0).
powSlow([2, 10], 1024.0).
powMod1e6([2, 10000], 709376).
powMod1e6([3, 10000], 200001).
tower([2, 4], 65536).
towerMod1e6([2, 5], 156736).
```

`2^10000 mod 10^6` is 709376, the last six digits of a number with over 3000
digits. The two tower results are stored as facts rather than computed.

---

# The reason

```text
step(powMod1e6([2, 10000], 709376),
     rule(11),
     ['Value' = 709376],
     [pow_mod(2, 10000, 1000000, 709376)]).
step(pow_mod(2, 10000, 1000000, 709376),
     rule(5),
     ['Base' = 2,
      'Exp' = 10000,
      'Mod' = 1000000,
      'Value' = 709376,
      'Half' = 5000,
      'Halfvalue' = 909376,
      'Square' = 826964709376],
     [10000 > 0,
      0 is 10000 mod 2,
      5000 is 10000 // 2,
      pow_mod(2, 5000, 1000000, 909376),
```

(Shortened.) `2^10000` is found by squaring `2^5000 mod 10^6 = 909376`: the
square is 826964709376, and its last six digits are 709376. The proof
continues down through 2500, 1250, 625, and so on.

---

# The check

```text
condition('C1', resolution, ok, 52).
condition('C5', re_decision, ok, 136).
condition('C7', relevance, ok, 194).
verdict(checked).
```

The checker replays 52 rule steps and recomputes all 136 arithmetic steps
itself, so every intermediate square and remainder is verified independently.
Nothing is trusted.

---

# Try it

- How many `pow_mod/4` steps does `2^10000` need? Compare with the 10000
  multiplications of the naive method.
- Compute `pow_mod(7, 560, 561, V)`. 561 is not prime, yet the result is 1:
  look up *Carmichael numbers* to see why.
- Replace `fast_power/3` with a version that counts down one multiplication at
  a time, and compare the two with `--stats`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 6 and 27.
