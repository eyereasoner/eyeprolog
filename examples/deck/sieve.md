# Primes below 1000

## Which numbers up to 1000 are prime?

A prime generator in plain Prolog. It skips most composite numbers before
testing them, using the fact that every prime above 3 is one more or one less
than a multiple of 6, and then tries divisors only up to the square root.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=sieve) ·
[Source](../sieve.pl)

---

# The question

List every prime number up to 1000, in order.

Testing every number against every smaller one would work, but it wastes
time on numbers that are obviously even or multiples of 3. The program avoids
generating those at all.

---

# The candidate wheel

```prolog
prime_under(Limit, 2) :-
  (Limit >= 2).

prime_under(Limit, 3) :-
  (Limit >= 3).

prime_candidate(Current, High, _, Current) :-
  (Current =< High).

prime_candidate(Current, High, Step, Value) :-
  (Current < High),
  (Next is Current + Step),
  (NextStep is 6 - Step),
  !,
  prime_candidate(Next, High, NextStep, Value).
```

Starting at 5 and stepping by 2, then 4, then 2, … gives 5, 7, 11, 13, 17,
19, …: exactly the numbers of the form 6k − 1 and 6k + 1. Every larger
multiple of 2 or 3 is skipped.

---

# The primality test

```prolog
prime_from(N, Divisor, _) :-
  (Divisor * Divisor > N).

prime_from(N, Divisor, Step) :-
  (Divisor * Divisor =< N),
  (N mod Divisor =\= 0),
  (Next is Divisor + Step),
  (NextStep is 6 - Step),
  !,
  prime_from(N, Next, NextStep).

primes(Limit, Ps) :-
  want_primes(Limit),
  findall(P, prime_under(Limit, P), Ps).
```

A candidate is prime if no divisor from the same wheel divides it, up to its
square root: a composite number always has a factor no larger than that.
`findall/3` collects all primes into one list.

---

# The answer

```sh
eyeprolog examples/sieve.pl
```

```text
primes(1000, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, …, 991, 997]).
```

One answer: a list of the 168 primes below 1000 (shortened here; see the
[full output](../output/sieve.pl)).

---

# The reason

```text
step(want_primes(1000), fact(1), [], []).
```

The proof is three steps: `primes/2` by its rule, the `want_primes(1000)` fact
above, and one `collected` step that records the whole result of
`findall(P, prime_under(1000, P), …)`. The proof does not list 168 separate
primality arguments; it treats the collection as a single conclusion.

---

# The check

```text
condition('C1', resolution, ok, 2).
condition('C6', boundary_consistency, ok, 0).
trusted(1).
verdict(checked_with_obligations).
```

The checker verifies the two rule and fact steps. The `findall/3` result is a
**trusted boundary**: confirming that the list contains *all* primes and only
primes would mean redoing the search, which a checker never does. The verdict
`checked_with_obligations` records that the list itself is taken as given.

---

# Try it

- Change `want_primes(1000)` to `want_primes(100)`. You get the 25 primes
  below 100.
- Add `prime_count(N) :- primes(_, Ps), length(Ps, N).` to count them.
- Remove the cut in `prime_from/3`. Do the answers change?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 6 and 8.
