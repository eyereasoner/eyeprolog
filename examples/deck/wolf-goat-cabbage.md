# Wolf, goat and cabbage

## How does a farmer cross the river without losing anything?

A farmer must ferry a wolf, a goat and a cabbage across a river in a boat that
holds only the farmer and one passenger. Left alone, the wolf eats the goat and
the goat eats the cabbage. EyeProlog searches the states of the riverbank and
finds every safe crossing plan.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=wolf-goat-cabbage) ·
[Source](../wolf-goat-cabbage.pl)

---

# The question

Which sequences of crossings move everyone from the west bank to the east bank
without ever leaving the goat alone with the wolf or with the cabbage?

This is a **state-space search**: describe the states, the moves between them,
and which states are safe, then let the search find a path from start to goal.

---

# The model

A state is a list `[Man, Wolf, Goat, Cabbage]`, each `w` (west) or `e` (east).

```prolog
move([X, X, Goat, Cabbage], wolf, [Y, Y, Goat, Cabbage]) :-
  change(X, Y).

move([X, Wolf, X, Cabbage], goat, [Y, Wolf, Y, Cabbage]) :-
  change(X, Y).

move([X, Wolf, Goat, Cabbage], nothing, [Y, Wolf, Goat, Cabbage]) :-
  change(X, Y).

change(e, w).
change(w, e).
```

The repeated `X` in `[X, X, Goat, Cabbage]` says the farmer can take the wolf
only when both are on the same bank. Unification does the bookkeeping.

---

# The rules

```prolog
safe([Man, Wolf, Goat, Cabbage]) :-
  one_eq(Man, Goat, Wolf),
  one_eq(Man, Goat, Cabbage).

one_eq(X, X, _).
one_eq(X, _, X).

solve(Config, Config, _visited, []).

solve(Config, Goal, Visited, [Move|Rest]) :-
  move(Config, Move, Nextconfig),
  safe(Nextconfig),
  \+ member(Nextconfig, Visited),
  solve(Nextconfig, Goal, [Nextconfig|Visited], Rest).
```

A state is safe when the farmer is with the goat, or the goat is away from the
wolf and from the cabbage. `solve/4` makes a move, keeps it only if the new
state is safe and has not been visited before, and continues. The visited list
is what keeps the search finite.

---

# The answer

```sh
eyeprolog examples/wolf-goat-cabbage.pl
```

```text
solution(puzzle, [goat, nothing, wolf, goat, cabbage, nothing, goat]).
solution(puzzle, [goat, nothing, cabbage, goat, wolf, nothing, goat]).
solved(puzzle, true).
```

There are exactly two plans, mirror images of each other. Both start by taking
the goat across and both bring the goat back once in the middle.

---

# The reason

```sh
eyeprolog --proof examples/wolf-goat-cabbage.pl
```

```text
step(move("wwww", goat, "ewew"),
     rule(5),
     ['X' = w, 'Wolf' = w, 'Cabbage' = w, 'Y' = e],
     [change(w, e)]).
step(safe("ewew"),
     rule(10),
     ['Man' = e, 'Wolf' = w, 'Goat' = e, 'Cabbage' = w],
     [one_eq(e, e, w), one_eq(e, e, w)]).
step(\+ member("ewew", ["wwww"]), absent, [], []).
```

The proof writes each state compactly: `"ewew"` is the list `[e, w, e, w]`,
farmer east, wolf west, goat east, cabbage west. The first move takes the goat
across (rule 5), the new state is safe because the farmer is with the goat
(rule 10), and it has not been visited yet.

---

# The check

```sh
eyeprolog --proof examples/wolf-goat-cabbage.pl > wgc.why.pl
eyeprolog --check-proof wgc.why.pl examples/wolf-goat-cabbage.pl
```

```text
condition('C1', resolution, ok, 48).
condition('C5', re_decision, ok, 14).
condition('C6', boundary_consistency, ok, 0).
trusted(0).
verdict(checked).
```

Of 62 steps, 48 are replayed against their clauses and 14 are recomputed: 2
built-in steps and the 12 "not visited yet" tests (`\+ member(...)`). An
absence cannot be proved by replaying a clause, but each of these is about a
list written out in the step, so the checker simply decides it again. Nothing
rests on trust, hence a plain `checked`.

---

# Try it

- Replace `length(Moves, 7)` in `solution/1` with `true`. The answers do not
  change: every safe plan that never revisits a state takes exactly seven
  crossings.
- Drop the cabbage condition from `safe/1` (keep only the wolf one) and ask
  `--goal 'solve([w,w,w,w],[e,e,e,e],[[w,w,w,w]],M)'`. Now a five-crossing plan
  appears. Which bank does the goat share with the cabbage?
- Remove the `\+ member(...)` test. Predict what happens before you run it,
  and run it with a timeout.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 10 and 24.
