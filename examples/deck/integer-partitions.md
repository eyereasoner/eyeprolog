# Integer partitions

## In how many ways can a number be written as a sum?

The number 4 can be written as 4, 3+1, 2+2, 2+1+1 and 1+1+1+1: five
**partitions**, where order does not matter. Counting them by brute force
explodes quickly. This example counts them with a two-branch recursion and
lets tabling remember every subproblem, a dynamic program written as logic.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=integer-partitions) ·
[Source](../integer-partitions.pl)

---

# The question

How many partitions do 12 and 15 have? How many partitions of 16 use parts
no larger than 5? And what is the total number of partitions of 1 through 8?

---

# The recursion

`partitions(N, K, Count)` counts the partitions of `N` into parts no larger
than `K`. Every such partition either **uses** a part of size `K` or it
**doesn't**:

```prolog
partitions(N, K, Count) :-
  (N > 0),
  (K > 0),
  (K =< N),
  (Remainder is N - K),
  partitions(Remainder, K, Withk),
  (K1 is K - 1),
  partitions(N, K1, Withoutk),
  (Count is Withk + Withoutk).
```

Using a `K` leaves `N - K` to partition with parts up to `K`; not using it
leaves `N` with parts up to `K - 1`. Base cases: zero has exactly one
partition (the empty sum), and a positive number with no parts allowed has
none.

---

# Remembering subproblems

```prolog
:- table partitions/3.
```

The two branches reach the same `(N, K)` pairs again and again. The table
stores each answer the first time it is computed and reuses it afterwards,
turning an exponential search into a fast computation. The relation means
the same with or without the table; only the work changes.

---

# The answer

```sh
eyeprolog examples/integer-partitions.pl
```

```text
partition_answer(p_12, 77).
partition_answer(p_15, 176).
partition_answer(p_16_using_parts_at_most_5, 101).
partition_answer(cumulative_p_1_to_8, 66).
```

`p(12) = 77` and `p(15) = 176`, matching the published values of the
partition function.

---

# The reason

```sh
eyeprolog --proof examples/integer-partitions.pl
```

```text
step(partition_answer(p_12, 77), rule(7), ['Count' = 77], [partition_count(12, 77)]).
step(partition_count(12, 77), rule(6), ['N' = 12, 'Count' = 77], [partitions(12, 12, 77)]).
```

`p(12) = 77` because `partitions(12, 12, 77)` holds. That step splits into
`Withk = 1` (the partition "12" itself) and `Withoutk = 76` (all partitions
using parts up to 11), and so on down to the base cases. Because each
conclusion gets one step, a shared subproblem is proved once and cited
wherever it is used; the whole proof has 476 steps.

---

# The check

```text
condition('C1', resolution, ok, 168).
condition('C5', re_decision, ok, 307).
obligation(builtin, theory_scoped, sumall(A, (between(1, 8, B), partition_count(B, A)), 66)).
verdict(checked_with_obligations).
```

168 rule steps replay and 307 arithmetic steps are recomputed. One step is
an **obligation**: the `sumall/3` total of 66 depends on the program's own
`partition_count/2`, so the checker cannot recompute it in isolation and
records it as a trusted boundary. Everything else is checked.

---

# Try it

- Add `partition_answer(p_5, C) :- partition_count(5, C).` and check the
  answer, 7, by listing the partitions of 5 by hand.
- Ask for `p(100)`. With the table it answers 190569292 in well under a
  second; remove `:- table partitions/3.` and see how far you get.
- Count partitions into *distinct* parts by changing one recursive call.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13.
