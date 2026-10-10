# Bayesian therapy choice

## Which therapy is best when the diagnosis is uncertain?

First infer how probable each disease is from the symptoms, then score every
therapy by its expected success across those possibilities minus a penalty for
side effects. Two layers of reasoning, one recommendation, and a proof that
covers every multiplication. (The numbers are illustrative, not medical
advice.)

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=bayes-therapy) ·
[Source](../bayes-therapy.pl)

---

# The question

A patient has fever and a dry cough, but no loss of smell, no sneezing, and no
shortness of breath. COVID-19 and influenza both fit. Five therapies are
available, and each works well for some diseases and poorly for others.
Which one should be recommended?

The answer is a **decision under uncertainty**: weigh each therapy's success
for each disease by the probability of that disease.

---

# Layer 1: diagnosis

```prolog
likelihood(_disease, [], 1.0).
likelihood(Disease, [Evidence|Rest], Likelihood) :-
  factor(Disease, Evidence, Factor),
  likelihood(Disease, Rest, Taillikelihood),
  (Likelihood is Factor * Taillikelihood).

score(Disease, Score) :-
  prior(Disease, Prior),
  evidence(case, Evidence),
  likelihood(Disease, Evidence, Likelihood),
  (Score is Prior * Likelihood).
```

Bayes' rule: each disease's score is its prior probability times the
likelihood of the symptoms. Normalizing the scores by their sum gives posterior
probabilities.

---

# Layer 2: decision

```prolog
success_by_disease(paxlovid, [0.75, 0.05, 0.02, 0.05]).
success_by_disease(oseltamivir, [0.05, 0.60, 0.02, 0.05]).

expected_success(Therapy, Expectedsuccess) :-
  posteriors(case, Posteriors),
  success_by_disease(Therapy, Successbydisease),
  dot_product(Posteriors, Successbydisease, Expectedsuccess).

therapy_utility(Therapy, Utility) :-
  expected_success(Therapy, Expectedsuccess),
  adverse(Therapy, Adverse),
  benefit_weight(Benefitweight),
  harm_weight(Harmweight),
  (Benefit is Benefitweight * Expectedsuccess),
  (Harmcost is Harmweight * Adverse),
  (Utility is Benefit - Harmcost).
```

Expected success is a dot product of the posterior vector with the therapy's
success rates. Utility is `10 × success − 3 × adverse-effect rate`. The shared
layers are declared with `:- table`, so the posteriors are computed once and
reused by every therapy.

---

# The answer

```sh
eyeprolog examples/bayes-therapy.pl
```

```text
posterior(covid19, 0.48388282341092037).
posterior(influenza, 0.42789379600913957).
utility(paxlovid, 3.5851740117076503).
utility(oseltamivir, 2.6114101258814744).
utility(supportiveCare, 2.8851195397013814).
recommendedTherapy(case, paxlovid).
```

A selection from 23 answers. COVID-19 (48%) and influenza (43%) are close, so
broad supportive care almost matches oseltamivir. Paxlovid still wins on
utility and is recommended.

---

# The reason

```sh
eyeprolog --proof examples/bayes-therapy.pl
```

```text
step(utility(paxlovid, 3.5851740117076503),
     rule(79),
     ['Therapy' = paxlovid, 'Utility' = 3.5851740117076503],
     [therapy(paxlovid), therapy_utility(paxlovid, 3.5851740117076503)]).
step(3.5851740117076503 is 3.88517401170765 - 0.30000000000000004, builtin, [], []).
```

Paxlovid's utility is its weighted expected success (3.885) minus its weighted
side-effect rate (3 × 0.10 = 0.3). Following the steps down reaches every
posterior, every product, and every symptom probability used.

---

# The check

```text
condition('C1', resolution, ok, 177).
condition('C5', re_decision, ok, 90).
condition('C7', relevance, ok, 290).
recomputed(90).
trusted(0).
claims(23).
verdict(checked).
```

177 rule and fact steps check against the program, and the checker recomputes
all 90 floating-point steps. The recommendation is certified relative to the
model's numbers; whether those numbers are clinically right is outside the
logic.

---

# Try it

- Change `ev(lossOfSmell, false)` to `true` and predict how the posteriors and
  the recommendation move.
- Raise `harm_weight/1` from 3 to 20. Does supportive care overtake paxlovid?
- Add a sixth therapy that works moderately for every disease with almost no
  side effects. What success rates would it need to be recommended?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29 (numerical models).
