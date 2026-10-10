# ODRL policy

## May this dataset be used for research?

An ODRL policy arrives as an RDF graph: one permission, one target, one action,
and one purpose constraint. EyeProlog reads the graph as ordinary `rdf/4`
facts, decides whether the permission applies, and writes the decision back as
RDF.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=odrl-policy) ·
[Source](../odrl-policy.pl)

---

# The question

ODRL, the W3C Open Digital Rights Language, describes what may be done with an
asset: who may perform which action, on what target, under which constraints.

Here the question is narrow and concrete: does the policy permit **use** of
the **dataset** when the purpose is **research**? The answer must come from the
policy graph itself, not from code that already knows it.

---

# The policy as facts

```prolog
rdf(iri('https://example.org/policy'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/permission'), default_graph).
rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/dataset'), default_graph).
rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph).
rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/purpose-constraint'), default_graph).
rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph).
rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph).
rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/research'), default_graph).
```

Each RDF triple becomes one `rdf(Subject, Predicate, Object, Graph)` fact. The
constraint reads: *purpose* **equals** *research*.

---

# The decision rule

```prolog
odrl_policy_decision(permit(use, research, dataset)) :-
  rdf(
    iri('https://example.org/policy'),
    iri('http://www.w3.org/ns/odrl/2/permission'),
    Permission,
    default_graph
  ),
  rdf(
    Permission,
    iri('http://www.w3.org/ns/odrl/2/target'),
    iri('https://example.org/dataset'),
    default_graph
  ),
```

The rule continues with the action and the three parts of the constraint. The
variables `Permission` and `Constraint` join the triples: every condition must
hold for the **same** permission node, not for unrelated ones.

---

# The answer

```sh
eyeprolog examples/odrl-policy.pl
```

```text
result_rdf(iri('https://example.org/result'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph).
result_rdf(iri('https://example.org/result'), iri('https://example.org/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph).
result_rdf(iri('https://example.org/result'), iri('https://example.org/purpose'), iri('https://example.org/research'), default_graph).
result_rdf(iri('https://example.org/result'), iri('https://example.org/target'), iri('https://example.org/dataset'), default_graph).
```

The decision is **permit**, written as four RDF triples that a graph store can
load directly.

---

# The reason

```text
step(odrl_policy_decision(permit(use, research, dataset)),
     rule(8),
     ['Permission' = iri('https://example.org/permission'),
      'Constraint' = iri('https://example.org/purpose-constraint')],
     [rdf(iri('https://example.org/policy'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/permission'), default_graph),
      ...]).
```

The permit holds by the decision rule (clause 8) with `Permission` bound to the
permission node and `Constraint` to the purpose constraint. Its uses are
exactly the seven policy triples, so an auditor sees which parts of the graph
the decision rests on.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C4', coverage, ok, 15).
condition('C7', relevance, ok, 16).
trusted(0).
claims(4).
verdict(checked).
```

All 12 steps replay against the program, the 4 claims are covered, and
nothing is taken on trust.

---

# Try it

- Change the right operand from `research` to `marketing` and run again: the
  rule no longer fires, and there is no permit to report.
- Add a second permission node for another dataset and check that the join on
  `Permission` keeps the two apart.
- Compare with the richer [ODRL policy reasoning](odrl-policy-reasoning.md)
  deck, which adds prohibitions, duties, and conflicts.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 15.
