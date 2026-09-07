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
- [rdf-prolog-roundtrip](https://github.com/eyereasoner/rdf-prolog-roundtrip) — standalone RDF 1.2 ↔ ISO Prolog bridge used by the RDF examples
- [ISO conformance review](test/conformance/ISO-COMPLIANCE.md) — supported Part 1 profile
- [Latest Neumerkel conformity](test/conformance/NEUMERKEL-LATEST.md) — tracked result from the current live upstream inventory
- [Conformance report](conformance-report.md) — generated executable conformance status, local corpus summary, and known deviations
- [OpenRuleBench](openrulebench/README.md) — portable benchmark profile
## RDF, Prolog, and symbiotic knowledge graphs

EyeProlog can sit behind an RDF knowledge graph without inventing a private graph representation. [`rdf-prolog-roundtrip`](https://github.com/eyereasoner/rdf-prolog-roundtrip) converts RDF 1.2 datasets to ordinary `rdf(Subject, Predicate, Object, Graph)` facts, EyeProlog applies portable rules, and ground `rdf/4` results can be converted back to RDF.

The checked [Symbiotic Knowledge Graphs example](examples/symbiotic-knowledge-graph.pl) uses named graphs and RDF 1.2 triple terms to distinguish trusted knowledge, AI-proposed statements, and human review. Its [wide-audience companion](https://eyereasoner.github.io/eyeprolog/examples/deck/symbiotic-knowledge-graphs) explains why this is a useful present-day software model for human/AI/KG co-evolution: RDF supplies shared semantic memory, Prolog supplies explicit deliberation, AI supplies new hypotheses, and people remain participants in meaning and judgment.

The same RDF → Prolog → RDF boundary is exercised by five additional checked scenarios: [cross-organization data sharing](https://eyereasoner.github.io/eyeprolog/examples/deck/cross-organization-data-sharing), [explainable EV-depot configuration](https://eyereasoner.github.io/eyeprolog/examples/deck/explainable-ev-depot-configuration), [operational incident response](https://eyereasoner.github.io/eyeprolog/examples/deck/operational-incident-response), [software supply-chain vulnerability response](https://eyereasoner.github.io/eyeprolog/examples/deck/sbom-vulnerability-response), and a [scientific evidence graph](https://eyereasoner.github.io/eyeprolog/examples/deck/scientific-evidence-graph). Together they cover policy decisions, reversible configuration reasoning, dependency-graph diagnosis, transitive SBOM exposure, and evidence aggregation with explicit disagreement.

## Benchmarks
EyeProlog has 19 checksum-protected wall-clock benchmarks spanning recursion/indexing, constraints, tabling/WFS, DCGs, Eyelet, search, term I/O, attributes, rewriting, and the classic Prolog naive-reverse workload. Short workloads are adaptively batched before timing so millisecond-scale noise is not mistaken for a regression. Run `npm run benchmark`; create a machine-local comparison point with `npm run benchmark:baseline`; use `npm run test:benchmark` for harness checks. The checked [`examples/bench.pl`](examples/bench.pl) preserves the classic Quintus 1984 `nrev/2` workload on a 30-element list. For a comparable LIPS number, run `npm run benchmark:lips`: it executes the classic failure-driven `dobench/1` and `dodummy/1` loops in Prolog, subtracts dummy-loop CPU time, and applies the historical 496 procedure calls per reversal. The generic benchmark table still shows a quick wall-clock LIPS estimate for `classic-nrev`, but `benchmark:lips` is the canonical engine-speed measurement. LIPS is a historical basic-engine-speed indicator, not a whole-system performance score. Details are in [*The Art of EyeProlog*](the-art-of-eyeprolog.md).
For the project policy on post-ISO-standard and WG17 compatibility features such as digit separators, see [ISO/WG17 compatibility extensions](test/conformance/ISO-WG17-EXTENSIONS.md).
## Development
```sh
git clone https://github.com/eyereasoner/eyeprolog.git
cd eyeprolog
npm install
npm test
```
`npm test` is the release gate and fetches the latest seven Neumerkel conformity sources before the local gates; use `npm run test:offline` for a network-free pass, `npm run test:conformance` for all conformance layers, `npm run test:neumerkel` for live upstream only, and `npm run test:neumerkel:cached` only to reproduce the last fetch. Upstream counts are discovered dynamically. A stale tracked [latest Neumerkel report](test/conformance/NEUMERKEL-LATEST.md) produces a warning during normal tests. `npm run conformance:update:neumerkel` refreshes it from live upstream; `npm run conformance:sync:neumerkel` refreshes it from the exact successful snapshot already fetched by `npm test`; and `npm run conformance:check:neumerkel` verifies that snapshot without a second live fetch. npm's version lifecycle uses the sync path and stages the generated reports into the release commit. Exact bytes/hashes stay under Git-ignored `.cache/neumerkel/`. Benchmarks remain `npm run benchmark` and `npm run benchmark:lips`.
EyeProlog is released under the [MIT License](LICENSE.md).
