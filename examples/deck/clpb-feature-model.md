# A feature model in Boolean constraints

## Which product configurations are valid, and how many are there?

A product line offers four features with rules about which go together.
EyeProlog states those rules as Boolean constraints, lists every valid
configuration, and counts them without enumerating them first.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpb-feature-model) ·
[Source](../clpb-feature-model.pl)

---

# The question

A deployment runs either in the cloud or at the edge, never both. Auditing
needs encryption. An edge deployment needs auditing. Which combinations of
`cloud`, `edge`, `audit`, and `encryption` satisfy all three rules?

This is a **feature model**: the kind of rulebook a product line uses to keep
customers from ordering a configuration that cannot work.

---

# The rules as constraints

```prolog
feature_constraints(Cloud, Edge, Audit, Encryption) :-
  sat((Cloud # Edge) *
      (Audit =< Encryption) *
      (Edge =< Audit)).
```

Each feature is a 0/1 variable from `library(clpb)`. `#` is exclusive or, `*`
is "and", and `A =< B` on Booleans reads "if A then B". The three factors are
the three rules, written once.

---

# Listing and counting

```prolog
feature_plan(features(
    cloud(Cloud), edge(Edge), audit(Audit), encryption(Encryption))) :-
  feature_constraints(Cloud, Edge, Audit, Encryption),
  labeling([Cloud, Edge, Audit, Encryption]).

feature_plan_count(Count) :-
  sat_count((_Cloud # Edge) *
            (Audit =< _Encryption) *
            (Edge =< Audit), Count).
```

`labeling/1` turns the constraints into concrete 0/1 assignments.
`sat_count/2` counts the solutions of the formula directly from its binary
decision diagram, without producing them one by one.

---

# The answer

```sh
eyeprolog examples/clpb-feature-model.pl
```

```text
feature_plan(features(cloud(0), edge(1), audit(1), encryption(1))).
feature_plan(features(cloud(1), edge(0), audit(0), encryption(0))).
feature_plan(features(cloud(1), edge(0), audit(0), encryption(1))).
feature_plan(features(cloud(1), edge(0), audit(1), encryption(1))).
feature_plan_count(4).
```

One edge configuration, which must audit and encrypt, and three cloud
configurations. The count agrees with the list.

---

# The reason

```text
step(feature_plan(features(cloud(0), edge(1), audit(1), encryption(1))),
     rule(2),
     ['Cloud' = 0, 'Edge' = 1, 'Audit' = 1, 'Encryption' = 1],
     [feature_constraints(0, 1, 1, 1), labeling([0, 1, 1, 1])]).
step(sat((0 # 1) * (1 =< 1) * (1 =< 1)), builtin, [], []).
```

The edge plan comes from the `feature_plan/1` rule with all four variables
bound. Its support is the constraint formula with those values substituted:
`0 # 1`, `1 =< 1`, `1 =< 1`, which is plainly true.

---

# The check

```text
condition('C5', re_decision, ok, 4).
obligation(builtin, stateful, sat((0 # 1) * (1 =< 1) * (1 =< 1))).
obligation(builtin, stateful, sat_count((A # B) * (C =< D) * (B =< C), 4)).
trusted(5).
verdict(checked_with_obligations).
```

The checker verifies the rules and recomputes four built-in steps. The `sat/1`
and `sat_count/2` calls depend on the constraint store the run built up, so the
checker cannot recompute them in isolation. It records them as
**obligations**: the proof holds provided those five constraint results are
right. The verdict says exactly that.

---

# Try it

- Drop the rule `Edge =< Audit` from `feature_plan_count/1`. The count rises
  from 4 to 6; which two configurations are new?
- Add a fifth feature, `backup`, required by `audit`, and predict the new count
  before running it.
- Ask only for edge plans: `--goal 'feature_plan(features(cloud(0), E, A, X))'`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 10.
