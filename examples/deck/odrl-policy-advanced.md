# Advanced ODRL policy

## One policy, three requests, three different outcomes

A hospital asks to use a health dataset for research, to use it commercially,
and to transfer it. One ODRL policy graph answers all three: a permit with a
duty, a denial because the purpose does not match, and a denial because the
action is explicitly prohibited.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=odrl-policy-advanced) ·
[Source](../odrl-policy-advanced.pl)

---

# The question

A real policy does more than say yes or no. It attaches **duties** to a
permission (here: de-identify the data), restricts it with **constraints**
(purpose must be medical research, region must be the EU), and can contain
**prohibitions** that forbid an action outright.

For each request, the system must give the decision *and* the reason in terms
of the policy.

---

# The requests

```prolog
request(research_use, research_hospital, use, health_dataset, medical_research, eu).
request(commercial_use, research_hospital, use, health_dataset, commercial, eu).
request(dataset_transfer, research_hospital, transfer, health_dataset, medical_research, eu).
```

The policy itself is 18 RDF triples, read through a small helper
`rdf_link/3` that maps short names such as `permission` and `duty` to their
ODRL IRIs.

---

# The rules

```prolog
policy_decision(Request, decision(Request, permit, [duty(DutyAction)])) :-
  permitted(Request, DutyAction).
policy_decision(Request, decision(Request, deny, [reason(purpose_mismatch)])) :-
  purpose_mismatch(Request).
policy_decision(Request, decision(Request, deny, [reason(prohibited)])) :-
  prohibited(Request).

purpose_mismatch(Request) :-
  request(Request, Assignee, Action, Target, Purpose, Region),
  rdf_link(advanced_policy, permission, Permission),
  rule_scope(Permission, Assignee, Action, Target),
  constraint_eq(Permission, spatial, Region),
  constraint_eq(Permission, purpose, RequiredPurpose),
  Purpose \= RequiredPurpose.
```

Each kind of decision is its own clause, and each carries its reason as data.
A purpose mismatch is not "no permit found": it is a permission that matches
in scope and region but requires a different purpose.

---

# The answer

```sh
eyeprolog examples/odrl-policy-advanced.pl
```

```text
result_rdf(iri('https://example.org/result/research_use'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph).
result_rdf(iri('https://example.org/result/commercial_use'), iri('https://example.org/decision'), iri('https://example.org/deny'), default_graph).
result_rdf(iri('https://example.org/result/dataset_transfer'), iri('https://example.org/decision'), iri('https://example.org/deny'), default_graph).
result_rdf(iri('https://example.org/result/research_use'), iri('https://example.org/duty'), iri('https://example.org/deidentify'), default_graph).
result_rdf(iri('https://example.org/result/commercial_use'), iri('https://example.org/reason'), iri('https://example.org/purpose_mismatch'), default_graph).
result_rdf(iri('https://example.org/result/dataset_transfer'), iri('https://example.org/reason'), iri('https://example.org/prohibited'), default_graph).
```

Research use is permitted with the duty to de-identify; commercial use is
denied for a purpose mismatch; transfer is denied because it is prohibited.

---

# The reason

```text
step(policy_decision(commercial_use, decision(commercial_use, deny, [reason(purpose_mismatch)])),
     rule(24),
     ['Request' = commercial_use],
     [purpose_mismatch(commercial_use)]).
step(commercial \= medical_research, builtin, [], []).
```

The commercial denial rests on `purpose_mismatch/1`, whose own step binds
`RequiredPurpose = medical_research` from the policy's purpose constraint. The
last test, `commercial \= medical_research`, is a built-in step: it cites no
clause, so the checker recomputes it.

---

# The check

```text
condition('C1', resolution, ok, 89).
condition('C5', re_decision, ok, 9).
condition('C7', relevance, ok, 104).
steps(98).
verified(89).
recomputed(9).
trusted(0).
verdict(checked).
```

89 steps replay against program clauses, and the 9 built-in steps (the `\=`
test and the `atom_concat/3` calls that build result IRIs) are recomputed and
agree. Nothing is trusted.

---

# Try it

- Change the commercial request's purpose to `medical_research`. Which
  decision does it get now, and with which duty?
- Add a request from a different assignee. Does any rule apply, or does the
  report fall silent for it? What would an explicit default-deny rule look
  like?
- Compare with the simpler [ODRL policy](odrl-policy.md) deck and with
  [ODRL policy reasoning](odrl-policy-reasoning.md), which adds conflicts and
  subsumption.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 25.
