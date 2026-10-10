# Collatz trajectories for 1 to 1000

## Does every start from 1 to 1000 reach 1?

Halve an even number, triple an odd one and add 1, and repeat. The Collatz
conjecture says every positive start eventually reaches 1. EyeProlog computes
the full trajectory of every start from 1000 down to 1, with tabling so shared
tails are computed once.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=collatz-1000) ·
[Source](../collatz-1000.pl)

---

# The question

Starting from 6: 6, 3, 10, 5, 16, 8, 4, 2, 1. Nobody has proved that every
start ends at 1, but it has been checked for enormous ranges. Here the claim
is checked for 1 to 1000, with each trajectory returned as a list.

---

# The relation

```prolog
collatz(1, [1]).
collatz(N, [N|J]) :-
  (N > 1),
  (0 is N mod 2),
  (N1 is N // 2),
  collatz(N1, J).
collatz(N, [N|J]) :-
  (N > 1),
  (1 is N mod 2),
  (T is 3 * N),
  (N1 is T + 1),
  collatz(N1, J).
```

`collatz(N, M)` relates a start `N` to its trajectory `M`. One clause per case:
reached 1, even, or odd. The recursion stops only because the trajectory
reaches 1, which is exactly what the conjecture claims.

---

# Generating the starts

```prolog
:- table collatz/2.

collatzTrajectory(N, M) :-
  repeat(1000, N0),
  (N is 1000 - N0),
  collatz(N, M).

repeat(N, I) :-
  (Last is N - 1),
  between(0, Last, I).
```

`between/3` enumerates 0 to 999, giving starts 1000 down to 1. `:- table
collatz/2.` remembers each trajectory: once the tail from 40 is known, every
later start that passes through 40 reuses it.

---

# The answer

```sh
eyeprolog examples/collatz-1000.pl
```

```text
collatzTrajectory(1000, [1000, 500, 250, 125, 376, 188, 94, 47, …, 16, 8, 4, 2, 1]).
collatzTrajectory(999, [999, 2998, 1499, 4498, 2249, 6748, 3374, 1687, …, 16, 8, 4, 2, 1]).
…
collatzTrajectory(2, [2, 1]).
collatzTrajectory(1, [1]).
```

1000 answers, one per start, all ending in 1. The longest trajectory starts at
871 and has 179 entries.

---

# The reason

```text
step(collatz(4, [4, 2, 1]),
     rule(5),
     ['N' = 4, 'J' = [2, 1], 'N1' = 2],
     [4 > 1, 0 is 4 mod 2, 2 is 4 // 2, collatz(2, [2, 1])]).
step(collatz(2, [2, 1]),
     rule(5),
     ['N' = 2, 'J' = [1], 'N1' = 1],
     [2 > 1, 0 is 2 mod 2, 1 is 2 // 2, collatz(1, [1])]).
step(collatz(1, [1]), fact(4), [], []).
```

Read from the bottom: 1 is the base fact; 2 is even and halves to 1; 4 is even
and halves to 2. Each trajectory is proved once, and every longer trajectory
that passes through it cites that one step.

---

# The check

```text
condition('C1', resolution, ok, 4228).
condition('C5', re_decision, ok, 9497).
steps(13725).
claims(1000).
trusted(0).
verdict(checked).
```

1000 claims rest on 13,725 steps: 4,228 rule applications and 9,497
arithmetic facts, all rechecked. The proof is a certificate for this range
only; it says nothing about starts above 1000.

---

# Try it

- Ask for one start: `--goal 'collatz(27, M)'`. Its trajectory has 112
  entries; at what value does it peak?
- Remove `:- table collatz/2.` and compare `--stats` for the full run.
- Write `collatz_length(N, L)` that returns only the number of steps, and find
  the start below 1000 with the longest trajectory.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
