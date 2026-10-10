# Towers of Hanoi

## How do you move a tower of three disks, one disk at a time?

The classic puzzle, solved by a two-clause recursion that mirrors the way people
explain it: move the smaller tower aside, move the largest disk, move the
smaller tower back on top.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=hanoi) ·
[Source](../hanoi.pl)

---

# The question

Three pegs, a stack of disks on the left peg, largest at the bottom. Move the
whole stack to the right peg, one disk at a time, never putting a larger disk
on a smaller one. What is the sequence of moves?

---

# The rules

```prolog
hanoi(0, _from, _to, _via, []).
hanoi(N, From, To, Via, Moves) :-
  (N > 0),
  (N1 is N - 1),
  hanoi(N1, From, Via, To, Before),
  hanoi(N1, Via, To, From, After),
  append(Before, [[From, To]|After], Moves).

answer(3, Moves) :-
  hanoi(3, left, right, center, Moves).
```

Moving zero disks takes no moves. Moving `N` disks means: move `N-1` to the
spare peg (`Before`), move the largest disk `[From, To]`, then move the `N-1`
disks on top of it (`After`). The disk count goes down on every call, so the
recursion ends.

---

# The answer

```sh
eyeprolog examples/hanoi.pl
```

```text
answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]).
```

Seven moves; the fourth, `[left, right]`, is the largest disk.

---

# The reason

```text
step(hanoi(3, left, right, center, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]),
     rule(2),
     ['N' = 3,
      'From' = left,
      'To' = right,
      'Via' = center,
      'Moves' = [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]],
      'N1' = 2,
      'Before' = [[left, right], [left, center], [right, center]],
      'After' = [[center, left], [center, right], [left, right]]],
     ...
```

The step for three disks shows the split: three moves to park two disks on the
centre peg, the big move, then three moves to bring them over.

---

# The check

```text
condition('C1', resolution, ok, 10).
condition('C5', re_decision, ok, 12).
verdict(checked).
```

The 10 rule steps replay against `hanoi/5` and `answer/2`. The 12 built-in
steps (the `>` tests, the `is` subtractions, and the `append/3` calls) were
recomputed independently and agreed. Nothing is trusted.

---

# Try it

- Add `answer(4, Moves) :- hanoi(4, left, right, center, Moves).` and count
  the moves. (15, that is 2⁴ − 1.)
- Why does the recursive clause need `N > 0`? Remove it and ask for
  `hanoi(1, left, right, center, M)`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 19.
