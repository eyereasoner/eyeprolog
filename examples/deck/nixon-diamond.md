# The Nixon diamond

## What should a reasoner conclude when two good defaults disagree?

Quakers are usually pacifists. Republicans are usually not. Nixon was both.
This classic puzzle from non-monotonic reasoning has no single right
default conclusion, so the example does not force one: it reports the
conflict explicitly.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=nixon-diamond) ·
[Source](../nixon-diamond.pl)

---

# The question

A *default* is a rule that holds unless there is reason to think otherwise.
Two defaults apply to Nixon and point in opposite directions. The name comes
from the diamond shape of the inheritance diagram: Nixon at the bottom, Quaker
and Republican in the middle, pacifist and hawk at the top.

Should the reasoner pick one side, refuse to conclude anything, or say that
the case is conflicted?

---

# The facts

```prolog
kind(nixon, quaker).
kind(nixon, republican).

supports_default(Person, pacifist) :-
  kind(Person, quaker).
supports_default(Person, hawk) :-
  kind(Person, republican).

contrary(pacifist, hawk).
contrary(hawk, pacifist).
```

Each default is a rule that *supports* a conclusion rather than asserting
it, and the two conclusions are declared contrary.

---

# The rules

```prolog
conflicted(Person, A, B) :-
  supports_default(Person, A),
  supports_default(Person, B),
  contrary(A, B).

status(Person, conflicted_default_case) :-
  conflicted(Person, _a, _b).
```

A person is conflicted when two supported conclusions are contrary. No
priority is invented between the defaults.

---

# The answer

```sh
eyeprolog examples/nixon-diamond.pl
```

```text
defaultSupports(nixon, pacifist).
defaultSupports(nixon, hawk).
conflict(nixon, conflict(pacifist, hawk)).
conflict(nixon, conflict(hawk, pacifist)).
status(nixon, conflicted_default_case).
```

Both defaults apply, the conflict is reported in both orders, and Nixon's
case is marked conflicted, not settled.

---

# The reason

```text
step(conflicted(nixon, pacifist, hawk),
     rule(7),
     ['Person' = nixon, 'A' = pacifist, 'B' = hawk],
     [supports_default(nixon, pacifist),
      supports_default(nixon, hawk),
      contrary(pacifist, hawk)]).
```

The conflict rests on exactly three premises: each default's support, and the
fact that the two conclusions are contrary.

---

# The check

```text
condition('C1', resolution, ok, 13).
condition('C4', coverage, ok, 18).
steps(13).
verified(13).
trusted(0).
verdict(checked).
```

All 13 steps replay against their clauses. There is no negation, arithmetic,
or aggregation, so nothing needs to be recomputed or trusted.

---

# Try it

- Add a priority fact such as `stronger(hawk, pacifist)` and a rule that
  resolves the conflict with it. What is lost by doing so?
- Add a second person who is only a Quaker. Which answers does that person
  get?
- Rewrite the defaults with `\+` ("pacifist unless known to be a hawk"). What
  happens when each default blocks the other?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7.
