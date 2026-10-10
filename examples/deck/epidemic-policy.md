# Choosing an epidemic policy

## Which intervention brings the outbreak under control?

A health authority can do nothing, run a vaccination campaign, require indoor
masks, or do both. Each option scales a base reproduction risk by its own
factors. The example scores all four, marks which stay above the outbreak
threshold, and recommends the one that does not.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=epidemic-policy) ·
[Source](../epidemic-policy.pl)

---

# The question

With a base risk of 1.40, a threshold of 0.75, and the effect factors below,
which policies keep the risk at or under the threshold, and what do they cost?

---

# The model

```prolog
base_risk(1.40).

vaccination_factor(vaccination_campaign, 0.55).
vaccination_factor(vaccination_and_masks, 0.55).
mask_factor(indoor_masks, 0.65).
mask_factor(vaccination_and_masks, 0.65).

policy_cost(vaccination_campaign, 3).
policy_cost(indoor_masks, 2).
policy_cost(vaccination_and_masks, 5).
```

The base risk works like a reproduction number: above 1, each case leads to
more than one new case. Vaccination multiplies it by 0.55, masks by 0.65;
options without a measure use a factor of 1.00.

---

# The rules

```prolog
risk_score(P, R) :-
  base_risk(Base),
  vaccination_factor(P, Vf),
  mask_factor(P, Mf),
  (A is Base * Vf),
  (R is A * Mf).

acceptable(P) :-
  risk_score(P, R),
  (R =< 0.75).

recommended(vaccination_and_masks) :-
  acceptable(vaccination_and_masks),
  status(no_mandate, insufficient_control),
  status(vaccination_campaign, insufficient_control),
  status(indoor_masks, insufficient_control).
```

The recommendation states its full justification: the combined policy is
acceptable, and every other option was checked and found insufficient.

---

# The answer

```sh
eyeprolog examples/epidemic-policy.pl
```

```text
status(no_mandate, insufficient_control).
status(vaccination_campaign, insufficient_control).
status(indoor_masks, insufficient_control).
status(vaccination_and_masks, acceptable_control).
riskScore(vaccination_campaign, 0.77).
riskScore(vaccination_and_masks, 0.5005000000000001).
recommendedPolicy(epidemic_policy, vaccination_and_masks).
```

Vaccination alone just misses the threshold (0.77). Combining it with masks
brings the risk to about 0.50, at the highest cost, 5. The full output has 14
answers, including all risk scores and costs.

---

# The reason

```sh
eyeprolog --proof examples/epidemic-policy.pl
```

```text
step(status(no_mandate, insufficient_control),
     rule(20),
     ['P' = no_mandate, 'R' = 1.4],
     [policy(no_mandate), risk_score(no_mandate, 1.4), 1.4 > 0.75]).
step(1.4 > 0.75, builtin, [], []).
```

Doing nothing is insufficient because its risk score is 1.4 and 1.4 exceeds
0.75. The recommendation's proof contains one such step for each rejected
alternative.

---

# The check

```sh
eyeprolog --proof examples/epidemic-policy.pl > epidemic-policy.why.pl
eyeprolog --check-proof epidemic-policy.why.pl examples/epidemic-policy.pl
```

```text
condition('C1', resolution, ok, 36).
condition('C4', coverage, ok, 60).
condition('C7', relevance, ok, 59).
verdict(checked).
```

All 36 rule steps replay and the 9 arithmetic steps are recomputed. Nothing is
taken on trust. What the check cannot vouch for is the model itself: the
factors are assumptions, not measurements.

---

# Try it

- Change the vaccination factor to 0.50. Does the recommendation still hold,
  and why does `recommended/1` now fail?
- Rewrite `recommended/1` so it picks the cheapest acceptable policy instead
  of naming it.
- Add a school-closure policy with its own factor and cost.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14 (knowledge engineering).
