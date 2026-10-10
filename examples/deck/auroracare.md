# AuroraCare

## Should this use of a patient's health data be permitted, and why?

A regional health-data platform receives seven requests to use one patient's
records: for care, quality improvement, research, insurance, and AI training.
Each request is checked against purpose-based policies (in the style of the
W3C ODRL and DPV vocabularies), the patient's consent, and the care
relationship, and every decision comes with its reason.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=auroracare) ·
[Source](../auroracare.pl)

---

# The question

The same health record is requested seven times, in scenarios A to G:

- a clinician in the patient's care team, for primary care;
- a quality-improvement analyst, with and without the required data;
- an insurance bot;
- the patient's GP checking lab results;
- a researcher using an anonymised dataset;
- an AI-training job for a patient who opted out.

For each request: permit or deny, which policy matched, and why?

---

# Policies as facts

```prolog
policyUid(policyQi, "urn:policy:qi-2025-aurora").
purposeAllowed(policyQi, ensureQualitySafetyHealthcare).
requireEnvironment(policyQi, "secure_env").
requireAllCategory(policyQi, labResults).
requireAllCategory(policyQi, patientSummary).
duty(policyQi, requireConsent).
duty(policyQi, noExfiltration).

policyUid(policyDenyInsurance, "urn:policy:deny-insurance").
prohibitPurpose(policyDenyInsurance, insuranceManagement).

consentAllow(ruben, healthcareScientificResearch).
consentDeny(ruben, trainTestAndEvaluateAiSystemsAlgorithms).
```

A policy is a set of facts: the purposes it allows, the environment and data
categories it requires, and the duties it imposes. The patient's consent is
recorded the same way.

---

# Matching a request

```prolog
qi_policy_match(S) :-
  purpose(S, ensureQualitySafetyHealthcare),
  environment(S, "secure_env"),
  category(S, labResults),
  category(S, patientSummary).

prohibition_match(S) :- insurance_prohibition_match(S).
prohibition_match(S) :- subject_opt_out(S).

no_policy_match(S) :-
  scenario(S),
  \+ permission_match(S),
  \+ prohibition_match(S).

decision(S, "PERMIT") :- permission_match(S), \+ prohibition_match(S).
decision(S, "DENY") :- prohibition_match(S).
decision(S, "DENY") :- no_policy_match(S).
```

Each policy branch is a named relation over a scenario. A request is
permitted when some permission matches and no prohibition applies; a
prohibited purpose or the patient's opt-out always denies; and a request that
matches nothing is denied by default. Parallel `reason/2` and
`matchedPolicyUid/2` rules report why.

---

# The answer

```sh
eyeprolog examples/auroracare.pl
```

```text
decision(scenarioA, "PERMIT").
decision(scenarioE, "PERMIT").
decision(scenarioB, "PERMIT").
decision(scenarioF, "PERMIT").
decision(scenarioD, "DENY").
decision(scenarioG, "DENY").
decision(scenarioC, "DENY").
```

Four permits and three denials, among 117 answers in all: labels,
descriptions, reasons, matched policy identifiers, audit traces, and ten
report checks per scenario ([full output](../output/auroracare.pl)). Scenario C
is denied because the analyst requested lab results only, while the quality
policy requires lab results *and* the patient summary.

---

# The reason

```sh
eyeprolog --proof examples/auroracare.pl
```

```text
step(decision(scenarioB, "PERMIT"),
     rule(153),
     ['S' = scenarioB],
     [permission_match(scenarioB), \+ prohibition_match(scenarioB)]).
step(permission_match(scenarioB), rule(145), ['S' = scenarioB], [qi_policy_match(scenarioB)]).
step(qi_policy_match(scenarioB),
     rule(140),
     ['S' = scenarioB],
     [purpose(scenarioB, ensureQualitySafetyHealthcare),
      environment(scenarioB, "secure_env"),
      category(scenarioB, labResults),
      category(scenarioB, patientSummary)]).
```

Scenario B is permitted because the quality-improvement policy matched (right
purpose, secure environment, and both required data categories) and no
prohibition applies. Each positive premise is a scenario fact that the proof
can point to; the absence of a prohibition is recorded as an `absent` step.

---

# The check

```text
condition('C1', resolution, ok, 181).
condition('C4', coverage, ok, 287).
condition('C6', boundary_consistency, ok, 6).
obligation(absent, theory_scoped, \+ permission_match(scenarioC)).
obligation(absent, theory_scoped, \+ prohibition_match(scenarioC)).
verdict(checked_with_obligations).
```

All 181 rule and fact steps replay against the program, and every one of the
117 claims is covered. The seven negations (no prohibition for the four
permits, no opt-out for research, and nothing at all matching scenario C)
cannot be replayed; they are listed as obligations. The checker compared six
of them with the program's own evidence and found none contradicted.

---

# Try it

- Add `category(scenarioC, patientSummary).` Scenario C now satisfies the
  quality policy and is permitted; the default denial disappears, because
  "no policy matched" no longer holds.
- Add `consentDeny(ruben, healthcareScientificResearch).` Scenario F is then
  denied with "Denied: the subject opted out of this purpose.", because an
  opt-out overrides any matching permission.
- Add a scenario H for remote patient monitoring by the GP, and predict its
  decision, reason, and matched policy before running it.

Related: [ODRL policy reasoning](odrl-policy-reasoning.md) and
[Cross-organization data sharing](cross-organization-data-sharing.md). Learn
more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 25.
