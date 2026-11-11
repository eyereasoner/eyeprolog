# Neumerkel conformity sources and cache

EyeProlog checks Ulrich Neumerkel's ISO/WG17 conformity material with dynamic
case inventories. Downloaded sources live in Git-ignored `.cache/neumerkel/`.
They remain outside Git, source release archives and the npm package.

`npm test` and `node test/run-neumerkel.mjs` reuse a complete cache without
contacting upstream. If a source is missing, the manifest is invalid, or a
source no longer matches its recorded SHA-256 hash and byte count, the runner
downloads all eight sources before checking them. A failed download leaves
the previous snapshot intact. The first run needs network access.

The eight TU Wien sources are:

1. `conformity_testing` — Part 1 syntax/reader/writer matrix;
2. `number_chars_cont_quad.pl` — `number_chars/2` continuation corpus;
3. `variable_names_quad.pl` — `variable_names/1` corpus;
4. `dif` — `dif/2` comparison table;
5. `length_quad.pl` — `length/2` corpus;
6. `phrase_quad.pl` — `phrase/2,3` corpus;
7. `prologue_quad.pl` — Prolog Prologue working-draft corpus;
8. `cleanup` — `setup_call_cleanup/3` examples.

Every run executes the cases discovered from its source bytes. `npm run sync`
refreshes all eight sources from current upstream, checks every discovered
case and updates [`NEUMERKEL-LATEST.md`](NEUMERKEL-LATEST.md). New upstream
rows therefore enter the next refreshed run automatically. The syntax
extractor reads TU Wien's labelled `Codex` column and checks the page's declared
total so hand-edited HTML cannot silently reduce coverage.

## Commands

```sh
npm test
npm run sync
npm run neumerkel
node test/run-neumerkel.mjs --cached
node test/run-neumerkel.mjs --cached --update-report
node test/run-neumerkel.mjs --cached --verify-report
```

`npm run neumerkel` forces a fresh download and requires the tracked report to
match. `--live` also forces a fresh download when using the runner directly.
`--cached` requires a complete, matching cache and never downloads anything.
`npm test -- --offline` skips the eight upstream suites entirely, including
WG17 syntax; a warm normal run includes them without needing upstream access.
There is no clean command: use `npm run sync` to refresh the cache explicitly.

## Tracked evidence and releases

The stable report records the upstream inventory successfully checked by
EyeProlog. A normal test run warns if it differs from the tracked report;
`--verify-report` makes that difference an error. `--cached --update-report`
records the exact snapshot already checked, without fetching again. Review
and commit intentional report changes.

The version lifecycle regenerates library and book files, runs `npm run sync`
once, then runs the full `npm test` against that same snapshot. It generates
and stages the conformance reports before the release commit. Releases thus
check current upstream without fetching twice, while ordinary tests reuse the
cache. A cached run alone does not establish that upstream is unchanged.

Exact source bytes, SHA-256 hashes, fetch timestamps, HTTP validators and
machine-readable results stay under `.cache/neumerkel/`. Cached reads use the
saved content type so the text encoding matches the live download. Tracked
reports omit volatile fetch metadata, keeping repeated runs stable.

The reviewed WG17 syntax regression corpus is an additional check on selected
outcomes. Every discovered syntax case still has to satisfy its upstream
Codex expectation; a reviewed outcome never replaces that assertion.
