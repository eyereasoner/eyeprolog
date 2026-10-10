# Skolem functions

## How do rules create new things with stable names?

Sometimes a rule must conclude that *something* exists: an observation record
for each lab result, an alert for each high reading. This example names each
new thing with a term built from the values that make it unique, so the same
inputs always give the same name and different inputs never collide.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=skolem-functions) ·
[Source](../skolem-functions.pl)

---

# The question

Three lab results arrive. For each, we want an observation resource with a
patient, a test, and a value, and a high-glucose alert that points to the
observation it is about. What should those new resources be called?

A random ID would differ on every run. A *Skolem term*, named after the
logician Thoralf Skolem, is a function term like `skolem_observation(alice,
glucose)`: a name computed from the facts it depends on.

---

# The data

```prolog
test_result(alice, glucose, 6.8).
test_result(alice, cholesterol, 4.2).
test_result(bob, glucose, 5.1).
```

---

# The rules

```prolog
type(skolem_observation(Patient, Test), observation) :-
  test_result(Patient, Test, _value).

value(skolem_observation(Patient, Test), Value) :-
  test_result(Patient, Test, Value).

type(skolem_alert(Patient, glucose), highGlucoseAlert) :-
  high_glucose(Patient).

about(skolem_alert(Patient, glucose), skolem_observation(Patient, glucose)) :-
  high_glucose(Patient).
```

The new resource appears directly in the rule head. Every rule that mentions
Alice's glucose observation builds exactly the same term, so all their
conclusions describe the same thing without any lookup table.

---

# The answer

```sh
eyeprolog examples/skolem-functions.pl
```

```text
type(skolem_observation(alice, glucose), observation).
type(skolem_observation(alice, cholesterol), observation).
type(skolem_observation(bob, glucose), observation).
type(skolem_alert(alice, glucose), highGlucoseAlert).
value(skolem_observation(alice, glucose), 6.8).
about(skolem_alert(alice, glucose), skolem_observation(alice, glucose)).
sameInputsSameId(skolemDemo, true).
noObservationClash(skolemDemo, true).
```

Sixteen answers in all: three observations with their patient, test, and
value, one alert (only Alice's glucose is above 6.0), and two checks that
the naming is deterministic and collision-free.

---

# The reason

```text
step(type(skolem_alert(alice, glucose), highGlucoseAlert),
     rule(10),
     ['Patient' = alice],
     [high_glucose(alice)]).
step(high_glucose(alice),
     rule(4),
     ['Patient' = alice, 'Value' = 6.8],
     [test_result(alice, glucose, 6.8), 6.8 > 6.0]).
step(6.8 > 6.0, builtin, [], []).
```

The alert exists because Alice's glucose reading, 6.8, exceeds 6.0. Its name
carries that origin with it: `skolem_alert(alice, glucose)`.

---

# The check

```text
condition('C1', resolution, ok, 20).
condition('C5', re_decision, ok, 4).
verdict(checked).
```

The 20 rule and fact steps replay against the program, and the 4 built-in
comparisons (the threshold test and the `=` / `\=` identity checks) are
recomputed. Nothing is trusted.

---

# Try it

- Add a second glucose result for Bob: `test_result(bob, glucose, 7.4).` Bob
  now gets an alert, but `skolem_observation(bob, glucose)` has two values.
  Which argument is missing from the Skolem term?
- Give alerts their own threshold argument, `skolem_alert(Patient, glucose,
  Limit)`, and see how the names change.
- Why would `observation_1`, `observation_2`, … be a worse naming scheme?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3.
