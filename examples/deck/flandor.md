# Flandor

## May a regional board use an economic insight, and which support package should it activate?

A fictional case set in Flanders. Firms' data are aggregated into one neutral
"macro insight"; a board may use it only for regional stabilization, before an
expiry time, and without firm-level detail. The rules decide whether use is
allowed, which needs are active, and which policy package is the cheapest one
that covers them all, and they record every check along the way.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=flandor) ·
[Source](../flandor.pl)

---

# The question

The case asks:

> Is the Flemish Economic Resilience Board allowed to use a neutral
> macro-economic insight for regional stabilization, and if so which package
> should it activate for Flanders?

Answering it takes three kinds of reasoning: **policy** (is this use
permitted, and is it on time?), **economics** (which needs are active?), and
**choice** (which package is cheapest among those that are good enough?).

---

# The signals and the packages

```prolog
exportOrdersIndex(clusterAntwerp, 84).
exportOrdersIndex(clusterGhent, 87).
techVacancyRateTenths(labourMarket, 46).
congestionHours(grid, 19).
maxMEUR(budget, 140).

costMEUR(pkgTrainingOnly, 70).
costMEUR(pkgLogisticsOnly, 95).
costMEUR(pkgFlandor, 120).
costMEUR(pkgFullCorridor, 165).
```

Weak export orders, a scarcity of technical staff, and grid congestion are
the three possible needs. Four packages differ in cost and in which needs they
cover.

---

# The rules

```prolog
eligible_package(Pkg) :-
  needs_retooling_pulse(case),
  maxMEUR(budget, Max),
  policyPackage(Pkg),
  costMEUR(Pkg, Cost),
  coversExportWeakness(Pkg, true),
  coversSkillsStrain(Pkg, true),
  coversGridStress(Pkg, true),
  (Cost =< Max).

recommended_package(case, Pkg) :-
  eligible_package(Pkg),
  costMEUR(Pkg, Cost),
  \+ lower_cost_eligible_package(Cost).
```

A package is eligible when every need is active, the package covers all three,
and it fits the budget. The recommendation is the eligible package for which
no cheaper eligible package exists.

---

# The answer

```sh
eyeprolog examples/flandor.pl
```

```text
outcome(decision, "Allowed").
recommendedPackageName(answer, "Flandor Retooling Pulse").
budgetCapMEUR(answer, 140).
packageCostMEUR(answer, 120).
allChecksPass(result, true).
reason(whyGridStress, "Grid stress is active because congestion hours = 19 (threshold > 11).").
```

Six of 43 answers. Use is allowed, the €120M "Flandor Retooling Pulse" is
chosen, and every check passes. The two cheaper packages each miss a need, and
the €165M corridor package exceeds the budget.

---

# The reason

```text
step(recommended_package(case, pkgFlandor),
     rule(123),
     ['Pkg' = pkgFlandor, 'Cost' = 120],
     [eligible_package(pkgFlandor),
      costMEUR(pkgFlandor, 120),
      \+ lower_cost_eligible_package(120)]).
step(\+ lower_cost_eligible_package(120), absent, [], []).
```

The choice rests on an *absence*: no eligible package costs less than 120. The
proof records that as an `absent` step, because finding nothing is something
the proof cannot spell out step by step.

---

# The check

```text
condition('C5', re_decision, ok, 9).
condition('C6', boundary_consistency, ok, 1).
obligation(absent, theory_scoped, \+ lower_cost_eligible_package(120)).
steps(107).
verified(97).
trusted(1).
verdict(checked_with_obligations).
```

97 steps are replayed and 9 built-in calls recomputed, among them "no sensitive
term in the insight", a test on text written out in the step. One absence, "no
cheaper package", is an **obligation**: the checker found no evidence against
it (C6), but it holds only within this theory. If someone adds a package, the
obligation must be met again.
The signature checks are named for what they do: the input marks the HMAC as
`trustedPrecomputedInput`, `signature_accepted_as_trusted/1` accepts that
declaration, and `hmac_is_expected_value/1` compares the recorded HMAC with the
expected value. Neither recomputes the cryptography.

---

# Try it

- Lower the budget to `maxMEUR(budget, 110)`. No package is recommended, and
  `allChecksPass` disappears.
- Set `congestionHours(grid, 10)`. Grid stress is no longer active. What
  happens to the recommendation, and is that the policy you want?
- Add a cheaper package covering all three needs at €100M. It is chosen, and
  `reason(whySelectedPackage, ...)` names it, because the reason text is built
  from whichever package is recommended.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 15 and 25.
