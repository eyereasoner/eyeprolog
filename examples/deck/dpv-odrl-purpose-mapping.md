# Mapping a data-processing record to a policy

## Does this policy really say what the processing record says?

A hospital describes a data-processing activity in **DPV**, the Data Privacy
Vocabulary, and grants a matching permission in **ODRL**, the W3C policy
language. Both are RDF. This example checks, role by role, that the policy
lines up with the processing record, and returns the verified mapping as RDF.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dpv-odrl-purpose-mapping) ·
[Source](../dpv-odrl-purpose-mapping.pl)

---

# The question

The processing record names a data controller, a recipient, personal data, a
kind of processing, a purpose, and a legal basis. The policy names an
assigner, an assignee, a target, an action, and constraints. Do the six pairs
correspond?

---

# The data

```prolog
rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasDataController'), iri('https://example.org/hospital_a'), default_graph).
rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasPurpose'), iri('https://w3id.org/dpv#Healthcare'), default_graph).
rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/assigner'), iri('https://example.org/hospital_a'), default_graph).
```

Every RDF triple becomes one `rdf/4` fact: subject, predicate, object, and the
graph it belongs to. The program was generated from RDF by
rdf-prolog-interchange.

---

# The rules

```prolog
mapped_role(data_controller, Controller, assigner) :-
  rdf_link(ex(alpha_care_process), dpv(hasDataController), ex(Controller)),
  rdf_link(ex(alpha_permission), odrl(assigner), ex(Controller)).

mapped_role(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)) :-
  rdf_link(ex(alpha_care_process), dpv(hasPurpose), dpv('Healthcare')),
  odrl_constraint(alpha_purpose_constraint, odrl(purpose), dpv('Healthcare')).

rdf_link(Subject, Predicate, Object) :-
  iri_term(Subject, SubjectIri),
  iri_term(Predicate, PredicateIri),
  rdf(iri(SubjectIri), iri(PredicateIri), iri(ObjectIri), default_graph),
  iri_term(Object, ObjectIri).
```

Each `mapped_role/3` clause states one correspondence: the same controller must
appear as the DPV data controller and the ODRL assigner, and the DPV purpose
must reappear as an ODRL purpose constraint. `rdf_link/3` lets the rules use
short prefixed names instead of full IRIs.

---

# The answer

```sh
eyeprolog examples/dpv-odrl-purpose-mapping.pl
```

```text
result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/sourceRole'), iri('https://example.org/role/data_controller'), default_graph).
result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/value'), iri('https://example.org/hospital_a'), default_graph).
result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/assigner'), default_graph).
```

All six correspondences hold. Each is reported as three RDF triples (source
role, value, and policy target), 18 answers in all, ready to be converted back
to RDF.

---

# The reason

```sh
eyeprolog --proof examples/dpv-odrl-purpose-mapping.pl
```

```text
step(mapped_role(data_controller, hospital_a, assigner),
     rule(27),
     ['Controller' = hospital_a],
     [rdf_link(ex(alpha_care_process), dpv(hasDataController), ex(hospital_a)),
      rdf_link(ex(alpha_permission), odrl(assigner), ex(hospital_a))]).
```

Hospital A is mapped from data controller to assigner because both RDF
statements are present: the process names it as controller and the permission
names it as assigner.

---

# The check

```sh
eyeprolog --proof examples/dpv-odrl-purpose-mapping.pl > dpv-odrl-purpose-mapping.why.pl
eyeprolog --check-proof dpv-odrl-purpose-mapping.why.pl examples/dpv-odrl-purpose-mapping.pl
```

```text
condition('C1', resolution, ok, 142).
condition('C4', coverage, ok, 244).
condition('C7', relevance, ok, 200).
verdict(checked).
```

All 142 rule steps replay and the 40 `atom_concat/3` steps that build IRIs are
recomputed. Every one of the 18 claims is covered, and nothing is taken on
trust.

---

# Try it

- Change the ODRL assignee to a different organisation. Which mapping
  disappears from the result?
- Change the purpose constraint's right operand from `dpv#Healthcare` to
  `dpv#Marketing`. What does the report say now?
- Add a seventh correspondence, for example between a DPV retention period and
  an ODRL constraint.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 15 (explicit data boundaries).
