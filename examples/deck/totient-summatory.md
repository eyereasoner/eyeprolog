# Euler's totient

## How many numbers up to N share no factor with N?

Euler's totient φ(N) counts the integers from 1 to N that are coprime to N,
that is, whose greatest common divisor with N is 1. This example defines φ
literally as that count, using a tabled version of Euclid's algorithm, and
sums it up to 30.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=totient-summatory) ·
[Source](../totient-summatory.pl)

---

# The question

What are φ(36), φ(97), and φ(84), and what is φ(1) + φ(2) + … + φ(30)?

The totient appears throughout number theory and cryptography; RSA key
generation, for example, depends on it. A fast implementation would use the
prime factorization. This one follows the definition, which makes it easy to
trust and to check.

---

# The rules

```prolog
:- table gcd/3.

gcd(A, 0, A) :- (A >= 0).
gcd(A, B, G) :-
  (B > 0),
  (R is A mod B),
  gcd(B, R, G).

coprime_upto(N, K) :-
  between(1, N, K),
  gcd(N, K, 1).

totient(N, Count) :-
  (N > 0),
  countall(coprime_upto(N, _k), Count).
```

`gcd/3` is Euclid's algorithm: replace `(A, B)` by `(B, A mod B)` until the
remainder is 0. `coprime_upto/2` generates each `K` in `1..N` with
`gcd(N, K) = 1`, and `countall/2` counts them. Tabling `gcd/3` lets the many
repeated gcd calls of the summation reuse earlier answers.

---

# The answer

```sh
eyeprolog examples/totient-summatory.pl
```

```text
totient_answer(phi_36, 12).
totient_answer(phi_97, 96).
totient_answer(coprime_count_84, 24).
totient_answer(summatory_phi_30, 278).
```

φ(97) = 96 because 97 is prime: every smaller positive number is coprime to
it. The sum of φ(N) for N up to 30 is 278.

---

# The reason

```text
step(totient(36, 12),
     rule(5),
     ['N' = 36, 'Count' = 12],
     [36 > 0, countall(coprime_upto(36, _k), 12)]).
step(countall(coprime_upto(36, _k), 12), builtin, [], []).
```

φ(36) = 12 holds by the `totient/2` rule, because counting the coprime numbers
up to 36 gave 12. The count itself is recorded as a single built-in step.

---

# The check

```text
condition('C1', resolution, ok, 8).
condition('C5', re_decision, ok, 3).
obligation(builtin, theory_scoped, countall(coprime_upto(36, A), 12)).
obligation(builtin, theory_scoped, sumall(A, (between(1, 30, B), totient(B, A)), 278)).
trusted(4).
verdict(checked_with_obligations).
```

The rule steps replay and the comparisons are recomputed. The four counts and
sums, though, run over the program's own `coprime_upto/2` and `totient/2`, so
the checker cannot recompute them without the program. It reports them as
**obligations**: the verdict holds provided those counts are right.

---

# Try it

- Add `totient_answer(phi_1, P) :- totient(1, P).` and predict the answer.
- For a prime `p`, φ(p) = p − 1. Check it for 89 and 101.
- Remove the `:- table gcd/3.` line and compare `--stats` for the summation.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8.
