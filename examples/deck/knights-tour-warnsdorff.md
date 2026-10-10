# Knight's tour

## Can a chess knight visit every square of a board exactly once?

A **knight's tour** is a sequence of knight moves that lands on every square
exactly once. Searching blindly for one explodes quickly. Warnsdorff's rule, a
heuristic from 1823, almost always finds a tour without backtracking: always
jump to the square that has the fewest onward moves left.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=knights-tour-warnsdorff) ·
[Source](../knights-tour-warnsdorff.pl)

---

# The question

Starting in the corner of a 5×5 board, is there a knight's tour, and what is
it?

The interesting part is the strategy. Squares near the edges have few exits,
so visiting them early, while plenty of freedom remains, avoids getting
stranded later.

---

# Knight moves

```prolog
board_size(5).

knight_move(p(X0, Y0), p(X, Y)) :-
    member(d(DX, DY), [
        d(1, 2), d(2, 1), d(-1, 2), d(-2, 1),
        d(1, -2), d(2, -1), d(-1, -2), d(-2, -1)
    ]),
    X is X0 + DX, Y is Y0 + DY,
    board_size(N),
    X >= 1, X =< N, Y >= 1, Y =< N.
```

A move adds one of the eight L-shaped offsets and keeps the result on the
board.

---

# Warnsdorff's rule

```prolog
degree(Square, Visited, Degree) :-
    findall(Next, (knight_move(Square, Next), \+ member(Next, Visited)), Nexts),
    length(Nexts, Degree).

tour_(_, Visited, SquareCount, Visited) :- length(Visited, SquareCount), !.
tour_(Current, Visited, SquareCount, Tour) :-
    findall(Degree-Next, (
        knight_move(Current, Next),
        \+ member(Next, Visited),
        degree(Next, Visited, Degree)
    ), Candidates),
    Candidates \= [],
    keysort(Candidates, [_-Best | _]),
    tour_(Best, [Best | Visited], SquareCount, Tour).
```

The **degree** of a square is how many unvisited squares a knight could reach
from it. Each step scores every candidate by degree, sorts the `Degree-Square`
pairs with `keysort/2`, and moves to the first, the most constrained.

---

# The answer

```sh
eyeprolog examples/knights-tour-warnsdorff.pl
```

```text
answer(25, [p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)]).
```

A complete 25-square tour from `p(1, 1)`. Notice how early it reaches the
corners: `p(1, 5)` is the third square visited and `p(5, 5)` the fifth.

---

# The reason

```sh
eyeprolog --proof examples/knights-tour-warnsdorff.pl
```

```text
step(keysort([3 - p(3, 5), 3 - p(4, 4), 1 - p(1, 5), 3 - p(3, 1), 3 - p(4, 2)], [1 - p(1, 5), 3 - p(3, 5), 3 - p(4, 4), 3 - p(3, 1), 3 - p(4, 2)]),
     builtin,
     [],
     []).
```

This is Warnsdorff's rule at work on the second move. From `p(2, 3)` there are
five candidates. The corner `p(1, 5)` has only one exit left, so sorting puts
it first and the tour goes there next.

---

# The check

```text
condition('C1', resolution, ok, 28).
condition('C5', re_decision, ok, 53).
obligation(collected, theory_scoped, findall(A - B, (knight_move(p(1, 1), B), \+ member(B, [p(1, 1)]), degree(B, [p(1, 1)], A)), [5 - p(2, 3), 5 - p(3, 2)])).
verdict(checked_with_obligations).
```

The proof has 105 steps. Twenty-eight replay against the program's clauses
and 53 built-in steps, such as the sorts and the arithmetic, are recomputed
independently. The 24 candidate lists come from `findall/3`. A proof can show
that each listed candidate is valid, but not that none is missing, so the
checker records each list as a **collected** obligation.

---

# Try it

- Change `board_size(5)` to `board_size(6)`. The same rule finds a 36-square
  tour.
- Start from `p(1, 2)` instead of `p(1, 1)`. There is no answer: color the 5×5
  board like a chessboard and count the squares of each color to see why no
  tour can start there.
- The rule commits to the first candidate even when several tie. Change
  `tour_/4` so it backtracks through ties, and compare the work with
  `--stats`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
