# Big-number multiplication and powers

## Can a logic program multiply 34-digit numbers exactly?

The example is named after "peasant multiplication", the old
doubling-and-halving method. Its actual job is simpler: it checks that
ordinary relations can carry arbitrarily large integers through native
arithmetic, up to a power with 18,781 digits.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=peasant) ·
[Source](../peasant.pl)

---

# The question

Many languages silently overflow or round once a number exceeds 64 bits.
ISO Prolog integers have no fixed size, so `8367238 ^ 2713` should come back
exact, digit for digit.

The question has two parts: are the answers exact, and can a proof still cite
each computation?

---

# The inputs are explicit

```prolog
want_prod([3, 0]).
want_prod([5, 6]).
want_prod([238, 13]).
want_prod([8367238, 27133]).
want_prod([62713345408367238, 40836723862713345]).
want_prod([4083672386271334562713345408367238, 4083672386271334562713345408367238]).

want_pow([3, 0]).
want_pow([5, 6]).
want_pow([238, 13]).
want_pow([8367238, 2713]).
```

The `want_*` facts name the cases to compute. Without them, `prod/2` would
have to enumerate an infinite domain of number pairs.

---

# The rules

```prolog
prod([A, B], C) :-
  want_prod([A, B]),
  (C is A * B).

pow([A, B], C) :-
  want_pow([A, B]),
  (C is A ^ B).
```

Each rule picks a requested pair and hands the arithmetic to `is/2`. With
integer operands, `^` stays an exact integer.

---

# The answer

```sh
eyeprolog examples/peasant.pl
```

```text
prod([3, 0], 0).
prod([5, 6], 30).
prod([238, 13], 3094).
prod([8367238, 27133], 227028268654).
prod([62713345408367238, 40836723862713345], 2561007568948454773873964883391110).
prod([4083672386271334562713345408367238, 4083672386271334562713345408367238], 16676380158395015918313370200581208707756668987398133546021071748644).
pow([3, 0], 1).
pow([5, 6], 15625).
pow([238, 13], 7861409907565911395902147452928).
```

The tenth answer, `pow([8367238, 2713], …)`, is an exact integer with 18,781
digits. See [`output/peasant.pl`](../output/peasant.pl).

---

# The reason

```text
step(prod([5, 6], 30), rule(11), ['A' = 5, 'B' = 6, 'C' = 30], [want_prod([5, 6]), 30 is 5 * 6]).
step(want_prod([5, 6]), fact(2), [], []).
step(30 is 5 * 6, builtin, [], []).
```

Each answer rests on two things: the request fact and one arithmetic step.
The arithmetic is a built-in step, so the proof does not explain
multiplication. It records the exact equation that was evaluated.

---

# The check

```text
condition('C1', resolution, ok, 20).
condition('C5', re_decision, ok, 10).
steps(30).
verified(20).
recomputed(10).
trusted(0).
verdict(checked).
```

The 20 rule and fact steps replay against the program. The checker
recomputes all 10 arithmetic equations independently, including the
18,781-digit power, and they agree.

---

# Try it

- Add `want_pow([2, 1000])` and compare the result with a known value of
  2¹⁰⁰⁰.
- Write the real peasant algorithm as a recursive relation: halve `A`, double
  `B`, and add `B` when `A` is odd. Then check it against `prod/2` on the same
  inputs.
- Replace `^` with `**`. Does the large power still come back exact?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6.
