# Missionaries and cannibals

## Can everyone cross the river without anyone being outnumbered?

Three missionaries and three cannibals must cross a river in a boat that
holds one or two people. On either bank, missionaries may never be
outnumbered by cannibals. EyeProlog searches the space of safe states and
returns a crossing plan.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=missionaries-cannibals) ·
[Source](../missionaries-cannibals.pl)

---

# The question

A state records how many missionaries and cannibals are on the left bank and
where the boat is. The start is `state(3, 3, left)` and the goal is
`state(0, 0, right)`. Which sequence of safe crossings connects them?

---

# The model

```prolog
move(1, 0).
move(0, 1).
move(2, 0).
move(0, 2).
move(1, 1).

bank_safe(0, _c).
bank_safe(M, C) :- (M > 0), (M >= C).
```

Five possible boat loads. A bank is safe if it has no missionaries, or at
least as many missionaries as cannibals.

---

# The rules

```prolog
crossing(state(Mleft, Cleft, left), state(Nextm, Nextc, right), carry(Movem, Movec)) :-
  move(Movem, Movec),
  (Nextm is Mleft - Movem),
  (Nextc is Cleft - Movec),
  state_safe(state(Nextm, Nextc, right)).

journey(Goal, Goal, Visited, Visited).
journey(State, Goal, Visited, Path) :-
  crossing(State, Next, _carry),
  \+ member(Next, Visited),
  journey(Next, Goal, [Next|Visited], Path).
```

A crossing applies one boat load and keeps both banks safe. The journey never
revisits a state, which keeps the search finite.

---

# The answer

```sh
eyeprolog examples/missionaries-cannibals.pl
```

```text
missionaries_cannibals_answer(first_solution, [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)]).
missionaries_cannibals_answer(state_count, 10).
missionaries_cannibals_answer(step_count, 11).
```

The classic 11-crossing solution. Only 10 left-bank configurations of
missionaries and cannibals are safe on both banks, which is why the search
is small.

---

# The reason

```text
step(crossing(state(0, 1, right), state(1, 1, left), carry(1, 0)),
     rule(10),
     ['Mleft' = 0, 'Cleft' = 1, 'Nextm' = 1, 'Nextc' = 1, 'Movem' = 1, 'Movec' = 0],
     [move(1, 0), 1 is 0 + 1, 1 is 1 + 0, state_safe(state(1, 1, left))]).
```

Near the end, one missionary rows back to the left bank, leaving one
missionary and one cannibal there, a safe state. Every crossing in the plan
has a step like this one.

---

# The check

```text
condition('C1', resolution, ok, 53).
condition('C5', re_decision, ok, 43).
condition('C6', boundary_consistency, ok, 0).
steps(97).
verified(53).
recomputed(42).
trusted(1).
verdict(checked_with_obligations).
```

Rule steps replay. The arithmetic and the 11 "this state was not visited yet"
tests (`\+ member/2` over a list written out in the step) are recomputed by
the checker itself. The one trusted step left is the `countall/2` that counts
the safe states: it is the single obligation.

---

# Try it

- Allow a boat of three: add `move(3, 0)`, `move(2, 1)`, and `move(0, 3)`. Is
  the shortest plan shorter?
- Try four missionaries and four cannibals with a two-person boat. Does any
  solution exist?
- Replace `once(solution(Path))` with `findall/3` and count how many distinct
  solutions the search finds.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
