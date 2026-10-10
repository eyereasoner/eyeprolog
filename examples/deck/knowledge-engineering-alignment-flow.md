# Knowledge-engineering alignment

## Can data in a local vocabulary be read as a shared standard without rewriting it?

Real data arrives in local terms such as `observed_by` and
`temperature_celsius`. Applications want shared vocabularies, like the W3C
SOSA ontology for sensor observations. This example keeps the source facts as
they are, states the alignment as facts, and lets generic rules derive the
target view.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=knowledge-engineering-alignment-flow) ·
[Source](../knowledge-engineering-alignment-flow.pl)

---

# The question

A temperature message uses local names. How is it expressed in a SOSA-like
target vocabulary, and which processing step can trust which sensor?

The pattern is common in knowledge engineering: **source data**, a declarative
**mapping**, and **derived target facts**, each kept separate.

---

# Source data and mapping

```prolog
sub_class(local_observation, sosa_observation).
sub_class(temperature_probe, sosa_sensor).
sub_property(observed_by, sosa_madeBySensor).
sub_property(in_flow, fpv_hasFlowStep).
equivalent_property(observed_feature, sosa_hasFeatureOfInterest).

base_type(msg1, local_observation).
triple(msg1, observed_by, probe7).
triple(msg1, temperature_celsius, 18.6).
triple(msg1, in_flow, ingest_step).
```

`sub_class` and `sub_property` say that a local name is a more specific case
of a target name. `equivalent_property` says that two names mean the same.
The `triple/3` facts are the message itself, untouched.

---

# Generic alignment rules

```prolog
type(Thing, Super) :- base_type(Thing, Class), sub_class_of(Class, Super).

target_fact(Subject, Superpredicate, Object) :- triple(Subject, Predicate, Object), sub_property(Predicate, Superpredicate).
target_fact(Subject, Targetpredicate, Object) :- triple(Subject, Predicate, Object), equivalent_property(Predicate, Targetpredicate).

trusted_by(Step, Sensor) :- type(Message, sosa_observation), target_fact(Message, fpv_hasFlowStep, Step), target_fact(Message, sosa_madeBySensor, Sensor).
```

The rules mention no particular property. Adding a new mapping fact extends
the target view without touching the rules. `trusted_by/2` is written purely
in the target vocabulary.

---

# The answer

```sh
eyeprolog examples/knowledge-engineering-alignment-flow.pl
```

```text
type(msg1, sosa_observation).
type(probe7, sosa_sensor).
target_fact(msg1, sosa_madeBySensor, probe7).
target_fact(msg1, sosa_hasSimpleResult, 18.6).
target_fact(msg1, fpv_hasFlowStep, ingest_step).
flow_emits(ingest_step, msg1).
trusted_by(ingest_step, probe7).
```

These are 7 of 21 answers. The full output also lists the base types, every
target fact, and the mapping summaries `runtime_rule/2` and
`target_predicate/2`. The message is now a SOSA observation made by
`probe7`, emitted by the `ingest_step` of the flow.

---

# The reason

```sh
eyeprolog --proof examples/knowledge-engineering-alignment-flow.pl
```

```text
step(flow_emits(ingest_step, msg1),
     rule(26),
     ['Step' = ingest_step, 'Message' = msg1],
     [type(msg1, sosa_observation),
      target_fact(msg1, fpv_hasFlowStep, ingest_step),
      target_fact(msg1, sosa_madeBySensor, probe7)]).
```

The flow conclusion rests on three target-vocabulary facts. Each of those has
its own step, tracing back to one source triple and one mapping fact, so the
proof shows exactly which alignment produced it.

---

# The check

```text
condition('C1', resolution, ok, 37).
condition('C4', coverage, ok, 55).
condition('C7', relevance, ok, 58).
verdict(checked).
```

All 37 steps replay against the program and cover all 21 claims. No built-ins
and no trusted boundaries are involved: the whole alignment is plain logic.

---

# Try it

- Add `sub_class(sosa_sensor, sosa_system).`. Does `type(probe7, sosa_system)`
  appear? Which rule makes it transitive?
- Add a second message with a different sensor and flow step, and predict the
  new `trusted_by/2` answers.
- Map `temperature_celsius` with `equivalent_property` instead of
  `sub_property`. Which answers change, and why does the third `target_fact/3`
  clause matter?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
