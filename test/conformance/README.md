# EyeProlog profile conformance suite

This directory contains executable tests for the EyeProlog implementation and
reasoner.
[*The Art of EyeProlog*](../../the-art-of-eyeprolog.md) is the reference for the
supported ISO Prolog profile, built-ins, extensions, and reasoner behavior.

The suite is intentionally file-based. Exact standard output, errors, warnings,
and proof output test the behavior of the JavaScript implementation.
[ISO-COMPLIANCE.md](ISO-COMPLIANCE.md) is the high-level Part 1 review and coverage map. [ISO-BUILTIN-MODE-ERROR-MATRIX.md](ISO-BUILTIN-MODE-ERROR-MATRIX.md)
tracks the row-by-row built-in review,
[ISO-TERM-SEMANTICS-MATRIX.md](ISO-TERM-SEMANTICS-MATRIX.md) closes 7.1-7.3,
[ISO-PROLOG-TEXT-EXECUTION-MATRIX.md](ISO-PROLOG-TEXT-EXECUTION-MATRIX.md)
closes 7.4-7.8, [ISO-EVALUABLE-FUNCTOR-MATRIX.md](ISO-EVALUABLE-FUNCTOR-MATRIX.md)
closes 7.9/Clause 9, and [ISO-PROCESSOR-REQUIREMENTS.md](ISO-PROCESSOR-REQUIREMENTS.md)
decomposes the Clause 5 processor obligations.
[ISO-CORRIGENDA-MATRIX.md](ISO-CORRIGENDA-MATRIX.md) gives every published
Corrigenda amendment cluster an executable, editorial, or superseded
disposition. [ISO-PART2.md](ISO-PART2.md) and [ISO-PART3.md](ISO-PART3.md) record,
directive by directive and predicate by predicate, what the normal profile
implements of Part 2 (modules) and Part 3 (definite clause grammar rules),
including the 2013 module-amendment evidence and the known gaps and deviations.
Neither part carries a conformance claim. Built-in rows may group closely related conditions only when the
row names every grouped condition and its executable evidence.
The exit checklist is embedded in [ISO-COMPLIANCE.md](ISO-COMPLIANCE.md). [WG17-SYNTAX-STATUS.md](WG17-SYNTAX-STATUS.md) records the
complete one-to-one trace for the vendored active upstream WG17 syntax cases.
[STC-DRAFT-STATUS.md](STC-DRAFT-STATUS.md) separately tracks executable
implementation questions from the post-N289 working draft (reviewed through the 2026-08-23 items #73-#76); those cases are
review evidence, not normative ISO claims.

“Conformance” here means conformance to EyeProlog's documented ISO compatibility
profile and implementation extensions. The default registry covers the exact
predicate indicators listed in Appendix B of the book across the Part 1 strict-core
target and the normal-mode module/DCG compatibility families. [ISO-COMPLIANCE.md](ISO-COMPLIANCE.md) is the explicit
release-facing ledger for the Part 1 strict-core review. This suite is not an independent certification. The release-facing Part 1
ledger now has explicit dispositions for Clause 5 processor obligations, Clause 6
syntax/rejection, Clause 7 semantics, the complete 8.2-8.17 built-in family, and
Clause 9 evaluable functors. Public comparison material remains supporting review
evidence rather than a duplicated vendored corpus. Cases under `iso/`
identify standards-derived behavior; other directories cover EyeProlog host
contracts and extensions. EyeProlog-only execution features such as explicit
tabling, `tnot/1` well-founded negation, and `wfs_truth/2` inspection are outside the Part 1 strict-core
claim. Their focused semantic coverage lives primarily in regression tests;
`tnot/1` and `wfs_truth/2` are absent from the strict ISO registry. The processor character set is documented as the Unicode scalar repertoire with
scalar-value collation in both normal and strict profiles; `--iso-strict`
therefore changes only implementation-specific language facilities, not this
implementation-defined processor choice.

All conformance files live under topic directories such as `arithmetic/`, `lists/`, `syntax/`, or `variables/`; new top-level numbered files should not be added. The report uses those directories as coverage categories.

A normal positive case consists of:

- `conformance/cases/<name>.pl` — input program;
- `conformance/expected/<name>.pl` — exact expected standard output, stored as EyeProlog-readable facts.

Expected-error cases consist of:

- `conformance/errors/<name>.pl` — input program that must fail during parsing or execution;
- `conformance/expected-errors/<name>.txt` — exact expected error message followed by a newline.

Expected-warning cases consist of:

- `conformance/warnings/<name>.pl` — input program run through the CLI with `--warnings`;
- `conformance/expected-warnings/<name>.pl` — exact expected standard output;
- `conformance/expected-warnings/<name>.txt` — exact expected standard error.

Expected-proof cases consist of:

- `conformance/proofs/<name>.pl` — input program run through the CLI with `--proof`;
- `conformance/expected-proofs/<name>.pl` — exact expected standard output, including both answer facts and `why/2` proof facts.

Case names may be nested in category directories such as `arithmetic/`, `strings/`, `lists/`, `terms/`, `atoms/`, `variables/`, `negation/`, or `syntax/`. Expected files mirror the same relative path.

## Running the suite

The release gate is network-aware by design: it checks the current upstream
Neumerkel conformity material before the deterministic local corpus.

```sh
npm test
```

For an offline-only development pass:

```sh
npm test -- --offline
```

The conformance commands are:

```sh
node test/run-conformance-all.mjs          # live Neumerkel + local ISO/conformance layers
node test/run-conformance-all.mjs --offline  # same local layers, no network
node test/run-neumerkel.mjs            # the seven live upstream suites only
node test/run-neumerkel.mjs --cached     # exact last fetched bytes; reproduction only
node test/run-neumerkel.mjs --cached --verify-report # verify tracked report against last successful live snapshot
node test/run-iso-strict.mjs                  # Part 1 + Corrigenda strict-core processor gate
node test/run-iso-part2-amendment.mjs  # 2013 Part 2 amendment module requirements
node test/run-wg17.mjs                 # vendored reviewed WG17 syntax regression
```

`node test/run-neumerkel.mjs` always fetches the current TU Wien sources. It does not skip a
fetch because a cache exists. The runner discovers the number of active tests from those sources and fails on any newly introduced case EyeProlog does not pass. If the stable, tracked [NEUMERKEL-LATEST.md](NEUMERKEL-LATEST.md) is stale, normal tests warn rather than turning a passing engine run into a failure. `node test/run-neumerkel.mjs --update-report` performs a fresh live run and refreshes the report; after `npm test`, `node test/run-neumerkel.mjs --cached --update-report` refreshes it from the exact successful cached snapshot; and `node test/run-neumerkel.mjs --cached --verify-report` verifies that snapshot without a second network fetch. Exact bytes, SHA-256 hashes, timestamps, and HTTP validators stay under Git-ignored `.cache/neumerkel/` for inspection/reproduction only. See [NEUMERKEL-LIVE.md](NEUMERKEL-LIVE.md).

The vendored WG17 syntax snapshot is intentionally secondary. Update it with `npm run conformance:update:wg17`. For focused upstream report maintenance and verification:

```sh
npm run conformance:update:wg17
node test/run-neumerkel.mjs --update-report
node test/run-neumerkel.mjs --cached --update-report
node test/run-wg17.mjs
```

Every vendored syntax case is still checked against its upstream Codex
expectation; reviewed exact outcomes are an additional regression lock rather
than an alternative acceptance rule.

Regenerate the top-level local-corpus report with `node test/run-conformance-report.mjs conformance-report.md`. It links to [NEUMERKEL-LATEST.md](NEUMERKEL-LATEST.md) rather than duplicating live evidence. Counts in the tracked Neumerkel report are generated evidence, not permanent constants in project policy.

Run a matching local file-based conformance subset directly with:

```sh
node test/run-conformance.mjs reusable
node test/run-conformance.mjs variables/
node test/run-conformance.mjs error/variables
```

## Scope

The corpus covers accepted syntax, typed scalar identity and explicit scalar conversions, query answers,
read-back printing, built-ins, directives, warnings, errors, proof output,
and host behavior. It verifies the book's descriptions and is not a separate
language specification.

The `iso/` category follows the mode, success/failure, and error rows in
ISO/IEC 13211-1 clauses 7 and 8. In particular, isolated negative cases keep
instantiation, type, domain, permission, representation, and evaluation errors
independently observable.

Selected cases are adapted from the ISO and standard-core suites of Logtalk,
Scryer Prolog, Trealla Prolog, and SWI-Prolog. Their upstream identifiers and licenses
are recorded in [THIRD_PARTY.md](THIRD_PARTY.md).

The corpus has 393 cases in `iso/` and 810 file-based conformance cases in total. Of those, 11 cases in `stc/` are explicitly labelled working-draft review evidence rather than normative ISO claims. The separate vendored strict-reader WG17 matrix is a deterministic regression snapshot; the live Neumerkel gate discovers the current upstream inventory at run time; release/report checks separately verify the tracked `NEUMERKEL-LATEST.md`. The generated `conformance-report.md` records local corpus totals and links to that live evidence. Together with regression, documentation-sync, API, example, and book-example checks, `npm test` is the release gate.

## Updating expected output

There is no committed auto-accept mode. To update an expected file, run the matching case with the conformance runner, inspect the result, and replace the corresponding file under `conformance/expected/`, `conformance/expected-errors/`, `conformance/expected-warnings/`, or `conformance/expected-proofs/` deliberately.
