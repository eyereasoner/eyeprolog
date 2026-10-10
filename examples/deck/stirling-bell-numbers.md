# Stirling and Bell numbers

## In how many ways can a set be split into groups?

Ten people can be split into four non-empty teams in 34105 ways, and into any
number of teams in 115975 ways. These counts are the **Stirling numbers of
the second kind** and the **Bell numbers**. This example computes them from
closed formulas, not by listing every partition.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=stirling-bell-numbers) ·
[Source](../stirling-bell-numbers.pl)

---

# The question

A **partition** of a set splits it into non-empty, non-overlapping blocks
whose order does not matter.

- `S(n, k)`, a Stirling number of the second kind, counts the partitions of
  `n` elements into exactly `k` blocks.
- `B(n)`, a Bell number, counts all partitions of `n` elements.

The example asks for `S(10, 4)`, `S(12, 5)`, `B(10)`, and `B(12)`.

---

# The formulas

Stirling numbers by inclusion–exclusion:

S(n, k) = (1 / k!) · Σᵢ₌₀..ₖ (−1)^(k−i) · C(k, i) · iⁿ

Bell numbers by recurrence:

B(0) = 1, B(n) = Σₖ₌₀..ₙ₋₁ C(n−1, k) · B(k)

---

# The rules

```prolog
stirling2(N, K, Count) :-
  (N > 0),
  (K > 0),
  sumall(Term, (between(0, K, I), signed_term(N, K, I, Term)), Sum),
  factorial(K, Factorial),
  (Count is Sum / Factorial).

bell(0, 1).
bell(N, Count) :-
  (N > 0),
  (N1 is N - 1),
  sumall(Term, (between(0, N1, K), binomial(N1, K, Choose), bell(K, Bell), (Term is Choose * Bell)), Count).
```

`sumall/3` adds a template over all solutions of a goal: here, the terms of
each sum. `signed_term/4` computes one term with the right sign, and
`binomial/3` builds `C(n, k)` from Pascal's rule.

---

# The answer

```sh
eyeprolog examples/stirling-bell-numbers.pl
```

```text
stirling_bell_answer(stirling_10_4, 34105.0).
stirling_bell_answer(stirling_12_5, 1379400.0).
stirling_bell_answer(bell_10, 115975).
stirling_bell_answer(bell_12, 4213597).
```

The Stirling numbers print as floats because the program raises numbers with
`**`, which in ISO Prolog is float exponentiation, and then divides with `/`.
The Bell numbers stay exact integers.

---

# The reason

```sh
eyeprolog --proof examples/stirling-bell-numbers.pl
```

```text
step(bell(10, 115975),
     rule(14),
     ['N' = 10, 'Count' = 115975, 'N1' = 9],
     [10 > 0,
      9 is 10 - 1,
      sumall(Expression, (between(0, 9, K), binomial(9, K, Choose), bell(K, Bell), Expression is Choose * Bell), 115975)]).
```

`B(10) = 115975` follows from the recurrence with `n − 1 = 9` and a sum over
`k = 0..9` that comes to 115975.

---

# The check

```text
condition('C1', resolution, ok, 14).
condition('C5', re_decision, ok, 21).
obligation(builtin, theory_scoped, sumall(A, (between(0, 9, B), binomial(9, B, C), bell(B, D), A is C * D), 115975)).
obligation(builtin, theory_scoped, sumall(A, (between(0, 4, B), signed_term(10, 4, B, A)), 818520.0)).
trusted(4).
verdict(checked_with_obligations).
```

The rule steps and 21 arithmetic steps check. The four sums are
**obligations**: each calls back into this program (`bell/2`,
`signed_term/4`), so a checker that never searches can only record that the
verdict depends on them. The inner sum for `S(10, 4)` is 818520, and
818520 / 4! = 34105.

---

# Try it

- Replace `**` with `^` and `/` with `//` in the Stirling rules. The results
  become exact integers: `34105` and `1379400`.
- Check that `B(n)` equals the sum of `S(n, k)` for `k = 0..n`, for `n = 5`.
- List the partitions of `{a, b, c}` by hand and confirm `S(3, 2) = 3` and
  `B(3) = 5`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 27 (recursion and induction) and 29 (counting).
