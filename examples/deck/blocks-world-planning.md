# Blocks-world planning

## Which five moves turn one stack of blocks into another?

Five blocks are stacked in a single tower. The goal moves block `c` to the
table while keeping the rest of the order. EyeProlog searches the legal moves,
returns a five-move plan, and proves that every move was allowed.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=blocks-world-planning) ·
[Source](../blocks-world-planning.pl)

---

# The question

The blocks world is a classic planning problem from artificial intelligence. A
state says which block rests on what; a move picks up a clear block (nothing on
top of it) and puts it on the table or on another clear block. Is there a plan
of exactly five moves from the start to the goal?

---

# States as sorted lists

```prolog
initial([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]).
goal([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]).
```

A state is a list of `on(Block, Support)` facts. Every new state is sorted, so
two descriptions of the same arrangement are the *same term*, and checking
whether a state was already visited is plain structural comparison.

---

# Legal moves

```prolog
clear(Block, State) :-
  \+ member(on(_other, Block), State).

move(State, move(Block, From, To), Newstate) :-
  member(on(Block, From), State),
  clear(Block, State),
  support(To, State),
  clear_support(To, State),
  (Block \= To),
  (From \= To),
  select(on(Block, From), State, Rest),
  sort([on(Block, To)|Rest], Newstate).
```

A block is clear when no fact puts anything on it. A move lifts a clear block
and sets it on a clear support; nothing else changes.

---

# A bounded planner

```prolog
plan(State, Goal, Depth, Visited, [Move|Moves], Final) :-
  (Depth > 0),
  move(State, Move, Next),
  \+ member(Next, Visited),
  (Restdepth is Depth - 1),
  plan(Next, Goal, Restdepth, [Next|Visited], Moves, Final).
```

The depth bound keeps the search finite, and the visited list stops the
planner from walking in circles. `once/1` keeps the first plan found.

---

# The answer

```sh
eyeprolog examples/blocks-world-planning.pl
```

```text
status(blocks_world, planned).
plan(blocks_world, [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)]).
finalState(blocks_world, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]).
blockCount(blocks_world, 5).
```

Unstack `e` and `d`, move `c` to the table, then rebuild `d` and `e` on top of
it.

---

# The reason

```text
step(\+ member(on(_other, e), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
     absent,
     [],
     []).
```

The first move is legal because `e` is clear: no `on(_, e)` fact exists in the
start state. The proof records this as an `absent` step, a completed search
that found nothing.

---

# The check

```text
condition('C1', resolution, ok, 37).
condition('C5', re_decision, ok, 45).
condition('C6', boundary_consistency, ok, 1).
obligation(collected, theory_scoped, findall(A, block(A), "abcde")).
verdict(checked_with_obligations).
```

Rule steps replay, and arithmetic plus the ground "not yet visited" tests are
decided again by the checker itself. What is left are the "clear" tests, which
ask whether *any* block sits on another (`\+ member(on(A, e), [...])`), and the
count of blocks: an open negation and a collection. The checker can confront
them with the evidence (C6 decided one and refuted none) but cannot prove them
outright, so it lists each as an **obligation** the verdict rests on.

---

# Try it

- Lower the depth bound from 5 to 4 in `five_move_plan/2`. Is there still a
  plan?
- Change the goal so that `e` ends on the table. How long is the shortest plan?
- Remove the visited list from `plan/6`. Does the planner still find a plan
  within depth 5, and what does the list buy you?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 10 and 24.
