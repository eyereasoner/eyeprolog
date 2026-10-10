# Naive reverse

## How much work does it take to reverse a list the slow way?

Naive reverse is the classic Prolog benchmark: it reverses a 30-element list
with a deliberately inefficient program, so every implementation does the same
amount of work. EyeProlog runs it, proves the result, and checks all 498 steps
of that proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=bench) ·
[Source](../bench.pl)

---

# The question

What is the list `[1, 2, ..., 30]` backwards, and what does it cost to find
out with the textbook program?

The benchmark dates from Quintus Prolog in 1984. Systems were compared by how
many of these logical inferences they performed per second (LIPS), so the
program is chosen for predictable work, not for speed.

---

# The rules

```prolog
nrev([], []).
nrev([X|Rest], Ans) :-
    nrev(Rest, L),
    concatenate(L, [X], Ans).

concatenate([], L, L).
concatenate([X|L1], L2, [X|L3]) :-
    concatenate(L1, L2, L3).
```

To reverse a list, reverse its tail and append the head at the end. Appending
walks the whole reversed tail each time, so a list of length *n* costs about
*n²/2* concatenation steps.

---

# The data

```prolog
data([1,2,3,4,5,6,7,8,9,10,
      11,12,13,14,15,16,17,18,19,20,
      21,22,23,24,25,26,27,28,29,30]).

bench_result(Reversed) :-
    data(List),
    nrev(List, Reversed).
```

The file also keeps the original harness predicates `dobench/1` and
`dodummy/1`, which time many repetitions and subtract the cost of an empty
loop.

---

# The answer

```sh
eyeprolog examples/bench.pl
```

```text
bench_result([30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]).
```

---

# The reason

```sh
eyeprolog --proof examples/bench.pl
```

```text
step(nrev([30], [30]),
     rule(2),
     ['X' = 30, 'Rest' = [], 'Ans' = [30], 'L' = []],
     [nrev([], []), concatenate([], [30], [30])]).
step(nrev([], []), fact(1), [], []).
step(concatenate([], [30], [30]), fact(3), ['L' = [30]], []).
```

The innermost call reverses the one-element list `[30]`: reverse the empty
tail (fact 1), then append `[30]` to the empty list (fact 3). Every larger
reversal in the proof is built the same way, one level up.

---

# The check

```text
condition('C1', resolution, ok, 498).
condition('C4', coverage, ok, 498).
condition('C7', relevance, ok, 499).
trusted(0).
verdict(checked).
```

The checker replays all 498 steps against the clauses they cite. No arithmetic
or library call is involved, so nothing is taken on trust: the whole reversal
is checked from the program alone.

---

# Try it

- Extend `data/1` to 40 elements. The checked proof grows from 498 to 863
  steps: the quadratic cost is visible in the proof itself.
- Replace `nrev/2` with an accumulator version,
  `rev([X|Xs], A, R) :- rev(Xs, [X|A], R).`. The same 30-element reversal
  then needs only 34 checked steps.
- Ask `--goal 'nrev([a, b, c], R)'` with `--proof` and count the steps. Can
  you predict the count for a list of length *n* before running it?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 5 and 23.
