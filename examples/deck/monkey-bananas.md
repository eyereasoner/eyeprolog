# Monkey and bananas

## How does a monkey get bananas hanging out of reach?

A classic AI planning puzzle. Bananas hang from the ceiling, a box stands
elsewhere in the room, and the monkey must walk, push, climb, and grab in the
right order. EyeProlog searches short move sequences and returns every plan
that works.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=monkey-bananas) ·
[Source](../monkey-bananas.pl)

---

# The question

The bananas are above `loc1`, the monkey is at `loc2`, and the box is at
`loc3`. The monkey can reach the bananas only by standing on the box directly
beneath them. Which sequences of at most five moves end with the monkey
holding the bananas?

---

# The model

```prolog
initial_state([loc1, loc2, loc3, n, n]).
goal_state([_, _, _, _, y]).

legal_move([B, M, M, n, H], climb_on, [B, M, M, y, H]).
legal_move([B, M, M, y, H], climb_off, [B, M, M, n, H]).
legal_move([B, B, B, y, n], grab, [B, B, B, y, y]).
legal_move([B, M, M, n, H], push(X), [B, X, X, n, H]) :-
  member(X, [loc1, loc2, loc3]),
  (X \= M).
legal_move([B, M, L, n, H], go(X), [B, X, L, n, H]) :-
  member(X, [loc1, loc2, loc3]),
  (X \= M).
```

A state lists the bananas' location, the monkey's location, the box's
location, whether the monkey is on the box, and whether it has the bananas.
Repeated variables do the work: `grab` applies only when bananas, monkey, and
box are all at the same place `B`.

---

# The rules

```prolog
plan(Moves) :-
  candidate_plan(Moves),
  initial_state(I),
  goal_state(G),
  reachable_state(I, Moves, G).

candidate_plan([_, _, _]).
candidate_plan([_, _, _, _]).
candidate_plan([_, _, _, _, _]).

reachable_state(S, [], S).
reachable_state(S1, [M|L], S3) :-
  legal_move(S1, M, S2),
  reachable_state(S2, L, S3).
```

A plan is a list of three, four, or five unknown moves; `reachable_state/3`
fills them in. Fixing the length first keeps the search finite.

---

# The answer

```sh
eyeprolog examples/monkey-bananas.pl
```

```text
plan(monkeyBananas, [go(loc3), push(loc1), climb_on, grab]).
plan(monkeyBananas, [go(loc1), go(loc3), push(loc1), climb_on, grab]).
plan(monkeyBananas, [go(loc3), push(loc1), climb_on, grab, climb_off]).
plan(monkeyBananas, [go(loc3), push(loc2), push(loc1), climb_on, grab]).
solved(monkeyBananas, true).
```

The shortest plan has four moves: walk to the box, push it under the
bananas, climb on, grab. No three-move plan exists. The five-move plans add a
detour or a final climb down.

---

# The reason

```text
step(plan([go(loc3), push(loc1), climb_on, grab]),
     rule(1),
     ['Moves' = [go(loc3), push(loc1), climb_on, grab],
      'I' = [loc1, loc2, loc3|"nn"],
      'G' = [loc1, loc1, loc1|"yy"]],
     [candidate_plan([go(loc3), push(loc1), climb_on, grab]),
      initial_state([loc1, loc2, loc3|"nn"]),
      goal_state([loc1, loc1, loc1|"yy"]),
      reachable_state([loc1, loc2, loc3|"nn"], [go(loc3), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
```

The plan is a four-move candidate that reaches the goal from the initial
state. In the goal everything is at `loc1`, with the monkey on the box and
holding the bananas. (The tail `[n, n]` is printed as `"nn"`: a list of
one-character atoms is written in double-quote notation.)

---

# The check

```text
condition('C1', resolution, ok, 41).
condition('C5', re_decision, ok, 8).
steps(49).
verified(41).
recomputed(8).
trusted(0).
verdict(checked).
```

Every move in every plan is replayed against the `legal_move/3` clause it
uses, and the eight `\=` tests are recomputed. Nothing is trusted.

---

# Try it

- Add `candidate_plan([_, _])` and confirm that no two-move plan exists.
- Put the box under the bananas from the start (`loc1`). What is the
  shortest plan now?
- Add a move `jump` that works only from the box. Which new plans appear?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
