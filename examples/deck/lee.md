# Lee routing

## How do you route a wire around obstacles on a chip?

Lee's algorithm finds a shortest wire route on a grid by sending out waves from
the source until one reaches the destination, then tracing back. This program
comes from Chapter 16 of Sterling and Shapiro's *The Art of Prolog*, and
EyeProlog runs it unchanged.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=lee) ·
[Source](../lee.pl)

---

# The question

On a grid, connect point `(1, 1)` to point `(9, 8)` with a wire that moves one
cell at a time horizontally or vertically. Two rectangular obstacles,
`(2,3)–(4,5)` and `(6,6)–(8,8)`, must be avoided. What is a shortest route?

---

# Waves

```prolog
waves(B, [Wave|Waves], _, Waves) :-
    member(B, Wave),
    !.
waves(B, [Wave, LastWave|LastWaves], Obstacles, Waves) :-
    next_wave(Wave, LastWave, Obstacles, NextWave),
    waves(B, [NextWave, Wave, LastWave|LastWaves], Obstacles, Waves).

next_wave(Wave, LastWave, Obstacles, NextWave) :-
    setof(X, admissible(X, Wave, LastWave, Obstacles), NextWave).
```

Each wave is the set of cells one step farther from the source than the last
one. A cell is admissible when it neighbours the current wave, is not blocked,
and is in neither of the last two waves. Expansion stops when the destination
appears in a wave.

---

# Tracing back

```prolog
path(A, A, _, [A]) :-
    !.
path(A, B, [Wave|Waves], [B|Path]) :-
    member(B1, Wave),
    neighbor(B, B1),
    !,
    path(A, B1, Waves, Path).
```

From the destination, step to any neighbour in the previous wave, and repeat
until the source is reached. Because waves grow one step at a time, the
traced path is a shortest one.

---

# The answer

```sh
eyeprolog examples/lee.pl
```

```text
route([[1, 1], [9, 8], [[[2, 3], [4, 5]], [[6, 6], [8, 8]]]], [[9, 8], [9, 7], [9, 6], [9, 5], [8, 5], [7, 5], [6, 5], [5, 5], [5, 4], [5, 3], [5, 2], [4, 2], [3, 2], [2, 2], [1, 2], [1, 1]]).
```

The route has 16 cells, so 15 moves: exactly the Manhattan distance
`|9 − 1| + |8 − 1|`. The obstacles cost no detour, only a particular path
around them.

---

# The reason

```sh
eyeprolog --proof examples/lee.pl
```

```text
step(next_wave([[1, 1]], [], [[[2, 3], [4, 5]], [[6, 6], [8, 8]]], [[0, 1], [1, 0], [1, 2], [2, 1]]),
     rule(4),
     ['Wave' = [[1, 1]],
      'LastWave' = [],
```

The first wave from `(1, 1)` is its four neighbours. Each later wave has its
own step, and the trace-back steps show which neighbour was chosen at each
cell.

---

# The check

```text
condition('C1', resolution, ok, 71).
condition('C5', re_decision, ok, 33).
steps(119).
verified(71).
recomputed(33).
trusted(15).
claims(1).
verdict(checked_with_obligations).
```

71 steps are replayed and 33 arithmetic and list steps recomputed. The 15
`setof/3` calls that build the waves are reported as obligations: the checker
cannot recompute them without running the program's own `admissible/4`
search, so the route is certified *given* that each wave is complete.

---

# Try it

- Remove both obstacles (`route([[1, 1], [9, 8], []], _)`). The route is still
  15 moves, but it now runs up the left column and along the top.
- Add a wall that forces a real detour, and check that the route grows longer
  than the Manhattan distance.
- Why does `admissible/4` exclude the last *two* waves, not just the last one?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
