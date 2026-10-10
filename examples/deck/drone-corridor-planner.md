# A drone corridor planner

## Which delivery plans from Gent to Oostende are reliable and cheap enough?

A drone must get from Gent to Oostende on the Belgian coast. Along the way it
can fly or take the train, recharge, and buy permits for a restricted corridor.
Each action has a duration, a cost, a reliability, and a comfort score. The
planner lists every plan that is reliable enough and cheap enough.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=drone-corridor-planner) ·
[Source](../drone-corridor-planner.pl)

---

# The question

Starting in Gent with a full battery and no permit, which sequences of actions
reach Oostende with an overall reliability above 0.94 and a total cost below
0.03?

---

# The actions

```prolog
step(state(gent, full, P), state(brugge, mid, P), fly_gent_brugge, 1500.0, 0.006, 0.99, 0.99).
step(state(brugge, B, none), state(brugge, B, yes), buy_permit_brugge, 450.0, 0.002, 0.98, 1.0).
step(state(brugge, mid, P), state(brugge, full, P), topup_brugge, 400.0, 0.003, 0.999, 0.98).
step(state(brugge, full, yes), state(oostende, mid, yes), cross_corridor_brugge_oostende, 900.0, 0.004, 0.98, 1.0).
```

A **state** records the city, the battery level, and whether the drone holds a
corridor permit. Each action moves from one state to another with a duration,
a cost, a belief (the probability it succeeds), and a comfort factor. The
corridor to Oostende requires a full battery and a permit.

---

# The planner

```prolog
fuel(fuel7, [t, t, t, t, t, t, t]).

path(From, To, [Act], Duration, Cost, Belief, Comfort, [_fuel|Fuelout], Fuelout) :-
  step(From, To, Act, Duration, Cost, Belief, Comfort).
path(From, To, Actions, Duration, Cost, Belief, Comfort, [_fuel|Fuelmid], Fuelout) :-
  step(From, Mid, Act, D1, C1, B1, M1),
  path(Mid, To, Restactions, D2, C2, B2, M2, Fuelmid, Fuelout),
  append([Act], Restactions, Actions),
  (Duration is D1 + D2),
  (Cost is C1 + C2),
  (Belief is B1 * B2),
  (Comfort is M1 * M2).
```

Durations and costs add up; beliefs and comfort multiply. Every action uses
one token from a list of seven, so no plan can be longer than seven actions
and the search must end, even though the action graph has cycles.

---

# The answer

```sh
eyeprolog examples/drone-corridor-planner.pl
```

```text
gps_plan(d1, plan([fly_gent_brugge, public_coastline_brugge_oostende], 2800.0, 0.012, 0.9602999999999999, 0.9503999999999999, low, none, "ttttt")).
gps_plan(d1, plan([train_gent_brugge, buy_permit_brugge, cross_corridor_brugge_oostende], 3050.0, 0.018000000000000002, 0.9594396, 0.995, mid, yes, "tttt")).
```

These are 2 of the 17 surviving plans. The fastest flies to Brugge and takes
the public coastline (2800, reliability 0.96). Taking the train and buying a
permit is slower but more comfortable. The last field is the unused fuel
tokens, printed in double-quote notation.

---

# The reason

```sh
eyeprolog --proof examples/drone-corridor-planner.pl
```

```text
step(fuel(fuel7, "ttttttt"), fact(1), [], []).
step(path(state(gent, full, none), state(oostende, low, none), [fly_gent_brugge, public_coastline_brugge_oostende], 2800.0, 0.012, 0.9602999999999999, 0.9503999999999999, "ttttttt", "ttttt"),
     rule(17),
     ['From' = state(gent, full, none),
```

The fastest plan rests on its two action facts and on the arithmetic that
combines them: 1500 + 1300 seconds, 0.006 + 0.006 cost, 0.99 × 0.97
reliability. Two of the seven fuel tokens are used.

---

# The check

```sh
eyeprolog --proof examples/drone-corridor-planner.pl > drone-corridor-planner.why.pl
eyeprolog --check-proof drone-corridor-planner.why.pl examples/drone-corridor-planner.pl
```

```text
condition('C1', resolution, ok, 115).
condition('C4', coverage, ok, 436).
condition('C7', relevance, ok, 303).
verdict(checked).
```

All 115 rule steps replay, and 171 arithmetic, comparison, and `append/3`
steps are recomputed. All 17 plans are covered, and nothing is taken on trust.

---

# Try it

- Raise the reliability threshold from 0.94 to 0.96. How many plans survive?
- Shorten the fuel list to three tokens. Which plans are still possible?
- Write a rule that picks the surviving plan with the shortest duration.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24 (designing finite search).
