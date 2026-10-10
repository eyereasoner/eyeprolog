# A truth maintenance system

## Which beliefs follow from which assumptions, and which clash?

A truth maintenance system keeps track of why each belief is held. This
example is a small assumption-based one: it records which sets of assumptions
support each conclusion, and which sets support contradictory conclusions and
are therefore inconsistent.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=truth-maintenance-system) ·
[Source](../truth-maintenance-system.pl)

---

# The question

A robot has two sensors and an operator who can override them. Under each
combination of readings, may the robot move? And under which combinations do
the conclusions contradict each other?

An **environment** is a set of assumptions, such as "the clear-path sensor
fired". A **justification** derives a belief from assumptions or from other
beliefs.

---

# The model

```prolog
environment(clear_only, [sensor_clear]).
environment(blocked_only, [sensor_blocked]).
environment(conflicting_sensors, [sensor_clear, sensor_blocked]).
environment(override_blocked, [sensor_blocked, operator_override]).

justification(j_clear_path, [assumption(sensor_clear)], clear_path).
justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path).
justification(j_permit_from_clear, [clear_path], permit_go).
justification(j_forbid_from_blocked, [blocked_path], forbid_go).
justification(j_override, [assumption(operator_override), blocked_path], permit_go).
```

Justifications are data, so the system can report which one fired, not only
what was concluded.

---

# The rules

```prolog
supported(Environment, Belief) :-
  justification(_, Preconditions, Belief),
  all_hold(Environment, Preconditions).

inconsistent(Environment) :-
  supported(Environment, Left),
  supported(Environment, Right),
  contradicts(Left, Right).
```

A belief is supported in an environment when all preconditions of some
justification hold there. An environment is inconsistent when it supports two
beliefs that contradict each other, here `permit_go` and `forbid_go`.

---

# The answer

```sh
eyeprolog examples/truth-maintenance-system.pl
```

```text
tmsSupport(clear_only, permit_go).
tmsSupport(blocked_only, forbid_go).
tmsSupport(override_blocked, forbid_go).
tmsSupport(override_blocked, permit_go).
tmsInconsistent(conflicting_sensors).
tmsInconsistent(override_blocked).
```

This is a selection of the 25 answers. With both sensors firing, the system
supports both moving and not moving. With the override, it still derives
`forbid_go` from the blocked path, so that environment is inconsistent too.

---

# The reason

```text
step(inconsistent(conflicting_sensors),
     rule(17),
     ['Environment' = conflicting_sensors, 'Left' = permit_go, 'Right' = forbid_go],
     [supported(conflicting_sensors, permit_go),
      supported(conflicting_sensors, forbid_go),
      contradicts(permit_go, forbid_go)]).
```

The conflicting-sensors environment is inconsistent because it supports
`permit_go`, it supports `forbid_go`, and the two contradict each other. Each
of those uses has its own step further down in the proof.

---

# The check

```text
condition('C1', resolution, ok, 81).
condition('C4', coverage, ok, 134).
condition('C5', re_decision, ok, 6).
claims(25).
verdict(checked).
```

All 25 claims are covered. The checker replays 81 rule and fact steps and
recomputes 6 `member/2` steps, without any trusted boundary.

---

# Try it

- Add a rule saying that an operator override defeats `forbid_go`, and see
  whether `override_blocked` stays inconsistent.
- Add an environment with no assumptions at all and predict its supported
  beliefs.
- Ask which justification fired for `permit_go` under each environment:
  `--goal 'tmsJustification(E, J, permit_go)'`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
