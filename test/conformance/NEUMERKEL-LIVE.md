# Live Neumerkel conformity gate

EyeProlog treats Ulrich Neumerkel's current ISO/WG17 conformity material as a
moving upstream release gate, not as a frozen snapshot with permanent case
counts.

`node test/run-neumerkel.mjs` fetches these eight TU Wien sources on every live run:

1. `conformity_testing` — Part 1 syntax/reader/writer matrix;
2. `number_chars_cont_quad.pl` — `number_chars/2` continuation corpus;
3. `variable_names_quad.pl` — `variable_names/1` corpus;
4. `dif` — `dif/2` comparison table;
5. `length_quad.pl` — `length/2` corpus;
6. `phrase_quad.pl` — `phrase/2,3` corpus;
7. `prologue_quad.pl` — Prolog Prologue working-draft corpus;
8. `cleanup` — `setup_call_cleanup/3` examples.

The Prologue corpus carries one permanent, documented divergence (its
`max_integer` quad — see `KNOWN_QUAD_DIVERGENCES` in `test/neumerkel.mjs`):
EyeProlog's `bounded=false` reports no `max_integer` value at all, which
neither of the quad's two anticipated answers describes. That quad is still
executed every run and counted honestly (it does not report as passing), but
it does not abort the run the way an unexplained failure would; the tracked
report and console summary both say "N divergence(s) to be addressed" rather
than a bare pass/fail count. See `NEUMERKEL-LATEST.md`'s own "Known
divergences" section for the explanation. If the divergence ever stopped
reproducing, the counts would simply climb back to a plain, unqualified PASS.

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
node test/run-neumerkel.mjs --update-report
```

Commit the resulting `test/conformance/NEUMERKEL-LATEST.md` after reviewing the
change. After a successful `npm test`, `node test/run-neumerkel.mjs --cached --update-report` writes
the tracked report from the exact cached source bytes that just passed, avoiding a
second network fetch. `node test/run-neumerkel.mjs --cached --verify-report` verifies the tracked
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
node test/run-neumerkel.mjs
```

for the canonical live check. For offline reproduction of the exact last live
fetch, use:

```sh
node test/run-neumerkel.mjs --cached
```

The cached command never claims to check the latest upstream suites by itself.
The release flow first performs the canonical live `npm test`, then uses those exact
just-fetched bytes only to synchronize and verify the tracked evidence without
contacting upstream twice.

The vendored WG17 syntax matrix remains useful as a deterministic reviewed
regression snapshot, but it is secondary to this live gate: passing the snapshot
cannot mask a new or changed Neumerkel case.
