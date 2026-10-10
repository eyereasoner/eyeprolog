# Trust-aware data flows

## May this data flow go ahead, given the policy and how much we trust the source?

An ODRL policy permits research partners to use lab results for healthcare,
but only from sources with enough trust, and forbids sending them to an ad
network for marketing. Three requested data flows arrive as RDF. EyeProlog
decides each one: permit, send for review, or deny.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=odrl-dpv-fpv-trust-flow) ·
[Source](../odrl-dpv-fpv-trust-flow.pl)

---

# The question

ODRL (the W3C Open Digital Rights Language) expresses permissions and
prohibitions over assets, actions, and purposes. Here a permission also
carries a minimum trust score (`minTrust` 0.80) for the data source. For
each requested flow: is it permitted, does it need human review, or is it
prohibited?

---

# The data

The policy, trust scores, and requests are RDF triples, stored as
`rdf(Subject, Predicate, Object, Graph)` facts:

```prolog
rdf(iri('https://example.org/healthcare-permission'), iri('https://example.org/minTrust'), literal('0.80', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
rdf(iri('https://example.org/hospital-a'), iri('https://example.org/trustScore'), literal('0.92', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
rdf(iri('https://example.org/small-clinic'), iri('https://example.org/trustScore'), literal('0.63', datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
rdf(iri('https://example.org/flow-ads'), iri('https://example.org/recipient'), iri('https://example.org/ad-network'), default_graph).
```

Three flows: hospital A to a research partner, a small clinic to the same
partner, and hospital A to an ad network.

---

# The rules

```prolog
permitted_flow(Flow, Score) :-
  flow_request(Flow, Source, Recipient, Data, Action, Purpose),
  policy_rule(odrl(permission), Rule, Recipient, Data, Action, Purpose),
  rdf_number(Rule, ex(minTrust), Minimum),
  rdf_number(Source, ex(trustScore), Score),
  Score >= Minimum.

review_flow(Flow, Score) :-
  flow_request(Flow, Source, Recipient, Data, Action, Purpose),
  policy_rule(odrl(permission), Rule, Recipient, Data, Action, Purpose),
  rdf_number(Rule, ex(minTrust), Minimum),
  rdf_number(Source, ex(trustScore), Score),
  Score < Minimum.

prohibited_flow(Flow) :-
  flow_request(Flow, _Source, Recipient, Data, Action, Purpose),
  policy_rule(odrl(prohibition), _Rule, Recipient, Data, Action, Purpose).
```

A flow matching a permission is permitted when the source's trust meets the
minimum, and goes to review when it does not. A flow matching a prohibition is
denied.

---

# The answer

```sh
eyeprolog examples/odrl-dpv-fpv-trust-flow.pl
```

```text
result_rdf(iri('https://example.org/flow-care'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph).
result_rdf(iri('https://example.org/flow-clinic'), iri('https://example.org/decision'), iri('https://example.org/review'), default_graph).
result_rdf(iri('https://example.org/flow-ads'), iri('https://example.org/decision'), iri('https://example.org/deny'), default_graph).
```

These are the first 3 of 9 answers, which are themselves RDF triples. The rest
add the confidence (0.92 and 0.63), the status, and the risk (trustworthiness
for the clinic, unwanted disclosure for the ad network).

---

# The reason

```text
step(review_flow(flow_clinic, 0.63),
     rule(35),
     ['Flow' = flow_clinic,
      'Score' = 0.63,
      'Source' = ex('small-clinic'),
      'Recipient' = ex('research-partner'),
      'Data' = ex('lab-result'),
      'Action' = odrl(use),
      'Purpose' = ex(healthcare),
      'Rule' = ex('healthcare-permission'),
      'Minimum' = 0.8],
     [flow_request(flow_clinic, ex('small-clinic'), ex('research-partner'), ex('lab-result'), odrl(use), ex(healthcare)),
      policy_rule(odrl(permission), ex('healthcare-permission'), ex('research-partner'), ex('lab-result'), odrl(use), ex(healthcare)),
      rdf_number(ex('healthcare-permission'), ex(minTrust), 0.8),
      rdf_number(ex('small-clinic'), ex(trustScore), 0.63),
      0.63 < 0.8]).
```

The clinic's flow matches the permission in every respect except trust: 0.63
is below the 0.8 minimum, so it goes to review rather than being refused.

---

# The check

```text
condition('C1', resolution, ok, 144).
condition('C5', re_decision, ok, 43).
steps(187).
verified(144).
recomputed(43).
trusted(0).
verdict(checked).
```

Every rule step replays, and the literal-to-number conversions and trust
comparisons are recomputed. All three decisions are fully checked.

---

# Try it

- Raise the clinic's trust score to `0.85`. Which decision changes?
- Add a flow from hospital A to the ad network for `healthcare` instead of
  `marketing`. Is it permitted, reviewed, or neither, and should "neither" be
  a decision of its own?
- What should happen when a flow matches both a permission and a prohibition?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 15.
