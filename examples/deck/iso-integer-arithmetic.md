# ISO integer arithmetic

## What is -7 divided by 3?

It depends on how you round. Standard Prolog has two integer divisions and
two remainders, and they disagree on negative numbers. This example computes
both pairs for -7 and 3, plus a few bit operations, and every answer is
recomputed by the proof checker.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-integer-arithmetic) ·
[Source](../iso-integer-arithmetic.pl)

---

# The question

Dividing -7 by 3 gives -2.33…. Should the integer quotient be -2 (round
toward zero) or -3 (round down)? Whichever it is, the remainder must make
`Quotient * 3 + Remainder = -7` hold. And how do bitwise AND, OR, and shift
behave on small integers?

---

# The rules

```prolog
report(div_mod, quotient_remainder(Q, R)) :-
  Q is -7 div 3,
  R is -7 mod 3.

report(quotient_rem, quotient_remainder(Q, R)) :-
  Q is -7 // 3,
  R is -7 rem 3.

report(bit_mask, Masked) :-
  Masked is 13 /\ 6.

report(bit_union, Union) :-
  Union is 8 \/ 3.

report(left_shift, Shifted) :-
  Shifted is 3 << 2.
```

`div` and `mod` belong together, and so do `//` and `rem`.

---

# The answer

```sh
eyeprolog examples/iso-integer-arithmetic.pl
```

```text
report(div_mod, quotient_remainder(-3, 2)).
report(quotient_rem, quotient_remainder(-2, -1)).
report(bit_mask, 4).
report(bit_union, 11).
report(left_shift, 12).
```

`div` rounds down to -3, and `mod` gives 2, since -3 × 3 + 2 = -7. `//`
rounds toward zero to -2, and `rem` gives -1, since -2 × 3 - 1 = -7. In bits,
13 is `1101` and 6 is `0110`, so AND gives `0100` = 4; 8 OR 3 is `1011` = 11;
and shifting 3 left by two places multiplies it by 4.

---

# The reason

```sh
eyeprolog --proof examples/iso-integer-arithmetic.pl
```

```text
step(-3 is -7 div 3, builtin, [], []).
step(2 is -7 mod 3, builtin, [], []).
step(report(bit_mask, 4), rule(3), ['Masked' = 4], [4 is 13 /\ 6]).
```

Each report rests on its rule and on the arithmetic it performed. The
arithmetic steps are `builtin`: they cite no clause, only the evaluation.

---

# The check

```text
condition('C1', resolution, ok, 5).
condition('C5', re_decision, ok, 7).
recomputed(7).
trusted(0).
verdict(checked).
```

The checker replays the five rule steps and recomputes all seven arithmetic
steps on its own, in a program that contains none of the example's clauses.
Nothing is left on trust, so the verdict is a plain `checked`.

---

# Try it

- Compute `-7 div -3` and `-7 mod -3`. (EyeProlog gives 2 and -1.) Which
  sign does `mod` follow, the dividend's or the divisor's?
- Compute `1 << 100`. Integers are unbounded, so the answer is exact.
- Add a report for `xor` and check it bit by bit.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 6 and 34.
