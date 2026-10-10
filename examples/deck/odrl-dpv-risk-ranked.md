# Ranked consumer-policy risks

## Which clauses of this agreement put the consumer at risk, and which matter most?

A consumer agreement is written in ODRL, and the consumer's needs are written
in a DPV-style vocabulary, both as RDF. EyeProlog finds each clause that
conflicts with a need, scores the risk, and returns one deterministic ranking
with a mitigation for every risk.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=odrl-dpv-risk-ranked) ·
[Source](../odrl-dpv-risk-ranked.pl)

---

# The question

ODRL describes what a service may do (permissions, duties, prohibitions).
DPV, the W3C Data Privacy Vocabulary, describes privacy concepts such as risks
and the needs of a data subject.

Put side by side, they let a program ask: does the agreement allow account
removal without notice, terms changes with too little notice, sharing without
explicit consent, or forbid data export? And if several risks apply, which
should be fixed first?

---

# Risk triggers are rules over the policy

```prolog
risk_triggered(deletion_risk, Rule, _Need) :-
  rdf_link(ex('consumer-policy'), odrl(permission), Rule),
  rdf_link(Rule, odrl(action), ex('remove-account')),
  \+ duty_action(Rule, ex(inform)),
  \+ constraint_number(Rule, ex(noticeDays), _Days).

risk_triggered(terms_risk, Rule, Need) :-
  rdf_link(ex('consumer-policy'), odrl(permission), Rule),
  rdf_link(Rule, odrl(action), ex('change-terms-action')),
  duty_action(Rule, ex(inform)),
  constraint_number(Rule, ex(noticeDays), Days),
  rdf_number(Need, ex(minimumNoticeDays), Minimum),
  Days < Minimum.
```

A deletion risk is a removal permission with **no** duty to inform and **no**
notice period. A terms risk is a terms change whose notice period is shorter
than the consumer's minimum.

---

# Scoring and ranking

```prolog
risk_report(Risk, Score, Level, Clause, Mitigation) :-
  risk_profile(_Profile, Risk, Rule, Need, Base, Mitigation),
  risk_triggered(Risk, Rule, Need),
  rdf_text(Rule, ex(clause), ClauseText),
  Clause = ClauseText,
  rdf_number(Need, ex(importance), Importance),
  Raw is Base + Importance,
  (Raw > 100 -> Score = 100 ; Score = Raw),
  risk_level(Score, Level).

risk_level(Score, high) :- Score > 79.
risk_level(Score, moderate) :- Score > 49, Score < 80.
```

The score is a base score plus the importance of the need, capped at 100.
`consumer_risk_report/1` collects every report with `findall/3`, sorts by
inverted score and clause, and numbers the result, so ties always break the
same way.

---

# The answer

```sh
eyeprolog examples/odrl-dpv-risk-ranked.pl
```

```text
result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/rank'), literal('3', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/rank'), literal('4', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
```

The full output has 20 RDF triples: rank, score, level, clause, and mitigation
for each of the four risks. Deletion scores 100 (high), sharing 97 (high),
terms 85 (high), and portability 70 (moderate).

---

# The reason

```text
step(2 is 1 + 1, builtin, [], []).
```

The proof follows the ranking down to its arithmetic: the step above is one of
the rank increments, recomputed by the checker. The collection of risk reports
is different. It is recorded as one `collected` step for the whole `findall/3`,
because a list of *all* solutions is a claim that nothing was missed, and that
cannot be replayed step by step.

---

# The check

```text
condition('C1', resolution, ok, 72).
condition('C5', re_decision, ok, 31).
condition('C6', boundary_consistency, ok, 0).
trusted(1).
claims(20).
verdict(checked_with_obligations).
```

72 steps replay against the program and 31 built-in steps are recomputed. The
verdict is `checked_with_obligations`: the proof is valid *given* one trusted
boundary, the completed `findall/3` that lists the four risk reports. The
check report names it as an `obligation/3` fact, so a reviewer knows exactly
which claim to audit separately.

---

# Try it

- Add an `inform` duty and a notice period to the removal permission. Which
  risk disappears, and how do the remaining ranks shift?
- Raise the importance of the portability need. Does its level change from
  moderate to high?
- Compare with the [ODRL policy reasoning](odrl-policy-reasoning.md) deck,
  which decides individual requests instead of ranking risks.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8.
