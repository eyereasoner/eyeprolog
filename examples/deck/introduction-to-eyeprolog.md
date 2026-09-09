---
marp: true
title: Introduction to EyeProlog
description: A short presentation introducing EyeProlog as a portable, inspectable ISO Prolog engine for answers, proofs, constraints, and RDF-backed reasoning.
---

# Introduction to EyeProlog

Portable Prolog reasoning for answers, proofs, constraints, and knowledge graphs

EyeProlog is meant to be approachable from two directions at once: it is small enough to embed in JavaScript applications, yet explicit enough that a conclusion can be explained as ordinary facts and rules.

---

## What is EyeProlog?

EyeProlog is an ISO-oriented Prolog implementation for JavaScript.

It turns explicit facts and rules into answers, variable bindings, checked example output, optional proof traces, and embeddable reasoning in Node.js or browsers.

The project’s emphasis is not only “can this query run?” but also “can we inspect what happened, test it again, and explain why the answer follows?” That makes EyeProlog useful for demos, documentation, knowledge-graph workflows, and applications that need a small transparent reasoning layer.

---

## Why Prolog?

Prolog is a language for relations.

Instead of spelling out every control step, you describe what must hold:

```prolog
human(socrates).
mortal(X) :- human(X).
```

Then you ask questions:

```prolog
?- mortal(socrates).
   true.
```

The same rule can answer a yes/no question, enumerate solutions, or participate in a larger proof. That reuse is one of the reasons Prolog remains attractive for rule-heavy software.

---

## The core idea

```text
facts + rules + query
        |
        v
  search by unification
        |
        v
answers with reasons
```

A query is not just a function call. It is a logical request: “find values that make this relation true.” EyeProlog searches by unifying terms, trying clauses, and backtracking over alternatives.

Because the input remains ordinary Prolog text, the boundary between data, rules, and answers stays inspectable.

---

## Quick start

Run EyeProlog without a global install:

```sh
npx --yes eyeprolog
```

Try a list query:

```prolog
?- use_module(library(lists)).
   true.
?- member(X, [prolog, logic]).
   X = prolog
;  X = logic.
```

The semicolon asks for another answer. This small interaction already shows the Prolog execution model: a relation can produce more than one solution.

---

## Programs are ordinary text

A file can contain facts, rules, and goals:

```prolog
human(socrates).
mortal(X) :- human(X).

?- mortal(X).
```

Run it:

```sh
eyeprolog examples/socrates.pl
```

The examples directory uses this same pattern at larger scale. Each runnable example has checked output, so examples are not just illustrative snippets; they are part of the release gate.

---

## Proofs are first-class

EyeProlog can show not only *what* was concluded, but *why*.

```sh
eyeprolog --proof examples/socrates.pl
```

Proof output is useful for debugging rules, explaining decisions, preserving audit trails, and keeping documentation honest. If a proof-producing example changes, the checked proof output changes too.

This is especially helpful when rules encode policies, risk decisions, or derived knowledge where the explanation matters as much as the final answer.

---

## ISO first, extensions visible

EyeProlog starts from ISO/IEC 13211-1 Prolog.

That matters because facts, rules, terms, control, errors, streams, arithmetic, and meta-calls have an external reference point. Strict ISO mode keeps that standardized core separate and testable.

Normal mode adds practical libraries and embedding features. The design goal is to keep extensions visible rather than hiding them inside an undocumented dialect.

---

## Constraints over integers: CLP(Z)

`library(clpz)` lets programs state relations over integers instead of manually enumerating arithmetic cases.

```prolog
:- use_module(library(clpz)).

?- X #>= 1, X #=< 4, Y #= X*X, labeling([X]).
   X = 1, Y = 1
;  X = 2, Y = 4
;  X = 3, Y = 9
;  X = 4, Y = 16.
```

This style is useful when you know the constraints before you know the values: scheduling, allocation, Sudoku, finite-domain puzzles, resource planning, and arithmetic search.

---

## Constraints over Booleans: CLP(B)

`library(clpb)` provides Boolean constraints with satisfiability, cardinality, counting, and optimization predicates.

```prolog
:- use_module(library(clpb)).

?- sat(card([2], [A,B,C,D]) * (A =< C) * (B # D)),
   labeling([A,B,C,D]).
```

The recent CLP(B) examples show several practical shapes: circuit verification, quorum constraints, feature-model counting, and weighted release planning.

