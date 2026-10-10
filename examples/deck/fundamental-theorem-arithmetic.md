# Prime factors of 202,692,987

## Which primes multiply to this number, and how do we know the list is right?

The fundamental theorem of arithmetic says every whole number above 1 is a
product of primes in exactly one way. This example factors 202,692,987, reads
the factors in both orders, and checks that multiplying them back gives the
original number.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=fundamental-theorem-arithmetic) ·
[Source](../fundamental-theorem-arithmetic.pl)

---

# The question

What are the prime factors of 202,692,987? A factorization is only convincing
with two checks attached: every factor is prime, and the product of the
factors is the number we started with.

---

# The factorization rules

```prolog
factor_smallest(N, [N]) :-
  (N >= 2),
  smallest_divisor_from(N, 2, N).

factor_smallest(N, Factors) :-
  (N >= 2),
  smallest_divisor_from(N, 2, D),
  (D \= N),
  (Q is N // D),
  factor_smallest(D, Left),
  factor_smallest(Q, Right),
  append(Left, Right, Factors).
```

A number whose smallest divisor is itself is prime and is its own
factorization. Otherwise split off the smallest divisor `D`, factor `D` and
the quotient `Q`, and join the lists. `smallest_divisor_from/3` comes from
`library(primes)`.

---

# The checks

```prolog
factor_product([], 1).
factor_product([X|Rest], P) :-
  factor_product(Rest, P0),
  (P is X * P0).

productReconstructsInput(case, true) :-
  case(fta, N),
  factor_smallest(N, Factors),
  factor_product(Factors, N).
```

The product of the factors must equal `N` itself: the same variable appears
in both places, so a wrong factor list simply fails.

---

# The answer

```sh
eyeprolog examples/fundamental-theorem-arithmetic.pl
```

```text
n(case, 202692987).
factorsSmallest(case, [3, 3, 7, 829, 3881]).
factorsLargest(case, [3881, 829, 7, 3, 3]).
product(case, 202692987).
expectedFactorsMatched(case, true).
productReconstructsInput(case, true).
distinctPrimeCount(case, 4).
smallestPrimeFactor(case, 3).
largestPrimeFactor(case, 3881).
```

202,692,987 = 3 × 3 × 7 × 829 × 3881, with four distinct primes.

---

# The reason

```text
step(factor_smallest(202692987, [3, 3, 7, 829, 3881]),
     rule(10),
     ['N' = 202692987,
      'Factors' = [3, 3, 7, 829, 3881],
      'D' = 3,
      'Q' = 67564329,
      'Left' = [3],
      'Right' = [3, 7, 829, 3881]],
     ...
```

The first split: the smallest divisor of 202,692,987 is 3, leaving
67,564,329, whose factors are found the same way. The proof records each split
and each arithmetic step.

---

# The check

```text
condition('C1', resolution, ok, 31).
condition('C5', re_decision, ok, 37).
verdict(checked).
```

The 31 rule and fact steps replay against their clauses. The 37 built-in steps
(divisor searches, divisions, comparisons, multiplications, list joins) were
recomputed independently and agreed. Nothing is trusted.

---

# Try it

- Change the case to `case(fta, 1001).` The factors become `[7, 11, 13]`, the
  product still reconstructs the input, and the expected-factors,
  smallest-factor and largest-factor answers disappear because they were
  written for the original number.
- Notice that `distinctPrimeCount(case, 4)` still appears for 1001. It is
  derived from four hard-coded primality checks, not from the factors. How
  would you compute it from `factorsSmallest/2` instead?
- The file declares `:- table factor_smallest/2.` Which calls would be
  repeated without it?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 26.
