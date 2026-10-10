# Exoplanet validation worlds

## When does a transit signal really mean a planet?

A telescope sees a star dim. Is it a planet passing in front, or a false
alarm? The example judges four candidate signals under four validation
policies and shows that only the Bayesian ones take rarity and false positives
into account.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=exoplanet-validation-worlds) ·
[Source](../exoplanet-validation-worlds.pl)

---

# The question

A detection method has a **sensitivity** (how often it catches a real planet)
and a **specificity** (how often it correctly stays quiet when there is none).
How likely a signal is to be real also depends on how common such planets are:
the **occurrence rate**. Bayes' rule combines all three into the
**positive predictive value** (PPV), the probability that a detection is a
real planet. The example compares that with simpler policies.

---

# The data and worlds

```prolog
candidate(rare_wide_orbit, 0.001, 0.99, 0.99).
candidate(mstar_short_period, 0.20, 0.99, 0.99).
candidate(common_hot_neptune_good, 0.25, 0.95, 0.97).
candidate(common_hot_neptune_low_spec, 0.25, 0.95, 0.90).

world(w0, full_bayes_reference).
world(w1, sensitivity_only_naive).
world(w2, occurrence_sensitivity_specificity_heuristic).
world(w3, cautious_bayes_threshold).
```

Each candidate lists occurrence rate, sensitivity, and specificity.

---

# The rules

```prolog
ppv_planet(Candidate, Ppv) :-
  candidate(Candidate, Occurrence, Sensitivity, Specificity),
  (Numerator is Sensitivity * Occurrence),
  (Noplanetprior is 1.0 - Occurrence),
  (Falsepositiverate is 1.0 - Specificity),
  (Falsepositivemass is Falsepositiverate * Noplanetprior),
  (Denominator is Numerator + Falsepositivemass),
  (Ppv is Numerator / Denominator).

confirms_in_world(Candidate, w0) :-
  ppv_planet(Candidate, Ppv),
  (Ppv >= 0.90).

confirms_in_world(Candidate, w1) :-
  candidate(Candidate, _Occurrence, Sensitivity, _Specificity),
  (Sensitivity >= 0.95).
```

World `w0` confirms at PPV of 0.90 or more; the naive world `w1` trusts
sensitivity alone.

---

# The answer

```sh
eyeprolog examples/exoplanet-validation-worlds.pl
```

```text
ppvPlanetGivenDetection(rare_wide_orbit, 0.09016393442622944).
ppvPlanetGivenDetection(mstar_short_period, 0.9611650485436893).
ppvPlanetGivenDetection(common_hot_neptune_good, 0.9134615384615384).
ppvPlanetGivenDetection(common_hot_neptune_low_spec, 0.76).
confirmsInWorld(rare_wide_orbit, w1).
rejectsInWorld(rare_wide_orbit, w0).
```

This excerpt shows 6 of the 22 answers. The rare wide-orbit signal comes from
an excellent detector, yet its PPV is only about 9%: such planets are so rare
that most detections are false alarms. The naive world confirms it anyway.

---

# The reason

```text
step(rejects_in_world(rare_wide_orbit, w0),
     rule(13),
     ['Candidate' = rare_wide_orbit, 'Ppv' = 0.09016393442622944],
     [ppv_planet(rare_wide_orbit, 0.09016393442622944), 0.09016393442622944 < 0.9]).
step(confirms_in_world(rare_wide_orbit, w1),
     rule(14),
     ['Candidate' = rare_wide_orbit, 'Sensitivity' = 0.99],
     [candidate(rare_wide_orbit, 0.001, 0.99, 0.99), 0.99 >= 0.95]).
```

The two worlds disagree for a visible reason: one compares the PPV with 0.9,
the other compares only the sensitivity with 0.95.

---

# The check

```text
condition('C1', resolution, ok, 47).
condition('C5', re_decision, ok, 39).
condition('C7', relevance, ok, 108).
verdict(checked).
```

The checker replays 47 rule steps and recomputes all 39 arithmetic and
comparison steps, including every PPV calculation. Nothing is trusted.

---

# Try it

- Raise the rare candidate's specificity from 0.99 to 0.9999. What is its new
  PPV, and does `w0` confirm it?
- The cautious world `w3` rejects `common_hot_neptune_good`. Which threshold
  would let it pass?
- Add a world that requires both a PPV of at least 0.9 and specificity of at
  least 0.97.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
