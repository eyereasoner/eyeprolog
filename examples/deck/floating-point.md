# Floating-point arithmetic

## What happens when a logic program computes with decimals?

Prolog integers are exact and unbounded; decimal numbers are IEEE-754 floats,
the same as in JavaScript. This small example runs the basic operations on
decimals and uses the results in comparisons, with a thermostat as the
setting.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=floating-point) ·
[Source](../floating-point.pl)

---

# The question

Do addition, subtraction, multiplication, division, and powers on decimals give
the values you expect? And can rules compare decimal values, for example to
decide whether a room is warmer than its target?

---

# The facts and rules

```prolog
sample(roomC, 21.5).
sample(targetC, 19.25).

value(sum, X) :- (X is 1.5 + 2.25).
value(quotient, X) :- (X is 7.5 / 2).
value(sqrtByPower, X) :- (X is 9.0 ** 0.5).
than(warmer, targetC) :- sample(roomC, R), sample(targetC, T), (R > T).
value(comfortable, true) :- sample(roomC, R), (R >= 21.0), (R =< 22.0).
```

`is/2` evaluates the expression on its right. The comparisons `>`, `>=`, and
`=<` compare numeric values. `**` is float exponentiation, so `9.0 ** 0.5`
is a square root.

---

# The answer

```sh
eyeprolog examples/floating-point.pl
```

```text
value(sum, 3.75).
value(difference, 6.875).
value(product, 10.0).
value(quotient, 3.75).
value(sqrtByPower, 3.0).
value(mathSum, 1.0).
value(mathProduct, 3.0).
value(comfortable, true).
than(warmer, targetC).
```

Every input here is exactly representable in binary (halves, quarters,
eighths), so every result is exact.

---

# The reason

```text
step(value(quotient, 3.75), rule(6), ['X' = 3.75], [3.75 is 7.5 / 2]).
step(3.75 is 7.5 / 2, builtin, [], []).
step(than(warmer, targetC),
     rule(10),
     ['R' = 21.5, 'T' = 19.25],
     [sample(roomC, 21.5), sample(targetC, 19.25), 21.5 > 19.25]).
```

The arithmetic appears in the proof as its result: `3.75 is 7.5 / 2` is a
`builtin` step. Anyone can check it without trusting the original run.

---

# The check

```text
condition('C1', resolution, ok, 11).
condition('C5', re_decision, ok, 10).
steps(21).
verified(11).
recomputed(10).
trusted(0).
verdict(checked).
```

11 steps cite rules and facts. The other 10 are arithmetic and comparisons,
which the checker evaluates again from scratch.

---

# Try it

- Compute `X is 0.1 + 0.2`. The answer is `0.30000000000000004`: 0.1 and 0.2
  have no exact binary form. Does `0.1 + 0.2 =:= 0.3` succeed?
- Compare `X is 7 / 2` (gives `3.5`) with `X is 7 // 2` (gives `3`).
- Change the room to `23.0`. `than(warmer, targetC)` still holds, but
  `value(comfortable, true)` disappears.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6.
