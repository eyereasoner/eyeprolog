# Bayesian diagnosis

## Which disease best explains these symptoms?

A patient has fever, a dry cough, loss of smell, and shortness of breath, but no
sneezing. Bayes' rule combines how common each disease is with how likely each
symptom is under it, giving a probability for each diagnosis. Here COVID-19 gets
about 94%.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=bayes-diagnosis) ·
[Source](../bayes-diagnosis.pl)

---

# The question

Four candidate diseases: COVID-19, influenza, allergic rhinitis, and bacterial
pneumonia. Given the observed symptoms, how probable is each?

**Bayes' rule**: the posterior probability of a disease is proportional to its
**prior** (how common it is) times the **likelihood** of the evidence (how
probable these symptoms are if the patient has it). Dividing each score by the
total turns the scores into probabilities that sum to 1.

---

# The model

```prolog
prior(covid19, 50).
prior(influenza, 30).

p_given(covid19, fever, 700).
p_given(covid19, sneezing, 150).

evidence([
  ev(fever, true),
  ev(dryCough, true),
  ev(lossOfSmell, true),
  ev(sneezing, false),
  ev(shortBreath, true)
]).
```

Probabilities are stored as integers in thousandths (`700` means 0.7), so the
arithmetic is exact. The excerpt shows a few of the 4 priors and 20 symptom
probabilities.

---

# The rules

```prolog
factor(Disease, Symptom, true, P) :- p_given(Disease, Symptom, P).
factor(Disease, Symptom, false, Q) :-
  p_given(Disease, Symptom, P),
  (Q is 1000 - P).

likelihood(_disease, [], Acc, Acc).
likelihood(Disease, [ev(Symptom, Present)|Rest], Acc, Value) :-
  factor(Disease, Symptom, Present, Factor),
  (Next is Acc * Factor),
  likelihood(Disease, Rest, Next, Value).

score(Disease, Score) :-
  prior(Disease, Prior),
  evidence(Evidence),
  likelihood(Disease, Evidence, 1, Likelihood),
  (Score is Prior * Likelihood).
```

An absent symptom contributes the probability of *not* having it. The
likelihood multiplies the factors with an accumulator, assuming the symptoms are
independent given the disease (the "naive Bayes" assumption).

---

# The answer

```sh
eyeprolog examples/bayes-diagnosis.pl
```

```text
posterior(result(covid19), 0.9412093962753174).
posterior(result(influenza), 0.029203652890249024).
posterior(result(allergicRhinitis), 0.00045630707641014084).
posterior(result(bacterialPneumonia), 0.029130643758023392).
```

The last 4 of 17 answers; the others list the diseases, the total evidence, and
the unnormalized scores. Loss of smell, which is rare under the other diseases,
drives COVID-19 far ahead.

---

# The reason

```sh
eyeprolog --proof examples/bayes-diagnosis.pl
```

```text
step(evidenceTotal(case, 0.0016436300000000003),
     rule(46),
     ['Total' = 0.0016436300000000003],
     [total_score_decimal(0.0016436300000000003)]).
step(total_score_decimal(0.0016436300000000003), fact(40), [], []).
```

Note what this proof says. The reported decimals come from stored facts such as
`total_score_decimal/1` and `posterior_decimal/2`, so the proof cites those
facts, not the multiplication. The integer rules agree with them: asking
`--goal 'score(D, S)'` gives `score(covid19, 1547000000000000)`, which is
0.001547 at the 10¹⁸ scale. Connecting the two is left to the reader.

---

# The check

```text
condition('C1', resolution, ok, 30).
condition('C4', coverage, ok, 34).
recomputed(0).
trusted(0).
claims(17).
verdict(checked).
```

All 30 steps check, but they check what the proof contains: lookups of stored
values. A proof certifies the derivation that was run, not a computation the
program could have done but did not.

---

# Try it

- Ask `--goal 'score(D, S)' --goal 'total_score(T)'` and divide by hand to
  reproduce the COVID-19 posterior.
- Change `ev(sneezing, false)` to `true` and compute the new integer scores.
  Which disease gains?
- Write a `posterior/2` rule that derives the probability from `score/2` and
  `total_score/1`, so the proof covers the arithmetic.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29 (numerical models).