Boolean constraints are compact when the domain is “on/off”, “selected/not selected”, “permitted/denied”, or “feature enabled/disabled”.

---

## RDF and knowledge graphs

EyeProlog pairs naturally with RDF through `rdf-prolog-interchange`:

```text
RDF dataset
  -> rdf(S, P, O, Graph) facts
  -> EyeProlog rules
  -> result_rdf/4 facts
  -> RDF dataset
```

RDF remains the interchange layer. Prolog remains the transparent reasoning layer.

This is useful when a knowledge graph needs explicit derivation rules, but the data should still move in and out as RDF rather than as a private in-memory structure.

---

## Categorized examples: start here

The example corpus is intentionally broad. A practical path through it is:

- **First steps:** `socrates.pl`, `ancestor.pl`, `list-collection.pl`.
- **Algorithms:** graph reachability, Dijkstra, parser, FFT, SAT/DPLL.
- **Integer constraints:** CLP(Z) queens, Sudoku, resource allocation.
- **Boolean constraints:** CLP(B) circuits, cardinality, feature models, planning.
- **Policies and decisions:** access control, ODRL, GDPR, trust flow.
- **RDF roundtrips:** symbiotic knowledge graph and domain-specific RDF scenarios.
- **Proofs:** examples with checked `--proof` output.

Use the [playground](https://eyereasoner.github.io/eyeprolog/playground) for quick exploration, or browse the [examples source tree](https://github.com/eyereasoner/eyeprolog/tree/main/examples) when you want to inspect the program and golden output side by side.

---

## Example path: constraints

For constraint reasoning, start with the small examples and move outward:

- `clpz-n-queens.pl` shows finite-domain search.
- `clpz-sudoku-9x9.pl` shows a familiar grid problem.
- `clpz-resource-allocation.pl` shows planning under resource limits.
- `clpb-boolean-circuit.pl` shows Boolean verification.
- `clpb-cardinality.pl` shows exact-count selection.
- `clpb-feature-model.pl` and `clpb-weighted-planning.pl` show product/release decisions.

Together these examples show that Prolog can describe a problem declaratively while constraint libraries do the propagation and search work.

---

## Example path: knowledge graphs

For RDF-backed reasoning, start with [Symbiotic Knowledge Graphs](https://eyereasoner.github.io/eyeprolog/examples/deck/symbiotic-knowledge-graphs).

Then explore the scenario decks:

- [Cross-organization data sharing](https://eyereasoner.github.io/eyeprolog/examples/deck/cross-organization-data-sharing)
- [Explainable EV-depot configuration](https://eyereasoner.github.io/eyeprolog/examples/deck/explainable-ev-depot-configuration)
- [Operational incident response](https://eyereasoner.github.io/eyeprolog/examples/deck/operational-incident-response)
- [SBOM vulnerability response](https://eyereasoner.github.io/eyeprolog/examples/deck/sbom-vulnerability-response)
- [Scientific evidence graph](https://eyereasoner.github.io/eyeprolog/examples/deck/scientific-evidence-graph)

Each scenario keeps source RDF, Prolog rules, generated Prolog, and output RDF as separate artifacts.

---

## Testing and conformance

EyeProlog’s release gate includes conformance cases, strict ISO tests, WG17 syntax cases, regression tests, runnable examples, proof examples, and documentation synchronization checks.

The point is simple: behavior should be reproducible, not anecdotal.

The examples are also linted for avoidable singleton-variable warnings. This keeps example code clean for users who run examples through stricter tooling or compare with other Prolog systems.

---

## When EyeProlog fits

EyeProlog is a good fit when a project needs explicit rules, inspectable conclusions, portable Prolog syntax, an embeddable JavaScript runtime, checked examples and proofs, and a clean boundary between data, rules, and results.

It is not trying to replace high-performance native Prolog systems. Its niche is transparent reasoning that can live close to JavaScript applications, documentation, and web-accessible demos.

---

## Where to go next

- Read [project README](https://github.com/eyereasoner/eyeprolog#readme) for setup and links.
- Open [EyeProlog playground](https://eyereasoner.github.io/eyeprolog/playground) to run examples in a browser.
- Browse [runnable examples](https://github.com/eyereasoner/eyeprolog/tree/main/examples) by category or filename.
- Read [Why EyeProlog?](https://eyereasoner.github.io/eyeprolog/why-eyeprolog) for the design motivation.
- Read [The Art of EyeProlog](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog) for the full reference.
