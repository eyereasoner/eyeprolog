# Proof by contrapositive

## If the ground is dry, is it raining?

Rain makes the ground wet, and the ground is not wet. So it is not raining.
This example writes that classic argument as one rule, and EyeProlog's proof
shows exactly which premises it used.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=proof-contrapositive) ·
[Source](../proof-contrapositive.pl)

---

# The question

Given that rain implies wet ground and the ground is not wet, can we refute
"it is raining"?

The **contrapositive** of "if A then B" is "if not B then not A". The two are
logically equivalent, which is why proving one proves the other.

---

# The facts

```prolog
implies(raining, wet_ground).
false(wet_ground).
```

The implication is not Prolog's `:-`; it is **data**, a fact about two
propositions. That lets one rule reason about any implication stored this way.

---

# The rule

```prolog
false(A) :-
  implies(A, B),
  false(B).
```

If `A` implies `B` and `B` is false, then `A` is false. This is *modus
tollens*, the rule behind every proof by contrapositive, written as an
ordinary clause.

```prolog
refutes(proof1, raining) :-
  false(raining).
```

---

# The answer

```sh
eyeprolog examples/proof-contrapositive.pl
```

```text
refutes(proof1, raining).
method(proof1, contrapositive).
reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining").
```

---

# The reason

```sh
eyeprolog --proof examples/proof-contrapositive.pl
```

```text
step(refutes(proof1, raining), rule(4), [], [false(raining)]).
step(false(raining),
     rule(3),
     ['A' = raining, 'B' = wet_ground],
     [implies(raining, wet_ground), false(wet_ground)]).
```

The refutation rests on `false(raining)`, which the modus tollens rule
(clause 3) derives from the implication and the observation that the ground is
not wet. The `reason/2` string is a summary for people; the steps are the
argument.

---

# The check

```text
condition('C1', resolution, ok, 6).
condition('C4', coverage, ok, 8).
condition('C7', relevance, ok, 9).
trusted(0).
verdict(checked).
```

All six steps replay and nothing is trusted.

---

# Try it

- Remove `false(wet_ground).` The run prints nothing: without the observation
  there is no refutation.
- Add `implies(sprinkler, wet_ground).` and ask `--goal 'false(X)'`. Both
  `raining` and `sprinkler` are refuted by the same dry ground.
- Add a chain, `implies(storm, raining).`, and predict whether `storm` is
  refuted too.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 26.
