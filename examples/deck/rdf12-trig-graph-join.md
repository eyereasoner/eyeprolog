# RDF 1.2 graph join

## Which station reported this sensor reading?

Sensor readings sit in a named graph. A triple in the default graph says which
station reported that whole graph. One rule joins the two levels, so each
sensor is linked to its reporting station.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=rdf12-trig-graph-join) ·
[Source](../rdf12-trig-graph-join.pl)

---

# The question

Which station is responsible for each sensor's data?

This is one of a family of RDF 1.2 examples. RDF data arrives as
`rdf(Subject, Predicate, Object, Graph)` facts, as produced by
[rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange).
In TriG, a graph name can itself be the subject of triples, which is how
datasets record provenance about whole graphs.

---

# The data

```prolog
rdf(iri('https://example.org/sensorGraph'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph).
rdf(iri('https://example.org/sensor1'), iri('https://example.org/temperature'), literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/sensorGraph')).
```

The first triple is **metadata about a graph**: `sensorGraph` was reported by
`station7`. The second is **data inside that graph**.

---

# The rule

```prolog
result_rdf(S, iri('https://example.org/reportedBy'), Station, default_graph) :-
  rdf(
    iri('https://example.org/sensorGraph'),
    iri('https://example.org/reportedBy'),
    Station,
    default_graph
  ),
  rdf(
    S,
    iri('https://example.org/temperature'),
    _,
    iri('https://example.org/sensorGraph')
  ).
```

The first goal reads the graph's metadata; the second finds the sensors whose
readings are in that graph. The join goes through the graph name.

---

# The answer

```sh
eyeprolog examples/rdf12-trig-graph-join.pl
```

```text
result_rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph).
```

---

# The reason

```text
step(result_rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
     rule(3),
     ['S' = iri('https://example.org/sensor1'), 'Station' = iri('https://example.org/station7')],
     [rdf(iri('https://example.org/sensorGraph'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
      rdf(iri('https://example.org/sensor1'), iri('https://example.org/temperature'), literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/sensorGraph'))]).
```

The conclusion uses two premises from two different graphs, and the proof
names both.

---

# The check

```text
condition('C1', resolution, ok, 3).
condition('C4', coverage, ok, 3).
condition('C7', relevance, ok, 4).
trusted(0).
verdict(checked).
```

---

# Try it

- Replace the fixed `sensorGraph` IRI in the rule with a variable, so every
  reported graph is joined with its own readings.
- Add a second sensor to `sensorGraph` and predict the output.
- Compare with [named-graph reasoning](rdf12-trig-named-graph.md), where rules
  stay inside one graph.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 15.
