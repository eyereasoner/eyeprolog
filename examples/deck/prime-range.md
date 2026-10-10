# Prime range and totient

## Which numbers up to 30 are prime, and how many numbers below 271 are coprime to it?

A prime is a number with no proper divisor, which is a statement about
absence. This example writes it exactly that way, with negation as failure,
and adds Euler's totient function computed from Euclid's algorithm.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=prime-range) ·
[Source](../prime-range.pl)

---

# The question

Two classic number-theory questions over finite domains:

- Which integers from 2 to 30 are **prime**?
- What is **Euler's totient** φ(271), the count of integers from 1 to 271
  that share no factor with 271?

For a prime `p`, φ(p) = p − 1, so the second answer also tests whether 271 is
prime.

---

# The rules

```prolog
candidate(N) :-
  between(2, 30, N).

composite(N) :-
  candidate(N),
  between(2, N, D),
  (D < N),
  (0 is N mod D).

prime(N) :-
  candidate(N),
  \+ composite(N).
```

A composite has a divisor strictly between 1 and itself. A prime is a
candidate that is **not** composite. The candidate is bound before the
negation runs, so `\+` asks a finite, ground question.

---

# Euclid and the totient

```prolog
gcd(N, 0, N).
gcd(N, M, G) :-
  (M > 0),
  (R is N mod M),
  gcd(M, R, G).

coprime(N, K) :-
  between(1, N, K),
  gcd(N, K, 1).

totient(N, Phi) :-
  countall(coprime(N, _k), Phi).
```

Euclid's algorithm replaces `(N, M)` by `(M, N mod M)` until the remainder is
zero. The totient counts the `K` whose greatest common divisor with `N` is 1.

---

# The answer

```sh
eyeprolog examples/prime-range.pl
```

```text
prime_result(range_2_30, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]).
prime_result(count_2_30, 10).
prime_result(totient_271, 270).
```

Ten primes up to 30, and φ(271) = 270, which confirms that 271 is prime.

---

# The reason

```sh
eyeprolog --proof examples/prime-range.pl
```

```text
step(prime_result(totient_271, 270), rule(10), ['Phi' = 270], [totient(271, 270)]).
step(totient(271, 270), rule(7), ['N' = 271, 'Phi' = 270], [countall(coprime(271, _k), 270)]).
step(countall(coprime(271, _k), 270), builtin, [], []).
```

The totient answer follows from the `totient/2` rule and a count of 270
solutions. The proof records the count itself as one step rather than 270
separate gcd derivations.

---

# The check

```text
condition('C1', resolution, ok, 4).
condition('C7', relevance, ok, 10).
obligation(collected, theory_scoped, findall(A, prime(A), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29])).
obligation(builtin, theory_scoped, countall(prime(A), 10)).
obligation(builtin, theory_scoped, countall(coprime(271, A), 270)).
trusted(3).
verdict(checked_with_obligations).
```

The four rule steps check out. The three collections are **obligations**: a
checker can refute a list of solutions if it finds a missing or extra one,
but it cannot prove the list complete without redoing the search. The verdict
says exactly that, rather than claiming more.

---

# Try it

- Raise the bound in `candidate/1` from 30 to 100 and predict the prime count.
- Compute `totient(272, Phi)` and explain why it is far below 271.
- `composite/1` tries every `D` up to `N`. Which bound on `D` would be enough,
  and does the answer change?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 7 (negation) and 8 (collecting answers).
