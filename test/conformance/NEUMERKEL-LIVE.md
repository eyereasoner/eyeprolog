# Live Neumerkel conformity gate

EyeProlog treats Ulrich Neumerkel's current ISO/WG17 conformity material as a
moving upstream release gate, not as a frozen snapshot with permanent case
counts.

`npm run test:neumerkel` fetches these seven TU Wien sources on every live run:

1. `conformity_testing` — Part 1 syntax/reader/writer matrix;
2. `number_chars_cont_quad.pl` — `number_chars/2` continuation corpus;
3. `variable_names_quad.pl` — `variable_names/1` corpus;
4. `dif` — `dif/2` comparison table;
5. `length_quad.pl` — `length/2` corpus;
6. `phrase_quad.pl` — `phrase/2,3` corpus;
7. `cleanup` — `setup_call_cleanup/3` examples.

The runner discovers the inventory at run time. A new upstream row is therefore
executed automatically and a removed row disappears automatically. The syntax
extractor keys the expected result from TU Wien's labelled `Codex` column rather
than assuming a fixed cell position, and cross-checks the discovered inventory
against the total declared by the live page so hand-edited HTML cannot silently
reduce coverage.

## Tracked GitHub evidence

The latest successful discovered inventory is committed as
[`NEUMERKEL-LATEST.md`](NEUMERKEL-LATEST.md). This is the stable report to link
from GitHub, releases, or other documentation.

A normal live run always executes the current upstream inventory. If the tracked
Markdown no longer matches, the test still reflects engine conformance and prints a
warning with the refresh command:

```sh
npm run conformance:update:neumerkel
```

Commit the resulting `test/conformance/NEUMERKEL-LATEST.md` after reviewing the
change. After a successful `npm test`, `npm run conformance:sync:neumerkel` writes
the tracked report from the exact cached source bytes that just passed, avoiding a
second network fetch. `npm run conformance:check:neumerkel` verifies the tracked
report against that same last successful snapshot. The npm version lifecycle
uses this race-free sync path and stages the generated reports into the release
commit. The tracked report intentionally omits fetch timestamps and HTTP validators,
so repeated runs against unchanged upstream suites do not dirty the checkout.

## Local inspection cache

Exact downloaded bytes, SHA-256 hashes, fetch timestamps, HTTP validators, and
machine-readable results are kept under `.cache/neumerkel/`. `.cache/` remains
Git-ignored: it is an inspection/reproduction cache, not published project evidence.

Use:

```sh
npm run test:neumerkel
```

for the canonical live check. For offline reproduction of the exact last live
fetch, use:

```sh
npm run test:neumerkel:cached
```

The cached command never claims to check the latest upstream suites by itself.
The release flow first performs the canonical live `npm test`, then uses those exact
just-fetched bytes only to synchronize and verify the tracked evidence without
contacting upstream twice.

The vendored WG17 syntax matrix remains useful as a deterministic reviewed
regression snapshot, but it is secondary to this live gate: passing the snapshot
cannot mask a new or changed Neumerkel case.
