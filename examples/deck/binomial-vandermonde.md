# Binomial coefficients and Vandermonde's identity

## Do two ways of counting the same committees agree?

Choosing 8 people from a group of 12 women and 10 men can be counted directly,
or by splitting on how many women are chosen. Vandermonde's identity says the
two counts agree. EyeProlog computes both sides, confirms they are equal, and
proves it.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=binomial-vandermonde) ·
[Source](../binomial-vandermonde.pl)

---

# The question

The binomial coefficient C(N, K) counts the ways to choose K items from N.
Vandermonde's identity states

C(R + S, N) = Σᵢ C(R, i) · C(S, N − i)

The example checks four concrete claims: C(24, 12), the symmetry
C(24, 7) = C(24, 17), the identity for 12, 10 and 8, and that row 12 of
Pascal's triangle sums to 2¹².

---

# Computing a coefficient

```prolog
choose(N, K, C) :-
  (K >= 0),
  (K =< N),
  choose_step(N, K, 0, 1, C).

choose_step(_n, K, K, Acc, Acc).
choose_step(N, K, I, Acc, C) :-
  (I < K),
  (I1 is I + 1),
  (Factor is N - I),
  (Numerator is Acc * Factor),
  (Nextacc is Numerator / I1),
  choose_step(N, K, I1, Nextacc, C).
```

`choose_step/5` walks the recurrence C(N, i+1) = C(N, i) · (N − i) / (i + 1)
with an accumulator. It is declared `:- table choose_step/5.`, so prefixes
shared by both sides of the identity are computed once.

---

# Both sides of the identity

```prolog
vandermonde_sum(N, M, R, Sum) :-
  sumall(Product,
    (between(0, R, K),
     (Rk is R - K),
     choose(N, K, A),
     choose(M, Rk, B),
     (Product is A * B)),
    Sum).

vandermonde(N, M, R, Sum) :-
  (Totaln is N + M),
  choose(Totaln, R, Sum),
  vandermonde_sum(N, M, R, Sum).
```

`vandermonde/4` computes the left side with `choose/3` and then requires the
sum over all splits to be the *same* `Sum`. The identity holds only if both
computations agree.

---

# The answer

```sh
eyeprolog examples/binomial-vandermonde.pl
```

```text
binomial_answer(choose_24_12, 2704156.0).
binomial_answer(symmetry_24_7, true).
binomial_answer(vandermonde_12_10_8, 319770.0).
binomial_answer(row_12_sum, 4096.0).
```

The values are floats because `/` always produces a float in ISO Prolog, even
when the division is exact.

---

# The reason

```text
step(vandermonde(12, 10, 8, 319770.0),
     rule(7),
     ['N' = 12, 'M' = 10, 'R' = 8, 'Sum' = 319770.0, 'Totaln' = 22],
     [22 is 12 + 10, choose(22, 8, 319770.0), vandermonde_sum(12, 10, 8, 319770.0)]).
step(22 is 12 + 10, builtin, [], []).
```

The identity holds because one step uses both `choose(22, 8, 319770.0)` and
`vandermonde_sum(12, 10, 8, 319770.0)`: the direct count and the sum over
splits arrived at the same number.

---

# The check

```text
condition('C1', resolution, ok, 59).
condition('C5', re_decision, ok, 145).
obligation(builtin, theory_scoped, sumall(A, (between(0, 8, B), C is 8 - B, choose(12, B, D), choose(10, C, E), A is D * E), 319770.0)).
obligation(builtin, theory_scoped, sumall(A, (between(0, 12, B), choose(12, B, A)), 4096.0)).
verdict(checked_with_obligations).
```

59 rule steps were replayed and 145 arithmetic steps were recomputed. The two
`sumall/3` totals are **obligations**: a sum over a nested search that calls
program predicates cannot be recomputed without the program, so the checker
names it as a trusted boundary instead of claiming it.

---

# Try it

- Change `/` to `//` in `choose_step/5`. Every answer becomes an integer
  (`2704156`, `319770`, `4096`), because each division in the recurrence is
  exact.
- Check the identity for 20, 15 and 10. The answer is `183579396.0`.
- Which part of the proof would grow if you removed the `table` declaration,
  and which answers would stay the same?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 8 and 26.
