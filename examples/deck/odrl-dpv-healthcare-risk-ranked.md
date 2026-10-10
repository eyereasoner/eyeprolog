# Ranking healthcare policy risks

## Which gaps in this healthcare data policy are the most urgent to fix?

A healthcare policy permits research use, genomic data sharing, and record
retention. Risk profiles in the style of DPV (the W3C Data Privacy
Vocabulary) say which safeguards each permission needs. EyeProlog detects the
missing safeguards, scores each risk, and ranks them with a mitigation.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=odrl-dpv-healthcare-risk-ranked) ·
[Source](../odrl-dpv-healthcare-risk-ranked.pl)

---

# The question

Three permissions, three possible risks:

- research use without an explicit-consent constraint;
- sharing genomic data without a de-identification constraint;
- retaining records for longer than three years.

Which risks are actually triggered, how severe is each, and in what order
should they be addressed?

---

# The data

```prolog
rdf(iri('https://example.org/record-retention'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/retention-constraint'), default_graph).
rdf(iri('https://example.org/retention-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), literal('3650', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
rdf(iri('https://example.org/retention-profile'), iri('https://example.org/baseScore'), literal('55', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
rdf(iri('https://example.org/retention-limit-3-years'), iri('https://example.org/maximumDays'), literal('1095', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
```

The policy and the risk profiles are RDF. Retention is set to 3,650 days,
while the need allows at most 1,095.

---

# The rules

```prolog
risk_triggered(consent_risk, Rule, _Need) :-
  rdf_link(ex('healthcare-policy'), odrl(permission), Rule),
  rdf_link(Rule, odrl(action), odrl(use)),
  \+ constraint_text(Rule, ex(explicitConsent), 'true').

risk_triggered(retention_risk, Rule, Need) :-
  rdf_link(ex('healthcare-policy'), odrl(permission), Rule),
  constraint_number(Rule, ex(retentionDays), Days),
  rdf_number(Need, ex(maximumDays), Maximum),
  Days > Maximum.

risk_level(Score, high) :- Score > 79.
risk_level(Score, moderate) :- Score > 49, Score < 80.
```

A missing safeguard is detected by negation: there is no constraint saying
`explicitConsent` is `true`. A risk's score is its base score plus the
importance of the unmet need, capped at 100.

---

# The answer

```sh
eyeprolog examples/odrl-dpv-healthcare-risk-ranked.pl
```

```text
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/rank'), literal('3', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/score'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
```

These are the first 6 of 15 RDF answers. All three risks are triggered:
consent and sharing score 100 (high), retention 70 (moderate). Equal scores
are ordered by clause (`h1` before `h2`). The remaining answers give each
risk's level, clause, and mitigation, such as `require-explicit-consent`.

---

# The reason

```text
step(findall(key(InverseScore, Clause) - dpv_risk(Risk, Score, Level, Clause, Mitigation), (risk_report(Risk, Score, Level, Clause, Mitigation), InverseScore is 1000 - Score), [key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)]),
     collected,
     [],
     []).
```

The ranking collects every risk report with `findall/3`, keys it by
1000 − score so that a plain `sort/2` puts the most severe first, and then
numbers the results. This step is recorded as `collected`: the proof shows
the collected list, not how each report inside it was derived.

---

# The check

```text
condition('C1', resolution, ok, 52).
condition('C5', re_decision, ok, 22).
steps(75).
verified(52).
recomputed(22).
trusted(1).
verdict(checked_with_obligations).
```

The ranking, sorting, and RDF output steps replay or are recomputed. The one
trusted step is that `findall/3`, listed as an obligation. Everything inside
it, including the `\+` tests that detect missing safeguards, is assumed
rather than certified. To make those detections part of the proof, they would
have to be derived outside the collection.

---

# Try it

- Add an `explicitConsent` = `true` constraint to the research-use permission.
  Which risk disappears, and how do the ranks shift?
- Lower the retention to 1,000 days. Is the retention risk still triggered?
- Restructure `healthcare_risk_report/1` so that each `risk_report/5` gets its
  own proof step, and compare the check report.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8.
