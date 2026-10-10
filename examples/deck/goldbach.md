# Goldbach for powers of two

## Can each power of two from 4 to 2²⁵ be written as a sum of two primes?

Goldbach's conjecture says every even number greater than 2 is the sum of two
primes. Nobody has proved it. This example does something smaller and
checkable: it finds a witness pair for each of 24 specific even numbers, and
the proof certifies every witness.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=goldbach) ·
[Source](../goldbach.pl)

---

# The question

For `N = 2^I` with `I` from 2 to 25, find primes `P` and `Q` with
`P + Q = N`.

A run that succeeds proves 24 concrete facts. It says nothing about the
infinitely many other even numbers; the conjecture stays open.

---

# The search

```prolog
goldbach(4, [2, 2]).
goldbach(N, L) :-
    0 =:= N rem 2,
    N > 4,
    goldb(N, L, 3).

goldb(N, [P, Q], P) :-
    Q is N-P,
    is_prime(Q),
    !.
goldb(N, L, P) :-
    P < N,
    next_prime(P, P1),
    goldb(N, L, P1).
```

Starting from `P = 3`, try `Q = N − P`. If `Q` is prime, stop (the cut keeps
the first pair); otherwise move `P` to the next odd prime and try again.

---

# Primality and the cases

```prolog
is_prime(2).
is_prime(3).
is_prime(P) :-
    P > 3,
    1 =:= P rem 2,
    smallest_divisor_from(P, 3, P).

case(N, G) :-
    between(2, 25, I),
    N is 2^I,
    goldbach(N, G).
```

An odd number is prime when its smallest divisor from 3 upward is itself.
`smallest_divisor_from/3` comes from `library(primes)`.

---

# The answer

```sh
eyeprolog examples/goldbach.pl
```

```text
case(4, [2, 2]).
case(8, [3, 5]).
case(16, [3, 13]).
case(32, [3, 29]).
case(64, [3, 61]).
case(128, [19, 109]).
...
case(33554432, [61, 33554371]).
```

24 answers, one per power of two. The smallest working `P` is often 3, but
128 needs 19 and 2²⁵ needs 61.

---

# The reason

```sh
eyeprolog --proof examples/goldbach.pl
```

```text
step(case(64, [3, 61]),
     rule(12),
     ['N' = 64, 'G' = [3, 61], 'I' = 6],
     [between(2, 25, 6), 64 is 2 ^ 6, goldbach(64, [3, 61])]).
step(goldbach(64, [3, 61]),
     rule(2),
     ['N' = 64, 'L' = [3, 61]],
     [0 =:= 64 rem 2, 64 > 4, goldb(64, [3, 61], 3)]).
```

64 is case 6 because `64 is 2 ^ 6`; it is even and greater than 4, and the
search starting at 3 found the pair `[3, 61]`. Further steps show that 61 is
prime.

---

# The check

```text
condition('C1', resolution, ok, 206).
condition('C5', re_decision, ok, 323).
steps(529).
verified(206).
recomputed(323).
trusted(0).
claims(24).
verdict(checked).
```

The checker replayed 206 steps against program clauses and recomputed 323
arithmetic and library steps itself, including every primality test. Nothing
is taken on trust, so each of the 24 witnesses is certified.

---

# Try it

- Ask for every even number from 6 to 20 instead of powers of two:
  `even_case(N, G) :- between(3, 10, I), N is 2*I, goldbach(N, G).` gives
  `even_case(12, [5, 7])` and `even_case(18, [5, 13])` among eight answers.
- Remove the cut in the first `goldb/3` clause. How many pairs does
  `goldbach(100, L)` now give?
- What would a *counterexample* look like as a query, and why can a finite run
  never prove the conjecture?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
