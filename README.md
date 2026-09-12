# EyeProlog

[![npm version](https://img.shields.io/npm/v/eyeprolog.svg)](https://www.npmjs.com/package/eyeprolog)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21446308-blue.svg)](https://doi.org/10.5281/zenodo.21446308)

EyeProlog turns portable ISO Prolog programs into answers and inspectable proofs.

<p>
  <a href="https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog">
    <img src="book-assets/title-page.svg" alt="Read The Art of EyeProlog" title="Click to read The Art of EyeProlog" width="320">
  </a><br>
  <strong>Click the cover to read <em>The Art of EyeProlog</em>.</strong>
</p>

The single implementation reference is [*The Art of EyeProlog*](the-art-of-eyeprolog.md).
It documents the language, built-ins, libraries, command line, JavaScript API,
examples, proofs, conformance profile, and implementation.

## Twenty years of EYE, and the next twenty years

The Euler project began in 2001 and became EYE, a Prolog-based reasoner, in 2006; it is still alive in 2026. In a symbolic way, EYE remembers Leonhard Euler, who lost sight in one eye. The Retina project began in 2021 and became EyeProlog in 2026; we hope to keep it growing for the next twenty years. That continuation offers a second quiet remembrance of Euler, who later lost sight in his other eye—while the project keeps trying to see farther through logic, proof, and reasoning.

## Quick start

EyeProlog requires Node.js 18 or newer:

```sh
node --version
```

If necessary, upgrade through a Node version manager or the
[official Node.js download](https://nodejs.org/en/download).

Run EyeProlog without installing it globally:

```sh
npx --yes eyeprolog
?- member(X, [prolog, logic]).
   X = prolog
;  X = logic.
?- halt.
```

For a persistent command, use a user-owned npm prefix:

```sh
npm install --global --prefix "$HOME/.local" eyeprolog
export PATH="$HOME/.local/bin:$PATH"
eyeprolog
```

Add the `PATH` export to your shell startup file. Do not use `sudo npm install`;
npm's [EACCES guidance](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally/)
also recommends a Node version manager or a user-owned prefix.

Run a program non-interactively:

```sh
printf 'human(socrates).\nmortal(X) :- human(X).\n' |
  npx --yes eyeprolog --proof --goal 'mortal(socrates)' -
```

## Links

- [The Art of EyeProlog](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog) — complete reference
- [Why EyeProlog?](https://eyereasoner.github.io/eyeprolog/why-eyeprolog) — project scope and design
- [Playground](https://eyereasoner.github.io/eyeprolog/playground) — run EyeProlog in a browser
- [Examples](examples) — runnable programs and checked output
- [Example decks](examples/deck/README.md) — explainable RDF/Prolog scenarios with reproducible roundtrips
- [Introduction to EyeProlog](https://eyereasoner.github.io/eyeprolog/examples/deck/introduction-to-eyeprolog) — short presentation deck for first-time audiences
- [Symbiotic Knowledge Graphs](https://eyereasoner.github.io/eyeprolog/examples/deck/symbiotic-knowledge-graphs) — RDF ↔ Prolog heatwave-response demo for human/AI/KG co-evolution
- [rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange) — standalone RDF 1.2 ↔ ISO Prolog bridge used by the RDF examples
- [RDF and Prolog: Two Standards-Based Legs](https://github.com/eyereasoner/rdf-prolog-interchange/blob/main/why-rdf-prolog.md) — why W3C RDF and ISO Prolog form the foundation
- [ISO conformance review](test/conformance/ISO-COMPLIANCE.md) — supported Part 1 profile
- [Latest Neumerkel conformity](test/conformance/NEUMERKEL-LATEST.md) — tracked result from the current live upstream inventory
- [Conformance report](conformance-report.md) — generated executable conformance status, local corpus summary, and known deviations
- [OpenRuleBench](openrulebench/README.md) — portable benchmark profile
## RDF, Prolog, and symbiotic knowledge graphs

EyeProlog can sit behind an RDF knowledge graph without inventing a private graph representation. [`rdf-prolog-interchange`](https://github.com/eyereasoner/rdf-prolog-interchange) converts RDF 1.2 datasets to ordinary `rdf(Subject, Predicate, Object, Graph)` facts, EyeProlog applies portable rules, and ground `rdf/4` results can be converted back to RDF.

The checked [Symbiotic Knowledge Graphs example](examples/symbiotic-knowledge-graph.pl) uses named graphs and RDF 1.2 triple terms to distinguish trusted knowledge, AI-proposed statements, and human review. Its [wide-audience companion](https://eyereasoner.github.io/eyeprolog/examples/deck/symbiotic-knowledge-graphs) explains why this is a useful present-day software model for human/AI/KG co-evolution: RDF supplies shared semantic memory, Prolog supplies explicit deliberation, AI supplies new hypotheses, and people remain participants in meaning and judgment.

The same RDF → Prolog → RDF boundary is exercised by five additional checked scenarios: [cross-organization data sharing](https://eyereasoner.github.io/eyeprolog/examples/deck/cross-organization-data-sharing), [explainable EV-depot configuration](https://eyereasoner.github.io/eyeprolog/examples/deck/explainable-ev-depot-configuration), [operational incident response](https://eyereasoner.github.io/eyeprolog/examples/deck/operational-incident-response), [software supply-chain vulnerability response](https://eyereasoner.github.io/eyeprolog/examples/deck/sbom-vulnerability-response), and a [scientific evidence graph](https://eyereasoner.github.io/eyeprolog/examples/deck/scientific-evidence-graph). Together they cover policy decisions, reversible configuration reasoning, dependency-graph diagnosis, transitive SBOM exposure, and evidence aggregation with explicit disagreement.

## Performance
EyeProlog does not carry a separate wall-clock benchmark harness. `npm test`'s own elapsed time, run across thousands of conformance, regression, and example programs, is the coarse performance indicator instead — a real slowdown shows up there. [OpenRuleBench](openrulebench/README.md) remains a dedicated, checked correctness-and-scale benchmark for the Datalog rule-engine profile specifically.
For the project policy on post-ISO-standard and WG17 compatibility features such as digit separators, see [ISO/WG17 compatibility extensions](test/conformance/ISO-WG17-EXTENSIONS.md).
## Development
```sh
git clone https://github.com/eyereasoner/eyeprolog.git
cd eyeprolog
npm install
npm test
```
The npm command list is deliberately small:

- `npm test` (or `npm run test`): run the release gate, including live upstream conformity checks (WG17 syntax among them).
- `npm run generate`: rebuild generated library and book files.

Use `npm test -- --offline` for a network-free local pass (this also skips the live-discovered WG17 syntax check, since it has no offline snapshot). Focused checks remain available directly, for example `node test/run-regression.mjs docs`; see [test runners](test/README.md). The automatic version hooks still run the release gate, refresh and stage conformance reports, and push the release. Detailed upstream report maintenance is documented in the [conformance guide](test/conformance/README.md).

EyeProlog is released under the [MIT License](LICENSE.md).
