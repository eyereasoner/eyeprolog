# Symbiotic Knowledge Graphs with RDF, EyeProlog, and people

## One idea, in plain language

**AI should not merely read a knowledge graph. People, AI, and the knowledge graph should improve one another while keeping meaning, provenance, uncertainty, and reasons explicit.**

This example is inspired by Ruben Taelman's ISWC 2026 vision article, [*Symbiotic Knowledge Graphs: A Vision for Semantic Brain-Computer Interfaces*](https://rubensworks.github.io/article-iswc2026-vision-symbiotic-knowledge-graphs/).

The demonstration does not claim that EyeProlog is a brain-computer interface. It shows a software architecture for something a future semantic interface would need: knowledge that can move between people and machines without collapsing into an opaque prompt or model state.

The architecture uses two small projects with deliberately separate jobs:

- [`rdf-prolog-interchange`](https://github.com/eyereasoner/rdf-prolog-interchange) moves RDF 1.2 datasets to and from ordinary `rdf/4` Prolog facts. It contains no Prolog solver.
- [EyeProlog](https://github.com/eyereasoner/eyeprolog) reasons over those facts with explicit ISO Prolog rules.

That separation is the central design choice. **RDF remains the shared interchange and publication layer; Prolog becomes the transparent reasoning layer.**

## The real-world story: a city heatwave

A city operations team must protect the Riverside neighbourhood during a severe heatwave.

Several sources contribute knowledge:

- the city facilities registry says which buildings are open, cooled, accessible, and how many people they can hold;
- the emergency plan says Riverside expects 70 people and has a mobile cooling unit available;
- a transit plan says which routes connect Riverside to cooling centres;
- a power sensor reports unstable electricity at Central Hall;
- an official transit feed says Route 7 is now suspended;
- a facilities bulletin says Riverside School may be used as an emergency cooling centre;
- a community post claims Central Hall is closed;
- a volunteer message claims North Library has only 40 usable places.

An AI agent extracts the last four items as candidate knowledge. But **candidate knowledge is not automatically truth**.

The system must answer a practical question:

> What should Riverside do now, and why?

## The actual data flow

```text
RDF 1.2 dataset
    |
    | rdf-to-prolog
    v
ordinary rdf(Subject, Predicate, Object, Graph) facts
    |
    | + ISO Prolog governance and decision rules
    v
EyeProlog
    |
    | result_rdf/4
    v
ground rdf/4 result facts
    |
    | prolog-to-rdf
    v
RDF 1.2 dataset again
```

There is no hidden RDF-to-reasoner object model in between. The bridge is intentionally boring and inspectable.

The checked files are:

```text
examples/data/symbiotic-knowledge-graph-input.nq
examples/data/symbiotic-knowledge-graph-rules.pl
examples/symbiotic-knowledge-graph.pl
examples/data/symbiotic-knowledge-graph-output.pl
examples/data/symbiotic-knowledge-graph-output.nq
```

`examples/symbiotic-knowledge-graph.pl` is the generated combination of the RDF source facts and the maintained rules file.

## Why RDF named graphs matter

The source dataset does not flatten everything into one graph. It keeps separate named graphs for:

- city facilities;
- the emergency plan;
- transit planning;
- power sensors;
- evidence metadata;
- AI proposals;
- human review.

That means provenance is not just prose in a log message. It participates in reasoning.

A rule can distinguish an official live feed from a public report. It can also distinguish an old planning value from a volatile current status.

For example, the older transit plan says Route 7 is `running`, while a newer official feed proposes `suspended`. Because transit status is explicitly declared replaceable and the source is an authoritative live feed, the newer value can supersede the planning value without deleting the history of either statement.

## RDF 1.2 triple terms keep proposals separate from truth

The AI proposal graph uses RDF 1.2 triple terms.

Conceptually, proposal `p2` says:

```text
p2 statement <<( RiversideSchool emergencyDesignation CoolingCenter )>>
p2 agent LanguageAgent
p2 evidence FacilitiesBulletin
p2 confidencePercent 93
```

The embedded triple is a **statement being talked about**. It is not yet an asserted operational fact.

After `rdf-prolog-interchange`, the same structure is an ordinary Prolog term:

```prolog
rdf(
  iri('https://example.org/city/proposal/p2'),
  iri('https://example.org/vocab/statement'),
  triple(
    iri('https://example.org/city/facility/riverside-school'),
    iri('https://example.org/vocab/emergencyDesignation'),
    iri('https://example.org/city/class/cooling-center')
  ),
  iri('https://example.org/graph/ai-proposals')
).
```

This is an important safety and governance boundary:

**generation produces a candidate; policy and review determine whether that candidate becomes shared knowledge.**

## Before human review

The reasoning layer accepts one proposal automatically:

```text
proposal_state(p1, auto_accepted).
```

That is the high-confidence official transit update saying Route 7 is suspended.

The school proposal is not automatic because opening an emergency public venue is governed by human approval:

```text
proposal_state(p2, human_accepted).
```

That state becomes available only in the `after_review` stage.

Before that review is applied, EyeProlog sees:

- Route 7 is suspended;
- Central Hall has unstable power;
- Riverside School has enough capacity and cooling, but is not yet an approved cooling centre.

So it derives:

```text
recommended_action(before_review, riverside, deploy_mobile_unit).
```

The explanation comes from the same logical state:

```text
Route 7 is suspended, Central Hall has unstable power, and Riverside School is not yet an approved cooling centre; deploy the mobile unit.
```

## Human review changes shared knowledge

The emergency coordinator verifies the facilities bulletin by phone and accepts proposal `p2`.

The operations officer rejects proposal `p3`, the community claim that Central Hall is closed, because the official operations desk confirms it is open.

Proposal `p4`, the low-confidence capacity claim, remains unresolved.

The point is not that humans are infallible. The point is that **human judgment is represented as first-class graph knowledge with provenance**, instead of disappearing into a chat transcript or a UI click that no later reasoner can inspect.

The accepted proposal creates exactly one new operational fact:

```text
knowledge_gain(riverside_school, emergency_designation, cooling_center).
```

## After review

Once Riverside School is an accepted emergency cooling centre, EyeProlog can combine that fact with existing RDF knowledge about location, capacity, cooling, status, and accessibility.

The recommendation changes:

```text
recommended_action(after_review, riverside, open_local_center(riverside_school)).
```

That is the symbiotic loop in one example:

1. the graph gives the AI a grounded operational context;
2. the AI extracts useful candidate knowledge from new information;
3. Prolog checks trust, conflicts, policy, and consequences;
4. a person resolves the governed uncertainty;
5. the accepted knowledge improves the graph;
6. the improved graph changes the next machine recommendation;
7. the result can be published back as RDF and reused by other systems.

## The result really goes back to RDF

EyeProlog exposes `result_rdf/4` for the facts that should leave the reasoning process.

Among those results is the newly accepted statement:

```prolog
rdf(
  iri('https://example.org/city/facility/riverside-school'),
  iri('https://example.org/vocab/emergencyDesignation'),
  iri('https://example.org/city/class/cooling-center'),
  iri('https://example.org/graph/accepted-knowledge')
).
```

`prolog-to-rdf` turns the ground result back into RDF 1.2. The checked output also contains the review outcomes and the before/after operational decisions.

This matters because a symbiotic KG should not end at “the model answered correctly”. Its improvements must be available to the next user, agent, query engine, or organization.

## Why Prolog is unusually close to human explicit reasoning

Knowledge graphs are excellent shared memory. Neural models are excellent at perception, extraction, similarity, and generation. The missing layer is often **explicit deliberation**: what follows, what conflicts, what is allowed, what else could work, and why.

For that layer, Prolog has an unusual cognitive advantage.

Among widely used computational formalisms, **Prolog is arguably one of the closest to the explicit, communicable surface of human cognition**. Not to neurons or perception, but to the way people *state and exchange reasons*.

| Human cognitive act | Prolog counterpart |
| --- | --- |
| “Central Hall is open.” | fact |
| “A safe centre must be open, cooled, accessible, and large enough.” | rule |
| “Where can Riverside send people?” | query |
| “Riverside School.” | variable binding / answer |
| “What else could work?” | backtracking |
| “Not Central Hall; its power is unstable.” | failed alternative under explicit conditions |
| “Why this recommendation?” | proof / explanation |
| “That machine claim is wrong.” | explicit review changing shared knowledge |

Most mainstream programming models force this reasoning through sequences of state-changing instructions. Vector models encode it in high-dimensional parameters. SQL is superb for asking structured data questions but does not itself give the same general rule-and-search model.

Prolog lets the *objects of thought* remain visible as facts, rules, questions, alternatives, bindings, and explanations.

That does **not** mean the brain literally executes Horn clauses. Human cognition also involves perception, emotion, embodiment, analogy, memory dynamics, learning, uncertainty, and many processes that Prolog does not model. The narrower claim is the important one for symbiotic systems: **when humans externalize knowledge and reasons, Prolog's surface structure is remarkably close to what they say.**

That closeness makes it easier for a person to enter the machine's reasoning loop without first translating everything into an imperative program or accepting an opaque latent representation.

## Why the RDF ↔ Prolog boundary strengthens the argument

Without RDF, the Prolog example could be dismissed as a hand-written toy knowledge base.

With `rdf-prolog-interchange`, the roles are clearer:

- RDF provides Web identifiers, graph boundaries, literals, RDF 1.2 triple terms, and interoperable publication;
- `rdf-prolog-interchange` preserves those structures as ordinary ISO Prolog terms;
- EyeProlog applies explicit rules and explores alternatives;
- materialized conclusions return to RDF.

So Prolog is not replacing the Knowledge Graph. It is giving the graph an inspectable reasoning metabolism.

A useful shorthand is:

> **RDF is shared semantic memory. Prolog is explicit semantic thought. AI is a powerful source of new perceptions and hypotheses. Humans remain participants in meaning and judgment.**

## Why this supports the Semantic BCI vision

A future Semantic Brain-Computer Interface would need more than neural bandwidth. It would need a semantic contract between human and machine.

The software demo exercises several pieces of such a contract today:

- assertions have stable identity;
- provenance remains attached to contributions;
- machine hypotheses can exist without being asserted as truth;
- confidence is distinct from authority;
- rules describe what follows;
- contradictions remain inspectable;
- human acceptance and rejection are explicit semantic events;
- reasons can travel back to the person;
- accepted knowledge can be republished for later machine use.

A direct neural interface would change the input/output channel. It would not remove the need for those semantic distinctions; it would make them more important.

## Reproduce the roundtrip

Assuming `rdf-prolog-interchange` and EyeProlog are available on `PATH`:

```sh
rdf-to-prolog \
  examples/data/symbiotic-knowledge-graph-input.nq \
  --rules examples/data/symbiotic-knowledge-graph-rules.pl \
  -o examples/symbiotic-knowledge-graph.pl
```

Run the checked EyeProlog example:

```sh
node test/run-examples.mjs
```

Materialize only the RDF-shaped results:

```sh
eyeprolog --goal write_results examples/symbiotic-knowledge-graph.pl \
  > examples/data/symbiotic-knowledge-graph-output.pl
```

Convert those results back to RDF:

```sh
prolog-to-rdf \
  examples/data/symbiotic-knowledge-graph-output.pl \
  -o examples/data/symbiotic-knowledge-graph-output.nq
```

The checked files show all four boundaries, so the story is reproducible without trusting a slide diagram.

## What a broad audience should remember

A symbiotic knowledge graph is not “RAG with a graph”. It is a feedback system in which:

- **AI proposes**;
- **RDF preserves shared meaning and provenance**;
- **Prolog reasons and exposes alternatives**;
- **humans judge where judgment is required**;
- **accepted results become reusable knowledge**;
- **the next machine decision starts from a better graph**.

The deepest reason Prolog fits this vision is not nostalgia or syntax. It is that its basic computational vocabulary—facts, rules, questions, answers, alternatives, and proofs—is already close to the vocabulary humans use when they explain what they know and why they believe something follows.

## References

- Ruben Taelman, [*Symbiotic Knowledge Graphs: A Vision for Semantic Brain-Computer Interfaces*](https://rubensworks.github.io/article-iswc2026-vision-symbiotic-knowledge-graphs/).
- [`eyereasoner/rdf-prolog-interchange`](https://github.com/eyereasoner/rdf-prolog-interchange) — standalone RDF 1.2 ↔ ISO Prolog roundtripping toolkit.
- [`eyereasoner/eyeprolog`](https://github.com/eyereasoner/eyeprolog) — ISO Prolog reasoning and proof engine.
